//
//  IMDataManager.swift
//  WeChat
//
//  Created by ysq on 2018/9/7.
//  Copyright © 2018年 ysq. All rights reserved.
//

import UIKit
import Starscream

let kIMMessageValueKey = "kIMMessageValueKey"
let kIMReceivedMessageNotification = "kIMReceivedMessageNotification"
let kIMSendMessageNotification = "kIMSendMessageNotification"
let kIMSendMessageFailureNofication = "kIMSendMessageFailureNofication"
let kIMMessageValueChangedNofication = "kIMMessageValueChangedNofication"

class IMDataManager: NSObject {
    
    typealias receivedMsgHandler = (_ msgModel: IMMessageModel) -> ()
    
    public var receivedHandler: receivedMsgHandler?
    
    public var sendStatusChanged: receivedMsgHandler?
    
    static let sharedInstance = IMDataManager()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss SSS"
        return formatter
    }()
    
    private override init() {}
    
    public func sendTextMsg(content: String, chat_id: Int, receivedName: String) -> IMMessageModel {
        return sendMsg(content: content, chat_id: chat_id, receivedName: receivedName, msgType: .text)
    }
    
    public func sendImageMsg(image: UIImage, chat_id: Int, receivedName: String) -> IMMessageModel {
        return sendMsg(content: "image url", chat_id: chat_id, receivedName: receivedName, msgType: .image)
    }
    
    private func sendMsg(content: String, chat_id: Int, receivedName: String, msgType: IMMessageType) -> IMMessageModel {
        
        // Note: 发送过快时间按秒计算未变化 造成seq相同..服务器会认为是同一消息.
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        let msg_seq = dateString + "userId" + UserModel.sharedInstance.id.StringValue
        
        //发送 消息体结构 status = 6001 表示xx发送  msg 消息唯一码
        let msg: [String: Any] = ["received_id": chat_id,
                                  "content": content,
                                  "is_group": 1,
                                  "group_id": 1,
                                  "msg_seq": msg_seq.md5,
                                  "msg_type": msgType.rawValue,
                                  "status": 6001]
        
        SQWebSocketService.sharedInstance.sendMsg(msg: msg.convertToString()!)
        
        let model = IMMessageModel()
        model.msg_content = content
        model.sender_id = UserModel.sharedInstance.id
        model.received_id = chat_id
        model.sender_name = UserModel.sharedInstance.username
        model.sender_avatar = UserModel.sharedInstance.icon
        model.msg_seq = msg_seq.md5
        model.msg_type = msgType.rawValue
        model.msg_status = IMMessageSendStatusType.sending.rawValue
        model.received_name = receivedName
        model.create_time = Int(date.timeIntervalSince1970)
        IMMessageQueue.shared.push(element: model)
        IMMessageQueue.shared.timeoutHandle = {
            (drop, index) in
            print("drop --->\(drop)")
            if drop {
                if let currentIndex = index {
                    IMMessageQueue.shared.elements[currentIndex].msg_status = IMMessageSendStatusType.failure.rawValue
                    IMMessageQueue.shared.elements[currentIndex].delivered = 0
                    self.sendStatusChanged?(IMMessageQueue.shared.elements[currentIndex])
                    //失败 也缓存一下
                    SQCache.saveMessageInfo(with: IMMessageQueue.shared.elements[currentIndex])
                    IMMessageQueue.shared.removed(at: currentIndex)
                }
            } else {
                SQWebSocketService.sharedInstance.sendMsg(msg: msg.convertToString()!)
            }
        }
        NotificationCenter.default.post(name: NSNotification.Name.init(kIMSendMessageNotification), object: nil, userInfo: [kIMMessageValueKey: model])
        return model
    }
    
    public func syncMsg(timestamp: Int, complectionHandle: ((_ data: [IMMessageModel], _ unReceivedData: [IMMessageModel], _ error: Bool) -> ())?)  {
        NetworkManager.request(targetType: MessageAPI.pullOfflineMessage(timestamp: timestamp)) { (result, error) in
            print("result --- \(result as Any)")
            if error == nil {
                if result.isEmpty {
                    complectionHandle?([], [],false)
                } else {
                    // TODO: 未拉取数据处理, 更新数据 消息列表重新排序
                    let data = result["data"] as! [[String: Any]]
                    var modelArr = [IMMessageModel]()
                    for element in data {
                        let model = IMMessageModel(data: element)
                        modelArr.append(model)
                    }
                    let newDataIndexArr = result["unReceivedMsg"] as! [Int]
                    var newData = [IMMessageModel]()
                    for (index, _) in newDataIndexArr.enumerated() {
                        newData.append(modelArr[newDataIndexArr[index]])
                    }
                    
                    if !modelArr.isEmpty {
                        SQCache.saveMessageInfoForBatch(with: modelArr)
                    }
                    complectionHandle?(modelArr, newData ,false)
                }
            } else {
                complectionHandle?([], [],true)
            }
        }

    }
    
    public func getUnReadMsgCount(chatIds: String) {
        NetworkManager.request(targetType: MessageAPI.getUnReadMsg(chatIds: chatIds)) {
            (result, error) in
            print("result --- \(result as Any)")

        }
    }
    
    public func ackUnReadMsg(msgId: Int) {
        NetworkManager.request(targetType: MessageAPI.readMsg(msgId: msgId)) {
            (result, error) in
            print("result --- \(result as Any)")
        }
    }

}

