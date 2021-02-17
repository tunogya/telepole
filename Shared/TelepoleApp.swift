//
//  TelepoleApp.swift
//  Telepole
//
//  Created by 丁涯 on 2020/12/23.


import SwiftUI

@main
struct TelepoleApp: App {
    @StateObject private var model = TelepoleModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }
    }
}
