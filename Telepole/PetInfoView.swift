//
//  PetIInfo.swift
//  Telepole
//
//  Created by 丁涯 on 2021/1/31.
//

import SwiftUI
import MapKit

struct PetInfoView: View {
    @Binding var showStatus: ShowStatus
    @Binding var pickPetID: String
    @State private var location: CLLocation = CLLocation(latitude: 0, longitude: 0)
    
    @ObservedObject var locationManager = LocationManager()
    var distence: DistenceModel {
        var distence = DistenceModel(value: 0, unit: .m)
        let value = Int(locationManager.lastLocation?.distance(from: location) ?? 0)
        
        if value > 1000 {
            distence.value = Int(value/1000)
            distence.unit = .km
        }else{
            distence.value = value
            distence.unit = .m
        }
        
        return distence
    }
    
    @State private var pet: PetModel = PetModel()
    @State private var metric: PetMetricsModel = PetMetricsModel()
    
    fileprivate func getPetInfo() {
        if pickPetID == "" {
            pet.name = "请选择宠物"
        }else {
            PetApi().getPetById(pickPetID) { (p) in
                pet = p
            }
            PetApi().getPetMetricsModel(pickPetID) { (m) in
                metric = m
            }
        }
    }
    
    var petName: String {
        if pickPetID == "" {
            return "请选择宠物"
        }else {
            return pet.name
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            CardHeader(flag: $showStatus.isShowPetInfo, hasEditButton: false, title: petName)
            
            VStack(spacing: 10) {
                Text(pet.description)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.body)
                
                HStack {
                    Image(systemName: "location")
                    Text("距离你\(distence.value)\(distence.unit.rawValue)")
                        .padding(.leading, -4)
                        .padding(.trailing, 6)
                    Image(systemName: "calendar")
                    Text("\(pet.variety)")
                        .padding(.leading, -4)
                    Spacer()
                }
                HStack {
                    Group {
                        Text("\(metric.meow_coin_count)")
                            .bold()
                            .foregroundColor(.black)
                        Text("喵喵币")
                            .padding(.leading, -4)
                            .padding(.trailing, 6)
                    }
                    
                    Group {
                        Text("\(metric.followers_count)")
                            .bold()
                            .foregroundColor(.black)
                        Text("关注者")
                            .padding(.leading, -4)
                    }
                    
                    Spacer()
                }
            }
            .font(.footnote)
            .foregroundColor(.secondary)
            .padding()
            
            Spacer()
        }
        .padding(.vertical, 10)
        .background(VisualEffectBlur(blurStyle: .systemChromeMaterial))
        .cornerRadius(20)
        .onAppear(perform: {
            self.getPetInfo()
        })
        .onChange(of: pickPetID, perform: { value in
            self.getPetInfo()
        })
    }
}

//
//  PetInfo.swift
//  Telepole
//
//  Created by 丁涯 on 2021/1/17.
//
