//
//  LoginAPI.swift
//  WeChat
//
//  Created by ysq on 2018/7/29.
//  Copyright © 2018年 ysq. All rights reserved.
//

import Foundation
import Moya

public enum LoginAPI {
    case login(phone: String, password: String)
    case register(phone: String, password: String)
//    case msgCode(phone: String)
}

extension LoginAPI: TargetType {
    public var baseURL: URL {
        return baseUrl
    }
    
    public var path: String {
        switch self {
        case .login(phone: _, password: _):
            return "/user/login"
        case .register(phone: _, password: _):
            return "/user/register"
        }
    }
    
    public var method: Moya.Method {
        return .post
    }
    
    public var task: Task {
        switch self {
        case .login(let phone, let password):
            return .requestParameters(parameters: ["mobile": phone, "password": password], encoding: URLEncoding.default)
        case .register(let phone, let password):
            return .requestParameters(parameters: ["mobile": phone, "password": password], encoding: URLEncoding.default)
        }
    }

    
}
