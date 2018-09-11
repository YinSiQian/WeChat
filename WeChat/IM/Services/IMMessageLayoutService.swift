//
//  IMMessageLayoutService.swift
//  WeChat
//
//  Created by ysq on 2018/9/7.
//  Copyright © 2018年 ysq. All rights reserved.
//

import UIKit

class IMMessageLayoutService: NSObject {

    public var msg_model: IMMessageModel {
        didSet {
            layout()
        }
    }
    
    public var height: CGFloat = 0
    
    public var nameWidth: CGFloat = 0
    
    public var contentHeight: CGFloat = 0
    
    public var contentWidth: CGFloat = 0;
    
    public var photoHeight: CGFloat = 0
    
    init(model: IMMessageModel) {
        self.msg_model = model
        super.init()
        layout()
    }
    
    
    private func layout() {
        
        height = 0
        
        height += kMsgTopMarginPadding + kMsgNameHeight + kMsgNameAndAvatarPadding + kMsgTopMarginPadding
        
        nameWidth = msg_model.sender_name.calculate(font: UIFont.systemFont(ofSize: 14), size: CGSize(width: kScreen_width - kMsgAvatarWidthAndHeight - kMsgCellPadding * 2.0, height: kMsgNameHeight)).width
        
        switch msg_model.msg_type {
        case .text:
            let size = msg_model.msg_content.calculate(font: UIFont.systemFont(ofSize: 16), size: CGSize(width: kMsgContentMaxWidth, height: CGFloat(MAXFLOAT)))
            contentHeight = size.height
            contentWidth = size.width
            break
        case .voice:
            break
        case .video:
            break
        case .image:
            break
            
        }
        height += contentHeight + 2.0 * kMsgAvatarLeftPadding
    }
}
