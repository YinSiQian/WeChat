//
//  SQFriendsMomentsController.swift
//  WeChat
//
//  Created by ysq on 2017/10/7.
//  Copyright © 2017年 ysq. All rights reserved.
//

import UIKit

class SQFriendsMomentsController: UIViewController {
    
    private var layouts: [TimelineLayoutService] = []
    
    private var fpsLabel: YYFPSLabel!
    
    private lazy var tableView: UITableView = {
      
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        return tableView
    }()
    
    private lazy var commentInputView: FriendMomentInputView = {
        let inputView = FriendMomentInputView(frame: CGRect(x: 0, y: kScreen_height - 40, width: kScreen_width, height: 40), placeholder: "评论")
        self.view.addSubview(inputView)
        return inputView
    }()
    
    // MARK: -- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "朋友圈"
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .onDrag
        setNavItem()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNavbarTheme(theme: .white)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        getOperationView()?.hide()
    }
    
    // MARK: -- Setup subviews
    
    private func setNavItem() {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 27, height: 27))
        btn.setBackgroundImage(UIImage(named: "camera")!, for: .normal)
        btn.addTarget(self, action: #selector(SQFriendsMomentsController.openCamera), for: .touchUpInside)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(SQFriendsMomentsController.postTextMomentInfo))
        longPress.minimumPressDuration = 0.5
        btn.addGestureRecognizer(longPress)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btn)
        
        self.fpsLabel = YYFPSLabel(frame: CGRect(x: 10, y: kScreen_height - 100, width: 100, height: 30))
        self.fpsLabel.sizeToFit()
        self.fpsLabel.alpha = 0.0
        UIApplication.shared.keyWindow?.addSubview(self.fpsLabel)
    }
    
    //MARK: -- Network handler
    
    private func loadData() {
        NetworkManager.request(targetType: TimelineAPIs.list(timestamp: "2018-06-21 16:13:33")) {
            [weak self] (result, error) in
            if !result.isEmpty {
                let arr = result["list"] as! [[String: Any]]
                let data = try! MomentModel.mapToArr(data: arr, type: Array<MomentModel>.self)
                self?.handlerDataAsnyc(data: data)
            }
        }
    }
    
    private func love(index: Int) {
        let layout = layouts[index]
        NetworkManager.request(targetType: TimelineAPIs.favorite(momentId: layout.timelineModel.momentId, isLoved: layout.isLoved)) {
            [weak self] (result, error) in
            if !result.isEmpty {
                //点赞
                if layout.isLoved == 0 {
                    self?.layouts[index].isLoved = 1
                } else {
                    self?.layouts[index].isLoved = 0
                }
                self?.handlerLoveData(data: result, isLoved: layout.isLoved, index: index)
            }
        }
    }

    /// 发表评论
    ///
    /// - Parameters:
    ///   - index: cell index
    ///   - content: 评论内容
    ///   - uid: 被回复人
    ///   - isComment: 1 评论 2 回复
    private func publishedComment(index: Int, content: String, uid: Int ,isComment: Int) {
        
        let layout = layouts[index]
        NetworkManager.request(targetType: TimelineAPIs.addComment(momentId: layout.timelineModel.momentId,
                                                                   content: content,
                                                                   uid: uid,
                                                                   isComment: isComment)) {
        [weak self]  (result, error) in
            if !result.isEmpty {
                let dict = result["data"] as! [String: Any]
                self?.handlerCommentData(data: dict, index: index)
            }
        }
    }
    
    // MARK: -- Handler Data
    
    private func handlerCommentData(data: [String: Any], index: Int) {
        if let comment = try? MomentModel.Comment.mapToModel(data: data, type: MomentModel.Comment.self) {
            layouts[index].timelineModel.comments.append(comment)
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
    }
    
    private func handlerLoveData(data: [String: Any], isLoved: Int, index: Int) {
        if isLoved == 1 {
            //取消点赞成功
            for (loveIndex, love) in layouts[index].timelineModel.loves.enumerated() {
                if love.uid == UserModel.sharedInstance.id {
                    layouts[index].timelineModel.loves.remove(at: loveIndex)
                    break
                }
            }
        } else {
            //点赞成功
            let dict = data["data"] as! [String: Any]
            if let loveInfo = try? MomentModel.Love.mapToModel(data: dict, type: MomentModel.Love.self) {
                self.layouts[index].timelineModel.loves.append(loveInfo)
                
            }
        }
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)

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
                self?.present(SQNavigationViewController(rootViewController: edit),
                              animated: true, completion: nil)
            }
        }
    }

    // MARK: -- Private method
    
    private func getOperationView() -> FriendMomentOpeationView? {
        if let view = UIApplication.shared.keyWindow?.viewWithTag(12306) as? FriendMomentOpeationView {
            return view
        }
        return nil
    }
    
    deinit {
        print("it is dealloc")
    }
    
}

