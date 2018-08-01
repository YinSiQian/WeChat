//
//  UIViewController+Extension.swift
//  WeChat
//
//  Created by ysq on 2018/7/30.
//  Copyright © 2018年 ysq. All rights reserved.
//

import Foundation
import UIKit

protocol NetworkErrorHandler {
    
    func showError(error: NSError?)
}

extension NetworkErrorHandler where Self: UIViewController {
    
    func showError(error: NSError? = NSError()) {
        guard error != nil else {
            return
        }
        let code = error!.code
        let msg = error!.userInfo["message"] as! String
        print("msg--->\(msg)   code---->\(code)")
        
    }
}

extension UIViewController: NetworkErrorHandler {

}


