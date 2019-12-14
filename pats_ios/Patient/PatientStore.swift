//
//  PatientStore.swift
//  pats_ios
//
//  Created by Brandon Yap on 2019-12-12.
//  Copyright © 2019 Brandon Yap. All rights reserved.
//

import SwiftUI
import Combine

class PatientStore : ObservableObject {
    @Published var patients: [Patient]
    
    init (patients: [Patient] = []) {
        self.patients = patients
    }
}
