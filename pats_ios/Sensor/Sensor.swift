//
//  Sensor.swift
//  pats_ios
//
//  Created by Brandon Yap on 2019-12-13.
//  Copyright © 2019 Brandon Yap. All rights reserved.
//

import SwiftUI

struct Sensor: Identifiable {
    var id: Int
    var bluetooth_address: String
    var name: String
    var description: String
    var active: Bool = false
}

#if DEBUG
let sensorTestData = [
    Sensor(id: 1, bluetooth_address: "11:22:33:44:55:66", name: "Sensor 1", description: "Blah"),
    Sensor(id: 2, bluetooth_address: "12:34:56:78:90:12", name: "Sensor 2", description: "Blah Blah")
]
#endif
