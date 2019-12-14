//
//  SensorStore.swift
//  pats_ios
//
//  Created by Brandon Yap on 2019-12-13.
//  Copyright © 2019 Brandon Yap. All rights reserved.
//

import SwiftUI
import Combine

class SensorStore : ObservableObject {
    @Published var sensors: [Sensor]
    
    init (sensors: [Sensor] = []) {
        self.sensors = sensors
    }
}
