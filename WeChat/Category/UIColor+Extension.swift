//
//  UIColor+Extension.swift
//  WeChat
//
//  Created by ysq on 2017/9/26.
//  Copyright © 2017年 ysq. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    public convenience init(hex6: UInt32, alpha: CGFloat = 1) {
        let divisor = CGFloat(255)
        let red     = CGFloat((hex6 & 0xFF0000) >> 16) / divisor
        let green   = CGFloat((hex6 & 0x00FF00) >>  8) / divisor
        let blue    = CGFloat( hex6 & 0x0000FF       ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    
}

