//
//  MomentEditViewController.swift
//  WeChat
//
//  Created by ysq on 2018/8/7.
//  Copyright © 2018年 ysq. All rights reserved.
//

import UIKit

class MomentEditViewController: UIViewController {

    var images: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setNavItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navbarAlpha = 0.0
    }
    
    private func setNavItem() {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(MomentEditViewController.cancel))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发表", style: .plain, target: self, action: #selector(MomentEditViewController.post))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.green
        
    }
    
    // MARK: -- Network Exchange
    
    private func postMoment() {
        NetworkManager.request(targetType: TimelineAPIs.post(content: "因为人脑思考一步的时间，人工智能可以思考无数步并找到最优解。", url: "self.urlJson!", location: "春华四季园")) { (result, error) in
            if !result.isEmpty {
                print(result as Any)
            }
        }
    }
    
    private func upload(images: [UIImage]) {
        
        NetworkManager.request(targetType: UploadAPIs.upload(images), compection: {
            (result, error) in
            if !result.isEmpty {
//                self.urlJson = result["url"] as? String;
                self.postMoment()
            }
        })
    }
    
    // MARK: -- Events
    
    @objc private func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func post() {
        upload(images: images)
    }

}
