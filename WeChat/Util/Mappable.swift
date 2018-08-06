//
//  Mappable.swift
//  WeChat
//
//  Created by ysq on 2018/8/2.
//  Copyright © 2018年 ysq. All rights reserved.
//

import Foundation

enum CustomMapError: Error {
    case mapToModelError
    case mapToArrModelError
    case dictConverToStringError
}

protocol Mappable: Codable {
    
}

extension Mappable {
    
   public static func mapToModel<T: Mappable>(data: [String: Any], type: T.Type) throws -> T {
        
        guard let json = data.convertToString() else {
            print("dictConverToStringError")
            throw CustomMapError.dictConverToStringError
        }
        let jsonData = json.data(using: .utf8)
        let decoder = JSONDecoder()
        
        if let value = try? decoder.decode(type, from: jsonData!) {
            return value
        }
        print("dictConverToStringError")
        throw CustomMapError.dictConverToStringError
    }
    
    public static func mapToArr<T: Mappable>(data: [[String: Any]], type: [T].Type) throws -> [T] {
        guard let arrData = try? JSONSerialization.data(withJSONObject: data, options: JSONSerialization.WritingOptions.prettyPrinted)  else {
            throw CustomMapError.mapToArrModelError
        }
        guard let jsonString = String(data: arrData, encoding: .utf8) else {
            throw CustomMapError.mapToArrModelError
        }
        let jsonData = jsonString.data(using: .utf8)
        let decoder = JSONDecoder()
        
        if let value = try? decoder.decode(type, from: jsonData!) {
            return value
        }
        throw CustomMapError.mapToArrModelError
        
    }
}
