//
//  IMMessageModel.swift
//  WeChat
//
//  Created by ysq on 2018/9/7.
//  Copyright © 2018年 ysq. All rights reserved.
//

import UIKit
import RealmSwift

class IMMessageModel: Object {

    @objc dynamic public var msg_id: Int = 0
    
    @objc dynamic public var sender_id: Int = 0
    
    @objc dynamic public var sender_name: String = ""
    
    @objc dynamic public var sender_avatar: String = ""
    
    @objc dynamic public var received_name: String = ""
    
    @objc dynamic public var received_id: Int = 0
    
    @objc dynamic public var received_avatar: String = ""
    
    @objc dynamic public var group_id: Int = 1
    
    @objc dynamic public var is_group: Int = 1
    
    @objc dynamic public var msg_content: String = ""
    
    @objc dynamic public var msg_seq: String = ""
    
    @objc dynamic public var create_time: Int = 0
    
    @objc dynamic public var delivered: Int = 0
    
    @objc dynamic public var msg_type: Int = IMMessageType.text.rawValue
    
    @objc dynamic public var msg_status: Int = IMMessageSendStatusType.sending.rawValue
    
    override static func primaryKey() -> String? {
        return "msg_seq"
    }
    
    convenience init(data: [String: Any]) {
        self.init()
        msg_id = data["msgId"] as? Int ?? 0
        sender_id = data["sendId"] as? Int ?? 0
        sender_name = data["senderName"] as? String ?? ""
        sender_avatar = data["senderIcon"] as? String ?? ""
        received_id = data["receivedId"] as? Int ?? 0
        received_avatar = UserModel.sharedInstance.icon
        group_id = data["groupId"] as? Int ?? 1
        is_group = data["isGroup"] as? Int ?? 1
        msg_content = data["msgContent"] as? String ?? ""
        msg_seq = data["msgSeq"] as? String ?? ""
        create_time = data["createTime"] as? Int ?? 0
        delivered = data["delivered"] as? Int ?? 0
        msg_type = data["msgType"] as? Int ?? 1
        msg_status = IMMessageSendStatusType.received.rawValue
    }
    
}
