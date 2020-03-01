//
//  BeaconLocationCell.swift
//  pats_ios
//
//  Created by Brandon Yap on 2020-02-29.
//  Copyright © 2020 Brandon Yap. All rights reserved.
//

import SwiftUI

struct BeaconLocationCell: View {
    let beaconlocation: BeaconLocation
    
    var body: some View {
        return NavigationLink(destination: BeaconLocationDetail(beaconlocation: beaconlocation)) {
            HStack {
                VStack (alignment: .leading) {
                    Text("Beacon " + String(beaconlocation.beacons_id))
                    HStack {
                        Text("Location X: " + String(beaconlocation.location_x) + " Location Y: " + String(beaconlocation.location_y))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}
