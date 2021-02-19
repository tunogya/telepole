//
//  UserModel.swift
//  Telepole
//
//  Created by 丁涯 on 2021/1/19.
//

import Alamofire
import Foundation
import SwiftyJSON

struct Account:Identifiable, Codable {
    var id: String = ""
    var user: String = ""
    var fullName: String = ""
    var email: String = ""
}

// AccountAPI
extension Account {
    //    根据id登陆
    func login(_ user: String, completion: @escaping (Account) -> ()) {
        let url = "\(HOSTNAME)/users/find/"
        let parameters: [String: Any] = ["query": ["user": ["$eq": user]]]
        // 根据user查询到user信息
        AF.request(url, method: .post, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let value):
                let email = JSON(value)["data"][0]["email"].stringValue
                let fullName = JSON(value)["data"][0]["fullName"].stringValue
                let user = JSON(value)["data"][0]["user"].stringValue
                let user_id = JSON(value)["data"][0]["_id"].stringValue
                completion(Account(id: user_id, user: user, fullName: fullName, email: email))
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    //    用户注册
    func register(_ user: Account, completion: @escaping (Account) -> ()) {
        let url = "\(HOSTNAME)/users/"
        let parameters: [String: Array<Any>] = ["data": [["fullName": user.fullName, "email": user.email, "user": user.user]]]
       
        AF.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let id = JSON(value)["ids"][0].stringValue
                self.getUserByID(id) { (user) in
                    completion(user)
                }
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    // 根据注册返回结果查询用户
    func getUserByID(_ doc_id: String, completion: @escaping (Account) -> ()) {
        let url = "\(HOSTNAME)/users/\(doc_id)/"
        // 根据user查询到user信息
        AF.request(url, method: .get).responseJSON { response in
            switch response.result {
            case .success(let value):
                let email = JSON(value)["data"]["email"].stringValue
                let fullName = JSON(value)["data"]["fullName"].stringValue
                let user = JSON(value)["data"]["user"].stringValue
                let user_id = JSON(value)["data"]["_id"].stringValue
                completion(Account(id: user_id, user: user, fullName: fullName, email: email))
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}
