//
//  SQMessageViewController.swift
//  WeChat
//
//  Created by ysq on 2017/9/18.
//  Copyright © 2017年 ysq. All rights reserved.
//

import UIKit

class SQMessageViewController: UIViewController {

    var tableView: UITableView?
    
    var datas: [[String: Any]] = [["name": "张无忌", "content": "hello world", "id": 1],
                                  ["name": "令狐冲", "content": "hello world", "id": 2]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = UserModel.sharedInstance.username
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        view.addSubview(tableView!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        connectServer()
    }
    
    
     private func connectServer() {
        if !SQWebSocketService.sharedInstance.isConnection {
            SQWebSocketService.sharedInstance.connectionServer(complectionHanlder: {
                //            [weak self] in
                
            }) {_ in
//                [weak self] (error) in
                
            }
        }

    }
    
}

extension SQMessageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "sqMessageCell") as? SQMessageCell
        if cell == nil {
            cell = SQMessageCell(style: .default, reuseIdentifier: "sqMessageCell")
        }
        cell?.data = datas[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let data = datas[indexPath.row]
        let chat = IMChatViewController()
        chat.chat_id = data["id"] as! Int
        chat.name = data["name"] as! String
        navigationController?.pushViewController(chat, animated: true)
    }
    
}
