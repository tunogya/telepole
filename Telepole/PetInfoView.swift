//
//  PetIInfo.swift
//  Telepole
//
//  Created by 丁涯 on 2021/1/31.
//

import SwiftUI

struct PetInfoView: View {
    @Binding var showStatus: ShowStatus
    @Binding var pickPetID: String
    var distences = 20
    
    @State private var pet: PetModel = PetModel()
    @State private var metric: PetMetricsModel = PetMetricsModel()
    
    fileprivate func getPetInfo() {
        if pickPetID == "" {
            pet.name = "请选择宠物"
        }else {
            PetApi().getPetById(pickPetID) { (p) in
                pet.name = p.name
            }
            PetApi().getPetMetricsModel(pickPetID) { (m) in
                metric.meow_coin_count = m.meow_coin_count
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            CardHeader(flag: $showStatus.isShowPetInfo, hasEditButton: false, title: pet.name)
            
            VStack(spacing: 10) {
                Text(pet.description)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.body)
                
                HStack {
                    Image(systemName: "location")
                    Text("距离你\(distences)Km")
                        .padding(.leading, -4)
                        .padding(.trailing, 6)
                    Image(systemName: "calendar")
                    Text("variety")
                        .padding(.leading, -4)
                    Spacer()
                }
                HStack {
                    Group {
                        Text("500")
                            .bold()
                            .foregroundColor(.black)
                        Text("喵喵币")
                            .padding(.leading, -4)
                            .padding(.trailing, 6)
                    }
                    
                    Group {
                        Text("2000")
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
