//
//  BeaconGroupCell.swift
//  pats_ios
//
//  Created by Brandon Yap on 2020-02-29.
//  Copyright © 2020 Brandon Yap. All rights reserved.
//

import SwiftUI

struct BeaconGroupCell: View {
    let beacongroup: BeaconGroup
    
    var body: some View {
        return NavigationLink(destination: BeaconGroupDetail(beacongroup: beacongroup)) {
            HStack {
                VStack (alignment: .leading) {
                    Text(beacongroup.name)
                }
            }
        }
    }
}
