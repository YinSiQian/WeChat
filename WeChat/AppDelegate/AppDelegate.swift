//
//  AppDelegate.swift
//  WeChat
//
//  Created by ysq on 2017/9/10.
//  Copyright © 2017年 ysq. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var currentAppDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var root: UIViewController? {
        return currentAppDelegate.window?.rootViewController
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NetworkStatusManager.shared.startCheckNetworkStatusChanged()
        setupRealmConfig()
        setupRootVC()
        
        if #available(iOS 11, *) {
            UITableView.appearance().estimatedRowHeight = 0
            UITableView.appearance().estimatedSectionHeaderHeight = 0
            UITableView.appearance().estimatedSectionFooterHeight = 0
        }
        return true
    }
    
    private func setupRootVC() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        if UserModel.sharedInstance.accessToken == "" {
            window?.rootViewController = SQLoginViewController()
        } else {
            window?.rootViewController = SQRootViewController()
        }
        window?.makeKeyAndVisible()
    }
    
    private func setupRealmConfig() {
        
        var realmConfig = Realm.Configuration (
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 3) {
                    // The renaming operation should be done outside of calls to `enumerateObjects(ofType: _:)`.
                    //                    migration.renameProperty(onType: Person.className(), from: "yearsSinceBirth", to: "age")
                }
        })
        realmConfig.fileURL = realmConfig.fileURL!.deletingLastPathComponent().appendingPathComponent("\(UserModel.sharedInstance.username.md5).realm")
        print("url ---> \(String(describing: realmConfig.fileURL))")
        
        Realm.Configuration.defaultConfiguration = realmConfig
            
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        if SQWebSocketService.sharedInstance.isConnection {
            //App进入后台 告知服务器当前用户已下线.走推送流程.
//            SQWebSocketService.sharedInstance.sendMsg(msg: "已下线")
        }
        print(#function)

    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print(#function)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        if !SQWebSocketService.sharedInstance.isConnection {
            SQWebSocketService.sharedInstance.connectionServer()
        }
        print(#function)

    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print(#function)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    public static func currentAppdelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }


}

