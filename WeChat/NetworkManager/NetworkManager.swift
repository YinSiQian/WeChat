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
        if !NetworkStatusManager.shared.isConnectNetwork {
            UIApplication.shared.keyWindow?.show(message: "请检查网络连接状态")
            return
        }
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
                    let customError = NSError(domain: baseUrl.absoluteString, code: code, userInfo: ["message": value["msg"] as Any])
                    compection([:], customError)
                    let root = AppDelegate.currentAppdelegate().root
                    root?.showMsg(customError: customError)
                }
            } catch {
                print(error.localizedDescription)
                let error = NSError(domain: baseUrl.absoluteString, code: 500, userInfo: ["message": "服务器发生错误,请联系系统管理员"] )
                compection([:], error)
                let root = AppDelegate.currentAppdelegate().root
                root?.showMsg(customError: error)
            }
        }
    }
    
    public static func upload(images: [UIImage], success: @escaping (_ response : Any?) -> (), failture : @escaping (_ error : Error)->()) {
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (_, value) in images.enumerated() {
                let imageData = value.jpegData(compressionQuality: 0.7)
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
