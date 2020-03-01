//
//  BeaconGroupModel.swift
//  pats_ios
//
//  Created by Brandon Yap on 2020-02-29.
//  Copyright © 2020 Brandon Yap. All rights reserved.
//

import SwiftUI

// Group Structs
struct BeaconGroup: Codable, Identifiable {
    var id: Int
    var name: String
    var description: String
}

struct BeaconGroupId: Codable {
    var id: Int
}

struct BeaconGroupResponse: Codable {
    let success: Bool
    let data: BeaconGroupId
}

struct BeaconGroupListResponse: Codable {
    let success: Bool
    let data: [BeaconGroup]
}

struct BeaconGroupByIdResponse: Codable {
    let success: Bool
    let data: BeaconGroup
}

// Group Location Structs

struct BeaconLocation: Codable, Identifiable {
    var id: Int
    var group_id: Int
    var beacons_id: Int
    var location_x: Float
    var location_y: Float
}

struct BeaconLocationId: Codable {
    var id: Int
}

struct BeaconLocationResponse: Codable {
    let success: Bool
    let data: BeaconLocationId
}

struct BeaconLocationListResponse: Codable {
    let success: Bool
    let data: [BeaconLocation]
}

struct BeaconLocationByIdResponse: Codable {
    let success: Bool
    let data: BeaconLocation
}
