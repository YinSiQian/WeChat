//
//  MessageService.swift
//  WeChat
//
//  Created by ysq on 2018/9/28.
//  Copyright © 2018 ysq. All rights reserved.
//

import Foundation
import Moya




public enum MessageAPI {
    
    case pullOfflineMessage(timestamp: Int)
    case readMsg(msgId: Int)
    case getUnReadMsg(chatIds: String)
    case readMsgs(ids: String)
    case trending
    
}

extension MessageAPI: TargetType {
    
    public var baseURL: URL {
        switch self {
        case .getUnReadMsg(chatIds: _), .pullOfflineMessage(timestamp: _), .readMsgs(ids: _), .readMsg(msgId: _):
            return baseUrl
        default:
            return URL(string: "https://github-trending-api.now.sh/")!
        }
    }
    
    public var path: String {
        switch self {
        case .getUnReadMsg(chatIds: _):
            return "/im/unReadMsgs"
        case .pullOfflineMessage(timestamp: _):
            return "/im/getMsg"
        case .readMsg(msgId: _):
            return "/im/readMsg"
        case .readMsgs(ids: _):
            return "/im/readMsgs"
        case .trending:
            return "developers"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getUnReadMsg(chatIds: _), .trending:
            return .get
        case .pullOfflineMessage(timestamp: _):
            return .get
        case .readMsg(msgId: _), .readMsgs(ids: _):
            return .post
            
        }
    }
    
    public var task: Task {
        switch self {
        case .getUnReadMsg(let chatIds):
            return .requestParameters(parameters: ["chatIds": chatIds], encoding: URLEncoding.default)
        case .pullOfflineMessage(let timestamp):
            return .requestParameters(parameters: ["timestamp": timestamp], encoding: URLEncoding.default)
        case .readMsg(let msgId):
            return .requestParameters(parameters: ["msgId": msgId], encoding: URLEncoding.default)
        case .readMsgs(let ids):
            return .requestParameters(parameters: ["msgIds": ids], encoding: URLEncoding.default)
            
        case .trending:
            return .requestParameters(parameters: ["language": "", "since": "daily"], encoding: URLEncoding.default)
        }
    }
    
    
    
    
}
