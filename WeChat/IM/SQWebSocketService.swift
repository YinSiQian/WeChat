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
    
    static let sharedInstance = SQWebSocketService()
    
    private var webSocket: WebSocket!
    
    private init() { setupSocket() }
    
    private func setupSocket() {
        var request = URLRequest(url: URL(string: "ws://localhost:8080/webSocket")!)
        request.timeoutInterval = 5
        request.addValue(UserModel.sharedInstance.accessToken, forHTTPHeaderField: "accessToken")
        request.addValue(UserModel.sharedInstance.id.StringValue, forHTTPHeaderField: "userId")
        webSocket = WebSocket(request: request)
        webSocket.delegate = self
    }
}

extension SQWebSocketService {
    
    public func connectionServer() {
        webSocket.connect()
    }
    
    public func disconnection() {
        webSocket.disconnect()
    }
    
    public func sendMsg(msg: String) {
        webSocket.write(string: msg)
    }
    
}

extension SQWebSocketService: WebSocketDelegate {
    
    public func websocketDidConnect(socket: WebSocketClient) {
        print("connected to server")
    }
    
    public func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("it is disconnect")
        print(error as Any)
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
            webSocket.write(string: msg.convertToString())
        default:
            print("default")
        }
        let alter = UIAlertView.init(title: "提示", message: text, delegate: nil, cancelButtonTitle: "sure")
        alter.show()
    }
    
    public func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
    }
    
    
}
