//
//  BeaconLocationDetail.swift
//  pats_ios
//
//  Created by Brandon Yap on 2020-02-29.
//  Copyright © 2020 Brandon Yap. All rights reserved.
//

import SwiftUI

struct BeaconLocationDetail: View {
    @EnvironmentObject var settings: SettingStore
    @State private var showingAlert = false
    @State private var showActionSheet = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State var beaconlocation: BeaconLocation
        
    var body: some View {
        Form {
            Section(header: Text("Beacon Location Info")){
                HStack {
                    Text("Beacon Location ID")
                    Spacer()
                    Text(String(beaconlocation.id))
                }
                HStack {
                    Text("Beacon ID")
                    Spacer()
                    Text(String(beaconlocation.beacons_id))
                }
                HStack {
                    Text("Location X")
                    Spacer()
                    Text(String(beaconlocation.location_x))
                }
                HStack {
                    Text("Location Y")
                    Spacer()
                    Text(String(beaconlocation.location_y))
                }
            }
            Button(action: deleteMessage) {
                Text("Delete Beacon Location").foregroundColor(.red)
            }
        }
        .navigationBarTitle("Beacon Location Details", displayMode: .inline)
        .navigationBarItems(trailing: NavigationLink(destination: BeaconLocationUpdate(beaconlocation: self.beaconlocation)) {
            Text("Edit")
            }).alert(isPresented: $showingAlert) {
                            Alert(title: Text("Delete Beacon Location Failed"), message: Text("Bad Connection or Invalid URL"), dismissButton: .default(Text("Ok")))
            }.onAppear(perform: load).actionSheet(isPresented: $showActionSheet) {
                ActionSheet(
                    title: Text("Delete Beacon Location"),
                    message: Text("Are you sure you would like to delete this beacon location?"),
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
        guard let url = URL(string: "http://" + settings.url_address + "/api/beacons/" + String(beaconlocation.beacons_id) + "/location") else {
            print("Invalid URL")
            return
        }
        print(url)
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "DELETE"
        let parameters: [String: Any] = [
            "group_id": beaconlocation.group_id
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
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
        guard let url = URL(string: "http://" + settings.url_address + "/api/beacons/group/" + String(beaconlocation.group_id) + "/location/" + String(beaconlocation.beacons_id)) else {
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
                    JSONDecoder().decode(BeaconLocationByIdResponse.self, from: data) {
                    if self.showingAlert {
                        return
                    }
                    // we have good data – go back to the main thread
                    DispatchQueue.main.async {
                        // update our UI
                        self.beaconlocation = decodedResponse.data
                    }
                    // everything is good, so we can exit
                    return
                }
            }
        }.resume()
    }
}
