//
//  String+Extension.swift
//  WeChat
//
//  Created by ysq on 2018/7/29.
//  Copyright © 2018年 ysq. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    var md5 : String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen);
        
        CC_MD5(str!, strLen, result);
        
        let hash = NSMutableString();
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i]);
        }
        result.deinitialize(count: digestLen);
        
        return String(format: hash as String)
    }
    
    public func url() -> URL? {
        
        if let url = URL(string: self) {
            return url
        }
        return URL(string: "")
    }
    
    public func convertToDict() -> [String: Any]{
        let data = self.data(using: .utf8)
        let json = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any]
        return json ?? [:]
    }
    
    public func calculate(font: UIFont, size: CGSize) -> CGSize {
        let size = (self as NSString).boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil).size
        return size
    }
    
}
