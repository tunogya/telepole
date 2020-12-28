//
//  HomeView.swift
//  Telepole
//
//  Created by 丁涯 on 2020/12/23.
//

import SwiftUI
import SDWebImageSwiftUI

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
    
    let pet: Pet
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4.0) {
            Spacer()
            Text(pet.name)
                .font(.body)
                .bold()
            Text(pet.variety)
                .font(.callout)
            HStack(spacing: 4.0) {
                Image(systemName: "clock")
                    .font(.footnote)
                Text(pet.birthday)
                    .font(.footnote)
//                Image("")
                Text(pet.gender)
                    .font(.footnote)
                Spacer()
            }.font(.body)
        }
        .padding()
        .frame(width: cardWidth ,height: 240, alignment: .center)
        .background(WebImage(url: pet.avator)
)
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
                PetCardItem(pet: pet)
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
