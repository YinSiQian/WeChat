//
//  UIViewController+Extension.swift
//  WeChat
//
//  Created by ysq on 2018/7/30.
//  Copyright © 2018年 ysq. All rights reserved.
//

import Foundation
import UIKit

enum ColorTheme {
    case white
    case black
}

protocol NetworkErrorHandler {
    
    func showError(error: NSError?)
}

protocol NavgationBarTheme {
    
    func loadNavbarTheme(theme: ColorTheme)
}

protocol DefaultTableView {
        
    var sq_tableView: UITableView {get}
    
}

extension NavgationBarTheme where Self: UIViewController {
    
    func loadNavbarTheme(theme: ColorTheme = ColorTheme.black) {
        
        switch theme {
        case .black:
            UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)
            let navbarTextAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.white]
            self.navigationController?.navigationBar.barTintColor = UIColor(red: 34.0 / 255.0, green: 34.0 / 255.0, blue: 34.0 / 255.0, alpha: 1.0)
            self.navigationController?.navigationBar.tintColor = UIColor.white
            self.navigationController?.navigationBar.titleTextAttributes = navbarTextAttribute
            
        case .white:
            UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: true)
            let navbarTextAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.black]
            self.navigationController?.navigationBar.barTintColor = UIColor.white
            self.navigationController?.navigationBar.tintColor = UIColor.black
            self.navigationController?.navigationBar.titleTextAttributes = navbarTextAttribute
        }
    }
}

extension NetworkErrorHandler where Self: UIViewController {
    
    func showError(error: NSError? = NSError(domain: baseUrl.absoluteString, code: 200, userInfo: ["message": "成功"])) {
        self.view.hideHUD()
        guard error != nil else {
            return
        }
        let code = error!.code
        let msg = error!.userInfo["message"] as! String
        print("msg--->\(msg)   code---->\(code)")
        self.view.show(message: msg)
    }
}

var navbarAlphaKey = "navbarAlphaKey"

extension UIViewController {
    
    var navbarAlpha: CGFloat {
        set {
            objc_setAssociatedObject(self, &navbarAlphaKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
            self.navigationController?.setNavbar(alpha: newValue)
        }
        get {
            guard let value = objc_getAssociatedObject(self, &navbarAlphaKey) else {
                return 1.0
            }
            return value as! CGFloat
        }
    }
    
    var currentControllerInKeyWindow: UIViewController? {
        
        if self is UINavigationController {
            let topViewController = (self as! UINavigationController).topViewController
            if let top = topViewController {
                if let presentViewController = top.presentedViewController {
                    if presentViewController is UINavigationController {
                        return (presentViewController as! UINavigationController).topViewController
                    }
                    return presentViewController
                }
            }
            return topViewController
        }
        return self
    }
    
}

extension DefaultTableView where Self: UIViewController {
    
    func setupTableView(style: UITableView.Style = .plain) -> UITableView {
        let tableView = UITableView(frame: self.view.bounds)
        tableView.backgroundColor = UIColor.white
        tableView.delegate = (self as! UITableViewDelegate)
        tableView.dataSource = (self as! UITableViewDataSource)
        return tableView
    }
    
}

extension UIViewController: NetworkErrorHandler {}

extension UIViewController: NavgationBarTheme {}


