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
    
    mutating func push(element: T)
    
    var count: Int { get }
    
    func pop()
    
    subscript(index: Int) -> T { get }
    
    mutating func removed(at index: Int)
}


struct IMMessageQueue {
    
    var elements = [T]()
    
    static var shared = IMMessageQueue()
    
    private init() {}
    
}

extension IMMessageQueue: LinkList {
    
    typealias T = IMMessageModel

    mutating func push(element: T) {
        elements.append(element)
    }
    
    func pop() {
        let _ = elements.dropFirst()
    }
    
    public func indexForMessage(seq: String) -> Int {
        for (index, element) in elements.enumerated() {
            if element.msg_seq == seq {
                return index
            }
        }
        return -1
    }
    
    var count: Int {
        return elements.count
    }
    
    subscript(index: Int) -> IMMessageModel {
        return elements[index]
    }
    
    mutating func removed(at index: Int) {
        elements.remove(at: index)
    }
    
}
