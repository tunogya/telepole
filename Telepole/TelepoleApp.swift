//
//  TelepoleApp.swift
//  Telepole
//
//  Created by 丁涯 on 2020/12/23.
//

import SwiftUI

@main
struct TelepoleApp: App {
    let regionPersistence = RegionPersistence.shared
    var body: some Scene {
        WindowGroup {
            MapView()
                .environment(\.managedObjectContext, regionPersistence.container.viewContext)
        }
    }
}
