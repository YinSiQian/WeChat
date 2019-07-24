//
//  SQMineViewController.swift
//  WeChat
//
//  Created by ysq on 2017/9/18.
//  Copyright © 2017年 ysq. All rights reserved.
//

import UIKit

class SQMineViewController: UIViewController {

    var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUserInfo()
        loadNavbarTheme()
    }
    
   

    fileprivate func setupSubviews() {
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView?.delegate = self
        tableView?.dataSource = self
        view.addSubview(tableView!)
        tableView?.register(UINib.init(nibName: "SQMineUserInfoCell", bundle: nil), forCellReuseIdentifier: "SQMineUserInfoCell")
    }
    
    private func loadUserInfo() {
        
        NetworkManager.request(targetType: UserAPI.userInfo) {
            (result, error) in
            if !result.isEmpty {
                let data = result["user"];
                UserModel.sharedInstance.initial(data: data as! [String : Any])
                UserModel.sharedInstance.syncUserInfo()
                self.tableView?.reloadData()
            }
        }
    }

}

extension SQMineViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 12
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 || section == 1 || section == 3 ? 1: 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 80 : 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SQMineUserInfoCell", for: indexPath) as! SQMineUserInfoCell
            cell.accessoryType = .disclosureIndicator
            cell.updateInfo()
            return cell
        }
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell?.accessoryType = .disclosureIndicator
        }
        let names = [[""], ["钱包"], ["收藏", "相册", "卡包"], ["设置"]]
        let images = [[], [#imageLiteral(resourceName: "home_money")], [#imageLiteral(resourceName: "home_favorite"), #imageLiteral(resourceName: "home_photo"), #imageLiteral(resourceName: "home_card")], [#imageLiteral(resourceName: "home_setting")]]
        cell?.textLabel?.font = UIFont(name: "Helvetica Bold", size: 14)
        cell?.textLabel?.text = names[indexPath.section][indexPath.row]
        cell?.imageView?.image = images[indexPath.section][indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 3 {
            let setting = MineSettingViewController()
            navigationController?.pushViewController(setting, animated: true)
        }
    }
    
    
}
