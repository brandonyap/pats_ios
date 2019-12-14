//
//  SensorCell.swift
//  pats_ios
//
//  Created by Brandon Yap on 2019-12-13.
//  Copyright © 2019 Brandon Yap. All rights reserved.
//

import SwiftUI

struct SensorCell: View {
    let sensor: Sensor
    
    var body: some View {
        return NavigationLink(destination: SensorDetail(sensor: sensor)) {
            VStack (alignment: .leading) {
                Text(sensor.name)
                HStack {
                    Text("Bluetooth Address: " + sensor.bluetooth_address)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}
