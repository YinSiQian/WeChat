//
//  Extension+TargetType.swift
//  WeChat
//
//  Created by ysq on 2018/7/30.
//  Copyright © 2018年 ysq. All rights reserved.
//

import Foundation
import Moya

extension TargetType {
    
    public var headers: [String : String]? {
        guard UserModel.sharedInstance.accessToken != "" else {
            return nil
        }
        return ["accessToken": UserModel.sharedInstance.accessToken]
    }
    
    public var sampleData: Data {
        return Data()
    }
    
}
