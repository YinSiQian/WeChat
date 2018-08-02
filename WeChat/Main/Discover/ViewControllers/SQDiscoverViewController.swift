//
//  SQDiscoverViewController.swift
//  WeChat
//
//  Created by ysq on 2017/9/18.
//  Copyright © 2017年 ysq. All rights reserved.
//

import UIKit

class SQDiscoverViewController: UIViewController {

    var tableView: UITableView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        // Do any additional setup after loading the view.
    }
    
    fileprivate func setupSubviews() {
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView?.delegate = self
        tableView?.dataSource = self
        view.addSubview(tableView!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNavbarTheme()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension SQDiscoverViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
            cell?.accessoryType = .disclosureIndicator
        }
        let names = [["朋友圈"],["扫一扫", "摇一摇"],["看一看", "搜一搜"],["附近的人","游戏"],["小程序"]]
        let images = [[#imageLiteral(resourceName: "discover_friend")],[#imageLiteral(resourceName: "discover_scan"), #imageLiteral(resourceName: "discover_shake")], [#imageLiteral(resourceName: "discover_see"), #imageLiteral(resourceName: "discover_search")], [#imageLiteral(resourceName: "discover_nearly"), #imageLiteral(resourceName: "discover_game")], [#imageLiteral(resourceName: "discover_weApp")]]
        cell?.textLabel?.font = UIFont(name: "Helvetica Bold", size: 14)
        cell?.textLabel?.text = names[indexPath.section][indexPath.row]
        cell?.imageView?.image = images[indexPath.section][indexPath.row]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 || section == 4 ? 1 : 2;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            let moments = SQFriendsMomentsController()
            self.navigationController?.pushViewController(moments, animated: true)
        
        default:
            print("this is default choose")
        }
  
    }
    
    
    
}
