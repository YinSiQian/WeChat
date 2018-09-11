//
//  IMChatViewController.swift
//  WeChat
//
//  Created by ysq on 2018/9/7.
//  Copyright © 2018年 ysq. All rights reserved.
//

import UIKit

class IMChatViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: kScreen_width, height: view.height), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(red:0.94, green:0.95, blue:0.95, alpha:1.00)
        return tableView
    }()
    
    private lazy var msgInputView: FriendMomentInputView = {
        let inputView = FriendMomentInputView(frame: CGRect(x: 0, y: kScreen_height - 40, width: kScreen_width, height: 40), placeholder: "")
        inputView.isMsgInput = true
        return inputView
    }()
    
    private var msgModels = [IMMessageLayoutService]()
    
    public var chat_id: Int = 0
    
    public var name: String = "" {
        didSet {
            title = name
        }
    }
    
    public var avatar: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red:0.94, green:0.95, blue:0.95, alpha:1.00)
        view.addSubview(tableView)
        view.addSubview(msgInputView)
        userSendMsg()
        receivedMsg()
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
    
    // MARK: -- 消息接收与发送处理
    
    private func receivedMsg() {
        IMDataManager.sharedInstance.receivedHandler = {
            [weak self] (model) in
            self?.handMsgData(model: model)
        }
    }
    
    private func userSendMsg() {
        msgInputView.complectionHandler = {
            [weak self] (text, _) in
            let msgModel = IMDataManager.sharedInstance.sendTextMsg(content: text, chat_id: (self?.chat_id)!)
            self?.handMsgData(model: msgModel)
        }
    }
    
    private func handMsgData(model: IMMessageModel) {
        model.received_name = name
        model.received_avatar = avatar
        DispatchQueue.global().async {
            let layout = IMMessageLayoutService(model: model)
            self.msgModels.append(layout)
            DispatchQueue.main.async(execute: {
                self.tableView.insertRows(at: [IndexPath(row: self.msgModels.count - 1, section: 0)], with: .automatic)
                self.tableView.scrollToRow(at: IndexPath(row: self.msgModels.count - 1
                    , section: 0), at: .none, animated: true)
            })
        }
    }

}

extension IMChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgModels.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return msgModels[indexPath.row].height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = IMMessageCell.cell(with: tableView)
        cell.msgServiceModel = msgModels[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if msgInputView.isActive {
            msgInputView.moveToBottom()
        }
    }
}

