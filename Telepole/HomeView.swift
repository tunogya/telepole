//
//  HomeView.swift
//  Telepole
//
//  Created by 丁涯 on 2020/12/23.
//

import SwiftUI

struct HomeView: View {
    @State private var searchText = ""
    var body: some View {
        VStack {
            HomeHeader(searchText: $searchText)
            
            ScrollView(showsIndicators: false) {
                PetCards()
            }
            
            
            Spacer()
            
        }
        .padding()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct PetCardItem: View {
    let cardWidth = (SCREENWIDTH - 60)/2
    var cardHeight: CGFloat {
        return cardWidth * 1.4
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12.0) {
            Spacer()
            Text("Cherry")
                .font(.title3)
                .bold()
            Text("杜宾犬")
                .font(.body)
            HStack(spacing: 4.0) {
                Image(systemName: "clock")
                Text("8月")
                Image("")
                Text("Girl")
                Spacer()
            }.font(.body)
        }
        .padding()
        .frame(width: cardWidth ,height: 240, alignment: .center)
        .background(Color.yellow)
        .cornerRadius(20)
    }
}

struct PetPicker: View {
    var body: some View {
        HStack(spacing: 15.0) {
            ForEach(0 ..< 5) { item in
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 60, height: 60, alignment: .center)
            }
            Spacer()
        }
        .padding()
    }
}

struct PetCards: View {
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
            ForEach(0 ..< 6) { item in
                PetCardItem()
            }
        }
        .padding(.top)
    }
}

struct HomeHeader: View {
    @Binding var searchText: String
    var body: some View {
        HStack(spacing: 20.0) {
            TextField("Placeholder", text: $searchText)
                .padding()
                .background(Color("GrayColor"), alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .cornerRadius(20)
                .frame(height: 50, alignment: .center)
            
            Circle()
                .background(Color("GrayColor"), alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .frame(width: 50, height: 50, alignment: .center)
        }
    }
}
