//
//  SQNavigationViewController.swift
//  WeChat
//
//  Created by ysq on 2017/9/18.
//  Copyright © 2017年 ysq. All rights reserved.
//

import UIKit

class SQNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barTintColor = UIColor.black
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
//            let barButton = UIBarButtonItem(image: #imageLiteral(resourceName: "back_icon"), style: .plain, target: self, action: #selector(pop))
//            barButton.tintColor = UIColor.white
//            viewController.navigationItem.leftBarButtonItem?.image = #imageLiteral(resourceName: "back_icon")
//            viewController.navigationItem.leftBarButtonItem = barButton
        }
        super.pushViewController(viewController, animated: true)
    }
    
    @objc fileprivate func pop() {
        super.popViewController(animated: true)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
