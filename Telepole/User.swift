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
    var id: String
    var name: String
    var username: String
    var description: String
    var profile_image_url: URL
    var protected: Bool
    var verified: Bool
    var variety: String
    var birthday: String
    var gender: String
    var shortbirthday: String {
        return String(birthday.prefix(7))
    }
}

// 根据ID获取用户数据
public class UserFetcherById {
    var user = User(id: <#T##String#>, name: <#T##String#>, username: <#T##String#>, description: <#T##String#>, profile_image_url: <#T##URL#>, protected: <#T##Bool#>, verified: <#T##Bool#>, variety: <#T##String#>, birthday: <#T##String#>, gender: <#T##String#>)
    
    init(id: String) {
        self.load(id: id)
    }
    
    func load(id: String) {
        let url = URL(string: "\(HOSTNAME)/telepole/v1.0/User/\(id)")!
        
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)["data"]
                self.user =  User(
                    id: jsonData["_id"].stringValue,
                    name: jsonData["description"].stringValue,
                    username: jsonData["name"].stringValue,
                    description: jsonData["variety"].stringValue,
                    profile_image_url: URL(string: jsonData["profile_image_url"].stringValue)!,
                    protected: jsonData["protected"].boolValue,
                    verified: jsonData["verified"].boolValue,
                    variety: jsonData["variety"].stringValue,
                    birthday: jsonData["birthday"].stringValue,
                    gender: jsonData["gender"].stringValue
                )
                print(self.user)
            case .failure(let error):
                print(error)
            }
        }
    }
}
