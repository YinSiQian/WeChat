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

class OperationModel: NSObject {
    
    public var isCancel: Bool = false
    
    private var timer: Timer!
    
    private var timeout = 0.0
    
    public var timeoutComplection: ((_ queue: IMMessageQueue) -> ())?
    
    public var retryTimes = 0
    
    public override init() {
        super.init()
        isCancel = false
    }
    
    /// 每五秒钟 进行一次消息重发
    @objc private func calculateIsTimeount() {
        DispatchQueue.global().async {
//            print("thread--->\(Thread.current)")
            if self.isCancel {
                self.timer?.invalidate()
                self.timer = nil
                return
            }
            self.timeout += 1
            if self.timeout >= 5.0 {
                self.timeout = 0.0
                self.retryTimes += 1
                print("消息重发")
                self.timer?.invalidate()
                self.timer = nil
                DispatchQueue.main.async(execute: {
                    self.timeoutComplection?(IMMessageQueue.shared)
                })
                return
            }
        }
    }
    
    public func start() {
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(OperationModel.calculateIsTimeount), userInfo: nil, repeats: true)
        RunLoop.main.add(self.timer, forMode: .common)
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
}

struct IMMessageQueue {
    
    typealias sendMsgTimeoutHandle = (_ drop: Bool, _ index: Int?) -> ()
    
    public var timeoutHandle: sendMsgTimeoutHandle?
    
    private var ops = [OperationModel]()
    
    var elements = [T]()
    
    static var shared = IMMessageQueue()
    
    private init() {}
    
}

extension IMMessageQueue: LinkList {
    
    typealias T = IMMessageModel

    mutating func push(element: T) {
        elements.append(element)
        start(index: elements.count - 1)
    }
    
    func pop() {
        let _ = elements.dropFirst()
    }
    
    public func indexForMessage(seq: String) -> Int? {
        for (index, element) in elements.enumerated() {
            if element.msg_seq == seq {
                return index
            }
        }
        return nil
    }
    
    var count: Int {
        return elements.count
    }
    
    subscript(index: Int) -> IMMessageModel {
        return elements[index]
    }
    
    mutating func removed(at index: Int) {
        elements.remove(at: index)
        ops[index].isCancel = true
        ops.remove(at: index)
    }
    
    private mutating func start(index: Int) {
       
        let seq = elements[index].msg_seq
        let opModel = OperationModel()
        opModel.timeoutComplection = { (queue) in
//            print("times---\(opModel.retryTimes)")
//            print("is drop---\(opModel.retryTimes == 3)")
//            print("handle---\(String(describing: queue.timeoutHandle))")
            let currentIndex = queue.indexForMessage(seq: seq)
            queue.timeoutHandle?(opModel.retryTimes == 3, currentIndex)
            if opModel.retryTimes < 3 {
                opModel.start()
            }
        }
        opModel.start()
        ops.append(opModel)
    }
    
    
    
}
