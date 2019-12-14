//
//  SensorDetail.swift
//  pats_ios
//
//  Created by Brandon Yap on 2019-12-13.
//  Copyright © 2019 Brandon Yap. All rights reserved.
//

import SwiftUI

struct SensorDetail: View {
    let sensor: Sensor
        
    var body: some View {
        Form {
            Section(header: Text("Sensor Info")){
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
        }
        .navigationBarTitle("Sensor Details", displayMode: .inline)
        .navigationBarItems(trailing: EditButton())
    }
}

#if DEBUG
struct SensorDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView { SensorDetail(sensor: sensorTestData[0]) }
    }
}
#endif
