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
    
    public static func show(message: String) {
//        let action = UIAlertAction(title: <#T##String?#>, style: <#T##UIAlertAction.Style#>, handler: <#T##((UIAlertAction) -> Void)?##((UIAlertAction) -> Void)?##(UIAlertAction) -> Void#>)
        let alertController = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        
    }

}
