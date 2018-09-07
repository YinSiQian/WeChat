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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                
            }) {
                [weak self] (error) in
                
            }
        }

    }
    
    @objc private func sendMsg() {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: date)
        let msg_seq = dateString + "userId" + UserModel.sharedInstance.id.StringValue
        
        //发送 消息体结构 status = 6001 表示xx发送  msg 消息唯一码
        let msg: [String: Any] = ["received_id": 3,
                                  "content": "大晚上的好饿啊",
                                  "is_group": 1,
                                  "group_id": 1,
                                  "msg_seq": msg_seq.md5,
                                  "msg_type": 1,
                                  "status": 6001]
        SQWebSocketService.sharedInstance.sendMsg(msg: msg.convertToString()!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}

extension SQMessageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "sqMessageCell")
        if cell == nil {
            cell = SQMessageCell(style: .default, reuseIdentifier: "sqMessageCell")
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let chat = IMChatViewController()
        navigationController?.pushViewController(chat, animated: true)
    }
    
}