extension IMDataManager: SQWebSocketServiceDelegate {
    
    func webSocketService(received msg: String) {
        
        let dict = msg.convertToDict()
        let status = dict["status"] as! Int
        switch status {
        case 5000:
            //消息推送: 添加好友, 点赞, 朋友圈回复, 评论
            print("接收到推送\(dict["content"] ?? 0)")
        case 6000:
            //消息发送成功
            print("消息发送成功: \(msg)")
            let seq = dict["msg_seq"] as? String ?? ""
            let msg_index = IMMessageQueue.shared.indexForMessage(seq: seq)
            if let index = msg_index {
                IMMessageQueue.shared.elements[index].msg_status = IMMessageSendStatusType.received.rawValue
                IMMessageQueue.shared.elements[index].delivered = 1
                sendStatusChanged?(IMMessageQueue.shared.elements[index])
                //缓存
                SQCache.saveMessageInfo(with: IMMessageQueue.shared.elements[index])
                IMMessageQueue.shared.removed(at: index)
            }
        case 6002:
            //服务器收到生产者的消息 服务器ACK
            print("server ack: \(msg)")
            let seq = dict["msg_seq"] as? String ?? ""
            let id = dict["msg_id"] as? Int ?? 0
            let time = dict["create_time"] as? Int ?? 0
            let msg_index = IMMessageQueue.shared.indexForMessage(seq: seq)
            if let index = msg_index {
                IMMessageQueue.shared.elements[index].msg_id = id
                IMMessageQueue.shared.elements[index].create_time = time
                 NotificationCenter.default.post(name: NSNotification.Name.init(kIMMessageValueChangedNofication), object: nil, userInfo: [kIMMessageValueKey: IMMessageQueue.shared.elements[index]])
            }
        case 6003:
            //服务器收到消费者的ack
            print("server ack to consumers: \(msg)")
        case 6004:
            //服务器转发消息给消费者
            print("server send msg to consumers: \(msg)")
            let msg_seq = dict["msg_seq"] as! String
            let msg: [String: Any] = ["status": 6003, "msg_seq": msg_seq]
            SQWebSocketService.sharedInstance.sendMsg(msg: msg.convertToString()!)
            
            let model = IMMessageModel()
            model.msg_content = dict["content"] as? String ?? ""
            model.msg_id = dict["msg_id"] as? Int ?? 0
            model.sender_id = dict["send_id"] as? Int ?? 0
            model.received_id = dict["received_id"] as? Int ?? 0
            model.received_avatar = UserModel.sharedInstance.icon
            model.received_name = UserModel.sharedInstance.username
            model.msg_seq = msg_seq
            model.msg_type = IMMessageType(rawValue: dict["msg_type"] as? Int ?? 1)!.rawValue
            model.delivered = 1
            model.sender_name = dict["sender_name"] as? String ?? ""
            model.create_time = dict["create_time"] as? Int ?? 0
            model.sender_avatar = dict["sender_avatar"] as? String ?? ""
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                SQCache.saveMessageInfo(with: model)
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kIMReceivedMessageNotification), object: nil, userInfo: [kIMMessageValueKey: model])

            receivedHandler?(model)

        default:
            print("default")
        }
    }
    
    func webSocketServiceDidDisconnect(socket: WebSocketClient, error: Error?) {
        
    }
    
    func webSocketServiceDidConnect(socket: WebSocketClient) {
        
    }
    
    
}
