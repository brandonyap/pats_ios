//
//  SettingView.swift
//  pats_ios
//
//  Created by Brandon Yap on 2019-12-14.
//  Copyright © 2019 Brandon Yap. All rights reserved.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var settings: SettingStore
    @State private var url_address = ""
    
    var body: some View {
        Form {
            Section(header: Text("Host URL & Port")) {
                TextField(settings.url_address, text: $url_address)
            }
        }.navigationBarTitle(Text("Settings"))
            .navigationBarItems(trailing: Button(action: save) {
                Text("Save")
            })
    }
    
    func save() {
        settings.url_address = url_address
        print("Saved URL Address: " + settings.url_address)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView { SettingView() }
    }
}
