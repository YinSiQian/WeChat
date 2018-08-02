//
//  TimelineLayoutService.swift
//  WeChat
//
//  Created by ysq on 2018/8/2.
//  Copyright © 2018年 ysq. All rights reserved.
//

import Foundation

let kAvatarWidth = 40  //头像宽高
let kNameHeight = 16   //名字高度
let kTimelineCellTopMargin = 15 //头像名字离顶部高度
let kTimelineCellLeft = 15      //头像离cell左侧间距
let kAvatarAndNamePadding = 10  //头像与名字间距
let kNameAndContentPadding = 8  //名字与内容上下间距
let kContentAndPicsPadding = 8  //内容与图片上下间距
let kPicsPaddingLeft = kTimelineCellLeft + kAvatarWidth + kAvatarAndNamePadding //图片离左侧间距
let kPicsPadding = 5 //多张图片内边距
let kLocationAndPicsPadding = 8 //图片与定位上下间距
let kTimeAndLocationPadding = 8 //时间与定位上下间距
let moreBtnPaddingBottomMargin = 15  //评论点赞按钮离底边距离

struct TimelineLayoutService {
    
    var timelineModel: MomentModel {
        didSet {
            layout()
        }
    }
    
    private func layout() {
        
    }
    
}
