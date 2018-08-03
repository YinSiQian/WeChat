//
//  TimelineLayoutService.swift
//  WeChat
//
//  Created by ysq on 2018/8/2.
//  Copyright © 2018年 ysq. All rights reserved.
//

import Foundation
import UIKit


let kAvatarWidth: CGFloat = 40  //头像宽高
let kNameHeight: CGFloat = 16   //名字高度
let kTimeHeight: CGFloat = 14   //时间地点高度
let kTimeWidth: CGFloat = 150
let kTimelineCellRightMargin: CGFloat = 15 //右边侧间距
let kTimelineCellTopMargin: CGFloat = 15 //头像名字离顶部高度 以及底部距离
let kTimelineCellLeft: CGFloat = 15      //头像离cell左侧间距
let kAvatarAndNamePadding: CGFloat = 10  //头像与名字间距
let kNameAndContentPadding: CGFloat = 8  //名字与内容上下间距
let kContentAndPicsPadding: CGFloat = 8  //内容与图片上下间距
let kPicsPaddingLeft: CGFloat = kTimelineCellLeft + kAvatarWidth + kAvatarAndNamePadding //图片离左侧间距
let kLocationAndPicsPadding: CGFloat = 8 //图片与定位上下间距
let kTimeAndLocationPadding: CGFloat = 8 //时间与定位上下间距
let moreBtnPaddingBottomMargin: CGFloat = 15  //评论点赞按钮离底边距离

let kPicsPadding: CGFloat = 5 //多张图片内边距
let kMaxPicsCount: CGFloat = 3
let kPicWidth: CGFloat = (kScreen_width - kPicsPaddingLeft - (kMaxPicsCount - 1.0) * kPicsPadding) / kMaxPicsCount

//MARK: 字体
let kNameFont = UIFont.systemFont(ofSize: 14)
let kContentFont = UIFont.systemFont(ofSize: 14)
let kTimeFont = UIFont.systemFont(ofSize: 12)
let kPlaceFont = UIFont.systemFont(ofSize: 12)

struct TimelineLayoutService {
    
    var timelineModel: MomentModel
    
    var height: CGFloat = 0
    
    var contentHeight: CGFloat = 0
    
    var picsHeight: CGFloat = 0
    
    var locationHeight: CGFloat = 0;
    
    var lovesHeight: CGFloat = 0
    
    var commentsHeight: CGFloat = 0;
    
    public init(timelineModel: MomentModel, height: CGFloat = 0,
                contentHeight: CGFloat = 0, picsHeight: CGFloat = 0,
                locationHeight: CGFloat = 0, lovesHeight: CGFloat = 0,
                commentsHeight: CGFloat = 0) {
        self.timelineModel = timelineModel
        layout()
    }
    
    private mutating func layout() {
        
        self.contentHeight = self.timelineModel.content.calculate(font: kContentFont, size: CGSize(width: kScreen_width - kPicsPaddingLeft - kTimelineCellRightMargin, height: kScreen_height)).height
        self.height = kTimelineCellTopMargin + kNameHeight
                      + kNameAndContentPadding + contentHeight + kContentAndPicsPadding;
        
        let pic = self.timelineModel.urls.split(whereSeparator: { $0 == "," })
        if !pic.isEmpty {
            var floor: CGFloat = 0
            switch pic.count {
                case 1, 2, 3:
                    floor = 1
                case 4, 5, 6:
                    floor = 2
                case 7, 8, 9:
                    floor = 3
                default:
                    break
            }
            self.picsHeight = picsHeight * floor
            self.height += self.picsHeight + kLocationAndPicsPadding
        } else {
            self.picsHeight = 0
        }
        
        //定位
        if !self.timelineModel.location.isEmpty {
            self.locationHeight = kTimeHeight
            self.height += kTimeHeight + kTimeAndLocationPadding
        } else {
            self.locationHeight = 0
        }
        
        //时间
        self.height += kTimeHeight
        
        //点赞
        if !self.timelineModel.loves.isEmpty {
            //TODO:
        }
        
        //评论
        if !self.timelineModel.comments.isEmpty {
            //TODO:
        }
        
        self.height += kTimelineCellTopMargin
        
    }
    
}
