//
//  Utils.swift
//  Telepole
//
//  Created by 丁涯 on 2021/2/20.
//

import Foundation

extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()

        for value in self {
            if result.contains(value) == false {
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

func updateTimeToCurrennTime(timeStamp: Double) -> String {
    //获取当前的时间戳
    let currentTime = Date().timeIntervalSince1970
    //时间戳为毫秒级要 ／ 1000， 秒就不用除1000，参数带没带000
    let timeSta:TimeInterval = TimeInterval(timeStamp)
    //时间差
    let reduceTime : TimeInterval = currentTime - timeSta
    //时间差小于60秒
    if reduceTime < 60 {
        return "刚刚"
    }
    //时间差大于一分钟小于60分钟内
    let mins = Int(reduceTime / 60)
    if mins < 60 {
        return "\(mins)分钟前"
    }
    let hours = Int(reduceTime / 3600)
    if hours < 24 {
        return "\(hours)小时前"
    }
    let days = Int(reduceTime / 3600 / 24)
    if days < 30 {
        return "\(days)天前"
    }
    //不满足上述条件---或者是未来日期-----直接返回日期
    let date = NSDate(timeIntervalSince1970: timeSta)
    let dfmatter = DateFormatter()
    //yyyy-MM-dd HH:mm:ss
    dfmatter.dateFormat="yyyy年MM月dd日 HH:mm:ss"
    return dfmatter.string(from: date as Date)
}

func timeStampToString(timeStamp: Double) -> String {
    //时间戳为毫秒级要 ／ 1000， 秒就不用除1000，参数带没带000
    let timeSta:TimeInterval = TimeInterval(timeStamp / 1000)
    let date = NSDate(timeIntervalSince1970: timeSta)
    let dfmatter = DateFormatter()
    //yyyy-MM-dd HH:mm:ss
    dfmatter.dateFormat="yyyy年MM月dd日 HH:mm:ss"
    return dfmatter.string(from: date as Date)
}

//MARK: -时间转时间戳函数
func timeToTimeStamp(time: String) -> Double {
    let dfmatter = DateFormatter()
    //yyyy-MM-dd HH:mm:ss
    dfmatter.dateFormat="yyyy年MM月dd日 HH:mm:ss"
    let last = dfmatter.date(from: time)
    let timeStamp = last?.timeIntervalSince1970
    return timeStamp!
}

// 循环
func DispatchTimer(timeInterval: Double, handler: @escaping (DispatchSourceTimer?)->())
{
    let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
    timer.schedule(deadline: .now(), repeating: timeInterval)
    timer.setEventHandler {
        DispatchQueue.main.async {
            handler(timer)
        }
    }
    timer.resume()
}

// 延迟
func DispatchAfter(after: Double, handler: @escaping ()->())
{
    DispatchQueue.main.asyncAfter(deadline: .now() + after) {
        handler()
    }
}
