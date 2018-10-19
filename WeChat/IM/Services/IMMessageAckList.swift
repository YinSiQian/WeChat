//
//  IMMessageAckList.swift
//  WeChat
//
//  Created by ysq on 2018/10/19.
//  Copyright © 2018 ysq. All rights reserved.
//

import Foundation

struct IMMessageAckList {
    
    static var shared = IMMessageAckList()
    
    private var list: [String : String] = [:]
    
    private init() {}
    
}

extension IMMessageAckList {
    
    mutating func append(chatId: Int) {
        if var value = list[chatId.StringValue] {
            value = value + "," + chatId.StringValue
        } else {
            list[chatId.StringValue] = chatId.StringValue
        }
    }
    
    mutating func get(chatId: Int) -> String? {
        return list[chatId.StringValue]
    }
    
    mutating func remove(chatId: Int) {
        list.removeValue(forKey: chatId.StringValue)
    }
    
}
