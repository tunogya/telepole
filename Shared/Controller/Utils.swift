//
//  Utils.swift
//  Telepole
//
//  Created by 丁涯 on 2021/2/20.
//

import Foundation

extension Array {
    // 去重
    func filterDuplicates<E: Equatable>(_ filter: (Element) -> E) -> [Element] {
        var result = [Element]()
        for value in self {
            let key = filter(value)
            if !result.map({filter($0)}).contains(key) {
                result.append(value)
            }
        }
        return result
    }
}

func stringConvertDate(string:String, dateFormat:String="yyyy-MM-dd HH:mm:ss ZZZ") -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat
    return dateFormatter.date(from: string)!
}
