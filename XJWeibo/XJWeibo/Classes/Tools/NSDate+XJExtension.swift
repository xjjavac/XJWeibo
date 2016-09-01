//
//  NSDate+XJExtension.swift
//  XJWeibo
//
//  Created by xj on 8/31/16.
//  Copyright © 2016 xj. All rights reserved.
//

import UIKit

extension NSDate{

    static func dateWithStr(time:String) -> NSDate {
        //1.将服务器返回给我们的时间字符串转换为NSDate
        //1.1创建formatter
        let formatter = NSDateFormatter()
        //1.2设置时间的格式
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z yyyy"
        //1.3设置时间的区域（真机必须设置，否则可能不能转换成功）
        formatter.locale = NSLocale(localeIdentifier: "en")
        //1.4转换字符串，转换好的时间是去除时区的时间
        let createDate = formatter.dateFromString(time)!
        return createDate
        
    }
    var descDate:String{
        get{
            let calendar = NSCalendar.currentCalendar()
            //1.判断是否是今天
            if calendar.isDateInToday(self) {
                //1.0获取当前时间和系统时间之间的差距
                let since = Int(NSDate().timeIntervalSinceDate(self))
                //1.1是否是刚刚
                if since < 60 {
                    return "刚刚"
                }
                //1.2多少分钟以前
                if since < 60*60 {
                    return "\(since/60)分钟"
                }
                 //1.3多少小时以前
                return "\(since/(60*60))小时"
            }
            
            //2.判断是否是昨天
            var formatterStr = "HH:mm"
            if calendar.isDateInYesterday(self) {
                //昨天：HH:mm
                formatterStr = "昨天" + formatterStr
            }else{
                //3.处理一年以内
                formatterStr = "MM-dd" + formatterStr
                //4.处理更早得时间
                let comps = calendar.components(NSCalendarUnit.Year, fromDate: self, toDate: NSDate(), options: NSCalendarOptions(rawValue:0))
                if comps.year >= 1 {
                    formatterStr = "yyyy-" + formatterStr
                }
            }
            
            //5.按照指定的格式将时间转换为字符串
            //5.1创建formatter
            let formatter = NSDateFormatter()
            //5.2设置时间的格式
            formatter.dateFormat = formatterStr
            //5.3设置时间的区域
            formatter.locale = NSLocale(localeIdentifier: "en")
            //5.4格式化
            return formatter.stringFromDate(self)
            
            
        }
    }
}




















