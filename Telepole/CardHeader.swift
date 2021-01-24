//
//  CardTitle.swift
//  Telepole
//
//  Created by 丁涯 on 2021/1/17.
//

import SwiftUI

struct CardHeader: View {
    @Binding var flag: Bool
    
    let hasEditButton: Bool
    let title: String
    
    var body: some View {
        VStack(spacing: 0) {
            SliderIndicator()
                .padding(.top, 12)
            
            VStack {
                HStack {
                    Text(title)
                        .bold()
                    
                    Spacer()
                    
                    if hasEditButton{
                        EditButton()
                            .font(.body)
                    }
                    
                    Button(action: {
                        flag = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
                .font(.title2)
                .padding(.horizontal)
                
                Divider()
            }
        }
    }
}

//struct CardTitle_Previews: PreviewProvider {
//    static var previews: some View {
//        CardTitle()
//    }
//}
