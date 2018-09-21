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
    
    static let shared = NetworkStatusManager()
    
    private(set) var isConnectNetwork: Bool = true
        
    
    private init() {}
    
}

extension NetworkStatusManager {
    
    public func startCheckNetworkStatusChanged() {
        
        let reachability = Reachability()!
        reachability.whenReachable = { [weak self] reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
            self?.isConnectNetwork = true
        }
        reachability.whenUnreachable = { [weak self]  _ in
            print("Not reachable")
            self?.isConnectNetwork = false
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
}
