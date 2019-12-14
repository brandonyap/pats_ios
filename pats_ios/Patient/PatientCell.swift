//
//  PatientCell.swift
//  pats_ios
//
//  Created by Brandon Yap on 2019-12-12.
//  Copyright © 2019 Brandon Yap. All rights reserved.
//

import SwiftUI

struct PatientCell: View {
    let patient: Patient
    
    var body: some View {
        return NavigationLink(destination: PatientDetail(patient: patient)) {
            HStack {
                Image(systemName: patient.alert ? "x.circle" : "checkmark.circle")
                    .foregroundColor(patient.alert ? .red : .green)
                VStack (alignment: .leading) {
                    Text(fullName(first_name: patient.first_name, last_name: patient.last_name))
                    HStack {
                        Text("Date of Birth: " + dateToString(date: patient.birthday))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}

func dateToString(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: date)
}

func fullName(first_name: String, last_name: String) -> String {
    return first_name + " " + last_name
}
