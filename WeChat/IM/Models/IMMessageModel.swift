//
//  IMMessageModel.swift
//  WeChat
//
//  Created by ysq on 2018/9/7.
//  Copyright © 2018年 ysq. All rights reserved.
//

import UIKit

class IMMessageModel: NSObject {

    public var msg_id: Int = 0
    
    public var sender_id: Int = 0
    
    public var sender_name: String = ""
    
    public var sender_avatar: String = ""
    
    public var received_name: String = ""
    
    public var received_id: Int = 0
    
    public var received_avatar: String = ""
    
    public var group_id: Int = 1
    
    public var is_group: Int = 1
    
    public var msg_content: String = ""
    
    public var msg_seq: String = ""
    
    public var send_time: String = ""
    
    public var delivered: Int = 0
    
    public var msg_type: IMMessageType = IMMessageType.text
    
    public var msg_status: IMMessageSendStatusType = IMMessageSendStatusType.sending
    
//    public mutating func setMsgId(id: Int) {
//        msg_id = id
//    }
//
//    public mutating func setSenderId(id: Int) {
//        sender_id = id
//    }
//
//    public mutating func setSenderName(name: String) {
//        sender_name = name
//    }
//
//    public mutating func setSenderAvatar(url: String) {
//        sender_avatar = url
//    }
//
//    public mutating func setReceiverName(name: String) {
//        received_name = name
//    }
//
//    public mutating func setReceiverId(id: Int) {
//        received_id = id
//    }
//
//    public mutating func setReceiverAvatar(url: String) {
//        received_avatar = url
//    }
//
//    public mutating func setMsgContent(content: String) {
//        msg_content = content
//    }
//
//    public mutating func setMsgSeq(seq: String) {
//        msg_seq = seq
//    }
//
//    public mutating func setSendTime(time: String) {
//        send_time = time
//    }
//
//    public mutating func setDelivered(delivered: Int) {
//        self.delivered = delivered
//    }
//
//    public mutating func setMsgType(type: IMMessageType) {
//        msg_type = type
//    }
    
}
