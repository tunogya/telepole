//
//  LocationModel.swift
//  Telepole
//
//  Created by 丁涯 on 2021/1/23.
//

import Alamofire
import Foundation
import SwiftyJSON

struct GeoModel {
    var pet: PetModel
    var name: String
    var latitude: Double
    var longitude: Double
}

class GeoApi {
    func postMyGeo(_ geo: GeoModel) -> Void {
        let url = "\(HOSTNAME)/telepole/v1.0/users/find/"
        let parameters: [String: Array<Any>] = ["data": [["latitude": geo.latitude, "longitude": geo.longitude, "name": geo.name, "pet": geo.pet.id]]]
       
        AF.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let id = JSON(value)["ids"][0].stringValue
                debugPrint(id)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}
