//
//  BeaconStore.swift
//  pats_ios
//
//  Created by Brandon Yap on 2019-12-16.
//  Copyright © 2019 Brandon Yap. All rights reserved.
//

import SwiftUI
import Combine

class BeaconStore : ObservableObject {
    @Published var beacons: [Beacon]
    
    init (beacons: [Beacon] = []) {
        self.beacons = beacons
    }
}
