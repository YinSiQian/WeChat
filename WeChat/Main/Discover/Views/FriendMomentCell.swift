//
//  FriendMomentCell.swift
//  WeChat
//
//  Created by ysq on 2018/8/2.
//  Copyright © 2018年 ysq. All rights reserved.
//

import UIKit

class FriendMomentPicView: UIView {
    
    
}

class FriendMomentCell: UITableViewCell {

    var name: UILabel!
    
    var avatar: UIImageView!
    
    var content: UILabel!
    
    var picView: FriendMomentPicView!
    
    var location: UILabel!
    
    var time: UILabel!
    
    var moreBtn: UIButton!
    
    var layout: TimelineLayoutService! {
        didSet {
            setData()
        }
    }
    
    public static func cell(with: UITableView) -> FriendMomentCell {
        let reuseId = "TimelineLayoutService.swift"
        var cell = with.dequeueReusableCell(withIdentifier: reuseId) as? FriendMomentCell
        if cell == nil {
            cell = FriendMomentCell(style: .default, reuseIdentifier: reuseId)
        }
        return cell!
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        self.contentView.backgroundColor = UIColor.white
        self.selectionStyle = .none
        setupSubviews()
    }
    
    private func setupSubviews() {
        
        self.avatar = UIImageView(frame: CGRect(x: kTimelineCellLeft, y: kTimelineCellTopMargin, width: 40, height: 40))
        self.avatar.backgroundColor = UIColor.orange
        self.contentView.addSubview(self.avatar)
        
        self.name = UILabel(frame: CGRect(x: kPicsPaddingLeft, y: kTimelineCellTopMargin, width: kScreen_width - kPicsPadding - kTimelineCellRightMargin, height: kNameHeight))
        self.name.textColor = UIColor.black
        self.name.font = kNameFont
        self.contentView.addSubview(self.name)
        
        self.content = UILabel(frame: CGRect(x: kPicsPaddingLeft, y: self.name.maxY + kNameAndContentPadding, width: kScreen_width - kPicsPaddingLeft - kTimelineCellRightMargin, height: 0))
        self.content.textColor = UIColor.black
        self.content.font = kContentFont
        self.contentView.addSubview(self.content)
        
        self.picView = FriendMomentPicView(frame: CGRect(x: kPicsPaddingLeft, y: 0, width: self.content.width, height: 0))
        self.picView.backgroundColor = UIColor.red
        self.contentView.addSubview(self.picView)
        
        self.location = UILabel(frame: CGRect(x: kPicsPaddingLeft, y: 0, width: self.content.width, height: 0))
        self.location.textColor = UIColor.blue
        self.location.font = kPlaceFont
        self.contentView.addSubview(self.location)
        
        self.time = UILabel(frame: CGRect(x: kPicsPaddingLeft, y: 0, width: kTimeWidth, height: kTimeHeight))
        self.time.textColor = UIColor.gray
        self.time.font = kTimeFont
        self.contentView.addSubview(self.time)
        
    }
    
    private func setData() {
        self.name.text = layout.timelineModel.name
        self.content.text = layout.timelineModel.content
        self.time.text = layout.timelineModel.timestamp
        self.location.text = layout.timelineModel.location
        
        self.content.height = layout.contentHeight
        var locationTop: CGFloat = 0
        if layout.picsHeight == 0 {
            locationTop = self.content.maxY + kLocationAndPicsPadding
        } else {
            self.picView.height = layout.picsHeight
            self.picView.minY = self.content.maxY + kContentAndPicsPadding
            locationTop = self.picView.maxY + kLocationAndPicsPadding
        }
        
        self.location.minY = locationTop
        self.location.height = layout.locationHeight
        
        self.time.minY = layout.locationHeight == 0 ? locationTop : self.location.maxY + kTimeAndLocationPadding
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
