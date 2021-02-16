//
//  TelepoleModel.swift
//  Telepole
//
//  Created by 丁涯 on 2021/2/15.
//
// 后续将进行优化，结合 使用CoreData

import AuthenticationServices

class TelepoleModel: ObservableObject {
    // 用户账户
    @Published private(set) var user: Account?
    // 我的宠物ID列表
    @Published private(set) var myPetIDs = Set<Pet.ID>()
    // 当前选择的宠物ID
    @Published private(set) var selectedPetID: Pet.ID?
    // 是否有定位允许
    @Published var locationAllowed = true
    
    let defaults = UserDefaults(suiteName: "group.wakanda.telepole")
    
}
