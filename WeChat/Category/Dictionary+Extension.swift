//
//  Dictionary+Extension.swift
//  WeChat
//
//  Created by ysq on 2018/7/29.
//  Copyright © 2018年 ysq. All rights reserved.
//

import Foundation

extension Dictionary {
    
    public func convertToString() -> String? {
        guard !JSONSerialization.isValidJSONObject(self) else {
            let data = try! JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
            let json = String(data: data, encoding: .utf8)
            return json!
        }
        return ""
    }
}
