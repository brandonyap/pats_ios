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
    var uuid: String
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
    Beacon(id: 1, uuid: "12345678abcdefgh12345678abcdefgh", name: "Sensor 1", description: "Blah"),
    Beacon(id: 2, uuid: "abcdefgh12345678abcdefgh12345678", name: "Sensor 2", description: "Blah Blah")
]
#endif
