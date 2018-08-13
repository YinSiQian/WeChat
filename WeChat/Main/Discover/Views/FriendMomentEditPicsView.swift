//
//  FriendMomentEditPicsView.swift
//  WeChat
//
//  Created by ysq on 2018/8/12.
//  Copyright © 2018年 ysq. All rights reserved.
//

import UIKit

class FriendMomentEditPicsView: UIView {

    typealias openPhotoAlbumAction = () -> Void
    
    var action: openPhotoAlbumAction!
    
    var images: [UIImage] = [] {
        didSet {
            setupSubviews()
        }
    }
    
    private var imageViews = [UIImageView]()
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
    }
    
    convenience init(frame: CGRect, images: [UIImage]) {
        self.init(frame: frame)
        self.images = images
        setupSubviews()
    }
    
    convenience init(frame: CGRect, images: [UIImage], complection: @escaping openPhotoAlbumAction) {
        self.init(frame: frame, images: images)
        self.action = complection
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        let maxCount: CGFloat = 3
        let space: CGFloat = 5
        let width = (self.width - (maxCount - 1) * space) / maxCount
        
        self.height = width * maxCount + space * (maxCount - 1)
        
        for (index, image) in images.enumerated() {
            
            if index >= imageViews.count {
                let imageView = UIImageView()
                imageView.image = image
                var rect = CGRect.zero
                rect.size.width = width
                rect.size.height = width
                rect.origin.x = CGFloat(index % 3) * width + CGFloat(index % 3) * space
                rect.origin.y = CGFloat(index / 3) * (width + space)
                
                imageView.frame = rect
                addSubview(imageView)
                imageViews.append(imageView)
            }
           
        }
        
        viewWithTag(119)?.removeFromSuperview()
        
        if imageViews.count < 9 {
            let addBtn = UIButton()
            addBtn.tag = 119
            var rect = CGRect.zero
            rect.size.width = width
            rect.size.height = width
            switch imageViews.count {
                case 3:
                    rect.origin.x = 0
                    rect.origin.y = width + space
                case 6:
                    rect.origin.x = 0
                    rect.origin.y = 2.0 * (width + space)
                default:
                    let imageView = imageViews[imageViews.count - 1]
                    rect.origin.x = imageView.maxX + space
                    rect.origin.y = imageView.minY
            }
            addBtn.frame = rect
            addBtn.setTitle("添加照片", for: .normal)
            addBtn.setTitleColor(UIColor.red, for: .normal)
            addBtn.addTarget(self, action: #selector(FriendMomentEditPicsView.openPhotoAlbum), for: .touchUpInside)
            addBtn.backgroundColor = UIColor.lightGray
            addSubview(addBtn)
        }
    }
    
    
    @objc private func openPhotoAlbum() {
        action?()
    }
    
}
