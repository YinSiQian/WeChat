//
//  FriendModel.swift
//  WeChat
//
//  Created by ysq on 2018/8/2.
//  Copyright © 2018年 ysq. All rights reserved.
//

import Foundation

struct FriendModels: Mappable {
    
    let firstLetter: String

    let users: [User]
    
    struct User: Mappable {
        
        let username: String
        let usermobile: String
        let id: Int
        let icon: String
        let signature: String
        let sex: Int
        let wxId: String
        let address: String
        let firstLetter: String
    }
    
}
