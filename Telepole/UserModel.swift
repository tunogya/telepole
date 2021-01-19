//
//  UserModel.swift
//  Telepole
//
//  Created by 丁涯 on 2021/1/19.
//

import Alamofire
import Foundation
import SwiftyJSON

struct UserModel {
    var user: String
    var fullName: String
    var email: String
}

class UserApi {
    //    根据id登陆
    func login(user: String, completion: @escaping (UserModel) -> ()) {
        let url = "\(HOSTNAME)/telepole/v1.0/users/\(user)/"
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)["data"]
                completion(UserModel(
                    user: jsonData["user"].stringValue,
                    fullName: jsonData["fullName"].stringValue,
                    email: jsonData["email"].stringValue
                ))
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //    用户注册
    func register(_ user: UserModel, completion: @escaping (UserModel) -> ()) {
        let parameters: [String: Array<Any>] = ["data": [["fullName": user.fullName, "email": user.email, "user": user.user]]]
        let url = "\(HOSTNAME)/telepole/v1.0/users/"
        
        AF.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let id = JSON(value)["ids"][0].stringValue
                self.login(user: id) { (User) in
                    completion(User)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
