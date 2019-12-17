//
//  BeaconView.swift
//  pats_ios
//
//  Created by Brandon Yap on 2019-12-16.
//  Copyright © 2019 Brandon Yap. All rights reserved.
//

import SwiftUI

struct BeaconView: View {
    @ObservedObject var store = BeaconStore()
    @EnvironmentObject var settings: SettingStore
    @State private var showingAlert = false
    
    var body: some View {
        List {
            ForEach(store.beacons) { beacon in
                BeaconCell(beacon: beacon)
            }
        }
        .navigationBarTitle(Text("Beacons"))
        .navigationBarItems(leading: Button(action: loadAll) {
            Image(systemName: "arrow.clockwise")
            }, trailing: NavigationLink(destination: BeaconCreate(store: self.store)) {
                Image(systemName: "plus")
            }).alert(isPresented: $showingAlert) {
            Alert(title: Text("Beacon Retrieval Failed"), message: Text("Bad Connection or Invalid URL"), dismissButton: .default(Text("Ok")))
        }.onAppear(perform: loadAll)
    }
    
    func loadAll() {
        guard let url = URL(string: "http://" + settings.url_address + "/api/beacons/all") else {
            print("Invalid URL")
            return
        }
        print(url)
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                // OH NO! An error occurred...
                self.showingAlert = true
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                self.showingAlert = true
                return
            }
            if let data = data {
                if let decodedResponse = try?
                    JSONDecoder().decode(BeaconListResponse.self, from: data) {
                    if self.showingAlert {
                        return
                    }
                    // we have good data – go back to the main thread
                    DispatchQueue.main.async {
                        // update our UI
                        self.store.beacons = decodedResponse.data
                    }
                    // everything is good, so we can exit
                    return
                }
            }
        }.resume()
    }
}
