//
//  SQMineUserInfoCell.swift
//  WeChat
//
//  Created by ysq on 2017/9/26.
//  Copyright © 2017年 ysq. All rights reserved.
//

import UIKit

class SQMineUserInfoCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var wxId: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }
    
    public func updateInfo() {
        
        avatar.kf.setImage(with: UserModel.sharedInstance.icon.url())
        name.text = UserModel.sharedInstance.username
        wxId.text = UserModel.sharedInstance.wxId
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
