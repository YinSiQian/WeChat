//
//  SQLoginViewController.swift
//  WeChat
//
//  Created by ysq on 2018/7/29.
//  Copyright © 2018年 ysq. All rights reserved.
//

import UIKit

class SQLoginViewController: UIViewController {

    @IBOutlet weak var phoneTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var changeLoginModeBtn: UIButton!
    
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.phoneTF.delegate = self
        self.passwordTF.delegate = self
    }
    
    @IBAction func changeAction(_ sender: UIButton) {
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        guard (self.phoneTF.text != nil) else {
            return
        }
        guard (self.phoneTF.text != nil) else {
            return
        }
        
        self.view.showIndicator(message: "正在登录...")
        NetworkManager.request(targetType: LoginAPI.login(phone: self.phoneTF.text!, password: self.passwordTF.text!)) { (response, error) in
            print(response)
            if !response.isEmpty {
                self.view.hideHUD()
                self.view.show(message: "登录成功!")
                UserModel.sharedInstance.initial(data: response["data"] as! [String : Any])
                UserModel.sharedInstance.syncUserInfo()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                    AppDelegate.currentAppdelegate().window?.rootViewController = SQRootViewController()
                })
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        phoneTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
    }
    
}

extension SQLoginViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.isEqual(self.phoneTF) {
            
        } else {
            if (textField.text?.count)! < 6 {
                
            }
        }
    }
    
}
