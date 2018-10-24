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
    
    func webSocketService(received msg: [String: Any])
    
    func webSocketServiceDidDisconnect(socket: WebSocketClient, error: Error?)
    
    func webSocketServiceDidConnect(socket: WebSocketClient)
}

public class SQWebSocketService {
    
    public typealias connectionSuccessHandler = () -> ()
    
    public typealias connectionErrorHandler = (_ error: Error?) -> ()
    
    public typealias conncetionStatusChanged = (_ status: IMSocketConnectionStatus) -> ()
    
    static let sharedInstance = SQWebSocketService()
    
    public var handler: connectionSuccessHandler!
    
    public var errorHandler: connectionErrorHandler!
    
    public var statusChangedHandle: conncetionStatusChanged!
    
    weak var delegate: SQWebSocketServiceDelegate?
    
    private var numberOfReconnect: Int = 0
    
    public var isConnection: Bool {
        return webSocket.isConnected
    }
    
    private var webSocket: WebSocket!
    
    private init() {}
    
   
}

extension SQWebSocketService {
    
    public func setupSocket(accessId: String, accessToken: String) {
//        120.79.10.111:8080/api
        var request = URLRequest(url: URL(string: "ws://112.74.162.15:8090/webSocket")!)
        request.timeoutInterval = 5
        request.addValue(accessToken, forHTTPHeaderField: "accessToken")
        request.addValue(accessId, forHTTPHeaderField: "userId")
        webSocket = WebSocket(request: request)
        webSocket.delegate = self
    }
    
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
    
    /// 断线后重连 // 每两秒尝试一次
    private func tryToReconnection() {
        if numberOfReconnect > 10 {
            statusChangedHandle?(.connectFailure)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
                self.numberOfReconnect = 0;
            }
        } else {
            statusChangedHandle?(.connecting)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                if self.webSocket.isConnected {
                    return
                } else {
                    self.numberOfReconnect += 1
                    self.webSocket.connect()
                    self.tryToReconnection()
                }
            }
        }
    }
    
}

extension SQWebSocketService: WebSocketDelegate {
    
    public func websocketDidConnect(socket: WebSocketClient) {
        print("connected to server")
        statusChangedHandle?(.connectSuccess)
        numberOfReconnect = 0
        handler?()
        delegate?.webSocketServiceDidConnect(socket: socket)
    }
    
    public func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("it is disconnect")
        print("error \(String(describing: error?.localizedDescription))")
        errorHandler?(error)
        delegate?.webSocketServiceDidDisconnect(socket: socket, error: error)
        if numberOfReconnect == 0 {
            if UserModel.sharedInstance.isLogin {
                tryToReconnection()
            }
        }
    }
    
    public func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        let dict = text.convertToDict()
        let status = dict["status"] as? Int ?? 0
        switch status {
        case 5010:
            //当前账号在其他设备上登录
            Helper.show(message: "当前账号已在其他设备上登录")
            
        default:
            break
        }
        delegate?.webSocketService(received: dict)
    }
    
    public func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
    }
    
    
}
