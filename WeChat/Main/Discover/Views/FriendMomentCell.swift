//
//  FriendMomentCell.swift
//  WeChat
//
//  Created by ysq on 2018/8/2.
//  Copyright © 2018年 ysq. All rights reserved.
//

import UIKit
import Kingfisher

protocol FriendMomentInputCommentViewDelegate: NSObjectProtocol {
    
    func clickCommentUsername(with index: Int, isReply: Bool)
    
    func clickCommentView(with index: Int)
}

class FriendMomentInputCommentView: UIView {
    
    weak var delegate: FriendMomentInputCommentViewDelegate?
    
    var contentView: UIView!

    var loveContentView: UIView!
    
    var loveNames: UILabel!
    
    var line: UIView!
    
    var contentViewArr: [UIView] = []
    
    var comments: [TimelineLayoutService.CommentInfo] = [] {
        didSet {
            loadComments()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        self.backgroundColor = UIColor.white
        setupSubviews()
    }
    
    private func setupSubviews() {
        let arrowImageView = UIImageView(image: UIImage(named: "friend_triangle"))
        arrowImageView.tintColor = UIColor(hex6: 0xf0f0f0)
        self.addSubview(arrowImageView)
        
        self.loveContentView = UIView(frame: CGRect(x: 0, y: 5, width: self.width, height: 0))
        self.loveContentView.clipsToBounds = true
        self.loveContentView.backgroundColor = UIColor(hex6: 0xf0f0f0)
        
        self.loveNames = UILabel(frame: self.loveContentView.bounds)
        self.loveNames.textColor = kNameColor
        self.loveNames.numberOfLines = 0
        self.loveNames.font = kPlaceFont
        self.loveContentView.addSubview(self.loveNames)
        
        self.addSubview(self.loveContentView)
        
        self.line = UIView(frame: CGRect(x: 0, y: 0, width: self.width, height: 0.5))
        self.line.backgroundColor = #colorLiteral(red: 0.8796480759, green: 0.8796480759, blue: 0.8796480759, alpha: 1)
        self.line.isHidden = true
        self.loveContentView.addSubview(self.line)
        
        self.contentView = UIView(frame: CGRect(x: 0, y: 0, width: self.width, height: 0))
        self.contentView.backgroundColor = UIColor(hex6: 0xf0f0f0)
        self.addSubview(self.contentView)
    }
    
    private func loadComments() {
        
        for elment in contentViewArr {
            elment.removeFromSuperview()
        }
        contentViewArr.removeAll()
        var top: CGFloat = 0
        for (index, element) in comments.enumerated() {
            let backView = UIView(frame: CGRect(x: 2, y: top, width: kContentWidth - 2, height: element.height))
            let text = setupLable(element: element)
            text.tag = index + 1
            backView.addSubview(text)
            top += element.height
            self.contentViewArr.append(backView)
            self.contentView.addSubview(backView)
        }
    }
    
    private func setupLable(element: TimelineLayoutService.CommentInfo) -> YYLabel {
        let attribute = NSMutableAttributedString(attributedString: element.content)
        attribute.yy_setTextHighlight(element.replyHighlightRange, color: kNameColor, backgroundColor: UIColor.red) { (containerView, text, range, rect) in
            self.delegate?.clickCommentUsername(with: containerView.tag - 1, isReply: true)
        }
        
        attribute.yy_setTextHighlight(element.receivedHighlightRange, color: kNameColor, backgroundColor: UIColor.red) { (containerView, text, range, rect) in
            self.delegate?.clickCommentUsername(with: containerView.tag - 1, isReply: false)
        }
        
        let text = YYLabel(frame: CGRect(x: 2, y: 0, width: kContentWidth - 2, height: element.height))
        text.font = kTimeFont
        text.numberOfLines = 0
        text.preferredMaxLayoutWidth = kContentWidth - 2
        text.attributedText = attribute
        text.textTapAction = {
            (containerView, text, range, rect) in
            self.delegate?.clickCommentView(with: containerView.tag - 1)
        }
        return text
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

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

protocol FriendMomentCellDelegate: NSObjectProtocol {
    
    func showInterfaceColumnView(point: CGPoint, indexPath: NSIndexPath)
    
    func watchUserInfo(cell index: Int, commentIndex: Int, isReply: Bool)
    
    func reply(cell index: Int, commentIndex: Int)
}

class FriendMomentCell: UITableViewCell {

    var name: UILabel!
    
    var avatar: UIImageView!
    
    var content: UILabel!
    
    var picView: FriendMomentPicView!
    
    var location: UILabel!
    
    var time: UILabel!
    
    var moreBtn: UIButton!
    
    var commentView: FriendMomentInputCommentView!
    
    weak var delegate: FriendMomentCellDelegate?
    
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
        self.name.textColor = kNameColor
        self.name.font = kNameFont
        self.contentView.addSubview(self.name)
        
        self.content = UILabel(frame: CGRect(x: kPicsPaddingLeft, y: self.name.maxY + kNameAndContentPadding, width: kContentWidth, height: 0))
        self.content.textColor = UIColor.black
        self.content.font = kContentFont
        self.content.numberOfLines = 0
        self.contentView.addSubview(self.content)
        
        self.picView = FriendMomentPicView(frame: CGRect(x: kPicsPaddingLeft, y: 0, width: self.content.width, height: 0))
        self.contentView.addSubview(self.picView)
        
        self.location = UILabel(frame: CGRect(x: kPicsPaddingLeft, y: 0, width: self.content.width, height: 0))
        self.location.textColor = kNameColor
        self.location.font = kPlaceFont
        self.contentView.addSubview(self.location)
        
        self.time = UILabel(frame: CGRect(x: kPicsPaddingLeft, y: 0, width: kTimeWidth, height: kTimeHeight))
        self.time.textColor = UIColor.gray
        self.time.font = kTimeFont
        self.contentView.addSubview(self.time)
        
        self.moreBtn = UIButton(frame: CGRect(x: kScreen_width - 15 - 25, y: 0, width: 25, height: 25))
        self.moreBtn.setBackgroundImage(UIImage(named: "friend_operation_comment"), for: .normal)
        self.moreBtn.addTarget(self, action: #selector(FriendMomentCell.showOperation(sender:)), for: .touchUpInside)
        self.contentView.addSubview(self.moreBtn)
        
        self.commentView = FriendMomentInputCommentView(frame: CGRect(x: kPicsPaddingLeft, y: 0, width: kContentWidth, height: 0))
        self.commentView.delegate = self
        self.contentView.addSubview(self.commentView)
        
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
        self.moreBtn.minY = self.time.minY - (self.moreBtn.height - self.time.height ) / 2
        
        self.commentView.height = layout.commentsHeight
        self.commentView.minY = self.time.maxY + kTimeAndLocationPadding
        
        self.commentView.loveContentView.height = layout.loveHeight
        self.commentView.loveNames.frame = self.commentView.loveContentView.bounds
        self.commentView.contentView.minY = layout.loveHeight > 0 ? self.commentView.loveContentView.maxY : 5
        
        self.commentView.contentView.height = layout.commentsHeight - layout.loveHeight - 5
        if self.commentView.contentView.height > 0 {
            self.commentView.line.isHidden = false
            self.commentView.line.minY = layout.loveHeight - 1
        } else {
            self.commentView.line.isHidden = true
        }
        self.commentView.comments = layout.commentInfos
        self.commentView.loveNames.attributedText = layout.loveInfo
        
    }
    
    private func setupImages() {
       
        let picsCount = self.layout.timelineModel.urlInfo.count
        for index in 0 ..< 9 {
            let imageView = self.picView.picsView[index]
            if index >= picsCount {
                imageView.kf.cancelDownloadTask()
                imageView.isHidden = true
            } else {
                let urlInfo = self.layout.timelineModel.urlInfo[index]
                imageView.isHidden = false
                var rect = CGRect.zero
                rect.size.width = kPicWidth
                rect.size.height = kPicWidth
                switch picsCount {
                case 1:
                    let scale = urlInfo.height / urlInfo.width
                    rect.origin.x = 0
                    rect.origin.y = 0
                    //高图
                    if scale >= 2.0 {
                        rect.size.height = kPicWidth * 2 * 1.5
                        rect.size.width = rect.size.height / scale
                    } else if scale >= 1.0 && scale < 2.0 {
                        rect.size.height = kPicWidth * 1.5 * scale
                        rect.size.width = rect.size.height / scale
                    } else if scale >= 0.5 && scale < 1.0 {
                        //宽图
                        rect.size.width = kPicWidth / scale * 1.5
                        rect.size.height = rect.size.width * scale
                    } else {
                        rect.size.width = kScreen_width - kPicsPaddingLeft - kTimelineCellRightMargin
                        rect.size.height = rect.size.width * scale
                    }
                case 4:
                    rect.origin.x = CGFloat(index % 2) * kPicsPadding + CGFloat(index % 2) * (kPicWidth)
                    rect.origin.y = CGFloat(index / 2) * (kPicWidth + kPicsPadding);
                default:
                    rect.origin.x = CGFloat(index % 3) * kPicsPadding + CGFloat(index % 3) * (kPicWidth);
                    rect.origin.y = CGFloat(index / 3) * (kPicWidth + kPicsPadding);
                }
                imageView.frame = rect
                let urlString = urlInfo.baseUrl + "/" + urlInfo.path
                imageView.kf.setImage(with: urlString.url(), placeholder: nil, options: nil, progressBlock: nil) { (image, error, cacheType, url) in
                    if let currentImage = image {
                        let scale =  currentImage.size.height / currentImage.size.width
                        if scale < 0.99 || scale.isNaN { // 宽图把左右两边裁掉
                            imageView.contentMode = .scaleAspectFit;
                            imageView.layer.contentsRect = CGRect(x: 0, y: 0, width: 1, height: 1)
                        } else { // 高图只保留顶部
                            imageView.contentMode = .scaleAspectFill;
                            imageView.layer.contentsRect = CGRect(x: 0, y: 0, width: 1, height: currentImage.size.width / currentImage.size.height)
                        }
                    }
                    imageView.image = image
                }
            }
        }
    }
    
    // MARK: -- Events
    
    @objc private func showOperation(sender: UIButton) {
        let point = self.convert(sender.frame.origin, to: AppDelegate.currentAppdelegate().window)
        self.delegate?.showInterfaceColumnView(point: point, indexPath: forIndexPath())

    }
    
    private func forIndexPath() -> NSIndexPath {
        var indexPath = NSIndexPath(row: 0, section: 0)
        if let tableView = self.superview as? UITableView {
            indexPath = tableView.indexPath(for: self)! as NSIndexPath
        }
        if let tableView = self.superview?.superview as? UITableView {
            indexPath = tableView.indexPath(for: self)! as NSIndexPath
        }
        return indexPath
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension FriendMomentCell: FriendMomentInputCommentViewDelegate {
    
    func clickCommentUsername(with index: Int, isReply: Bool) {
        self.delegate?.watchUserInfo(cell: forIndexPath().row, commentIndex: index, isReply: isReply)
    }
    
    func clickCommentView(with index: Int) {
        self.delegate?.reply(cell: forIndexPath().row, commentIndex: index)

    }
    
}
