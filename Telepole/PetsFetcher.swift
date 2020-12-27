//
//  PetsFetcher.swift
//  Telepole
//
//  Created by 丁涯 on 2020/12/27.
//

import Foundation
import Alamofire
import SwiftyJSON

public class PetsFetcher: ObservableObject {
    @Published var pets = [Pet]()
    
    init() {
        load()
    }
    
    func load() {
        let url = URL(string: "https://app.wakanda.vip/rest-api/v1.0/Pets/")!
        
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
}
