//
//  MomentModel.swift
//  WeChat
//
//  Created by ysq on 2018/8/2.
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
        let uid: Int          //点赞人id
        let username: String  //名字
    }
    
    struct Comment: Mappable {
        let id: Int
        let momentId: Int
        let receivedId: Int
        let replyId: Int
        let content: String
        let createTime: String
        let updateTime: String
        let replyName: String      //回复人
        let receivedName: String   //被回复人
        let isComment: Int         //1 评论 2 回复
    }
    
    struct ImageInfo: Mappable {
        let baseUrl: String
        let path: String
        let type: String
        let width: CGFloat
        let height: CGFloat
    }
    

}
