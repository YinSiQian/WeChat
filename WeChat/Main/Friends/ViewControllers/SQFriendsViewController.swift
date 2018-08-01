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
    
        let searchResultVC = SQSearchResultViewController()
        searchResultVC.view.backgroundColor = UIColor.red
        searchVC = UISearchController(searchResultsController: searchResultVC)
        searchVC?.searchResultsUpdater = (searchResultVC as UISearchResultsUpdating)
//        searchVC?.dimsBackgroundDuringPresentation = false
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
        
        
    }
    
    // MARK: -- load Data
    
    private func loadData() {
        NetworkManager.request(targetType: FriendsAPI.friendList) { [weak self] (result, error) in
            if !result.isEmpty {
                
            }
            print(result)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
//        if tableView == indexTableView {
//            return 1
//        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if tableView == indexTableView {
//            return 22
//        }
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if tableView == indexTableView {
//            return 20
//        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            
        }
        if indexPath.section == 0 {
            let names = ["新的朋友", "群聊", "标签", "公众号"]
            let images = [#imageLiteral(resourceName: "contact_newFriend"), #imageLiteral(resourceName: "contact_addFriend"), #imageLiteral(resourceName: "contact_tag"), #imageLiteral(resourceName: "contact_public")]
            cell?.textLabel?.text = names[indexPath.row]
            cell?.imageView?.image = images[indexPath.row]
        } else {
            
        }
        
        return cell!
    }
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

