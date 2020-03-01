//
//  BeaconGroupDetail.swift
//  pats_ios
//
//  Created by Brandon Yap on 2020-02-29.
//  Copyright © 2020 Brandon Yap. All rights reserved.
//

import SwiftUI

struct BeaconGroupDetail: View {
    @EnvironmentObject var settings: SettingStore
    @State private var showingAlert = false
    @State private var showActionSheet = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State var beacongroup: BeaconGroup
    @ObservedObject var store = BeaconLocationStore()
        
    var body: some View {
        Form {
            Section(header: Text("Beacon Group Info")){
                HStack {
                    Text("Beacon Group ID")
                    Spacer()
                    Text(String(beacongroup.id))
                }
                HStack {
                    Text("Name")
                    Spacer()
                    Text(beacongroup.name)
                }
                HStack {
                    Text("Description")
                    Spacer()
                    Text(beacongroup.description)
                        .lineLimit(nil)
                }
            }
            Section(header: Text("Beacon Group Locations")) {
                List {
                    ForEach(store.beaconlocations) { beacon in
                        BeaconLocationCell(beaconlocation: beacon)
                    }
                }
                NavigationLink(destination: BeaconLocationCreate(group_id: beacongroup.id)) {
                    Text("Add Beacon Location to Group").foregroundColor(.blue)
                }
            }
            Button(action: deleteMessage) {
                Text("Delete Beacon Group").foregroundColor(.red)
            }
        }
        .navigationBarTitle("Beacon Details", displayMode: .inline)
        .navigationBarItems(trailing: NavigationLink(destination: BeaconGroupUpdate(beacongroup: self.beacongroup)) {
            Text("Edit")
            }).alert(isPresented: $showingAlert) {
                            Alert(title: Text("Delete Beacon Group Failed"), message: Text("Bad Connection or Invalid URL"), dismissButton: .default(Text("Ok")))
            }.onAppear(perform: load).actionSheet(isPresented: $showActionSheet) {
                ActionSheet(
                    title: Text("Delete Beacon"),
                    message: Text("Are you sure you would like to delete this beacon group?"),
                    buttons: [
                        .destructive(Text("Delete"), action: {
                            self.delete()
                        }),
                        .cancel { }
                    ]
                )
            }
    }
    
    func deleteMessage() {
        showActionSheet = true
    }
    
    func delete() {
        sendDelete()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if !self.showingAlert {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }

    func sendDelete() {
        guard let url = URL(string: "http://" + settings.url_address + "/api/beacons/group/" + String(beacongroup.id)) else {
            print("Invalid URL")
            return
        }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                // OH NO! An error occurred...
                self.showingAlert = true
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                self.showingAlert = true
                return
            }
        }.resume()
    }
    
    func load() {
        loadDetails()
        loadLocations()
    }
    
    func loadDetails() {
        guard let url = URL(string: "http://" + settings.url_address + "/api/beacons/group/" + String(beacongroup.id)) else {
            print("Invalid URL")
            return
        }
        print(url)
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                // OH NO! An error occurred...
                self.showingAlert = true
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                self.showingAlert = true
                return
            }
            if let data = data {
                if let decodedResponse = try?
                    JSONDecoder().decode(BeaconGroupByIdResponse.self, from: data) {
                    if self.showingAlert {
                        return
                    }
                    // we have good data – go back to the main thread
                    DispatchQueue.main.async {
                        // update our UI
                        self.beacongroup = decodedResponse.data
                    }
                    // everything is good, so we can exit
                    return
                }
            }
        }.resume()
    }
    
    func loadLocations() {
        guard let url = URL(string: "http://" + settings.url_address + "/api/beacons/group/" + String(beacongroup.id) + "/location/all") else {
            print("Invalid URL")
            return
        }
        print(url)
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
//            if error != nil {
//                // OH NO! An error occurred...
////                self.showingAlert = true
//                return
//            }
//
//            guard let httpResponse = response as? HTTPURLResponse,
//                  (200...404).contains(httpResponse.statusCode) else {
////                self.showingAlert = true
//                return
//            }
            if let data = data {
                if let decodedResponse = try?
                    JSONDecoder().decode(BeaconLocationListResponse.self, from: data) {
//                    if self.showingAlert {
//                        return
//                    }
                    // we have good data – go back to the main thread
                    DispatchQueue.main.async {
                        // update our UI
                        self.store.beaconlocations = decodedResponse.data
                    }
                    // everything is good, so we can exit
                    return
                } else {
                    DispatchQueue.main.async {
                        // update our UI
                        self.store.beaconlocations = []
                    }
                    return
                }
            }
        }.resume()
    }
}
