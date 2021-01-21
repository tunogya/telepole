//
//  UserModel.swift
//  Telepole
//
//  Created by 丁涯 on 2021/1/19.
//

import Foundation
import CoreData

final class User: NSManagedObject {
   @NSManaged var user: String
   @NSManaged var fullName: String
   @NSManaged var email: String
}
