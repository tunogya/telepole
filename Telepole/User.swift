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
    var profile_image_url: String
    var protected: Bool
    var verified: Bool
    var variety: String
    var gender: String
}

class UserApi {
//    根据用户id查询用户信息
    func getUserById(id: String, completion: @escaping (User) -> ()) {
        let url = "\(HOSTNAME)/telepole/v1.0/users/\(id)"
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)["data"]
                completion(User(
                    id: jsonData["_id"].stringValue,
                    name: jsonData["description"].stringValue,
                    username: jsonData["name"].stringValue,
                    description: jsonData["variety"].stringValue,
                    profile_image_url: jsonData["profile_image_url"].stringValue,
                    protected: jsonData["protected"].boolValue,
                    verified: jsonData["verified"].boolValue,
                    variety: jsonData["variety"].stringValue,
                    gender: jsonData["gender"].stringValue
                ))
            case .failure(let error):
                print(error)
            }
        }
    }
    
//    用户注册
    func createUser(name: String, username: String, description: String, profile_image_url: String, protected: Bool, verified: Bool, gender: String) {
        
        let parameters: [String: Array<[String: Any]>] = ["data": [["name": name, "username": username, "description": description, "profile_image_url": profile_image_url, "protected": protected, "verified": verified, "gender": gender]]]
        print(parameters)
        
        let url = "\(HOSTNAME)/telepole/v1.0/users"
        AF.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
            case .failure(let error):
                print(error)
            }
        }
        
        
        
        
        
    }
    
//    照片上传
    func uploadProfileImage() {
        
    }
}
