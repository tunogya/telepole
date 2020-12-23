//
//  AboutView.swift
//  Telepole
//
//  Created by 丁涯 on 2020/12/23.
//

import SwiftUI

var SCREENWIDTH = UIScreen.main.bounds.width
var SCREENHEIGHT = UIScreen.main.bounds.height

struct AboutView: View {
    var body: some View {
        ZStack {
            VStack{
                PetAvator()
                
                Group {
                    PetInfoCard(name: "贝贝", variety: "杜宾犬", age: "4岁", gender: "Boy", location: "江苏省，南通市")
                    
                    OwnerInfo(name: "丁浩", date: "2020.01.01", job: "开发", avator: "avator地址", content: "Hellow，worldHellow，worldHellow，worldHellow，worldHellow，worldHellow，worldHellow，worldHellow，worldHellow，worldHello")
                    
                }
                .offset(y: -80)
      
                Spacer()
                
            }
            
            VStack {
                ButtonsTop()
                    .padding(.horizontal)
                    .padding(.top, 70)
                
                Spacer()
                
                ButtonsButtom()
                    .padding(.bottom, 60)
            }
            
        }
       
        .ignoresSafeArea(.all)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}

struct PetInfoCard: View {
    let name: String
    let variety: String
    let age: String
    let gender: String
    let location: String
    
    var body: some View {
        VStack(spacing: 16.0) {
            HStack {
                Text(name)
                    .bold()
                    .font(.title2)
                Spacer()
                Image(systemName: "infinity.circle")
                    .font(.title3)
            }
            
            HStack(spacing: 4.0) {
                Text(variety)
                    .font(.body)
                Spacer()
                Image(systemName: "clock")
                    .font(.footnote)
                Text(age)
                    .font(.footnote)
            }
           
            
            HStack(spacing: 4.0) {
                Image(systemName: "paperplane.fill")
                Text(location)
                    .foregroundColor(Color("GrayColor"))
                Spacer()
            }
            .font(.footnote)
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(30)
        .shadow(color: Color.gray, radius: 1, x: 1, y: 1)
        .padding(.horizontal, 20)
    }
}

struct OwnerInfo: View {
    let name: String
    let date: String
    let job: String
    let avator: String
    let content: String
    
    var body: some View {
        VStack {
            HStack(spacing: 16.0) {
                Image("pet-avator")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 75, height: 75, alignment: .center)
                    .cornerRadius(75)
                    .shadow(color: Color.gray, radius: 1, x: 1, y: 1)
                
                VStack(alignment: .leading, spacing: 12.0) {
                    HStack {
                        Text(name)
                            .font(.body)
                            .bold()
                        Spacer()
                        Text(date)
                            .font(.footnote)
                    }
                    Text(job)
                        .font(.footnote)
                        .foregroundColor(Color("GrayColor"))
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            HStack {
                Text(content)
                    .font(.body)
                Spacer()
            }
            .padding(.top, 16)
            .padding(.horizontal)
        }
    }
}

struct PetAvator: View {
    var body: some View {
        Image("pet-avator")
            .resizable()
            .scaledToFill()
            .frame(height: SCREENWIDTH, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
}

struct ButtonsTop: View {
    var body: some View {
        HStack {
            Button(action: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/{}/*@END_MENU_TOKEN@*/) {
                Image(systemName: "arrow.left.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40, alignment: .center)
                
            }
            Spacer()
            Button(action: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/{}/*@END_MENU_TOKEN@*/) {
                Image(systemName: "paperplane.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40, alignment: .center)
            }
        }
        .foregroundColor(.white)
        .opacity(0.5)
    }
}

struct ButtonsButtom: View {
    var body: some View {
        HStack(spacing: 16.0) {
            Spacer()
            Button(action: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/{}/*@END_MENU_TOKEN@*/) {
                Image(systemName: "heart.circle")
                    .resizable()
                    .frame(width: 44, height: 44, alignment: .center)
                    .foregroundColor(Color("GrayColor"))
            }
            
            Button(action: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/{}/*@END_MENU_TOKEN@*/) {
                HStack {
                    Spacer()
                    Text("联系我")
                        .font(.body)
                    Spacer()
                }
                .foregroundColor(.white)
                .frame(width: 220, height: 44, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .background(Color("AccentColor"), alignment: .center)
                .cornerRadius(20)
            }
            Spacer()
        }
    }
}
