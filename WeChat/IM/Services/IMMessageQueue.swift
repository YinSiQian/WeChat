//
//  IMMessageQueue.swift
//  WeChat
//
//  Created by ysq on 2018/9/10.
//  Copyright © 2018年 ysq. All rights reserved.
//

import Foundation

protocol LinkList {
    
    associatedtype T
    
    var elements: [T] {get set}
    
    mutating func push(element: T)
    
    func pop()
    
    subscript(index: Int) -> T { get }
}

extension LinkList {
    
    mutating func push(element: T) {
        elements.append(element)
    }
    
    func pop() {
       let _ = elements.dropFirst()
    }
    
    subscript(index: Int) -> T {
        return elements[index]
    }
    
}

struct IMMessageQueue: LinkList {
    
    typealias T = IMMessageModel
    
    var elements: [IMMessageModel] = []
    
    
    
}
