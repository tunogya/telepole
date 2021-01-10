//
//  TelepoleTests.swift
//  TelepoleTests
//
//  Created by 丁涯 on 2020/12/23.
//

import XCTest
@testable import Telepole
import Alamofire
import SwiftyJSON

class TelepoleTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // 注册用户
        let url = URL(string: "\(HOSTNAME)/telepole/v1.0/User/")!
        
        print(url)
        
//        AF.request(url,
//                   method: .post,
//                   parameters: data,
//                   encoder: JSONParameterEncoder.default).response { response in
//            debugPrint(response)
//        }
        
        
        
        
        
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
