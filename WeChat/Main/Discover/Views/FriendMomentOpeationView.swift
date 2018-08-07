//
//  FriendMomentOpeationView.swift
//  WeChat
//
//  Created by ysq on 2018/8/7.
//  Copyright © 2018年 ysq. All rights reserved.
//

import UIKit

class FriendMomentOpeationView: UIView {

    private var point: CGPoint = CGPoint(x: 0, y: 0)
    
    private var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        let tag = UITapGestureRecognizer(target: self, action: #selector(FriendMomentOpeationView.hide))
        self.addGestureRecognizer(tag)
    }
    
    convenience init(frame: CGRect, point: CGPoint) {
        self.init(frame: frame)
        self.point = point
    }
    
    private func setupSubviews() {
        self.contentView = UIView(frame: CGRect(x: point.x, y: point.y, width: 200, height: 40))
        self.contentView.backgroundColor = UIColor.black
        self.contentView.layer.cornerRadius = 6
        self.contentView.layer.masksToBounds = true
    }
    
    @objc private func hide() {
        self.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
