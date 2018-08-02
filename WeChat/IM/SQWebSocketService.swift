//
//  SQWebSocketService.swift
//  WeChat
//
//  Created by ysq on 2018/7/28.
//  Copyright © 2018年 ysq. All rights reserved.
//

import Foundation
import Starscream

public class SQWebSocketService {
    
    public typealias connectionSuccessHandler = () -> Void
    
    public typealias connectionErrorHandler = (_ error: Error?) -> Void
    
    static let sharedInstance = SQWebSocketService()
    
    public var handler: connectionSuccessHandler!
    
    public var errorHandler: connectionErrorHandler!
    
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
    
    public func connectionServer(complectionHanlder: @escaping () -> Void,
                                 errorHanlder: @escaping (_ error: Error?) -> Void) {
        handler = complectionHanlder
        errorHandler = errorHanlder
        webSocket.connect()
    }
    
    public func disconnection() {
        if webSocket.isConnected {
            webSocket.disconnect()
        }
    }
    
    public func sendMsg(msg: String) {
        if webSocket.isConnected {
            webSocket.write(string: msg)
        }
    }
    
}

extension SQWebSocketService: WebSocketDelegate {
    
    public func websocketDidConnect(socket: WebSocketClient) {
        print("connected to server")
        handler?()
    }
    
    public func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("it is disconnect")
        print(error as Any)
        errorHandler?(error)
    }
    
    public func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        let dict = text.convertToDict()
        let status = dict["status"] as! Int
        switch status {
        case 6000:
            //消息发送成功
            print("消息发送成功: \(text)")
        case 6002:
            //服务器收到生产者的消息 服务器ACK
            print("server ack: \(text)")
        case 6003:
           //服务器收到消费者的ack
            print("server ack to consumers: \(text)")
        case 6004:
            //服务器转发消息给消费者
            print("server send msg to consumers: \(text)")
            let msg_seq = dict["msg_seq"] as! String
            let msg: [String: Any] = ["status": 6003, "msg_seq": msg_seq]
            webSocket.write(string: msg.convertToString()!)
        default:
            print("default")
        }
        let alter = UIAlertView.init(title: "提示", message: text, delegate: nil, cancelButtonTitle: "sure")
        alter.show()
    }
    
    public func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
    }
    
    
}
