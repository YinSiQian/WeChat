//
//  TimelineService.swift
//  WeChat
//
//  Created by ysq on 2018/6/26.
//  Copyright © 2018年 ysq. All rights reserved.
//

import Foundation
import Moya

public enum TimelineAPIs {
    case list(timestamp: String)
    //发送
    case post(content: String, url: String, location: String)
    //重新编辑
    case update(momentId: Int, content: String, location: String)
    //删除
    case delete(momentId: Int)
    //添加评论
    case addComment(momentId: Int, content: String, uid: Int, isComment: Int)
    //删除评论
    case deleteComment(id: Int)
    //点赞
    case favorite(momentId: Int, isLoved: Int)
}

extension TimelineAPIs: TargetType {
    
    public var path: String {
        switch self {
        case .list(_):
            return "moments/list"
        case .post(content: _, url: _, location: _):
            return "moments/sendMoment"
        case .update(momentId: _, content: _, location: _):
            return "moments/update"
        case .delete(momentId: _):
            return "moments/delete"
        case .addComment(momentId: _, content: _, uid: _, isComment: _):
            return "moments/addComment"
        case .deleteComment(id: _):
            return "moments/deleteComment"
        case .favorite(momentId: _, isLoved: _):
            return "moments/favorite"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .list(_):
            return .get
        case .post(content: _, url: _, location: _):
            return .post
        case .update(momentId: _, content: _, location: _):
            return .post
        case .delete(momentId: _):
            return .post
        case .addComment(momentId: _, content: _, uid: _, isComment: _):
            return .post
        case .deleteComment(id: _):
            return .post
        case .favorite(momentId: _, isLoved: _):
            return .post
        }
    }
    
    public var task: Task {
        switch self {
        case .list(let timestamp):
            return .requestParameters(parameters: ["timestamp": timestamp], encoding: URLEncoding.default)
        case .post(let content, let url, let location):
            return .requestParameters(parameters: ["content": content, "imagesUrl": url, "location": location], encoding: URLEncoding.default)
        case .update(let momentId, let content, let location):
            return .requestParameters(parameters: ["content": content, "momentId": momentId, "location": location], encoding: URLEncoding.default)
        case .delete(let momentId):
            return .requestParameters(parameters: ["momentId": momentId], encoding: URLEncoding.default)
        case .addComment(let momentId, let content, let uid, let isComment):
            return .requestParameters(parameters: ["momentId": momentId, "content": content, "uid": uid, "isComment": isComment], encoding: URLEncoding.default)
        case .deleteComment(let id):
            return .requestParameters(parameters: ["id": id], encoding: URLEncoding.default)
        case .favorite(let momentId, let isLoved):
            return .requestParameters(parameters: ["momentId": momentId, "isLoved": isLoved], encoding: URLEncoding.default)
        
        }
    }
    
}
