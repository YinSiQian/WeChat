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
    
}

extension TimelineAPIs: TargetType {
    public var baseURL: URL {
        return baseUrl
    }
    
    public var path: String {
        switch self {
        case .list(_):
            return "moments/list"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .list(_):
            return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .list(let timestamp):
            return .requestParameters(parameters: ["accessToken": "0AD2A2CC8D7D2C8002FA30F1A7B38432", "timestamp": timestamp], encoding: URLEncoding.default)
        }
    }
    
    public var headers: [String : String]? {
        return ["accessToken": UserModel.sharedInstance.accessToken]
    }
    
    
}
