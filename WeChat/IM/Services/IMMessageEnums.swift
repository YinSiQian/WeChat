//
//  IMMessageEnums.swift
//  WeChat
//
//  Created by ysq on 2018/9/7.
//  Copyright © 2018年 ysq. All rights reserved.
//

import Foundation

public enum IMMessageSendStatusType: Int {
    case sending = 1
    case received
    case failure
}

public enum IMMessageType: Int {
    case text   = 1
    case voice
    case image
    case video
}

public enum IMSocketConnectionStatus: Int {
    case connecting
    case connectSuccess
    case connectFailure
}
