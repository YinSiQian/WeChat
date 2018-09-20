//
//  SQRefreshControl.swift
//  WeChat
//
//  Created by ABJ on 2018/9/20.
//  Copyright © 2018年 ysq. All rights reserved.
//

import Foundation

class SQRefreshControl: UIControl {
    
    
    
    private var indicator: UIActivityIndicatorView!

    public let indicatorColor: UIColor? = UIColor.white


    override init(frame: CGRect) {
        indicator = UIActivityIndicatorView(style: .white)
        super.init(frame: frame)
        
        indicator.frame = CGRect(x: (self.width - 10) / 2, y: 0, width: 10, height: 10)
        addSubview(indicator)
        
        addTarget(self, action: #selector(self.valueChanged), for: .valueChanged)
    }
    
    @objc private func valueChanged() {
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
