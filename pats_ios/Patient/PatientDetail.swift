//
//  PatientDetail.swift
//  pats_ios
//
//  Created by Brandon Yap on 2019-12-12.
//  Copyright © 2019 Brandon Yap. All rights reserved.
//

import SwiftUI

struct PatientDetail: View {
    @EnvironmentObject var settings: SettingStore
    @State private var showingAlert = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
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
                    Text(patient.hospital_id)
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
            Button(action: delete) {
                Text("Delete Patient").foregroundColor(.red)
            }
        }
        .navigationBarTitle("Patient Details", displayMode: .inline)
        .navigationBarItems(trailing: EditButton()).alert(isPresented: $showingAlert) {
                        Alert(title: Text("Delete Patient Failed"), message: Text("Bad Connection or Invalid URL"), dismissButton: .default(Text("Ok")))
        }
    }
    
    func delete() {
        sendDelete()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if !self.showingAlert {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    func sendDelete() {
        guard let url = URL(string: "http://" + settings.url_address + "/api/patients/" + String(patient.id)) else {
            print("Invalid URL")
            return
        }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
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
        }.resume()
    }
}

#if DEBUG
struct PatientDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView { PatientDetail(patient: patientTestData[2]) }
    }
}
#endif
