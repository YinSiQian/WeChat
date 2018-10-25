//
//  Helper.swift
//  WeChat
//
//  Created by ysq on 2018/10/24.
//  Copyright © 2018 ysq. All rights reserved.
//

import UIKit
import Foundation

class Helper: NSObject {
    
    public static func show(message: String, sureComplection:(() -> ())?) {
        let action = UIAlertAction(title: "确定", style: .default) { (_) in
            sureComplection?()
        }
        let alertController = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alertController.addAction(action)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        
    }

}
