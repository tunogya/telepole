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
                    PetInfoCard()
                    
                    OwnerInfo()
                    
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
    var body: some View {
        VStack(spacing: 16.0) {
            HStack {
                Text("贝贝")
                    .bold()
                    .font(.title2)
                Spacer()
                Image(systemName: "infinity.circle.fill")
                    .font(.title3)
            }
            
            HStack(spacing: 4.0) {
                Text("杜宾犬")
                    .font(.body)
                Spacer()
                Image(systemName: "clock.fill")
                    .font(.footnote)
                Text("1岁")
                    .font(.footnote)
            }
           
            
            HStack(spacing: 4.0) {
                Image(systemName: "paperplane.fill")
                Text("江苏省，南通市")
                Spacer()
            }
            .font(.footnote)
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(30)
        .shadow(color: Color.gray, radius: 2, x: 2, y: 2)
        .padding(.horizontal, 20)
    }
}

struct OwnerInfo: View {
    var body: some View {
        VStack {
            HStack {
                Image("pet-avator")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 75, height: 75, alignment: .center)
                    .cornerRadius(75)
                
                VStack(alignment: .leading, spacing: 12.0) {
                    HStack {
                        Text("丁浩")
                            .font(.body)
                            .bold()
                        Spacer()
                        Text("2020.12.20")
                            .font(.footnote)
                    }
                    Text("家长")
                        .font(.footnote)
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            HStack {
                Text("你好啊")
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
                Image(systemName: "arrow.left.circle.fill")
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
                    .foregroundColor(.black)
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
