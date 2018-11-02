//
//  File.swift
//  WeChat
//
//  Created by ysq on 2017/10/7.
//  Copyright © 2017年 ysq. All rights reserved.
//

import Foundation
import UIKit

// 1 表示测试 0表示正式环境
let TEST = 1

let host = TEST == 1 ? "localhost" : "112.74.162.15"

let port = 8090

let kScreen_width = UIScreen.main.bounds.size.width

let kScreen_height = UIScreen.main.bounds.size.height

//112.74.162.15 120.79.10.111
let baseUrl = URL(string: "http://112.74.162.15:8090/")!

let testHostUrl = URL(string: "http://localhost:8080/")!

let kNetworkStatusChanged = Notification.Name(rawValue: "kNetworkStatusChanged")

let kViewBackgroudColor = UIColor(red:0.94, green:0.95, blue:0.95, alpha:1.00)

let server_url = "http://" + host + ":\(port)/"
