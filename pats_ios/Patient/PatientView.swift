//
//  PatientView.swift
//  pats_ios
//
//  Created by Brandon Yap on 2019-12-13.
//  Copyright © 2019 Brandon Yap. All rights reserved.
//

import SwiftUI

struct PatientView: View {
    @ObservedObject var store = PatientStore()
    
    var body: some View {
        List {
            ForEach(store.patients) { patient in
                PatientCell(patient: patient)
            }
            .onDelete(perform: delete)
        }
        .navigationBarTitle(Text("Patients"))
        .navigationBarItems(trailing:
            Button(action: add)
            {
                Image(systemName: "plus")
        })
    }
    
    func add() {
        store.patients.append(Patient(id: 4, sensors_id: 4, first_name: "Blah", last_name: "Blah", birthday: dateFormat(date: "2000-01-01"), hospital_id: 4, physician: "John Doe", caretaker: "Jane Doe", date_created: dateFormat(date: "2019-12-31"), comments: "No Comment", alert: false))
    }
    
    func delete(at offsets: IndexSet) {
        store.patients.remove(atOffsets: offsets)
    }
}
