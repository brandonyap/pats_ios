//
//  SensorCreate.swift
//  pats_ios
//
//  Created by Brandon Yap on 2019-12-13.
//  Copyright © 2019 Brandon Yap. All rights reserved.
//

import SwiftUI

struct SensorCreate: View {
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
            TextField("Bluetooth Address", text: $bluetooth_address)
            TextField("Name", text: $name)
            TextField("Description", text: $description)
                .lineLimit(nil)
        }
        .navigationBarTitle("Create Sensor", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: add) {
                Text("Create")
        }).alert(isPresented: $showingAlert) {
                        Alert(title: Text("Create Sensor Failed"), message: Text("Bad Connection or Invalid Data"), dismissButton: .default(Text("Ok")))
        }
    }
    
    func add() {
        sendCreate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if !self.showingAlert {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    func sendCreate() {
        let url = URL(string: "http://" + settings.url_address + "/api/sensors")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
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
    
    func createSensor() -> Sensor {
        return Sensor(id: id, bluetooth_address: bluetooth_address, name: name, description: description, active: false)
    }
}

#if DEBUG
struct SensorCreate_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView { SensorCreate() }
        }
    }
}
#endif
