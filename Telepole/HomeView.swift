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
        NavigationView{
            ScrollView(showsIndicators: false) {
                PetCards()
            }
            .padding()
            .navigationTitle("Telepole")
        }
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
                Text(pet.shortbirthday)
                    .font(.footnote)
                Text(pet.gender)
                    .font(.footnote)
                Spacer()
            }.font(.body)
        }
        .padding()
        .foregroundColor(.white)
        .frame(width: cardWidth ,height: 240, alignment: .center)
        .background(WebImage(url: pet.avator)
                            .resizable()
                            .scaledToFill())
        .cornerRadius(24)
    }
}

struct PetCards: View {
    @ObservedObject var fetcher = PetsFetcher()
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
            ForEach(fetcher.pets) { pet in
                NavigationLink(destination: AboutView(pet: pet)) { PetCardItem(pet: pet)
                }
            }
        }
        .padding(.top)
    }
}
