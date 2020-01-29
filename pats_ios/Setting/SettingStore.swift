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
    
    init () {
        self.url_address = UserDefaults.standard.string(forKey: "address") ?? "192.168.0.36:8888"
    }
}
