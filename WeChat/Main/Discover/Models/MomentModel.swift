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
    //发布人
    let userId: Int
    let comments: [Comment]
    let loves: [Love]
    let urlInfo: [ImageInfo]
    
    struct Love: Mappable {
        let id: Int
        let momentId: Int
        let uid: Int
        let username: String
    }
    
    struct Comment: Mappable {
        let id: Int
        let momentId: Int
        let receivedId: Int
        let replyId: Int
        let username: String
        let content: String
        let createTime: String
        let updateTime: String
        let replyName: String
        let receivedName: String
    }
    
    struct ImageInfo: Mappable {
        let baseUrl: String
        let path: String
        let type: String
        let width: CGFloat
        let height: CGFloat
    }

}
