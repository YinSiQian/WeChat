//
//  UINavigationController+Extension.swift
//  WeChat
//
//  Created by ysq on 2018/8/5.
//  Copyright © 2018年 ysq. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    
    func setNavbar(alpha: CGFloat) {
        
        let barBackgroundView = self.navigationBar.subviews.first
        let backgroundImageView = barBackgroundView?.subviews.first as? UIImageView
        if self.navigationBar.isTranslucent {
            if backgroundImageView != nil && backgroundImageView?.image != nil {
                barBackgroundView?.alpha = alpha
            } else {
                let effectView = barBackgroundView?.subviews[1]
                effectView?.alpha = alpha
            }
        } else {
            barBackgroundView?.alpha = alpha
        }
        self.navigationBar.clipsToBounds = alpha == 0.0
    }
    
}
