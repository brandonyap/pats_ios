//
//  Sensor.swift
//  pats_ios
//
//  Created by Brandon Yap on 2019-12-13.
//  Copyright © 2019 Brandon Yap. All rights reserved.
//

import SwiftUI

struct Sensor: Codable, Identifiable {
    var id: Int
    var bluetooth_address: String
    var name: String
    var description: String
    var active: Bool = false
}

struct SensorId: Codable {
    var id: Int
}

struct SensorResponse: Codable {
    let success: Bool
    let data: SensorId
}

struct SensorListResponse: Codable {
    let success: Bool
    let data: [Sensor]
}

struct SensorByIdResponse: Codable {
    let success: Bool
    let data: Sensor
}

#if DEBUG
let sensorTestData = [
    Sensor(id: 1, bluetooth_address: "11:22:33:44:55:66", name: "Sensor 1", description: "Blah"),
    Sensor(id: 2, bluetooth_address: "12:34:56:78:90:12", name: "Sensor 2", description: "Blah Blah")
]
#endif
