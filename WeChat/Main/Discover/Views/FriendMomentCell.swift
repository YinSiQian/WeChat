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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
