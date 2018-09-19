//
//  SQNavigationViewController.swift
//  WeChat
//
//  Created by ysq on 2017/9/18.
//  Copyright © 2017年 ysq. All rights reserved.
//

import UIKit

class SQNavigationViewController: UINavigationController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barTintColor = UIColor(red: 34.0 / 255.0, green: 34.0 / 255.0, blue: 34.0 / 255.0, alpha: 1.0)

        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        interactivePopGestureRecognizer?.isEnabled = true
        interactivePopGestureRecognizer?.delegate = self
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            let barButton = UIBarButtonItem(image: #imageLiteral(resourceName: "back_icon"), style: .plain, target: self, action: #selector(pop))
            viewController.navigationItem.leftBarButtonItem = barButton
        }
        super.pushViewController(viewController, animated: true)
    }

    @objc fileprivate func pop() {
        self.popViewController(animated: true)
    }

}
