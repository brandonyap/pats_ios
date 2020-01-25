//
//  BeaconDetail.swift
//  pats_ios
//
//  Created by Brandon Yap on 2019-12-16.
//  Copyright © 2019 Brandon Yap. All rights reserved.
//

import SwiftUI

struct BeaconDetail: View {
    @EnvironmentObject var settings: SettingStore
    @State private var showingAlert = false
    @State private var showActionSheet = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State var beacon: Beacon
        
    var body: some View {
        Form {
            Section(header: Text("Beacon Info")){
                HStack {
                    Text("Beacon ID")
                    Spacer()
                    Text(String(beacon.id))
                }
                HStack {
                    Text("Name")
                    Spacer()
                    Text(beacon.name)
                }
                HStack {
                    Text("Description")
                    Spacer()
                    Text(beacon.description)
                        .lineLimit(nil)
                }
                HStack {
                    Text("UUID")
                    Spacer()
                    Text(beacon.uuid)
                }
            }
            Button(action: deleteMessage) {
                Text("Delete Beacon").foregroundColor(.red)
            }
        }
        .navigationBarTitle("Beacon Details", displayMode: .inline)
        .navigationBarItems(trailing: NavigationLink(destination: BeaconUpdate(beacon: self.beacon)) {
            Text("Edit")
            }).alert(isPresented: $showingAlert) {
                            Alert(title: Text("Delete Beacon Failed"), message: Text("Bad Connection or Invalid URL"), dismissButton: .default(Text("Ok")))
            }.onAppear(perform: load).actionSheet(isPresented: $showActionSheet) {
                ActionSheet(
                    title: Text("Delete Beacon"),
                    message: Text("Are you sure you would like to delete this beacon?"),
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
        guard let url = URL(string: "http://" + settings.url_address + "/api/beacons/" + String(beacon.id)) else {
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
        guard let url = URL(string: "http://" + settings.url_address + "/api/beacons/" + String(beacon.id)) else {
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
                    JSONDecoder().decode(BeaconByIdResponse.self, from: data) {
                    if self.showingAlert {
                        return
                    }
                    // we have good data – go back to the main thread
                    DispatchQueue.main.async {
                        // update our UI
                        self.beacon = decodedResponse.data
                    }
                    // everything is good, so we can exit
                    return
                }
            }
        }.resume()
    }
}

#if DEBUG
struct BeaconDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView { BeaconDetail(beacon: beaconTestData[0]) }
    }
}
#endif
