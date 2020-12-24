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
                .offset(y: -70)
      
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

// 宠物信息卡
struct PetInfoCard: View {
    let name: String
    let variety: String
    let age: String
    let gender: String
    let location: String
    
    var body: some View {
        VStack(spacing: 10.0) {
            HStack {
                Text(name)
                    .bold()
                    .font(.title)
                Spacer()
                Image(systemName: "infinity.circle")
                    .font(.title2)
            }
            .padding(.bottom, 8)
            
            HStack(spacing: 4.0) {
                Text(variety)
                    .font(.body)
                Spacer()
                Image(systemName: "clock")
                    .font(.footnote)
                Text(age)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
           
            
            HStack(spacing: 4.0) {
                Image(systemName: "paperplane.fill")
                Text(location)
                    .foregroundColor(.secondary)
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

// 家长信息卡
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
                            .foregroundColor(.secondary)
                    }
                    Text(job)
                        .font(.footnote)
                        .foregroundColor(.secondary)
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

// 宠物画廊
struct PetAvator: View {
    var body: some View {
        Image("pet-avator")
            .resizable()
            .scaledToFill()
            .frame(height: SCREENWIDTH, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
}

// 顶部的按钮：返回、分享
struct ButtonsTop: View {
    var body: some View {
        HStack {
            // 返回按钮
            Button(action: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/{}/*@END_MENU_TOKEN@*/) {
                Image(systemName: "arrow.left.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40, alignment: .center)
                
            }
            
            Spacer()
            
            // 分享按钮
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

// 底部的按钮：喜欢、联系
struct ButtonsButtom: View {
    var body: some View {
        HStack(spacing: 16.0) {
            Spacer()
            
            // 喜欢按钮
            Button(action: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/{}/*@END_MENU_TOKEN@*/) {
                Image(systemName: "heart.circle")
                    .resizable()
                    .frame(width: 44, height: 44, alignment: .center)
                    .foregroundColor(.secondary)
            }
            
            // 联系按钮
            Button(action: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/{}/*@END_MENU_TOKEN@*/) {
                HStack {
                    Spacer()
                    Text("联系我")
                        .font(.body)
                    Spacer()
                }
                .foregroundColor(Color("GrayColor"))
                .frame(width: 220, height: 44, alignment: .center)
                .background(Color("AccentColor"), alignment: .center)
                .cornerRadius(20)
            }
            
            Spacer()
        }
    }
}
