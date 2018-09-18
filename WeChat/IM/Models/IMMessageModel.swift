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
    
    @objc dynamic public var send_time: String = ""
    
    @objc dynamic public var delivered: Int = 0
    
    @objc dynamic public var msg_type: Int = IMMessageType.text.rawValue
    
    @objc dynamic public var msg_status: Int = IMMessageSendStatusType.sending.rawValue
    
    override static func primaryKey() -> String? {
        return "msg_id"
    }
    
}
