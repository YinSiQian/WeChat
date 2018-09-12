//
//  IMDataManager.swift
//  WeChat
//
//  Created by ysq on 2018/9/7.
//  Copyright © 2018年 ysq. All rights reserved.
//

import UIKit
import Starscream


class IMDataManager: NSObject {
    
    typealias receivedMsgHandler = (_ msgModel: IMMessageModel) -> ()
    
    public var receivedHandler: receivedMsgHandler?
    
    public var sendStatusChanged: receivedMsgHandler?
    
    static let sharedInstance = IMDataManager()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    private override init() {}
    
    public func sendTextMsg(content: String, chat_id: Int) -> IMMessageModel {
        return sendMsg(content: content, chat_id: chat_id, msgType: .text)
    }
    
    public func sendImageMsg(image: UIImage, chat_id: Int) -> IMMessageModel {
        return sendMsg(content: "image url", chat_id: chat_id, msgType: .image)
    }
    
    private func sendMsg(content: String, chat_id: Int, msgType: IMMessageType) -> IMMessageModel {
        
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        let msg_seq = dateString + "userId" + UserModel.sharedInstance.id.StringValue
        
        //发送 消息体结构 status = 6001 表示xx发送  msg 消息唯一码
        let msg: [String: Any] = ["received_id": chat_id,
                                  "content": content,
                                  "is_group": 1,
                                  "group_id": 1,
                                  "msg_seq": msg_seq.md5,
                                  "msg_type": 1,
                                  "status": 6001]
        SQWebSocketService.sharedInstance.sendMsg(msg: msg.convertToString()!)
        
        var model = IMMessageModel()
        model.msg_content = content
        model.sender_id = UserModel.sharedInstance.id
        model.received_id = chat_id
        model.sender_name = UserModel.sharedInstance.username
        model.sender_avatar = UserModel.sharedInstance.icon
        model.msg_seq = msg_seq.md5
        model.msg_type = msgType
   
        IMMessageQueue.shared.push(element: model)
        
        return model
    }
    
    public func syncMsg() {
        
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
            if msg_index != -1 {
                IMMessageQueue.shared.elements[msg_index].msg_status = .received
                IMMessageQueue.shared.elements[msg_index].delivered = 1
                sendStatusChanged?(IMMessageQueue.shared.elements[msg_index])
            }
        case 6002:
            //服务器收到生产者的消息 服务器ACK
            print("server ack: \(msg)")
            let seq = dict["msg_seq"] as? String ?? ""
            let id = dict["msg_id"] as? Int ?? 0
            let msg_index = IMMessageQueue.shared.indexForMessage(seq: seq)
            if msg_index != -1 {
                IMMessageQueue.shared.elements[msg_index].msg_id = id
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
            model.sender_name = "测试名称"
            model.sender_avatar = UserModel.sharedInstance.icon
            model.msg_seq = msg_seq
            model.msg_type = IMMessageType(rawValue: dict["msg_type"] as? Int ?? IMMessageType.text.rawValue)!
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
