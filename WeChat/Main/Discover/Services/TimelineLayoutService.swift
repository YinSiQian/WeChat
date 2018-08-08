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
let kPicWidth: CGFloat = (kScreen_width - kPicsPaddingLeft - (kMaxPicsCount - 1.0) * kPicsPadding - kTimelineCellRightMargin) / kMaxPicsCount

let kContentWidth: CGFloat = kScreen_width - kPicsPaddingLeft - kTimelineCellRightMargin


//MARK: 字体
let kNameFont = UIFont.boldSystemFont(ofSize: 14)
let kContentFont = UIFont.systemFont(ofSize: 14)
let kTimeFont = UIFont.systemFont(ofSize: 12)
let kPlaceFont = UIFont.systemFont(ofSize: 12)

let kNameColor = UIColor(hex6: 0x4460BB)

struct TimelineLayoutService {
    
    var timelineModel: MomentModel
    
    var isLoved: Bool = false
    
    var height: CGFloat = 0
    
    var contentHeight: CGFloat = 0
    
    var picsHeight: CGFloat = 0
    
    var locationHeight: CGFloat = 0;
    
    //点赞 评论
    var commentsHeight: CGFloat = 0;
    
    var loveHeight: CGFloat = 0
    
    var commentInfos: [CommentInfo] = []
    
    var loveInfo: NSAttributedString = NSAttributedString()
        
    public init(timelineModel: MomentModel, height: CGFloat = 0,
                contentHeight: CGFloat = 0, picsHeight: CGFloat = 0,
                locationHeight: CGFloat = 0,commentsHeight: CGFloat = 0) {
        self.timelineModel = timelineModel
        
        layout()
        
    }
    
    private mutating func layout() {
        
        self.height = 0
        
        self.contentHeight = self.timelineModel.content.calculate(font: kContentFont, size: CGSize(width: kContentWidth, height: kScreen_height)).height
        self.height = kTimelineCellTopMargin + kNameHeight
                      + kNameAndContentPadding + contentHeight + kContentAndPicsPadding;
        
        
        if !self.timelineModel.urlInfo.isEmpty {
            var floor: CGFloat = 0
            switch self.timelineModel.urlInfo.count {
                case 1, 2, 3:
                    floor = 1
                case 4, 5, 6:
                    floor = 2
                case 7, 8, 9:
                    floor = 3
                default:
                    break
            }
            if self.timelineModel.urlInfo.count == 1 {
                let maxWidth = kScreen_width - kPicsPaddingLeft - kTimelineCellRightMargin
                
                let scale = self.timelineModel.urlInfo[0].height / self.timelineModel.urlInfo[0].width
                if scale >= 2.0 {
                    //高图最宽为 2 * kPicWidth
                    self.picsHeight = 2 * kPicWidth * 1.5 * scale
                } else if scale >= 1.0 && scale < 2.0 {
                    
                    self.picsHeight = kPicWidth * scale * 1.5
                } else if scale >= 0.5 && scale < 1.0 {
                    //宽图最宽为 maxWidth
                    self.picsHeight = kPicWidth * 1.5
                } else {
                    self.picsHeight = maxWidth * scale
                }
            } else {
                self.picsHeight = kPicWidth * floor + kPicsPadding * (floor - 1)
            }
            self.height += self.picsHeight + kLocationAndPicsPadding
        } else {
            self.picsHeight = 0
        }
        
        //定位
        if !self.timelineModel.location.isCurrentEmpty {
            self.locationHeight = kTimeHeight
            self.height += kTimeHeight + kTimeAndLocationPadding
        } else {
            self.locationHeight = 0
        }
        
        //时间
        self.height += kTimeHeight
        
        //点赞
        if !self.timelineModel.loves.isEmpty {
            let count = self.timelineModel.loves.count
            var loveContent = " "
            for (index, element) in self.timelineModel.loves.enumerated() {
                loveContent.append(element.username)
                if index == count - 1 {
                    break
                } else {
                    loveContent.append("，")
                }
            }
            loveContent.append("，风清扬，刘正风，曲洋，习大大，李克强，温家宝，江泽民，胡锦涛")
            
            let attach = NSTextAttachment(data: nil, ofType: nil)
            attach.image = UIImage(named: "friend_loved")
            attach.bounds = CGRect(x: 4, y: -4, width: 15, height: 15)
            let attachAttributeString = NSAttributedString(attachment: attach)
            
            let attribute = NSMutableAttributedString(string: loveContent)
            attribute.insert(attachAttributeString, at: 0)
            loveInfo = attribute.copy() as! NSAttributedString
            
            loveHeight = attribute.string.calculate(font: kContentFont, size: CGSize(width: kContentWidth, height: CGFloat(MAXFLOAT))).height + 5
            commentsHeight += loveHeight
            
        }
        
        //评论
        if !self.timelineModel.comments.isEmpty {
            for element in self.timelineModel.comments {
                var content = ""
                if element.isComment == 1 {
                    //评论
                    content = element.replyName + ": " + element.content
                } else  {
                    content = element.replyName + " 回复 " + element.receivedName + ": " + element.content
                }
                let height = content.calculate(font: kTimeFont, size: CGSize(width: kContentWidth - 2, height: CGFloat(MAXFLOAT))).height + 10
                let replyHighlightRange = (content as NSString).range(of: element.replyName)
                let receivedHighlightRange = (content as NSString).range(of: element.receivedName)
                
                let attributeText = NSMutableAttributedString(string: content)
                attributeText.addAttribute(NSAttributedStringKey.foregroundColor, value: kNameColor, range: replyHighlightRange)
                if receivedHighlightRange.location != NSNotFound {
                    attributeText.addAttribute(NSAttributedStringKey.foregroundColor, value: kNameColor, range: receivedHighlightRange)
                }
                
                let info = CommentInfo(content: attributeText, height: height, replyHighlightRange: replyHighlightRange, receivedHighlightRange: receivedHighlightRange)
                commentInfos.append(info)
                
                commentsHeight += height
            }
        }
        
        commentsHeight = commentsHeight > 0 ? commentsHeight + 5 : 0
        
        self.height += commentsHeight

        self.height += kTimelineCellTopMargin
        
    }
    
    struct CommentInfo {
        
        let content: NSAttributedString
        let height: CGFloat
        let replyHighlightRange: NSRange
        let receivedHighlightRange: NSRange
    }
    
}
