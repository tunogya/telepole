//
//  AreaListView.swift
//  Telepole
//
//  Created by 丁涯 on 2021/1/17.
//

import SwiftUI
import MapKit

struct AreaListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Region.latitude, ascending: true)],
        animation: .default)
    
    private var items: FetchedResults<Region>
    
    @Binding var region: MKCoordinateRegion
    @Binding var isShowArea: Bool
    
    @ObservedObject var locationManager = LocationManager()
    
    var userLatitude: CLLocationDegrees {
        return locationManager.lastLocation?.coordinate.latitude ?? 0
    }
    
    var userLongitude: CLLocationDegrees {
        return locationManager.lastLocation?.coordinate.longitude ?? 0
    }
    
    private func addRegion(_ region: RegionModel) {
        withAnimation {
            let newRegion = Region(context: viewContext)
            newRegion.title = region.title
            newRegion.latitude = region.latitude
            newRegion.longitude = region.longitude
            newRegion.latitudeDelta = region.latitudeDelta
            newRegion.longitudeDelta = region.longitudeDelta
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
    
    private func deleteRegions(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

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
    
    var body: some View {
        VStack(spacing: 0) {
            SliderIndicator()
                .padding(.top, 12)
            
            VStack {
                // 标题及定位
                HStack {
                    Text("Telepole")
                        .bold()
                    Spacer()
                    EditButton()
                        .font(.body)
                }
                .font(.title2)
                .padding(.horizontal)
                
                Divider()
            }
            
            Form {
                Section(header: Text("我的关注地区")) {
                    ForEach(items) { item in
                        Button(action: {
                            region = MKCoordinateRegion(
                                center: CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude),
                                span: MKCoordinateSpan(latitudeDelta: item.latitudeDelta, longitudeDelta: item.longitudeDelta)
                            )
                            isShowArea = true
                        }) {
                            Text(item.title ?? "神秘地点")
                        }
                    }
                    .onDelete(perform: deleteRegions)
                    
                    if items.isEmpty{
                        Button(action: {
                            addRegion(RegionModel(title: "\(region.center.latitude), \(region.center.longitude)", latitude: region.center.latitude, longitude: region.center.longitude, latitudeDelta: region.span.latitudeDelta, longitudeDelta: region.span.longitudeDelta))
                        }) {
                            Text("增加一个兴趣点")
                                .font(.body)
                        }
                    }
                }
            }
        }
        .background(VisualEffectBlur(blurStyle: .systemChromeMaterial))
        .cornerRadius(20)
    }
}
//struct AreaListView_Previews: PreviewProvider {
//    static var previews: some View {
//        AreaListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
