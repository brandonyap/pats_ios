//
//  PatientDetail.swift
//  pats_ios
//
//  Created by Brandon Yap on 2019-12-12.
//  Copyright © 2019 Brandon Yap. All rights reserved.
//

import SwiftUI

struct PatientDetail: View {
    let patient: Patient
        
    var body: some View {
        Form {
            Section(header: Text("Patient Info")){
                HStack {
                    Text("First Name")
                    Spacer()
                    Text(patient.first_name)
                }
                HStack {
                    Text("Last Name")
                    Spacer()
                    Text(patient.last_name)
                }
                HStack {
                    Text("Birthday")
                    Spacer()
                    Text(dateToString(date: patient.birthday))
                }
            }
            Section(header: Text("Hospital Info")){
                HStack {
                    Text("Sensors ID")
                    Spacer()
                    Text(String(patient.sensors_id))
                }
                HStack {
                    Text("Hospital ID")
                    Spacer()
                    Text(String(patient.hospital_id))
                }
                HStack {
                    Text("Date Created")
                    Spacer()
                    Text(dateToString(date: patient.date_created))
                }
                HStack {
                    Text("Physician")
                    Spacer()
                    Text(patient.physician)
                }
                HStack {
                    Text("Caretaker")
                    Spacer()
                    Text(patient.caretaker)
                }
            }
            Section(header: Text("Comments")){
                Text(patient.comments)
                    .lineLimit(nil)
            }
        }
        .navigationBarTitle("Patient Details", displayMode: .inline)
        .navigationBarItems(trailing: EditButton())
    }
}

#if DEBUG
struct PatientDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView { PatientDetail(patient: patientTestData[0]) }
    }
}
#endif
