//
//  UIView+Extension.swift
//  WeChat
//
//  Created by ABJ on 2018/8/3.
//  Copyright © 2018年 ysq. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    var maxY: CGFloat {
        return self.frame.origin.y + self.frame.size.height
    }
    
    var maxX: CGFloat {
        return self.frame.origin.x + self.frame.size.width
    }
    
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            var _frame = self.frame
            _frame.size.height = newValue
            self.frame = _frame
        }
    }
    
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            var _frame = self.frame
            _frame.size.width = newValue
            self.frame = _frame
        }
    }
    
    var minX: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var _frame = self.frame
            _frame.origin.x = newValue
            self.frame = _frame
        }
    }
    
    var minY: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var _frame = self.frame
            _frame.origin.y = newValue
            self.frame = _frame
        }
    }
    
    
}
