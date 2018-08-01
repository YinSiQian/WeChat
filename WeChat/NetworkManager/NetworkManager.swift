//
//  NetworkManager.swift
//  WeChat
//
//  Created by ysq on 2018/5/27.
//  Copyright © 2018年 ysq. All rights reserved.
//

import Foundation
import Moya

public class NetworkManager {
    
    typealias complectionHandler = (_ response: [String: Any], _ error: NSError?) ->()
    
    public static func request<T: TargetType>(targetType: T, compection: @escaping (_ response: [String: Any], _ error: NSError?) ->()) -> Void {
        
        let provide = MoyaProvider<T>(plugins: [NetworkActivityPlugin(networkActivityClosure: { (changeType, targetType) in
            print("changeType--->\(changeType), targetType--->\(targetType)")
            switch changeType {
            case .began: break
            case .ended: break
            }
        })])
        provide.request(targetType) { (result) in
            do {
                let response = try result.dematerialize()
                let value = try response.mapJSON() as! [String: Any]
                let code = value["code"] as! Int
                if code == 200 {
                    let data = value["data"] as! [String: Any]
                    compection(data, nil)
                } else {
                    let customError = NSError(domain: baseUrl.absoluteString, code: code, userInfo: ["message": value["message"] as Any])
                    compection([:], customError)
                    AppDelegate.currentAppdelegate().root.selectedViewController?.showError(error: customError)
                }
            } catch {
                print(error.localizedDescription)
                compection([:], NSError(domain: baseUrl.absoluteString, code: 500, userInfo: nil))
            }
        }
    }
    
}
