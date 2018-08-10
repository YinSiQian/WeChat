//
//  FriendMomentOpeationView.swift
//  WeChat
//
//  Created by ysq on 2018/8/7.
//  Copyright © 2018年 ysq. All rights reserved.
//

import UIKit

class FriendMomentOpeationView: UIView {
    
    private var contentView: UIView!
    
    typealias action = (_ type: Int) -> Void
    
    var clickAction: action!
    
    var loved: Int = 0 {
        didSet {
            updateLoveBtnTitle()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.clipsToBounds = true
    }
    
    convenience init(frame: CGRect, point: CGPoint, action: @escaping (_ type: Int) -> Void) {
        self.init(frame: frame)
        self.clickAction = action
        self.minX = point.x - 155
        self.minY = point.y - 4.5
        setupSubviews()
    }
    
    private func setupSubviews() {
        self.contentView = UIView(frame: CGRect(x: self.width, y: 0, width: self.width, height: self.height))
        self.contentView.backgroundColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        self.contentView.layer.cornerRadius = 6
        self.contentView.layer.masksToBounds = true
        self.addSubview(self.contentView)
        
        let commentBtn = UIButton(frame: CGRect(x: self.width / 2, y: 0, width: self.width / 2, height: self.height))
        commentBtn.setTitle("评论", for: .normal)
        commentBtn.setTitleColor(UIColor.white, for: .normal)
        commentBtn.backgroundColor = UIColor.clear
        commentBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        commentBtn.setImage(UIImage(named: "friend_comment"), for: .normal)
        commentBtn.addTarget(self, action: #selector(FriendMomentOpeationView.btnAction(sender:)), for: .touchUpInside)
        commentBtn.tag = 2
        self.contentView.addSubview(commentBtn)
        
        let loveBtn = UIButton(frame: CGRect(x: 0, y: 0, width: self.width / 2, height: self.height))
        if self.loved == 1 {
            loveBtn.setTitle("取消", for: .normal)
        } else {
            loveBtn.setTitle("赞", for: .normal)
        }
        loveBtn.setTitleColor(UIColor.white, for: .normal)
        loveBtn.backgroundColor = UIColor.clear
        loveBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        loveBtn.setImage(UIImage(named: "friend_love"), for: .normal)
        loveBtn.tag = 1
        loveBtn.addTarget(self, action: #selector(FriendMomentOpeationView.btnAction(sender:)), for: .touchUpInside)
        self.contentView.addSubview(loveBtn)
        
        loveBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        
    }
    
    @objc private func btnAction(sender: UIButton) {
        if sender.tag == 1 {
            sender.setTitle("取消", for: .normal)
        }
        self.clickAction?(sender.tag)
    }
    
    @objc func hide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.minX += 200
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    public func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
        UIView.animate(withDuration: 0.3) {
            self.contentView.minX = 0
        }
    }
    
    private func updateLoveBtnTitle() {
        let btn = self.viewWithTag(1) as! UIButton
        if self.loved == 1 {
            btn.setTitle("取消", for: .normal)
        } else {
            btn.setTitle("赞", for: .normal)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
