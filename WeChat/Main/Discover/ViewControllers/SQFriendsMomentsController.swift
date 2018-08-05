//
//  SQFriendsMomentsController.swift
//  WeChat
//
//  Created by ysq on 2017/10/7.
//  Copyright © 2017年 ysq. All rights reserved.
//

import UIKit

class SQFriendsMomentsController: UITableViewController {
    
    private var layouts: [TimelineLayoutService] = []
    
    private var urlJson: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        self.title = "朋友圈"
        tableView.tableFooterView = UIView()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "camera")!, style: .plain, target: self, action: #selector(SQFriendsMomentsController.openCamera))
        loadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNavbarTheme(theme: .white)
    }
    
    //MARK: -- Network handler
    
    private func loadData() {
        NetworkManager.request(targetType: TimelineAPIs.list(timestamp: "2018-06-21 16:13:33")) {
            [weak self] (result, error) in
            if !result.isEmpty {
                print(result as Any)
//                let arr = result["list"] as! [[String: Any]]
//                let data = try! MomentModel.mapToArr(data: arr, type: Array<MomentModel>.self)
//                self?.handlerDataAsnyc(data: data)
            }
        }
    }
    
    private func upload(images: [UIImage]) {
        
        NetworkManager.request(targetType: UploadAPIs.upload(images), compection: {
            (result, error) in
            if !result.isEmpty {
                self.urlJson = result["url"] as? String;
                self.postMoment()
            }
        })
    }
    
    private func postMoment() {
        self.urlJson = self.urlJson ?? ""
        NetworkManager.request(targetType: TimelineAPIs.post(content: "因为人脑思考一步的时间，人工智能可以思考无数步并找到最优解。", url: self.urlJson!, location: "春华四季园")) { (result, error) in
            if !result.isEmpty {
                print(result as Any)
            }
        }
    }
    
    private func handlerDataAsnyc(data: Array<MomentModel>) {
        
        DispatchQueue.global().async {
            for element in data {
                let layout = TimelineLayoutService(timelineModel: element)
                self.layouts.append(layout)
            }
            
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
            })
        }
        
    }
    
    @objc private func openCamera() {
        
        SystemPhotoService.shard.open(sourceController: self, type: UIImagePickerControllerSourceType.photoLibrary) {
            [weak self]  (image) in
            
            if !image.isEmpty {
                self?.upload(images: image)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return layouts.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return layouts[indexPath.row].height
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FriendMomentCell.cell(with: tableView)
        cell.layout = layouts[indexPath.row]
        return cell
    }
    
}
