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
    var usermobile: String = ""
    var accessToken: String = ""
    var id: Int = 0
    var icon: String = ""
    var firstLetter: String = ""
    var signature: String = ""
    var sex: Int = 0
    var wxId: String = ""
    var expired: String = ""
    var address: String = ""
    
    var isLogin: Bool {
        return accessToken != ""
    }
    
    private init() {
        let data = UserDefaults.standard.object(forKey: "userModel + \(host)") as? [String: Any]
        if data != nil {
            initial(data: data!)
        }
    }
    
}

extension UserModel {
    
    public mutating func initial(data: [String: Any]) {
        
        self.username = data["username"] as! String
//        self.password = data["password"] as! String
        self.accessToken = data["accessToken"] as! String
        self.id = data["id"] as! Int
        self.usermobile = data["usermobile"] as! String
        self.icon = data["icon"] as! String
        self.firstLetter = data["firstLetter"] as! String
        self.signature = data["signature"] as! String
        self.sex = data["sex"] as! Int
        self.wxId = data["wxId"] as! String
        self.expired = data["expired"] as! String
        self.address = data["address"] as! String
        
    }
    
    public func removeAccessToken() {
        UserModel.sharedInstance.accessToken = ""
    }
    
    public func syncUserInfo() {
        let mirror = Mirror(reflecting: UserModel.sharedInstance)
        var data: Dictionary = [String : Any]()
        for (key, value) in mirror.children {
            data.updateValue(value, forKey: key!)
        }
        UserDefaults.standard.set(data, forKey: "userModel + \(host)")
    }
    
}
