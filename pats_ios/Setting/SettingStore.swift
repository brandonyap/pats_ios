//
//  SettingStore.swift
//  pats_ios
//
//  Created by Brandon Yap on 2019-12-14.
//  Copyright © 2019 Brandon Yap. All rights reserved.
//

import SwiftUI
import Combine

class SettingStore : ObservableObject {
    @Published var url_address: String
    
    init (url_address: String = "192.168.0.36:8888") {
        self.url_address = url_address
    }
}
