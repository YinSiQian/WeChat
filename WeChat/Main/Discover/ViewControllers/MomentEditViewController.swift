//
//  MomentEditViewController.swift
//  WeChat
//
//  Created by ysq on 2018/8/7.
//  Copyright © 2018年 ysq. All rights reserved.
//

import UIKit

class MomentEditViewController: UIViewController {
    
    typealias complection = () -> Void

    var complectionHandler: complection!
    
    var images: [UIImage] = []
    
    var hasImage: Bool = false
    
    var urlInfo: String = ""
    
    lazy var placeholderLable: UILabel = {
        let label = UILabel(frame: CGRect(x: 7, y: 8, width: 160, height: 18))
        label.text = "输入这一刻的想法"
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView(frame: CGRect(x: 30, y: 124, width: kScreen_width - 60, height: 140))
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = UIColor.black
        return textView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(complection: @escaping complection) {
        self.init()
        self.complectionHandler = complection
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setNavItem()
        setupPicsView()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        if #available(iOS 11.0, *) {
            super.viewSafeAreaInsetsDidChange()
            self.textView.minY = self.view.safeAreaInsets.top + 40
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    private func setupSubviews() {
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        self.title = hasImage ? "" : "发表文字"
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.textView)
        self.textView.addSubview(self.placeholderLable)
        NotificationCenter.default.addObserver(self, selector: #selector(MomentEditViewController.textViewDidChanged(noti:)), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    private func setNavItem() {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(MomentEditViewController.cancel))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发表", style: .plain, target: self, action: #selector(MomentEditViewController.post))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.green
        
    }
    
    private func setupPicsView() {
        
        if !images.isEmpty {
            let picsView = FriendMomentEditPicsView(frame: CGRect(x: 30, y: textView.maxY + 20, width: kScreen_width - 60, height: 0), images: images) {
                
                SystemPhotoService.shard.open(sourceController: self, maxCount: 9 - self.images.count, complectionHanlder: {
                    [weak self] (images) in
                    self?.images.append(contentsOf: images)
                    self?.reloadPics()
                })
            }
            picsView.tag = 110
            view.addSubview(picsView)
        }
    }
    
    private func reloadPics() {
        if let picsView = view.viewWithTag(110) as? FriendMomentEditPicsView {
            picsView.images = self.images
        }
    }
    
    // MARK: -- Network Exchange
    
    private func postMoment() {
        
        NetworkManager.request(targetType: TimelineAPIs.post(content: self.textView.text, url: self.urlInfo, location: "北京天安门")) { (result, error) in
            self.view.hideHUD()
            if !result.isEmpty {
                print(result)
            }
            
        }
    }
    
    private func upload(images: [UIImage]) {
        
        NetworkManager.request(targetType: UploadAPIs.upload(images), compection: {
            (result, error) in
            if !result.isEmpty {
                self.urlInfo = result["url"] as? String ?? "";
                self.postMoment()
            }
        })
    }
    
    // MARK: -- Notification
    
    @objc private func textViewDidChanged(noti: Notification) {
        self.placeholderLable.isHidden = self.textView.text.count > 0
    }
    
    // MARK: -- Events
    
    @objc private func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func post() {
        self.view.endEditing(true)
        self.view.showIndicator(message: "稍等片刻,马上就好")
        if hasImage {
            upload(images: images)
        } else {
            postMoment()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textView.resignFirstResponder()
    }

}
