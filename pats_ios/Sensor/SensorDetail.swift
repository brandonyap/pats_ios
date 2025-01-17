//
//  SensorDetail.swift
//  pats_ios
//
//  Created by Brandon Yap on 2019-12-13.
//  Copyright © 2019 Brandon Yap. All rights reserved.
//

import SwiftUI

struct SensorDetail: View {
    @EnvironmentObject var settings: SettingStore
    @State private var showingAlert = false
    @State private var showActionSheet = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State var sensor: Sensor
        
    var body: some View {
        Form {
            Section(header: Text("Sensor Info")){
                HStack {
                    Text("Sensor ID")
                    Spacer()
                    Text(String(sensor.id))
                }
                HStack {
                    Text("Name")
                    Spacer()
                    Text(sensor.name)
                }
                HStack {
                    Text("Description")
                    Spacer()
                    Text(sensor.description)
                        .lineLimit(nil)
                }
                HStack {
                    Text("Bluetooth Address")
                    Spacer()
                    Text(sensor.bluetooth_address)
                }
            }
            Section(header: Text("Sensor Status")){
                HStack {
                    Text("Active")
                    Spacer()
                    Text(sensor.active ? "Yes" : "No")
                }
            }
            Button(action: deleteMessage) {
                Text("Delete Sensor").foregroundColor(.red)
            }
        }
        .navigationBarTitle("Sensor Details", displayMode: .inline)
        .navigationBarItems(trailing: NavigationLink(destination: SensorUpdate(sensor: self.sensor)) {
            Text("Edit")
            }).alert(isPresented: $showingAlert) {
                            Alert(title: Text("Delete Sensor Failed"), message: Text("Bad Connection or Invalid URL"), dismissButton: .default(Text("Ok")))
            }.onAppear(perform: load).actionSheet(isPresented: $showActionSheet) {
                ActionSheet(
                    title: Text("Delete Sensor"),
                    message: Text("Are you sure you would like to delete this sensor?"),
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
        guard let url = URL(string: "http://" + settings.url_address + "/api/sensors/" + String(sensor.id)) else {
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
        guard let url = URL(string: "http://" + settings.url_address + "/api/sensors/" + String(sensor.id)) else {
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
                    JSONDecoder().decode(SensorByIdResponse.self, from: data) {
                    if self.showingAlert {
                        return
                    }
                    // we have good data – go back to the main thread
                    DispatchQueue.main.async {
                        // update our UI
                        self.sensor = decodedResponse.data
                    }
                    // everything is good, so we can exit
                    return
                }
            }
        }.resume()
    }
}

#if DEBUG
struct SensorDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView { SensorDetail(sensor: sensorTestData[0]) }
    }
}
#endif
