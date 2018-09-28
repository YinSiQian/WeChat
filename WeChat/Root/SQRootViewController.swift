//
//  SQRootViewController.swift
//  WeChat
//
//  Created by ysq on 2017/9/10.
//  Copyright © 2017年 ysq. All rights reserved.
//

import UIKit
import RealmSwift
import Reachability

class SQRootViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        setupViewcontrollers()
        setupRealmConfig()
        SQWebSocketService.sharedInstance.delegate = IMDataManager.sharedInstance
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

    
    fileprivate func setupViewcontrollers() {
        
        let messageVC = SQMessageViewController()
        messageVC.title = "消息";
        let messageNav = SQNavigationViewController(rootViewController: messageVC);
        
        let friendVC = SQFriendsViewController()
        friendVC.title = "通讯录";
        let friendNav = SQNavigationViewController(rootViewController: friendVC);
        
        let discoverVC = SQDiscoverViewController()
        discoverVC.title = "发现";
        let discoverNav = SQNavigationViewController(rootViewController: discoverVC);
        
        let mineVC = SQMineViewController()
        mineVC.title = "我";
        let mineNav = SQNavigationViewController(rootViewController: mineVC);
        
        self.viewControllers = [
            messageNav,
            friendNav,
            discoverNav,
            mineNav
        ];
        customize(tabbar: self)
    }
    
    fileprivate func customize(tabbar: UITabBarController) {
        let titles = ["微信", "通讯录", "发现", "我"]
        let images_normal = [#imageLiteral(resourceName: "tabbar_message_normal"), #imageLiteral(resourceName: "tabbar_contacts_normal"), #imageLiteral(resourceName: "tabbar_discover_normal"), #imageLiteral(resourceName: "tabbar_me_normal")]
        let images_selected = [#imageLiteral(resourceName: "tabbar_message_selected"), #imageLiteral(resourceName: "tabbar_contacts_selected"), #imageLiteral(resourceName: "tabbar_discover_selected"), #imageLiteral(resourceName: "tabbar_me_selected")]
        var index = 0
        for item in self.tabBar.items! {
            item.title = titles[index]
            item.selectedImage = images_selected[index].withRenderingMode(.alwaysOriginal)
            item.image = images_normal[index]
            item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(hex6:0x24CF5F, alpha: 1)], for: .selected)
            index += 1
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
