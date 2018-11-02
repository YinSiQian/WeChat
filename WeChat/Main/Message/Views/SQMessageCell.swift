//
//  SQMessageCell.swift
//  WeChat
//
//  Created by ysq on 2017/10/7.
//  Copyright © 2017年 ysq. All rights reserved.
//

import UIKit

class SQMessageCell: UITableViewCell {

    private var icon_layer: CALayer?
    
    private var name_layer: CATextLayer?
    
    private var content_layer: CATextLayer?
    
    private var time_layer: CATextLayer?
    
    private var redView: UIView!
    
    public var model: MessageListModel = MessageListModel() {
        didSet {
            name_layer?.string = model.name
            if model.create_time > 1000000000000 {
                let currentTime = model.create_time / 1000
                time_layer?.string = currentTime.timestamp
            } else {
                time_layer?.string = model.create_time.timestamp
            }
            if model.unread_count > 0 {
                redView.isHidden = false
                if model.unread_count > 1 {
                    content_layer?.string = "[\(model.unread_count)条]" + model.content
                } else {
                    content_layer?.string = model.content
                }
            } else {
                content_layer?.string = model.content
            }
        }
    }
    
    public var showRedMessage: Bool = false {
        didSet {
            redView.isHidden = !showRedMessage
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupSubviews() {
        
      
        
//        let font = UIFont.fontNames(forFamilyName: "Helvetica")
//        print(font)
//
//        let sysFont = UIFont(name: "Helvetica-Light", size: 16)
        
        let fontName = "Helvetica-Bold"
        
        icon_layer = CALayer()
        icon_layer?.frame = CGRect(x: 10, y: 5, width: 60, height: 60)
        icon_layer?.contents = #imageLiteral(resourceName: "info_default").cgImage
        icon_layer?.cornerRadius = 4
        icon_layer?.masksToBounds = true
        contentView.layer.addSublayer(icon_layer!)
        
        redView = UIView(frame: CGRect(x: 64, y: 7, width: 8, height: 8))
        redView.backgroundColor = UIColor.red
        redView.layer.cornerRadius = 4
        redView.isHidden = true
        contentView.addSubview(redView)
        
        name_layer = CATextLayer()
        name_layer?.frame = CGRect(x: 80, y: 8, width: kScreen_width - 90 - 100, height: 20)
        name_layer?.font = fontName as CFTypeRef
        name_layer?.string = "微信团队"
        name_layer?.fontSize = 16
        name_layer?.foregroundColor = UIColor.black.cgColor
        name_layer?.contentsScale = UIScreen.main.scale
        contentView.layer.addSublayer(name_layer!)
        
        time_layer = CATextLayer()
        time_layer?.frame = CGRect(x: kScreen_width - 130, y: 10, width: 120, height: 14)
        time_layer?.font = "HiraKakuProN-W3" as CFTypeRef
        time_layer?.string = "下午10:30"
        time_layer?.fontSize = 12
        time_layer?.alignmentMode = CATextLayerAlignmentMode(rawValue: "right")
        time_layer?.foregroundColor = UIColor.gray.cgColor
        time_layer?.contentsScale = UIScreen.main.scale
        contentView.layer.addSublayer(time_layer!)
        
        content_layer = CATextLayer()
        content_layer?.frame = CGRect(x: 80, y: 40, width: kScreen_width - 80 - 10, height: 20)
        content_layer?.font = "HiraKakuProN-W3" as CFTypeRef
        content_layer?.string = "天刀同人秀: 长假马上就要过去啦,进来查看更多长假信息"
        content_layer?.fontSize = 14
        content_layer?.foregroundColor = UIColor.gray.cgColor
        content_layer?.contentsScale = UIScreen.main.scale
        content_layer?.truncationMode = CATextLayerTruncationMode.end
        contentView.layer.addSublayer(content_layer!)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
