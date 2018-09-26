//
//  NetworkConnectStatusView.swift
//  WeChat
//
//  Created by ysq on 2018/9/26.
//  Copyright © 2018 ysq. All rights reserved.
//

import UIKit
import Reachability

class NetworkConnectStatusView: UIView {

    private var indicatorView: UIActivityIndicatorView!
    
    private var status: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    private func setupSubviews() {
        
        status = UILabel(frame: CGRect(x: (width - 80) / 2, y: 0, width: 80, height: height))
        status.textColor = UIColor.white
        status.font = UIFont.boldSystemFont(ofSize: 16)
        status.textAlignment = .center
        addSubview(status)
        
        indicatorView = UIActivityIndicatorView()
        indicatorView.frame = CGRect(x: status.minX - 20, y: (height - 20) / 2, width: 20, height: 20)
        indicatorView.tintColor = UIColor.white
        addSubview(indicatorView)
    }
    
    public func updateStatus(connectStatus: IMSocketConnectionStatus) {
        switch connectStatus {
        case .connecting:
            indicatorView.isHidden = false
            indicatorView.startAnimating()
            status.text = "连接中..."
            
        case .connectFailure:
            indicatorView.stopAnimating()
            status.text = "未连接"
        case .connectSuccess:
            indicatorView.stopAnimating()
            status.text = "微信(10)"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
