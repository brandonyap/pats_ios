//
//  ContentView.swift
//  pats_ios
//
//  Created by Brandon Yap on 2019-12-10.
//  Copyright © 2019 Brandon Yap. All rights reserved.
//

import SwiftUI

enum ListType {
    case patient
    case sensor
    case beacon
}

struct ContentView: View {
    @State var list_type: ListType = .patient
    @ObservedObject var patient_store = PatientStore()
    @ObservedObject var sensor_store = SensorStore()
    @EnvironmentObject var settings: SettingStore
    
    var body: some View {
        TabView {
            NavigationView {
                PatientView(store: patient_store)
            }.tabItem {
                VStack {
                    Image(systemName: "person.3")
                    Text("Patients")
                }
            }.tag(1)
            NavigationView {
                SensorView(store: sensor_store)
            }.tabItem {
                VStack {
                    Image(systemName: "dot.radiowaves.left.and.right")
                    Text("Sensors")
                }
            }.tag(2)
            Text("Beacons").tabItem {
                VStack {
                    Image(systemName: "antenna.radiowaves.left.and.right")
                    Text("Beacons")
                }
            }.tag(3)
            NavigationView {
                SettingView()
            }.tabItem {
                VStack {
                    Image(systemName: "gear")
                    Text("Settings")
                }
            }.tag(4)
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(list_type: .patient, patient_store: PatientStore(patients: patientTestData), sensor_store: SensorStore(sensors: sensorTestData))
            
            ContentView(list_type: .patient, patient_store: PatientStore(patients: patientTestData), sensor_store: SensorStore(sensors: sensorTestData))
                .environment(\.colorScheme, .dark)
        }
    }
}
#endif
