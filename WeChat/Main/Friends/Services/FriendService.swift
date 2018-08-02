//
//  FriendService.swift
//  WeChat
//
//  Created by ysq on 2018/4/27.
//  Copyright © 2018年 ysq. All rights reserved.
//

import Foundation
import Moya

public enum FriendsAPI {
    case friendList
    
}

extension FriendsAPI: TargetType {
    
    public var path: String {
        switch self {
        case .friendList:
            return "/friend/list"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .friendList:
            return .get
        }
    }
    
    public var task: Task {
        switch self {
        case .friendList:
            return .requestPlain
        }
    }
}

