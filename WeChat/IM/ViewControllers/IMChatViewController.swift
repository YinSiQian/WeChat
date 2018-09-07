//
//  IMChatViewController.swift
//  WeChat
//
//  Created by ABJ on 2018/9/7.
//  Copyright © 2018年 ysq. All rights reserved.
//

import UIKit

class IMChatViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: kScreen_width, height: view.height), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.red
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var msgInputView: FriendMomentInputView = {
        let inputView = FriendMomentInputView(frame: CGRect(x: 0, y: kScreen_height - 40, width: kScreen_width, height: 40), placeholder: "评论")
        inputView.isMsgInput = true
        return inputView
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    public var chat_id: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(tableView)
        view.addSubview(msgInputView)
        
        msgInputView.complectionHandler = {
            [weak self] (text, _) in
            self?.sendMsg(info: text)
        }
    }
    
    override func viewSafeAreaInsetsDidChange() {
        if #available(iOS 11.0, *) {
            super.viewSafeAreaInsetsDidChange()
            var rect = tableView.frame
            rect.size.height -= msgInputView.height + 34
            tableView.frame = rect
            
            var inputRect = msgInputView.frame
            inputRect.origin.y = rect.height + rect.minY
            msgInputView.frame = inputRect
        } else {
            
            // Fallback on earlier versions
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if msgInputView.isActive {
            msgInputView.moveToBottom()
        }
    }
    
    private func sendMsg(info: String) {
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        let msg_seq = dateString + "userId" + UserModel.sharedInstance.id.StringValue
        
        //发送 消息体结构 status = 6001 表示xx发送  msg 消息唯一码
        let msg: [String: Any] = ["received_id": chat_id,
                                  "content": info,
                                  "is_group": 1,
                                  "group_id": 1,
                                  "msg_seq": msg_seq.md5,
                                  "msg_type": 1,
                                  "status": 6001]
        SQWebSocketService.sharedInstance.sendMsg(msg: msg.convertToString()!)
    }
    

}

extension IMChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return IMMessageCell.cell(with: tableView)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if msgInputView.isActive {
            msgInputView.moveToBottom()
        }
    }
}

