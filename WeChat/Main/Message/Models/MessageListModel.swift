//
//  MessageListModel.swift
//  WeChat
//
//  Created by ysq on 2018/9/20.
//  Copyright © 2018年 ysq. All rights reserved.
//

import Foundation
import RealmSwift

public class MessageListModel: Object {
    
    @objc dynamic var msg_id: Int = 0
    
    @objc dynamic var avatar: String = ""
    
    @objc dynamic var name: String = ""
    
    @objc dynamic var content: String = ""
    
    @objc dynamic var create_time: Int = 0
    
    @objc dynamic var chatId: Int = 0
    
    @objc dynamic var sort: Int = 0
    
    @objc dynamic var msg_seq: String = ""
    
    @objc dynamic var is_show = false
    
    @objc dynamic var unread_count = 0
    
    convenience init(with: IMMessageModel) {
        self.init()
        convert(with: with)
    }
    
    private func convert(with: IMMessageModel) {
        msg_id = with.msg_id
        avatar = with.sender_avatar
        name = with.sender_name
        content = with.msg_content
        create_time = with.create_time
        chatId = with.sender_id
        msg_seq = with.msg_seq
    }
    
}
