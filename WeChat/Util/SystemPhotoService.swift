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
    
    public func open(sourceController: UIViewController!, complectionHanlder: @escaping (_ resouce: [UIImage]) -> ()) {
        open(sourceController: sourceController, maxCount: 9, complectionHanlder: complectionHanlder)
       
    }
    
    public func open(sourceController: UIViewController!, maxCount: Int, complectionHanlder: @escaping (_ resouce: [UIImage]) -> ()) {
        self.vc = sourceController
        self.handler = complectionHanlder
        openImagePickerController(type: .photoLibrary, maxImagesCount: maxCount)
    }
    
    private func openImagePickerController(type: UIImagePickerControllerSourceType, maxImagesCount: Int) {
        if UIImagePickerController.isSourceTypeAvailable(type) {
            let picker = TZImagePickerController(maxImagesCount: maxImagesCount, columnNumber: 4, delegate: nil, pushPhotoPickerVc: true)
            picker?.didFinishPickingPhotosWithInfosHandle = {
                [weak self] (photos,_,isSelectOriginalPhoto,_) in
                self?.vc = nil
                if photos?.isEmpty == false {
                    self?.handler(photos!)
                }
            }
            picker?.imagePickerControllerDidCancelHandle = {
                [weak self] in
                self?.vc = nil
            }
            vc.present(picker!, animated: true, completion: nil)
        }
    }

}


