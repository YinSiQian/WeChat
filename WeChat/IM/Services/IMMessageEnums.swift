//
//  IMMessageEnums.swift
//  WeChat
//
//  Created by ABJ on 2018/9/7.
//  Copyright © 2018年 ysq. All rights reserved.
//

import Foundation

public enum IMMessageSendType: Int {
    case send = 1
    case received
}

public enum IMMessageType: Int {
    case text   = 1
    case voice
    case image
    case video
}
