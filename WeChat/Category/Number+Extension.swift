//
//  Number+Extension.swift
//  WeChat
//
//  Created by ysq on 2018/7/29.
//  Copyright © 2018年 ysq. All rights reserved.
//

import Foundation

let msgDateFormatter = DateFormatter()

extension Int {
    
    var StringValue: String {
        return "\(self)"
    }
    
    var timestamp: String {
        let nowTimeValue = Date(timeIntervalSince1970: TimeInterval(self))
        msgDateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let stamp = msgDateFormatter.string(from: nowTimeValue)
        return stamp
    }
    
}
