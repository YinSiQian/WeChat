//
//  SQCache.swift
//  WeChat
//
//  Created by ysq on 2018/9/12.
//  Copyright © 2018年 ysq. All rights reserved.
//

import Foundation

public enum CacheError: Error {
    case cacheClassTypeError
    case noCache
}

class SQCache: NSObject {
    
    public static let shared = SQCache()
    
    private var dataCache = NSCache<NSString, AnyObject>()
    
    private override init() {
        
    }
    
}

extension SQCache {
    
    public func setCache(key: NSString, value: AnyObject) {
        dataCache.setObject(value, forKey: key)
    }
    
    public func getCache<T: AnyObject>(key: NSString, type: T.Type) throws -> T {
        if let value = dataCache.object(forKey: key) {
            if value is T {
                return value as! T
            } else {
                throw CacheError.cacheClassTypeError
            }
        }
        throw CacheError.noCache
    }
    
    public func getCacheList<T: AnyObject>(key: NSString, type: [T].Type) throws -> [T] {
        // TODO: data 转 JSON 再转 Model
        if let value = dataCache.object(forKey: key) {
            if value is Array<T> {
                return value as! [T]
            } else {
                throw CacheError.cacheClassTypeError
            }
        }
        throw CacheError.noCache
    }
    
}
