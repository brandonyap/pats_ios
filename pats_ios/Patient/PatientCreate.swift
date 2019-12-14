//
//  PatientCreate.swift
//  pats_ios
//
//  Created by Brandon Yap on 2019-12-14.
//  Copyright © 2019 Brandon Yap. All rights reserved.
//

import SwiftUI

struct SensorNames {
    static let allSensors = [
        1,
        2,
        3
    ]
}

struct PatientCreate: View {
    @ObservedObject var store = PatientStore()
    @State private var sensors_id = 0
    @State private var first_name = ""
    @State private var last_name = ""
    @State private var birthday = Date()
    @State private var hospital_id = ""
    @State private var physician = ""
    @State private var caretaker = ""
    @State private var comments = ""
    
    var sensors: [Sensor] = []
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
            
    var body: some View {
        Form {
            Section(header: Text("Patient Info")){
                TextField("First Name",
                          text: $first_name)
                TextField("Last Name",
                          text: $last_name)
                DatePicker("Date of Birth", selection: $birthday, displayedComponents: .date)
            }
            Section(header: Text("Hospital Info")){
                Picker("Sensor ID", selection: $sensors_id) {
                    ForEach(SensorNames.allSensors, id: \.self) { sensor in
                        Text(String(sensor)).tag(sensor)
                    }
                }
                TextField("Hospital ID",
                          text: $hospital_id)
                TextField("Physician",
                          text: $physician)
                TextField("Caretaker",
                          text: $caretaker)
            }
            Section(header: Text("Comments")){
                TextField("Comments",
                    text: $comments).fixedSize(horizontal: false, vertical: true)
            }
        }
        .navigationBarTitle("Create Patient", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: add) {
                Text("Create")
            })
    }
    
    func add() {
        store.patients.append(createPatient())
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func createPatient() -> Patient {
        return Patient(id: store.patients.count, sensors_id: sensors_id, first_name: first_name, last_name: last_name, birthday: birthday, hospital_id: Int(hospital_id) ?? 0, physician: physician, caretaker: caretaker, date_created: Date(), comments: comments, alert: false)
    }
}

#if DEBUG
struct PatientCreate_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView { PatientCreate() }
        }
    }
}
#endif
