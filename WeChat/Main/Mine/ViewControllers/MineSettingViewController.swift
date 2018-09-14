//
//  MineSettingViewController.swift
//  WeChat
//
//  Created by ysq on 2018/8/25.
//  Copyright © 2018年 ysq. All rights reserved.
//

import UIKit

class MineSettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1.00)
        title = "设置"
        view.addSubview(sq_tableView)
    }
    
    
    
    private func logout() {
        
        view.showIndicator(message: "正在退出...")
        NetworkManager.request(targetType: UserAPI.exit) { (result, error) in
            if !result.isEmpty {
                SQWebSocketService.sharedInstance.disconnection()
                UserModel.sharedInstance.removeAccessToken()
                UserModel.sharedInstance.syncUserInfo()
                SQWebSocketService.sharedInstance.disconnection()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                    self.view.hideHUD()
                    AppDelegate.currentAppdelegate().window?.rootViewController = SQLoginViewController()
                })
            }
        }
    }

}

extension MineSettingViewController: DefaultTableView {
    
    var sq_tableView: UITableView {
        let tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1.00)
        return tableView
    }
    
}

extension MineSettingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        case 2:
            return 2
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let names = [["账号与安全"], ["新消息通知", "隐私", "通用"], ["帮助与反馈", "关于微信"], ["插件"], ["退出登录"]]
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell?.accessoryType = .disclosureIndicator
        }
        if indexPath.section == 4 {
            cell?.accessoryType = .none
            cell?.textLabel?.textAlignment = .center

        }
        cell?.textLabel?.font = UIFont(name: "Helvetica Bold", size: 14)
        cell?.textLabel?.text = names[indexPath.section][indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 4 {
            logout()
        }
    }
    
}
