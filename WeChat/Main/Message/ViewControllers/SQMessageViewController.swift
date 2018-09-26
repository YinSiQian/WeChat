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
        setupSubviews()
        loadData()
        receivedMsg()
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
    
    private func connectServer() {
        if !SQWebSocketService.sharedInstance.isConnection {
            SQWebSocketService.sharedInstance.connectionServer(complectionHanlder: {
                //            [weak self] in
                
            }) {_ in
//                [weak self] (error) in
                
            }
        }
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
            self?.handleMsg(data: model)
        }
    }
    
    private func handleMsg(data: IMMessageModel) {
        let listModel = MessageListModel()
        listModel.msg_id = data.msg_id
        listModel.avatar = data.sender_avatar
        listModel.chatId = data.sender_id
        listModel.content = data.msg_content
        listModel.name = data.sender_name
        listModel.time = data.send_time
        
        if let index = self.searchForData(id: listModel.chatId) {
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
    
    private func searchForData(id: Int) -> Int? {
        for (index, element) in listData.enumerated() {
            if element.chatId == id {
                return index
            }
        }
        return nil
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
