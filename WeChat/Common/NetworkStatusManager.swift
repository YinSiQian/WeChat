//
//  NetworkStatusManager.swift
//  WeChat
//
//  Created by ysq on 2018/9/21.
//  Copyright © 2018年 ysq. All rights reserved.
//

import Foundation
import Reachability

class NetworkStatusManager {
    
    typealias networkStatusChanged = (_ status: Reachability.Connection) -> ()
    
    public var networkStatusChangedHandle: networkStatusChanged? = nil
    
    static let shared = NetworkStatusManager()
    
    private(set) var isConnectNetwork: Bool = false
    
    private let reachability = Reachability()!
    
    var connectionStatus: Reachability.Connection {
        return reachability.connection
    }
    
    private init() {}
    
}

extension NetworkStatusManager {
    
    public func startCheckNetworkStatusChanged() {
        
        reachability.whenReachable = { [weak self] reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
            self?.networkStatusChangedHandle?(reachability.connection)
            self?.isConnectNetwork = true
        }
        reachability.whenUnreachable = { [weak self]  _ in
            print("Not reachable")
            self?.isConnectNetwork = false
            self?.networkStatusChangedHandle?(.none)
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
}
