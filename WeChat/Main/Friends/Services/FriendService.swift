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
    public var baseURL: URL {
        return baseUrl
    }
    
    public var path: String {
        switch self {
        case .friendList:
            return "/user/userList"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .friendList:
            return .post
        }
    }
    
    public var task: Task {
        switch self {
        case .friendList:
            return .requestPlain
        }
    }
}

let friendProvider = MoyaProvider<FriendsAPI>(plugins: [NetworkActivityPlugin(networkActivityClosure: { (changeTyoe, targetType) in
    print("changeType--->\(changeTyoe), targetType--->\(targetType)")
})])

