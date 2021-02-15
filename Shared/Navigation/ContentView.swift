//
//  HomeView.swift
//  Telepole
//
//  Created by 丁涯 on 2021/2/5.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        #if os(iOS)
        AppSingleView()
        #endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
