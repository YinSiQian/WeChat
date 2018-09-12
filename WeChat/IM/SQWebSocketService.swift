//
//  SQWebSocketService.swift
//  WeChat
//
//  Created by ysq on 2018/7/28.
//  Copyright © 2018年 ysq. All rights reserved.
//

import Foundation
import Starscream

protocol SQWebSocketServiceDelegate: class {
    
    func webSocketService(received msg: String)
    
    func webSocketServiceDidDisconnect(socket: WebSocketClient, error: Error?)
    
    func webSocketServiceDidConnect(socket: WebSocketClient)
}

public class SQWebSocketService {
    
    public typealias connectionSuccessHandler = () -> Void
    
    public typealias connectionErrorHandler = (_ error: Error?) -> Void
    
    static let sharedInstance = SQWebSocketService()
    
    public var handler: connectionSuccessHandler!
    
    public var errorHandler: connectionErrorHandler!
    
    weak var delegate: SQWebSocketServiceDelegate?
    
    public var isConnection: Bool {
        return webSocket.isConnected
    }
    
    private var webSocket: WebSocket!
    
    private init() { setupSocket() }
    
    private func setupSocket() {
        var request = URLRequest(url: URL(string: "ws://120.79.10.111:8080/api/webSocket")!)
        request.timeoutInterval = 5
        request.addValue(UserModel.sharedInstance.accessToken, forHTTPHeaderField: "accessToken")
        request.addValue(UserModel.sharedInstance.id.StringValue, forHTTPHeaderField: "userId")
        webSocket = WebSocket(request: request)
        webSocket.delegate = self
    }
}

extension SQWebSocketService {
    
    public func connectionServer(complectionHanlder: (() -> ())? = nil,
                                 errorHanlder: ((_ error: Error?) -> ())? = nil) {
        if let complection = complectionHanlder {
            handler = complection
        }
        if let errorHandle = errorHanlder {
            errorHandler = errorHandle
        }
        webSocket.connect()
    }
    
    public func disconnection() {
        if webSocket.isConnected {
            webSocket.disconnect()
        }
    }
    
    public func sendMsg(msg: String) {
        if webSocket.isConnected {
            webSocket.write(string: msg) {
                print("send success")
            }
        }
    }
    
}

extension SQWebSocketService: WebSocketDelegate {
    
    public func websocketDidConnect(socket: WebSocketClient) {
        print("connected to server")
        handler?()
        delegate?.webSocketServiceDidConnect(socket: socket)
    }
    
    public func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("it is disconnect")
        print(error as Any)
        errorHandler?(error)
        delegate?.webSocketServiceDidDisconnect(socket: socket, error: error)
    }
    
    public func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        delegate?.webSocketService(received: text)
    }
    
    public func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
    }
    
    
}
