//
//  UserModel.swift
//  WeChat
//
//  Created by ysq on 2018/7/29.
//  Copyright © 2018年 ysq. All rights reserved.
//

import Foundation

struct UserModel {
    
    static var sharedInstance = UserModel()
    
    var username: String = ""
    var password: String = ""
    var phoneNumber: String = ""
    var accessToken: String = ""
    var id: Int = 0
    var icon: String = ""
    var firstLetter: String = ""
    var signature: String = ""
    var sex: Int = 0
    var wxId: String = ""
    var expired: String = ""
    var address: String = ""
    
    private init() {
        
    }
    
}

extension UserModel {
    
    public mutating func initialData(data: [String: Any]) {
        self.username = data["username"] as! String
        self.password = data["password"] as! String
        self.accessToken = data["accessToken"] as! String
        self.id = data["id"] as! Int
        self.phoneNumber = data["usermobile"] as! String
        self.icon = data["icon"] as! String
        self.firstLetter = data["firstLetter"] as! String
        self.signature = data["signature"] as! String
        self.sex = data["sex"] as! Int
        self.wxId = data["wxId"] as! String
        self.expired = data["expired"] as! String
        self.address = data["address"] as! String
    }
}
