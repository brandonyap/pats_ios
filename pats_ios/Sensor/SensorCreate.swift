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
    @State private var bluetooth_address = ""
    @State private var name = ""
    @State private var description = ""
    
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
            })
    }
    
    func add() {
        store.sensors.append(createSensor())
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func createSensor() -> Sensor {
        return Sensor(id: store.sensors.count, bluetooth_address: bluetooth_address, name: name, description: description, active: false)
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
