//
//  UserInfoViewController.swift
//  WeChat
//
//  Created by ysq on 2018/9/21.
//  Copyright © 2018年 ysq. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController {

    public var model: FriendModels.User?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1.00)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "详细资料"
        setupSubviews()
    }
    
    private func setupSubviews() {
        view.addSubview(tableView)
        tableView.register(UINib(nibName: "SQMineUserInfoCell", bundle: Bundle.main), forCellReuseIdentifier: "cell")
    }
   
}

extension UserInfoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 80 : 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SQMineUserInfoCell
            cell.accessoryType = .disclosureIndicator
            cell.model = model
            return cell
        } else {
            var cell = tableView.dequeueReusableCell(withIdentifier: "otherCell")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "otherCell")
                cell?.accessoryType = .none
                cell?.textLabel?.textAlignment = .center
            }
            cell?.textLabel?.textColor = UIColor.black
            cell?.textLabel?.font = UIFont(name: "Helvetica Bold", size: 16)
            cell?.textLabel?.text = "发消息"
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            let chat = IMChatViewController()
            chat.chat_id = model?.id ?? 0
            chat.name = model?.username ?? ""
            navigationController?.pushViewController(chat, animated: true)
        }
    }
    
}
