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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "朋友圈"
        tableView.tableFooterView = UIView()
        setNavItem()
        loadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNavbarTheme(theme: .white)
    }
    
    private func setNavItem() {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 27, height: 27))
        btn.setBackgroundImage(UIImage(named: "camera")!, for: .normal)
        btn.addTarget(self, action: #selector(SQFriendsMomentsController.openCamera), for: .touchUpInside)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(SQFriendsMomentsController.postTextMomentInfo))
        longPress.minimumPressDuration = 1
        btn.addGestureRecognizer(longPress)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btn)
    }
    
    //MARK: -- Network handler
    
    private func loadData() {
        NetworkManager.request(targetType: TimelineAPIs.list(timestamp: "2018-06-21 16:13:33")) {
            [weak self] (result, error) in
            if !result.isEmpty {
                print(result as Any)
                let arr = result["list"] as! [[String: Any]]
                let data = try! MomentModel.mapToArr(data: arr, type: Array<MomentModel>.self)
                self?.handlerDataAsnyc(data: data)
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
    
    private func love(id: Int, complection: @escaping (_ success: Bool) -> ()) {
        
        NetworkManager.request(targetType: TimelineAPIs.favorite(momentId: id)) { (result, error) in
            if !result.isEmpty {
                complection(true)
            }
        }
    }
    
    // MARK: -- Events
    
    @objc private func postTextMomentInfo() {
        let edit = MomentEditViewController()        
        self.present(SQNavigationViewController(rootViewController: edit), animated: true, completion: nil)
    }
    
    @objc private func openCamera() {
        
        SystemPhotoService.shard.open(sourceController: self, type: UIImagePickerControllerSourceType.photoLibrary) {
            [weak self]  (image) in
            
            if !image.isEmpty {
                let edit = MomentEditViewController()
                edit.hasImage = true
                edit.images = image
                self?.present(SQNavigationViewController(rootViewController: edit), animated: true, completion: nil)
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
        cell.delegate = self
        cell.layout = layouts[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        getOperationView()?.hide()
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        getOperationView()?.hide()
    }
    
    // MARK: -- Private method
    
    private func getOperationView() -> FriendMomentOpeationView? {
        if  let view = UIApplication.shared.keyWindow?.viewWithTag(12306) as? FriendMomentOpeationView {
            return view
        }
        return nil
    }
    
    deinit {
        print("it is dealloc")
    }
    
}

extension SQFriendsMomentsController: FriendMomentCellDelegate {
    func showInterfaceColumnView(point: CGPoint, indexPath: NSIndexPath) {
        
        if let view = getOperationView() {
            view.hide()
            return
        }
        var layout = self.layouts[indexPath.row]

        let operationView = FriendMomentOpeationView(frame: CGRect(x: 0, y: 0, width: 140, height: 34), point: point) {  [weak self] (type) in
            if type == 1 {
                //点赞
                self?.love(id: layout.timelineModel.momentId, complection: {
                    (success) in
                    self?.getOperationView()?.loved = success
                    layout.isLoved = success
                })
            } else {
                //评论
            }
            self?.getOperationView()?.hide()
        }
        operationView.tag = 12306
        operationView.loved = layout.isLoved
        operationView.show()
    }
}
