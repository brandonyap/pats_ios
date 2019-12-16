//
//  PatientUpdate.swift
//  pats_ios
//
//  Created by Brandon Yap on 2019-12-16.
//  Copyright © 2019 Brandon Yap. All rights reserved.
//

import SwiftUI

struct PatientUpdate: View {
    let patient: Patient
    @ObservedObject var store = PatientStore()
    @EnvironmentObject var settings: SettingStore
    @State private var id = 0
    @State private var sensors_id = 0
    @State private var first_name = ""
    @State private var last_name = ""
    @State private var birthday = Date()
    @State private var hospital_id = ""
    @State private var physician = ""
    @State private var caretaker = ""
    @State private var comments = ""
    @State private var sensors: [Sensor] = []
    @State private var showingAlert = false

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
                    Text(String(sensors_id))
                    ForEach(sensors) { sensor in
                        Text(String(sensor.id))
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
                    text: $comments).fixedSize(horizontal: false, vertical: true).lineLimit(nil)
            }
        }
        .navigationBarTitle("Update Patient", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: update) {
                Text("Update")
            })
        .alert(isPresented: $showingAlert) {
                Alert(title: Text("Update Patient Failed"), message: Text("Bad Connection or Invalid Data"), dismissButton: .default(Text("Ok")))
            }
        .onAppear(perform: loadAtStart)
    }
    
    func loadAtStart() {
        loadAllInactiveSensors()
        setDefaultValues()
    }

    func update() {
        sendUpdate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if !self.showingAlert {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }

    func sendUpdate() {
        let url = URL(string: "http://" + settings.url_address + "/api/patients/" + String(id))!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        let parameters: [String: Any] = [
            "sensors_id": sensors_id,
            "first_name": first_name,
            "last_name": last_name,
            "birthday": dateToString(date: birthday),
            "hospital_id": hospital_id,
            "physician": physician,
            "caretaker": caretaker,
            "comments": comments
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
                
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
                    JSONDecoder().decode(PatientCreateData.self, from: data) {
                    if self.showingAlert {
                        return
                    }
                    // we have good data – go back to the main thread
                    DispatchQueue.main.async {
                        // update our UI
                        self.id = decodedResponse.id
                    }
                    // everything is good, so we can exit
                    return
                }
            }
        }.resume()
    }

    func loadAllInactiveSensors() {
        guard let url = URL(string: "http://" + settings.url_address + "/api/sensors/all?active=false") else {
            print("Invalid URL")
            return
        }
        print(url)
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                // OH NO! An error occurred...
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return
            }
            if let data = data {
                if let decodedResponse = try?
                    JSONDecoder().decode(SensorListResponse.self, from: data) {
                    // we have good data – go back to the main thread
                    DispatchQueue.main.async {
                        // update our UI
                        self.sensors = decodedResponse.data
                    }
                    // everything is good, so we can exit
                    return
                }
            }
        }.resume()
    }
    
    func setDefaultValues() {
        id = patient.id
        sensors_id = patient.sensors_id
        first_name = patient.first_name
        last_name = patient.last_name
        birthday = patient.birthday
        hospital_id = patient.hospital_id
        physician = patient.physician
        caretaker = patient.caretaker
        comments = patient.comments
    }
}
