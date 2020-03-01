//
//  BeaconLocationStore.swift
//  pats_ios
//
//  Created by Brandon Yap on 2020-02-29.
//  Copyright © 2020 Brandon Yap. All rights reserved.
//

import SwiftUI
import Combine

class BeaconLocationStore : ObservableObject {
    @Published var beaconlocations: [BeaconLocation]
    
    init (beaconlocations: [BeaconLocation] = []) {
        self.beaconlocations = beaconlocations
    }
}
