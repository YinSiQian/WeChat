//
//  SQCache.swift
//  WeChat
//
//  Created by ysq on 2018/9/12.
//  Copyright © 2018年 ysq. All rights reserved.
//

import Foundation
import RealmSwift

public enum CacheError: Error {
    case cacheClassTypeError
    case noCache
}

class SQCache: NSObject {
    
    public static let shared = SQCache()
    
    private var dataCache = NSCache<NSString, AnyObject>()
    
    private override init() {
        
    }
    
    public static func messageInfo(with chatId: Int, page: Int) -> [IMMessageModel] {
        print("realm query message page \(page)")
        let rows = 20
        var offset = 0
        var endOffset = 0
        var models: [IMMessageModel] = []
        do {
            let realm = try Realm()
            let results = realm.objects(IMMessageModel.self).filter("(sender_id = \(chatId) AND received_id = \(UserModel.sharedInstance.id)) OR (sender_id = \(UserModel.sharedInstance.id) AND received_id = \(chatId)) AND group_id = 1").sorted(byKeyPath: "msg_id", ascending: true)
            if results.count <= rows {
                return models
            } else {
                let currentCount = page * rows
                if currentCount >= results.count {
                    return []
                } else {
                    offset = results.count - (page + 1) * rows - 1
                    endOffset = offset + rows
                    for index in offset..<endOffset {
                        models.append(results[index])
                    }
                    return models
                }
            }
        } catch let error as NSError {
            print("realm query error \(error.localizedDescription)")
        }
        return []
    }
    
    public static func saveMessageInfo(with model: IMMessageModel) {
        print("save message")
        
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(model)
            }
        } catch let error as NSError {
            print("realm insert error \(error.localizedDescription)")
        }
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
