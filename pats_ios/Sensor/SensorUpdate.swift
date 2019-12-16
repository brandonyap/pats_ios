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
