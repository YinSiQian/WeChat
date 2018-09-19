//
//  IMChatViewController.swift
//  WeChat
//
//  Created by ysq on 2018/9/7.
//  Copyright © 2018年 ysq. All rights reserved.
//

import UIKit
import RealmSwift

class IMChatViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: kScreen_width, height: view.height - 40), style: .plain)
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
    
    private var page: Int = 0
    
    public var chat_id: Int = 0
    
    public var name: String = "" {
        didSet {
            title = name
        }
    }
    
    public var avatar: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        userSendMsg()
        msgStatusChanged()
        connectionStatusChanged()
        loadData()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        if #available(iOS 11.0, *) {
            super.viewSafeAreaInsetsDidChange()
            var rect = tableView.frame
            rect.size.height -= view.safeAreaInsets.bottom
            tableView.frame = rect
            
            var inputRect = msgInputView.frame
            inputRect.origin.y = rect.height + rect.minY
            msgInputView.frame = inputRect
            msgInputView.currentLocationForY = inputRect.origin.y
        } else {
            
            // Fallback on earlier versions
        }
    }
    
    private func setupSubviews() {
        view.backgroundColor = UIColor(red:0.94, green:0.95, blue:0.95, alpha:1.00)
        view.addSubview(tableView)
        view.addSubview(msgInputView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.receivedMsg(notification:)), name: NSNotification.Name(kIMReceivedMessageNotification), object: nil)
    }
    
    // MARK: -- Load Data
    
    private func loadData() {
        
        let models = SQCache.messageInfo(with: self.chat_id, page: self.page);
        for model in models {
            let layout = IMMessageLayoutService(model: model)
            self.msgModels.append(layout)
        }
        self.tableView.reloadData()
        if msgModels.count > 0 {
            self.tableView.scrollToRow(at: IndexPath(row: self.msgModels.count - 1
                , section: 0), at: .none, animated: false)
        }
    }
    
    // MARK: -- Socket Status Changed
    
    private func connectionStatusChanged() {
        SQWebSocketService.sharedInstance.statusChangedHandle = {
            [weak self] status in
            switch status {
            case .connecting:
                break
            case .connectSuccess:
                break
            case .connectFailure:
                break
            }
        }
    }
    
    // MARK: -- 消息接收与发送处理
    
    @objc private func receivedMsg(notification: Notification) {
        
        if let userInfo = notification.userInfo {
            if let model = userInfo[kIMReceivedMessageKey] as? IMMessageModel {
                self.handMsgData(model: model)
            }
        }
    }
    
    private func userSendMsg() {
        msgInputView.complectionHandler = {
            [weak self] (text, _) in
            let msgModel = IMDataManager.sharedInstance.sendTextMsg(content: text, chat_id: (self?.chat_id)!)
            self?.handMsgData(model: msgModel)
        }
    }
    
    private func msgStatusChanged() {
        IMDataManager.sharedInstance.sendStatusChanged = {
            [weak self] (model: IMMessageModel) in
            if let index = self?.indexFor(msgModel: model) {
                self?.msgModels[index].msg_model.delivered = model.delivered
                self?.msgModels[index].msg_model.msg_status = model.msg_status
                let cell = self?.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? IMMessageCell
                if let msgCell = cell {
                    msgCell.setIndicator(status: model.msg_status)
                }
            }
        }
    }
    
    private func handMsgData(model: IMMessageModel) {
        model.received_name = name
        model.received_avatar = avatar
        DispatchQueue.global().async {
            let layout = IMMessageLayoutService(model: model)
            self.msgModels.append(layout)
            DispatchQueue.main.async(execute: {
                if UserModel.sharedInstance.id == model.sender_id {
                    self.tableView.insertRows(at: [IndexPath(row: self.msgModels.count - 1, section: 0)], with: .right)
                } else {
                    self.tableView.insertRows(at: [IndexPath(row: self.msgModels.count - 1, section: 0)], with: .left)
                }
                
                self.tableView.scrollToRow(at: IndexPath(row: self.msgModels.count - 1
                    , section: 0), at: .none, animated: true)
            })
        }
    }
    
    private func indexFor(msgModel: IMMessageModel) -> Int? {
        for (index, element) in msgModels.enumerated() {
            if element.msg_model.msg_seq == msgModel.msg_seq {
                return index
            }
        }
        return nil
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if msgInputView.isActive {
            msgInputView.moveToBottom()
        }
    }
    
    deinit {
        print("chat view controller is dealloc")
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
        let layout = msgModels[indexPath.row]
        
//        print("address layout--->\(String(format: "%p", layout)) \n in collection layou address --->\(String(format: "%p", msgModels[indexPath.row]))")
        cell.msgServiceModel = msgModels[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if msgInputView.isActive {
            msgInputView.moveToBottom()
        }
    }
}

