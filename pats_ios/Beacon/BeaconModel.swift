//
//  BeaconModel.swift
//  pats_ios
//
//  Created by Brandon Yap on 2019-12-16.
//  Copyright © 2019 Brandon Yap. All rights reserved.
//

import SwiftUI

struct Beacon: Codable, Identifiable {
    var id: Int
    var bluetooth_address: String
    var name: String
    var description: String
}

struct BeaconId: Codable {
    var id: Int
}

struct BeaconResponse: Codable {
    let success: Bool
    let data: BeaconId
}

struct BeaconListResponse: Codable {
    let success: Bool
    let data: [Beacon]
}

struct BeaconByIdResponse: Codable {
    let success: Bool
    let data: Beacon
}

#if DEBUG
let beaconTestData = [
    Beacon(id: 1, bluetooth_address: "11:22:33:44:55:66", name: "Sensor 1", description: "Blah"),
    Beacon(id: 2, bluetooth_address: "12:34:56:78:90:12", name: "Sensor 2", description: "Blah Blah")
]
#endif
