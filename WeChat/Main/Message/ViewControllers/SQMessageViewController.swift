//
//  SQMessageViewController.swift
//  WeChat
//
//  Created by ysq on 2017/9/18.
//  Copyright © 2017年 ysq. All rights reserved.
//

import UIKit
import RealmSwift

class SQMessageViewController: UIViewController {

    private lazy var statusView: NetworkConnectStatusView = {
        let view = NetworkConnectStatusView(frame: CGRect(x: 0, y: 0, width: 140, height: 40))
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: self.view.bounds, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        return table
    }()
    
    private var listData: [MessageListModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SQWebSocketService.sharedInstance.setupSocket(accessId: UserModel.sharedInstance.id.StringValue, accessToken: UserModel.sharedInstance.accessToken)
        setupSubviews()
        loadData()
        receivedMsg()
        addMsgStatusObserver()
        networkStatusChanged()
        connectionStatusChanged()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        connectServer()
    }
    
    private func setupSubviews() {
        navigationItem.titleView = statusView
        view.addSubview(tableView)
    }
    
    private func addMsgStatusObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(SQMessageViewController.sendMsg(noti:)), name: NSNotification.Name.init(kIMSendMessageNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SQMessageViewController.messageValueChanged(noti:)), name: NSNotification.Name.init(kIMMessageValueChangedNofication), object: nil)
    }
    
    private func connectServer() {
        if !SQWebSocketService.sharedInstance.isConnection {
            SQWebSocketService.sharedInstance.connectionServer(complectionHanlder: {
//                [weak self] in
                
                
            }) {_ in
//                [weak self] (error) in
                
            }
        }
    }
    
    // MARK: -- Sync Data
    
    private func loadUnPullData() {
        statusView.updateStatus(connectStatus: .dataReceiving)
        var timestamp = UserDefaults.standard.integer(forKey: "msg_timestamp")
        if timestamp == 0 {
            timestamp = 1528560000000
        }
        
        IMDataManager.sharedInstance.syncMsg(timestamp: timestamp) {
            [weak self] (data, newData ,error) in
            if error {
                self?.statusView.updateStatus(connectStatus: .dataReceevedFailure)

            } else {
                self?.statusView.updateStatus(connectStatus: .connectSuccess)
            }
        }
//        IMDataManager.sharedInstance.ackUnReadMsg(msgId: 38)
//
//        IMDataManager.sharedInstance.getUnReadMsgCount(chatIds: "2,3,7")
    }
    
    
    private func networkStatusChanged() {
        NetworkStatusManager.shared.networkStatusChangedHandle = {
            [weak self] status in
            switch status {
            case .none:
                self?.view.show(message: "网络连接失败,请检查网络连接情况")
            case .wifi:
                self?.view.show(message: "已连接到WIFI网络")
            case .cellular:
                self?.view.show(message: "已连接到4G网络")
            }
        }
    }
    
    private func connectionStatusChanged() {
        SQWebSocketService.sharedInstance.statusChangedHandle = {
            [weak self] status in
            if status == IMSocketConnectionStatus.connectSuccess {
                self?.loadUnPullData()
            }
            self?.statusView.updateStatus(connectStatus: status)
        }
    }
    
    // MARK: -- 数据处理
    
    private func loadData() {
        listData = SQCache.allMsgList()
        self.tableView.reloadData()
    }
    
    private func receivedMsg() {
        IMDataManager.sharedInstance.receivedHandler = {
            [weak self] (model) in
            print("received msg in message controller")
            self?.saveLastMsg(timestamp: model.create_time)
            self?.handleMsg(data: model, isSend: false)
        }
    }
    
    @objc private func sendMsg(noti: Notification) {
        if let userInfo = noti.userInfo {
            if let model = userInfo[kIMMessageValueKey] as? IMMessageModel {
                self.handleMsg(data: model, isSend: true)
            }
        }
    }
    
    @objc private func messageValueChanged(noti: Notification) {
        if let userInfo = noti.userInfo {
            if let model = userInfo[kIMMessageValueKey] as? IMMessageModel {
                if let index = self.searchForData(seq: model.msg_seq) {
                    let msg = self.listData[index]
                    SQCache.update(content: msg.content, time: model.create_time / 1000, model: msg)
                    tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                }
            }
        }
    }
    
    private func handleMsg(data: IMMessageModel, isSend: Bool) {
        let listModel = MessageListModel()
        listModel.msg_id = data.msg_id
        if isSend {
            listModel.chatId = data.received_id
            listModel.name = data.received_name
            listModel.avatar = data.received_avatar
        } else {
            listModel.avatar = data.sender_avatar
            listModel.chatId = data.sender_id
            listModel.name = data.sender_name
        }
    
        listModel.content = data.msg_content
        listModel.create_time = data.create_time
        
        if let index = self.searchForData(seq: listModel.msg_seq) {
                let oldMsg = self.listData[index]
                SQCache.delete(model: oldMsg)
                self.listData.remove(at: index)
        }
        self.listData.insert(listModel, at: 0)
        self.listDataSort()
        SQCache.saveMsgListInfo(with: listModel)
        self.tableView.reloadData()

    }
    
    private func listDataSort() {
        for (index, element) in listData.enumerated() {
            let realm = try! Realm()
            try! realm.write {
                element.sort = index + 1
            }
        }
    }
    
    private func searchForData(seq: String) -> Int? {
        for (index, element) in listData.enumerated() {
            if element.msg_seq == seq {
                return index
            }
        }
        return nil
    }
    
    private func saveLastMsg(timestamp: Int) {
        UserDefaults.standard.set(timestamp, forKey: "msg_timestamp")
        UserDefaults.standard.synchronize()
    }
    
}

extension SQMessageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "sqMessageCell") as? SQMessageCell
        if cell == nil {
            cell = SQMessageCell(style: .default, reuseIdentifier: "sqMessageCell")
        }
        cell?.model = listData[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let chat = IMChatViewController()
        chat.chat_id = listData[indexPath.row].chatId
        chat.name = listData[indexPath.row].name
        navigationController?.pushViewController(chat, animated: true)
    }
    
}
