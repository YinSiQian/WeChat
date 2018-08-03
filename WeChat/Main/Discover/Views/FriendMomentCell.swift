//
//  FriendMomentCell.swift
//  WeChat
//
//  Created by ysq on 2018/8/2.
//  Copyright © 2018年 ysq. All rights reserved.
//

import UIKit
import Kingfisher

class FriendMomentPicView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        loadPics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var picsView: [UIImageView] = []
    
    private func loadPics() {
        
        for _ in 0 ..< 9 {
            
            let imageView = UIImageView()
            imageView.isUserInteractionEnabled = true
            imageView.clipsToBounds = true
            imageView.isHidden = true
            imageView.isExclusiveTouch = true
            imageView.backgroundColor = UIColor(hex6: 0xf0f0f0)
            self.addSubview(imageView)
            self.picsView.append(imageView)
        }
    }
    
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
        self.content.numberOfLines = 0
        self.contentView.addSubview(self.content)
        
        self.picView = FriendMomentPicView(frame: CGRect(x: kPicsPaddingLeft, y: 0, width: self.content.width, height: 0))
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
        self.picView.height = layout.picsHeight
        if layout.picsHeight == 0 {
            locationTop = self.content.maxY + kLocationAndPicsPadding
        } else {
            self.picView.minY = self.content.maxY + kContentAndPicsPadding
            locationTop = self.picView.maxY + kLocationAndPicsPadding
            setupImages()
        }
        
        self.location.minY = locationTop
        self.location.height = layout.locationHeight
        
        self.time.minY = layout.locationHeight == 0 ? locationTop : self.location.maxY + kTimeAndLocationPadding
        
    }
    
    private func setupImages() {
       
        let picsCount = self.layout.pics.count
        for index in 0 ..< 9 {
            let imageView = self.picView.picsView[index]
            if index >= picsCount {
                imageView.kf.cancelDownloadTask()
                imageView.isHidden = true
            } else {
                imageView.isHidden = false
                var rect = CGRect.zero
                rect.size.width = kPicWidth
                rect.size.height = kPicWidth
                switch picsCount {
                case 1:
                    rect.origin.x = 0
                    rect.origin.y = 0
                    rect.size.height = kPicWidth * 2.0
                    rect.size.width = kPicWidth
                case 4:
                    rect.origin.x = CGFloat(index % 2) * kPicsPadding + CGFloat(index % 2) * (kPicWidth)
                    rect.origin.y = CGFloat(index / 2) * (kPicWidth + kPicsPadding);
                default:
                    rect.origin.x = CGFloat(index % 3) * kPicsPadding + CGFloat(index % 3) * (kPicWidth);
                    rect.origin.y = CGFloat(index / 3) * (kPicWidth + kPicsPadding);
                }
                imageView.frame = rect
                imageView.kf.setImage(with: self.layout.pics[index].url(), placeholder: nil, options: nil, progressBlock: nil) { (image, error, cacheType, url) in
                    let scale = (image?.size.height)! / (image?.size.width)!
                    if scale < 0.99 || scale.isNaN { // 宽图把左右两边裁掉
                        imageView.contentMode = .scaleAspectFit;
                        imageView.layer.contentsRect = CGRect(x: 0, y: 0, width: 1, height: 1)
                    } else { // 高图只保留顶部
                        imageView.contentMode = .scaleAspectFill;
                        imageView.layer.contentsRect = CGRect(x: 0, y: 0, width: 1, height: (image?.size.width)! / (image?.size.height)!)
                    }
                    imageView.image = image
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
