//
//  NetworkManager.swift
//  WeChat
//
//  Created by ysq on 2018/5/27.
//  Copyright © 2018年 ysq. All rights reserved.
//

import Foundation
import Moya
import Alamofire

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
                    if data.isEmpty {
                        compection(value, nil)
                    } else {
                        compection(data, nil)
                    }
                } else {
                    let customError = NSError(domain: baseUrl.absoluteString, code: code, userInfo: ["message": value["message"] as Any])
                    compection([:], customError)
                    let root = AppDelegate.currentAppdelegate().root
                    if root is UITabBarController {
                        (root as! UITabBarController).selectedViewController?.currentControllerInKeyWindow?.showError(error: customError)
                    } else {
                        AppDelegate.currentAppdelegate().root?.currentControllerInKeyWindow?.showError(error: customError)
                    }
                }
            } catch {
                print(error.localizedDescription)
                compection([:], NSError(domain: baseUrl.absoluteString, code: 500, userInfo: nil))
            }
        }
    }
    
    public static func upload(images: [UIImage], success: @escaping (_ response : Any?) -> (), failture : @escaping (_ error : Error)->()) {
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (_, value) in images.enumerated() {
                let imageData = UIImageJPEGRepresentation(value, 1.0)
                multipartFormData.append(imageData!, withName: "image", fileName: "", mimeType: "image/jpeg")
            }
        },                          to: "http://localhost:8080/file/upload",
                               headers: ["accessToken": UserModel.sharedInstance.accessToken],
                    encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.responseJSON { response in
                                    print("response = \(response)")
                                    let result = response.result
                                    if result.isSuccess {
                                        success(response.value)
                                    }
                                }
                            case .failure(let encodingError):
                                failture(encodingError)
                            }
                        }
        )
    }
    
}
