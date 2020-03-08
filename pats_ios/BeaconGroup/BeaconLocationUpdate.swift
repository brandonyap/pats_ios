//
//  BeaconLocationUpdate.swift
//  pats_ios
//
//  Created by Brandon Yap on 2020-02-29.
//  Copyright © 2020 Brandon Yap. All rights reserved.
//

import SwiftUI

struct BeaconLocationUpdate: View {
    let beaconlocation: BeaconLocation
    @ObservedObject var store = BeaconLocationStore()
    @EnvironmentObject var settings: SettingStore
    @State private var group_id = 0
    @State private var id = 0
    @State private var beacons_id = 0
    @State private var location_x = ""
    @State private var location_y = ""
    @State private var showingAlert = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
            
    var body: some View {
        Form {
            Section(header: Text("Beacon ID")) {
                Text(String(beacons_id))
            }
            Section(header: Text("Beacon Location Info")){
                TextField("Location X",
                          text: $location_x)
                TextField("Location Y",
                          text: $location_y)
            }
        }
        .navigationBarTitle("Update Beacon Location", displayMode: .inline)
        .navigationBarItems(leading: Button(action: cancel) {
                Text("Cancel")
            },trailing: Button(action: update) {
                Text("Update")
        }).alert(isPresented: $showingAlert) {
                        Alert(title: Text("Update Beacon Group Failed"), message: Text("Bad Connection or Invalid Data"), dismissButton: .default(Text("Ok")))
        }.onAppear(perform: setDefaultValues)
    }
    
    func cancel() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func update() {
        sendUpdate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if !self.showingAlert {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    func sendUpdate() {
        let url = URL(string: "http://" + settings.url_address + "/api/beacons/" + String(beacons_id) + "/location")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        let parameters: [String: Any] = [
            "group_id": group_id,
            "location_x": location_x,
            "location_y": location_y
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
            
            if let data = data {
                if let decodedResponse = try?
                    JSONDecoder().decode(BeaconLocationId.self, from: data) {
                    if self.showingAlert {
                        return
                    }
                    // we have good data – go back to the main thread
                    DispatchQueue.main.async {
                        // update our UI
                        self.id = decodedResponse.id
                    }
                    // everything is good, so we can exit
                    return
                }
            }
        }.resume()
    }
    
    func setDefaultValues() {
        beacons_id = beaconlocation.beacons_id
        group_id = beaconlocation.group_id
        location_x = String(beaconlocation.location_x)
        location_y = String(beaconlocation.location_y)
    }
}