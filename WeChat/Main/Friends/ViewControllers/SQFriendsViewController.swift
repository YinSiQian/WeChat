//
//  SQFriendsViewController.swift
//  WeChat
//
//  Created by ysq on 2017/9/18.
//  Copyright © 2017年 ysq. All rights reserved.
//

import UIKit

class SQFriendsViewController: UIViewController {
    
    var tableView: UITableView?
    
    var searchVC: UISearchController?
    
    var modelArr: [FriendModels] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        loadData()
    }
    
    fileprivate func setupSubviews() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.tableFooterView = UIView()
        view.addSubview(tableView!)
        tableView?.register(UINib(nibName: "FriendCell", bundle: Bundle.main), forCellReuseIdentifier: "FriendCell")
    
        let searchResultVC = SQSearchResultViewController()
        searchResultVC.view.backgroundColor = UIColor.red
        searchVC = UISearchController(searchResultsController: searchResultVC)
        searchVC?.searchResultsUpdater = (searchResultVC as UISearchResultsUpdating)
        searchVC?.hidesNavigationBarDuringPresentation = true
        searchVC?.delegate = self
        tableView?.tableHeaderView = searchVC?.searchBar
    
        let bar = searchVC?.searchBar
        if #available(iOS 11, *) {
            bar?.heightAnchor.constraint(equalToConstant: 44)
        }
        bar?.barStyle = .default
        bar?.tintColor = UIColor.orange
        bar?.barTintColor = UIColor (red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
    
        bar?.delegate = self as? UISearchBarDelegate
        bar?.setBackgroundImage(#imageLiteral(resourceName: "searbar_bg"), for: .any, barMetrics: .default)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "contact_barItem_addFriend"), style: .plain, target: self, action: #selector(SQFriendsViewController.addFriend))
    }
    
    // MARK: -- load Data
    
    private func loadData() {
        NetworkManager.request(targetType: FriendsAPI.friendList) { [weak self] (result, error) in
            if !result.isEmpty {
                let arr = result["data"] as! [[String: Any]]
                self?.modelArr = try! FriendModels.mapToArr(data: arr, type: Array<FriendModels>.self)
                self?.tableView?.reloadData()
            }
            print(result)
        }
    }

    @objc private func addFriend() {
        let add = AddFriendViewController()
        navigationController?.pushViewController(add, animated: true)
    }
}

extension SQFriendsViewController: UISearchControllerDelegate {
    
    func didPresentSearchController(_ searchController: UISearchController) {
        self.tabBarController?.tabBar.isHidden = true
        self.searchVC?.isActive = true
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        self.searchVC?.isActive = false
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        self.tabBarController?.tabBar.isHidden = false
    }
}

extension SQFriendsViewController: UITableViewDataSource, UITableViewDelegate {
    
//    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        return ["A", "B", "C", "D", "E", "F", "G", "H", "J", "K", "L","M", "N", "P",
//                "Q", "R", "S", "T", "W", "X", "Y", "Z"]
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return modelArr.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section == 0 else {
            return modelArr[section - 1].users.count
        }
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: kScreen_width, height: 20))
        title.backgroundColor = #colorLiteral(red: 0.93985601, green: 1, blue: 0.9281028662, alpha: 0.956442637)
        title.text = "    " + modelArr[section - 1].firstLetter
        title.font = UIFont.systemFont(ofSize: 14)
        title.textColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        return title
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 44: 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
        if indexPath.section == 0 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
                
            }
            let names = ["新的朋友", "群聊", "标签", "公众号"]
            let images = [#imageLiteral(resourceName: "contact_newFriend"), #imageLiteral(resourceName: "contact_addFriend"), #imageLiteral(resourceName: "contact_tag"), #imageLiteral(resourceName: "contact_public")]
            cell?.textLabel?.text = names[indexPath.row]
            cell?.imageView?.image = images[indexPath.row]
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
            return cell!

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendCell
            let user = modelArr[indexPath.section - 1].users[indexPath.row]
            cell.setData(name: user.username, url: user.icon)
            return cell
        }
    }
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section > 0 {
            let model = modelArr[indexPath.section - 1].users[indexPath.row]
            let info = UserInfoViewController()
            info.model = model
            navigationController?.pushViewController(info, animated: true)
        }
    }
}

