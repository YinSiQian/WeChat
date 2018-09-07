//
//  IMMessageLayoutService.swift
//  WeChat
//
//  Created by ABJ on 2018/9/7.
//  Copyright © 2018年 ysq. All rights reserved.
//

import UIKit

class IMMessageLayoutService: NSObject {

    public var msg_model: IMMessageModel! {
        didSet {
            layout()
        }
    }
    
    public var contentHeight: CGFloat = 0
    
    public var contentWidht: CGFloat = 0;
    
    public var photoHeight: CGFloat = 0
    
    private func layout() {
        
        switch msg_model.msg_type {
        case .text:
            let size = msg_model.msg_content.calculate(font: UIFont.systemFont(ofSize: 16), size: CGSize(width: kMsgContentMaxWidth, height: CGFloat(MAXFLOAT)))
            contentHeight = size.height
            contentWidht = size.width
            break
        case .voice:
            break
        case .video:
            break
        case .image:
            break
            
        } 
    }
}