extension SQFriendsMomentsController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return layouts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return layouts[indexPath.row].height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FriendMomentCell.cell(with: tableView)
        cell.delegate = self
        cell.layout = layouts[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        getOperationView()?.hide()
        commentInputView.hide()
    }
    
}

extension SQFriendsMomentsController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if self.fpsLabel.alpha == 0.0 {
            UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                self.fpsLabel.alpha = 1.0
            }, completion: nil)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.fpsLabel.alpha != 0.0 {
            UIView.animate(withDuration: 1, delay: 2, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                self.fpsLabel.alpha = 0.0
            }, completion: nil)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            if self.fpsLabel.alpha != 0.0 {
                UIView.animate(withDuration: 1, delay: 2, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                    self.fpsLabel.alpha = 0.0
                }, completion: nil)
            }
        }
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        if self.fpsLabel.alpha == 0.0 {
            UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                self.fpsLabel.alpha = 1.0
            }, completion: nil)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        getOperationView()?.hide()
    }
    
}

extension SQFriendsMomentsController: FriendMomentCellDelegate {
    
    
    /// 查看评论用户信息
    ///
    /// - Parameters:
    ///   - index: 数据源index
    ///   - commentIndex: 评论index
    ///   - isReply: 是回复人还是接收人
    func watchUserInfo(cell index: Int, commentIndex: Int, isReply: Bool) {
        var username = ""
        if isReply {
            username = self.layouts[index].timelineModel.comments[commentIndex].replyName
        } else {
            username = self.layouts[index].timelineModel.comments[commentIndex].receivedName
        }
        print("click username: " + username)
    }
    
    
    /// 回复评论
    ///
    /// - Parameters:
    ///   - index: 数据源index
    ///   - commentIndex: 评论index
    func reply(cell index: Int, commentIndex: Int) {
        let layout = self.layouts[index]
        let placeholder = "回复" + layouts[index].timelineModel.comments[commentIndex].replyName
        self.commentInputView.placeholder = placeholder
        self.commentInputView.setIndex(currentIndex: index).show().complectionHandler = {
            [weak self] (text, index) in
            self?.publishedComment(index: index,
                                   content: text,
                                   uid: layout.timelineModel.comments[commentIndex].replyId,
                                   isComment: 2)
        }
    }
    
    
    /// 评论或点赞
    ///
    /// - Parameters:
    ///   - point: 点击按钮相对于keyWindow的位置
    ///   - indexPath: cell indexPath
    func showInterfaceColumnView(point: CGPoint, indexPath: NSIndexPath) {
        
        if let view = getOperationView() {
            view.hide()
            return
        }
        let layout = self.layouts[indexPath.row]
        let operationView = FriendMomentOpeationView(frame: CGRect(x: 0, y: 0, width: 140, height: 34), point: point) {  [weak self] (type) in
            if type == 1 {
                //点赞
                self?.love(index: indexPath.row)
                
            } else {
                //评论
                self?.commentInputView.placeholder = "评论"
                self?.commentInputView.setIndex(currentIndex: indexPath.row).show().complectionHandler = {
                    [weak self] (text, index) in
                    self?.publishedComment(index: index,
                                           content: text,
                                           uid: layout.timelineModel.userId,
                                           isComment: 1)
                }
                
            }
            self?.getOperationView()?.hide()
        }
        operationView.tag = 12306
        operationView.loved = layout.isLoved
        operationView.show()
    }
}
