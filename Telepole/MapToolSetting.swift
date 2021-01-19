//
//  MapToolSetting.swift
//  Telepole
//
//  Created by 丁涯 on 2021/1/17.
//

import SwiftUI
import MapKit

struct MapToolSetting: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var isShowSetting: Bool
    @Binding var region: MKCoordinateRegion
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 20) {
                Button(action: {
                    isShowSetting.toggle()
                }) {
                    Image(systemName: "person.circle")
                        .frame(width: 44, height: 44, alignment: .center)
                        .font(.title)
                        .background(VisualEffectBlur(blurStyle: .systemChromeMaterial))
                        .clipShape(Circle())
                }
                
                VStack {
                    Button(action: {
                        
                    }) {
                        Image(systemName: "location.fill")
                            .frame(width: 40, height: 40, alignment: .center)
                    }
                    Divider()
                        .frame(width: 44, height: 1, alignment: .center)
                    
                    Button(action: {
                        addRegion(title: "测试", latitude: region.center.latitude, longitude: region.center.longitude, latitudeDelta: region.span.latitudeDelta, longitudeDelta: region.span.longitudeDelta)
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .frame(width: 40, height: 40, alignment: .center)
                    }
                }
                .background(VisualEffectBlur(blurStyle: .systemChromeMaterial))
                .cornerRadius(8)
                
                Spacer()
            }
        }
        .padding()
        .padding(.top, 30)
    }
    
    private func addRegion(title: String ,latitude: Double, longitude: Double, latitudeDelta: Double, longitudeDelta: Double) {
        withAnimation {
            let newRegion = Region(context: viewContext)
            newRegion.title = title
            newRegion.latitude = latitude
            newRegion.longitude = longitude
            newRegion.latitudeDelta = latitudeDelta
            newRegion.longitudeDelta = longitudeDelta
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

//struct MapToolSetting_Previews: PreviewProvider {
//    static var previews: some View {
//        MapToolSetting()
//    }
//}
