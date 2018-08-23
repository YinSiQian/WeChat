//
//  UploadService.swift
//  WeChat
//
//  Created by ysq on 2018/8/4.
//  Copyright © 2018年 ysq. All rights reserved.
//

import Foundation
import UIKit
import Moya

public enum UploadAPIs {
    
    case upload([UIImage])
    
}

extension UploadAPIs: TargetType {
    
    public var path: String {
        return "file/upload"
    }
    
    public var method: Moya.Method {
        switch self {
        case .upload(_):
            return .post
        }
    }
    
    public var task: Task {
        switch self {
        case .upload(let images):
            var datas = [MultipartFormData]()
            for image in images {
                let imageData = image.pngData()
                let muti = MultipartFormData(provider: .data(imageData!), name: "image", fileName: "file", mimeType: "image/jpg")
                datas.append(muti)
            }
            return .uploadMultipart(datas)
        }
    }
    
    
}
