//
//  Patient.swift
//  pats_ios
//
//  Created by Brandon Yap on 2019-12-11.
//  Copyright © 2019 Brandon Yap. All rights reserved.
//

import SwiftUI

struct Patient: Codable, Identifiable {
    var id: Int
    var sensors_id: Int
    var first_name: String
    var last_name: String
    var birthday: Date
    var hospital_id: String
    var physician: String
    var caretaker: String
    var date_created: Date
    var comments: String
    var alert: Bool = false
}

struct PatientResponse: Codable {
    let success: Bool
    let data: PatientCreateData
}

struct PatientListResponse: Codable {
    let success: Bool
    let data: [PatientCreateData]
}

struct PatientByIdResponse: Codable {
    let success: Bool
    let data: PatientCreateData
}

struct PatientCreateData: Codable, Identifiable {
    var sensors_id: Int
    var first_name: String
    var last_name: String
    var birthday: String
    var hospital_id: String
    var physician: String
    var caretaker: String
    var date_created: String
    var comments: String
    var id: Int
}

func PatientCreateToPatient(patient_data: [PatientCreateData]) -> [Patient] {
    var patients: [Patient] = []
    for i in 0..<patient_data.count {
        patients.append(createPatient(data: patient_data[i]))
    }
    return patients
}

func createPatient(data: PatientCreateData) -> Patient {
    return Patient(id: data.id, sensors_id: data.sensors_id, first_name: data.first_name, last_name: data.last_name, birthday: dateFormat(date: data.birthday), hospital_id: data.hospital_id, physician: data.physician, caretaker: data.caretaker, date_created: Date(), comments: data.comments, alert: false)
}

func dateFormat(date: String) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.date(from: date)!
}

#if DEBUG

let patientTestData = [
    Patient(id: 1, sensors_id: 1, first_name: "John", last_name: "Smith", birthday: dateFormat(date: "2000-01-01"), hospital_id: "1", physician: "John Doe", caretaker: "Jane Doe", date_created: dateFormat(date: "2019-12-31"), comments: "No Comment", alert: false),
    Patient(id: 2, sensors_id: 2, first_name: "Joe", last_name: "Schmoe", birthday: dateFormat(date: "2000-01-01"), hospital_id: "2", physician: "Test Test", caretaker: "Blah Blah", date_created: dateFormat(date: "2019-12-31"), comments: "No Comment", alert: true),
    Patient(id: 3, sensors_id: 3, first_name: "Jane", last_name: "Doe", birthday: dateFormat(date: "2000-01-01"), hospital_id: "4", physician: "Test", caretaker: "Blah", date_created: dateFormat(date: "2019-12-31"), comments: "Did you ever hear the tragedy of Darth Plagueis The Wise? I thought not. It's not a story the Jedi would tell you. It's a Sith legend. Darth Plagueis was a Dark Lord of the Sith, so powerful and so wise he could use the Force to influence the midichlorians to create life… He had such a knowledge of the dark side that he could even keep the ones he cared about from dying. The dark side of the Force is a pathway to many abilities some consider to be unnatural. He became so powerful… the only thing he was afraid of was losing his power, which eventually, of course, he did. Unfortunately, he taught his apprentice everything he knew, then his apprentice killed him in his sleep. Ironic. He could save others from death, but not himself.", alert: false),
    Patient(id: 1, sensors_id: 1, first_name: "John", last_name: "Smith", birthday: dateFormat(date: "2000-01-01"), hospital_id: "4", physician: "John Doe", caretaker: "Jane Doe", date_created: dateFormat(date: "2019-12-31"), comments: "No Comment", alert: false),
    Patient(id: 1, sensors_id: 1, first_name: "John", last_name: "Smith", birthday: dateFormat(date: "2000-01-01"), hospital_id: "4", physician: "John Doe", caretaker: "Jane Doe", date_created: dateFormat(date: "2019-12-31"), comments: "No Comment", alert: false),
    Patient(id: 1, sensors_id: 1, first_name: "John", last_name: "Smith", birthday: dateFormat(date: "2000-01-01"), hospital_id: "4", physician: "John Doe", caretaker: "Jane Doe", date_created: dateFormat(date: "2019-12-31"), comments: "No Comment", alert: false),
    Patient(id: 1, sensors_id: 1, first_name: "John", last_name: "Smith", birthday: dateFormat(date: "2000-01-01"), hospital_id: "4", physician: "John Doe", caretaker: "Jane Doe", date_created: dateFormat(date: "2019-12-31"), comments: "No Comment", alert: false),
    Patient(id: 1, sensors_id: 1, first_name: "John", last_name: "Smith", birthday: dateFormat(date: "2000-01-01"), hospital_id: "4", physician: "John Doe", caretaker: "Jane Doe", date_created: dateFormat(date: "2019-12-31"), comments: "No Comment", alert: false),
    Patient(id: 1, sensors_id: 1, first_name: "John", last_name: "Smith", birthday: dateFormat(date: "2000-01-01"), hospital_id: "4", physician: "John Doe", caretaker: "Jane Doe", date_created: dateFormat(date: "2019-12-31"), comments: "No Comment", alert: false),
    Patient(id: 1, sensors_id: 1, first_name: "John", last_name: "Smith", birthday: dateFormat(date: "2000-01-01"), hospital_id: "4", physician: "John Doe", caretaker: "Jane Doe", date_created: dateFormat(date: "2019-12-31"), comments: "No Comment", alert: false),
    Patient(id: 1, sensors_id: 1, first_name: "John", last_name: "Smith", birthday: dateFormat(date: "2000-01-01"), hospital_id: "4", physician: "John Doe", caretaker: "Jane Doe", date_created: dateFormat(date: "2019-12-31"), comments: "No Comment", alert: false),
    Patient(id: 1, sensors_id: 1, first_name: "John", last_name: "Smith", birthday: dateFormat(date: "2000-01-01"), hospital_id: "4", physician: "John Doe", caretaker: "Jane Doe", date_created: dateFormat(date: "2019-12-31"), comments: "No Comment", alert: false),
    Patient(id: 1, sensors_id: 1, first_name: "John", last_name: "Smith", birthday: dateFormat(date: "2000-01-01"), hospital_id: "4", physician: "John Doe", caretaker: "Jane Doe", date_created: dateFormat(date: "2019-12-31"), comments: "No Comment", alert: false)
]
#endif
