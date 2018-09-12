//
//  IMMessageCell.swift
//  WeChat
//
//  Created by ysq on 2018/9/7.
//  Copyright © 2018年 ysq. All rights reserved.
//

import UIKit

let kMsgTopMarginPadding: CGFloat = 10.0
let kMsgCellPadding: CGFloat = 5.0
let kMsgAvatarLeftPadding: CGFloat = 15.0
let kMsgNameAndAvatarPadding: CGFloat = 10.0
let kMsgContentAndNamePadding: CGFloat = 10.0
let kMsgAvatarWidthAndHeight: CGFloat = 40.0
let kMsgContentMaxWidth: CGFloat = kScreen_width - kMsgAvatarLeftPadding - 2.0 * kMsgAvatarWidthAndHeight - kMsgNameAndAvatarPadding
let kMsgNameHeight: CGFloat = 18

class IMMessageCell: UITableViewCell {
    
    private var avatar: UIImageView!
    
    private var username: UILabel!
    
    private var messageBackImage: UIImageView!
    
    private var content: UILabel!
    
    private var photo: UIImageView!
    
    private var indicator: UIActivityIndicatorView!
    
    public var msgServiceModel: IMMessageLayoutService? {
        didSet {
            print("address layout--->\(String(format: "%p", msgServiceModel!))")
            print("changed---2")
//            msgServiceModel?.addObserver(self, forKeyPath: "msg_model.delivered", options: .new, context: nil)
            layout()
        }
    }
    
    public static func cell(with: UITableView) -> IMMessageCell {
        let reuesId = "IMMessageCell"
        var cell = with.dequeueReusableCell(withIdentifier: reuesId)
        if cell == nil {
            cell = IMMessageCell(style: .default, reuseIdentifier: reuesId)
        }
        return cell as! IMMessageCell
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        selectionStyle = .none
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        avatar = UIImageView(frame: CGRect(x: kMsgAvatarLeftPadding, y: kMsgTopMarginPadding, width: kMsgAvatarWidthAndHeight, height: kMsgAvatarWidthAndHeight))
        avatar.isUserInteractionEnabled = true
        avatar.backgroundColor = UIColor.orange
        avatar.contentMode = .scaleAspectFit
        contentView.addSubview(avatar)
        
        username = UILabel(frame: CGRect(x: avatar.maxX + kMsgNameAndAvatarPadding, y: kMsgTopMarginPadding, width: kMsgContentMaxWidth, height: kMsgNameHeight))
        username.textColor = UIColor.darkGray
        username.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(username)
        
        photo = UIImageView(frame: CGRect(x: avatar.maxX + kMsgNameAndAvatarPadding, y: username.maxY + kMsgCellPadding, width: kMsgContentMaxWidth, height: kMsgNameHeight))
        photo.isUserInteractionEnabled = true
        photo.isHidden = true
        contentView.addSubview(photo)
        
        messageBackImage = UIImageView(frame: CGRect(x: avatar.maxX + kMsgNameAndAvatarPadding, y: username.maxY + kMsgCellPadding, width: kMsgContentMaxWidth, height: kMsgNameHeight))
        contentView.addSubview(messageBackImage)
        
        content = UILabel(frame: CGRect(x: kMsgAvatarLeftPadding, y: kMsgAvatarLeftPadding - 3, width: kMsgContentMaxWidth - 2.0 * kMsgCellPadding, height: kMsgNameHeight))
        content.textColor = UIColor.black
        content.font = UIFont.systemFont(ofSize: 16)
        content.numberOfLines = 0
        messageBackImage.addSubview(content)
        
        indicator = UIActivityIndicatorView(style: .gray)
        indicator.color = UIColor.red
        indicator.isHidden = false
        contentView.addSubview(indicator)
    }
    
    private func layout() {
//        let model = msgServiceModel
        guard let model = msgServiceModel else {
            return
        }
        avatar.kf.setImage(with: model.msg_model.received_avatar.url(), placeholder: nil, options: [], progressBlock: nil, completionHandler: nil)
        username.text = model.msg_model.sender_name
        content.text = model.msg_model.msg_content
        print("sender_id ---\(model.msg_model.sender_id)  local sender id \(UserModel.sharedInstance.id)" )
        
        if model.msg_model.sender_id == UserModel.sharedInstance.id {
            //自己发送的
            avatar.frame = CGRect(x: kScreen_width - kMsgAvatarLeftPadding - kAvatarWidth, y: kMsgTopMarginPadding, width: kMsgAvatarWidthAndHeight, height: kMsgAvatarWidthAndHeight)
            username.frame = CGRect(x: avatar.minX - kMsgNameAndAvatarPadding - model.nameWidth, y: kMsgTopMarginPadding, width: model.nameWidth, height: kMsgNameHeight)
            messageBackImage.frame = CGRect(x: avatar.minX - kMsgNameAndAvatarPadding - model.contentWidth - 2 * kMsgAvatarLeftPadding, y: username.maxY + kMsgCellPadding, width: model.contentWidth + 2 * kMsgAvatarLeftPadding, height: model.contentHeight + 2 * kMsgAvatarLeftPadding)
            messageBackImage.image = #imageLiteral(resourceName: "aaSenderMsgNodeBkg_62x49_")
            indicator.frame = CGRect(x: messageBackImage.minX  - 30, y: (messageBackImage.height - 30) / 2 + messageBackImage.minY, width: 30, height: 30)
            
        } else {
            avatar.frame = CGRect(x: kMsgAvatarLeftPadding, y: kMsgTopMarginPadding, width: kMsgAvatarWidthAndHeight, height: kMsgAvatarWidthAndHeight)
            username.frame = CGRect(x: avatar.maxX + kMsgNameAndAvatarPadding, y: kMsgTopMarginPadding, width: kMsgContentMaxWidth, height: kMsgNameHeight)
            messageBackImage.frame = CGRect(x: avatar.maxX + kMsgNameAndAvatarPadding, y: username.maxY + kMsgCellPadding, width: model.contentWidth + 2 * kMsgAvatarLeftPadding, height: model.contentHeight + 2 * kMsgAvatarLeftPadding)
            messageBackImage.image = #imageLiteral(resourceName: "ReceiverTextNodeBkg_62x49_")
//            indicator.frame = CGRect(x: messageBackImage.maxX, y: (messageBackImage.height - 30) / 2 + messageBackImage.minY, width: 30, height: 30)
            
        }
        if model.msg_model.delivered == 1 {
            indicator.stopAnimating()
        } else {
            indicator.startAnimating()
        }
        content.height = model.contentHeight
        content.width = model.contentWidth
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    deinit {
        msgServiceModel?.removeObserver(self, forKeyPath: "msgServiceModel.msg_model.msg_status")
    }

}
