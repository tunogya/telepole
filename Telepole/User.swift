//
//  Pets.swift
//  Telepole
//
//  Created by 丁涯 on 2020/12/27.
//
import Alamofire
import Foundation
import SwiftyJSON

let HOSTNAME = "https://app.wakanda.vip"

struct User: Identifiable {
    var id = UUID()
    var code: String
    var name: String
    var username: String
    var description: String
    var profile_image_url: String
    var protected: Bool
    var verified: Bool
    var variety: String
    var gender: String
   
}

// 根据ID获取用户数据
public class UserFetcherById {
    var user = User(code: "", name: "", username: "", description: "", profile_image_url: "", protected: false, verified: false, variety: "", gender: "boy")
    
    init(id: String) {
        self.load(id: id)
    }
    
    func load(id: String) {
        let url = "\(HOSTNAME)/telepole/v1.0/users/\(id)"
    
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)["data"]
                self.user =  User(
                    code: jsonData["_id"].stringValue,
                    name: jsonData["description"].stringValue,
                    username: jsonData["name"].stringValue,
                    description: jsonData["variety"].stringValue,
                    profile_image_url: jsonData["profile_image_url"].stringValue,
                    protected: jsonData["protected"].boolValue,
                    verified: jsonData["verified"].boolValue,
                    variety: jsonData["variety"].stringValue,
                    gender: jsonData["gender"].stringValue
                )
                print("网络请求")
                print(self.user)
            case .failure(let error):
                print(error)
            }
        }
    }
}
