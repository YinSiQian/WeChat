//
//  UserService.swift
//  WeChat
//
//  Created by ysq on 2018/8/25.
//  Copyright © 2018年 ysq. All rights reserved.
//

import Foundation
import Moya

public enum UserAPI {
    case exit
    case updateName(username: String)
    case updateAvatar(url: String)
    case updateSign(sign: String)
    case updateSex(sex: Int)
    case userInfo
}

extension UserAPI: TargetType {
    
    public var path: String {
        switch self {
        case .exit:
            return "/user/logout"
        case .updateSex(sex: _):
            return "/user/modifySex"
        case .updateSign(sign: _):
            return "/user/info"
        case .updateAvatar(url: _):
            return "/user/modifySex"
        case .updateName(username: _):
            return "/user/modifySex"
        case .userInfo:
            return "/user/info"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .exit:
            return .post
        case .updateSex(sex: _):
            return .post
        case .updateSign(sign: _):
            return .post
        case .updateAvatar(url: _):
            return .post
        case .updateName(username: _):
            return .post
        case .userInfo:
            return .get
        }
    }
    
    public var task: Task {
        switch self {
        case .exit:
            return .requestParameters(parameters: ["accessToken": UserModel.sharedInstance.accessToken], encoding: URLEncoding.default)
            
        case .updateSex(let sex):
            return .requestParameters(parameters: ["sex": sex], encoding: URLEncoding.default)
            
        case .updateSign(let sign):
            return .requestParameters(parameters: ["signature": sign], encoding: URLEncoding.default)

        case .updateAvatar(let url):
            return .requestParameters(parameters: ["url": url], encoding: URLEncoding.default)

        case .updateName(let username):
            return .requestParameters(parameters: ["username": username], encoding: URLEncoding.default)

        case .userInfo:
            return .requestPlain

        }
    }
    
}
