//
//  IMMessageCell.swift
//  WeChat
//
//  Created by ABJ on 2018/9/7.
//  Copyright © 2018年 ysq. All rights reserved.
//

import UIKit

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
    
    public var msgServiceModel: IMMessageLayoutService? {
        didSet {
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
        selectionStyle = .none
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        avatar = UIImageView(frame: CGRect(x: kMsgAvatarLeftPadding, y: kMsgCellPadding, width: kMsgAvatarWidthAndHeight, height: kMsgAvatarWidthAndHeight))
        avatar.isUserInteractionEnabled = true
        avatar.contentMode = .scaleAspectFit
        contentView.addSubview(avatar)
        
        username = UILabel(frame: CGRect(x: avatar.maxX + kMsgNameAndAvatarPadding, y: kMsgCellPadding, width: kMsgContentMaxWidth, height: kMsgNameHeight))
        username.textColor = UIColor.darkGray
        username.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(username)
        
        content = UILabel(frame: CGRect(x: avatar.maxX + kMsgNameAndAvatarPadding, y: username.maxY + kMsgCellPadding, width: kMsgContentMaxWidth, height: kMsgNameHeight))
        content.textColor = UIColor.black
        content.font = UIFont.systemFont(ofSize: 16)
        content.numberOfLines = 0
        contentView.addSubview(content)
        
        photo = UIImageView(frame: CGRect(x: avatar.maxX + kMsgNameAndAvatarPadding, y: username.maxY + kMsgCellPadding, width: kMsgContentMaxWidth, height: kMsgNameHeight))
        photo.isUserInteractionEnabled = true
        photo.isHidden = true
        contentView.addSubview(photo)
    }
    
    private func layout() {
        guard let model = msgServiceModel else {
            return
        }
        avatar.kf.setImage(with: model.msg_model.received_avatar.url(), placeholder: nil, options: [], progressBlock: nil, completionHandler: nil)
        username.text = model.msg_model.received_name
        content.text = model.msg_model.msg_content
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
