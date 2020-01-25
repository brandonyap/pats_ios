//
//  BeaconCell.swift
//  pats_ios
//
//  Created by Brandon Yap on 2019-12-16.
//  Copyright © 2019 Brandon Yap. All rights reserved.
//

import SwiftUI

struct BeaconCell: View {
    let beacon: Beacon
    
    var body: some View {
        return NavigationLink(destination: BeaconDetail(beacon: beacon)) {
            HStack {
                VStack (alignment: .leading) {
                    Text(beacon.name)
                    HStack {
                        Text("UUID: " + beacon.uuid)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}
