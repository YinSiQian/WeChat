//
//  MomentModel.swift
//  WeChat
//
//  Created by ABJ on 2018/8/2.
//  Copyright © 2018年 ysq. All rights reserved.
//

import Foundation

struct MomentModel: Mappable {
    
    let content: String
    let location: String
    let momentId: Int
    let name: String
    let timestamp: String
    let uid: Int
    let urls: String
    let userIcon: String
    let userId: Int
    let comments: [Comment]
    let loves: [Love]
    
    struct Comment: Mappable {
        let id: Int
        let momentId: Int
    }
    
    struct Love: Mappable {
        let id: Int
        let momentId: Int
        let uid: Int
        let username: String
    }

}
