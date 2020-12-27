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
            HomeHeader(searchText: $searchText, avator: "")
            
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
    
    let name: String
    let variety: String
    let age: String
    let avator: String
    let gender: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4.0) {
            Spacer()
            Text(name)
                .font(.body)
                .bold()
            Text(variety)
                .font(.callout)
            HStack(spacing: 4.0) {
                Image(systemName: "clock")
                    .font(.footnote)
                Text(age)
                    .font(.footnote)
                Image("")
                Text(gender)
                    .font(.footnote)
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
    @ObservedObject var fetcher = PetsFetcher()
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
            ForEach(fetcher.pets) { pet in
                PetCardItem(name: pet.name, variety: pet.variety, age: "5岁", avator: pet.avators[0], gender: pet.gender)
            }
        }
        .padding(.top)
    }
}

struct HomeHeader: View {
    @Binding var searchText: String
    var avator: String
    
    var body: some View {
        HStack(spacing: 20.0) {
            TextField("Placeholder", text: $searchText)
                .font(.body)
                .padding(.vertical, 8)
                .padding(.horizontal)
                .frame(height: 44, alignment: .center)
                .background(Color("GrayColor"), alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .cornerRadius(10)
           
            
            Circle()
                .frame(width: 40, height: 40, alignment: .center)
        }
    }
}
