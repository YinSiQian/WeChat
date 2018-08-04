//
//  SystemPhotoService.swift
//  WeChat
//
//  Created by ysq on 2018/8/4.
//  Copyright © 2018年 ysq. All rights reserved.
//

import Foundation
import UIKit


class SystemPhotoService: NSObject {
    
    typealias complectionHanlder = (_ resouce: [UIImage]) -> ()
    
    var handler: complectionHanlder!
    
    var vc: UIViewController!
    
    static let shard = SystemPhotoService()
    
    private override init() {}
    
}

extension SystemPhotoService {
    
    public func open(sourceController: UIViewController!, type: UIImagePickerControllerSourceType, complectionHanlder: @escaping (_ resouce: [UIImage]) -> ()) {
        self.vc = sourceController
        self.handler = complectionHanlder
        openImagePickerController(type: type)
    }
    
    private func openImagePickerController(type: UIImagePickerControllerSourceType) {
        if UIImagePickerController.isSourceTypeAvailable(type) {
            let picker = TZImagePickerController(maxImagesCount: 9, columnNumber: 3, delegate: nil, pushPhotoPickerVc: true)
            picker?.didFinishPickingPhotosWithInfosHandle = {
                [weak self] (photos,_,isSelectOriginalPhoto,_) in
                if photos?.isEmpty == false {
                    self?.handler(photos!)
                }
            }
            vc.present(picker!, animated: true, completion: nil)
        }
    }
}


