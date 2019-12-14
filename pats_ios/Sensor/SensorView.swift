//
//  SensorView.swift
//  pats_ios
//
//  Created by Brandon Yap on 2019-12-13.
//  Copyright © 2019 Brandon Yap. All rights reserved.
//

import SwiftUI

struct SensorView: View {
    @ObservedObject var store = SensorStore()
    
    var body: some View {
        List {
            ForEach(store.sensors) { sensor in
                SensorCell(sensor: sensor)
            }
        }
        .navigationBarTitle(Text("Sensors"))
        .navigationBarItems(trailing: NavigationLink(destination: SensorCreate(store: self.store)) {
                Image(systemName: "plus")
            })
    }
}
