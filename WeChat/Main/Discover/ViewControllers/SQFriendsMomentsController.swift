//
//  SQFriendsMomentsController.swift
//  WeChat
//
//  Created by ysq on 2017/10/7.
//  Copyright © 2017年 ysq. All rights reserved.
//

import UIKit

class SQFriendsMomentsController: UITableViewController {

    private var momentArr: [MomentModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "朋友圈"
  
        tableView.tableFooterView = UIView()
        
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNavbarTheme(theme: .white)
    }
    
    private func loadData() {
        NetworkManager.request(targetType: TimelineAPIs.list(timestamp: "2018-06-21 16:13:33")) {
            [weak self] (result, error) in
            if !result.isEmpty {
                let arr = result["list"] as! [[String: Any]]
                self?.momentArr = try! MomentModel.mapToArr(data: arr, type: Array<MomentModel>.self)
                print(self?.momentArr as Any)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "reuseIdentifier")
        }
        // Configure the cell...

        cell?.textLabel?.text = "index-->\(indexPath.row)"
        return cell!
    }
    
}
