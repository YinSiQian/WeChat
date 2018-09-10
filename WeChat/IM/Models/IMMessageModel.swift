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
    
}
