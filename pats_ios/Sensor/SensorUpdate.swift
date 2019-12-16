//
//  SensorUpdate.swift
//  pats_ios
//
//  Created by Brandon Yap on 2019-12-15.
//  Copyright © 2019 Brandon Yap. All rights reserved.
//

import SwiftUI

struct SensorUpdate: View {
    let sensor: Sensor
    @ObservedObject var store = SensorStore()
    @EnvironmentObject var settings: SettingStore
    @State private var bluetooth_address = ""
    @State private var name = ""
    @State private var description = ""
    @State private var id: Int = 0
    @State private var showingAlert = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
            
    var body: some View {
        Form {
            Section(header: Text("Bluetooth Address")) {
                TextField("Bluetooth Address", text: $bluetooth_address)
            }
            Section(header: Text("Name")) {
                TextField("Name", text: $name)
            }
            Section(header: Text("Description")) {
                TextField("Description", text: $description)
                .lineLimit(nil)
            }
        }
        .navigationBarTitle("Update Sensor", displayMode: .inline)
        .navigationBarItems(leading: Button(action: cancel) {
                Text("Cancel")
            },trailing: Button(action: update) {
                Text("Update")
        }).alert(isPresented: $showingAlert) {
                        Alert(title: Text("Update Sensor Failed"), message: Text("Bad Connection or Invalid Data"), dismissButton: .default(Text("Ok")))
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
        let url = URL(string: "http://" + settings.url_address + "/api/sensors/" + String(id))!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        let parameters: [String: Any] = [
            "bluetooth_address": bluetooth_address,
            "name": name,
            "description": description
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
                    JSONDecoder().decode(SensorId.self, from: data) {
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
        bluetooth_address = sensor.bluetooth_address
        name = sensor.name
        id = sensor.id
        description = sensor.description
    }
}

#if DEBUG
struct SensorUpdate_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView { SensorUpdate(sensor: sensorTestData[0]) }
        }
    }
}
#endif
