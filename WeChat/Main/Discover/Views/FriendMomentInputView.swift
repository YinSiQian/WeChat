//
//  FriendMomentInputView.swift
//  WeChat
//
//  Created by ABJ on 2018/8/10.
//  Copyright © 2018年 ysq. All rights reserved.
//

import UIKit

class FriendMomentInputView: UIView {
    
    typealias complection = (_ text: String, _ index: Int) -> Void
    
    var complectionHandler: complection!
    
    var placeholder: String? {
        didSet {
            placeholderLable.isHidden = false
            placeholderLable.text = placeholder
        }
    }
    
    var currentTextViewHeight: CGFloat = 33
    
    var draft: String? {
        didSet {
            textView.text = draft
        }
    }
    
    var isMsgInput: Bool = false
    
    var isActive: Bool = false
    
    private var index: Int = 0
    
    private var placeholderLable: UILabel!
    
    private var textView: UITextView!
    
    var originY: CGFloat = 0
    
    var currentLocationForY: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 0.984174192, green: 0.9887431264, blue: 0.9636532664, alpha: 1)
        originY = self.minY
        currentLocationForY = self.minY
        setupSubviews()
        addObserver()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect, placeholder: String) {
        self.init(frame: frame)
        self.placeholder = placeholder
    }
    
    convenience init(frame: CGRect, placeholder: String, complectionHandler: @escaping complection) {
        self.init(frame: frame, placeholder: placeholder)
        self.complectionHandler = complectionHandler
    }
    
    private func setupSubviews() {
        
        textView = UITextView(frame: CGRect(x: 20, y: 5, width: self.width - 40, height: 30))
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = UIColor.black
        textView.returnKeyType = .send
        textView.layer.cornerRadius = 4
        textView.layer.masksToBounds = true
        textView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        textView.layer.borderWidth = 0.5
        textView.delegate = self
        self.addSubview(textView)
        
        placeholderLable = UILabel(frame: CGRect(x: 8, y: 0, width: textView.width, height: 30))
        placeholderLable.textColor = UIColor.lightGray
        placeholderLable.font = UIFont.systemFont(ofSize: 14)
        placeholderLable.text = placeholder
        textView.addSubview(placeholderLable)
                
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(FriendMomentInputView.keyboardWillShow(noti:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FriendMomentInputView.keyboardWillHide(noti:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FriendMomentInputView.keyboardFrameChanged(noti:)), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(FriendMomentInputView.textViewDidChanged(noti:)), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    @objc private func textViewDidChanged(noti: Notification) {
        let maxHeight: CGFloat = 120
        let object = noti.object as! UITextView
        let rect = object.frame
        let constraintSize = CGSize(width: rect.size.width, height: CGFloat(MAXFLOAT))
        var size = object.sizeThatFits(constraintSize)
        let detla = size.height - currentTextViewHeight

        if size.height >= maxHeight {
            size.height = maxHeight
            object.isScrollEnabled = true
        } else {
            object.isScrollEnabled = false
        }
        if size.height < maxHeight {
            UIView.animate(withDuration: 0.2) {
                self.frame = CGRect(x: 0, y: self.originY - detla , width: self.width, height: size.height + 10)
            }
        }
        UIView.animate(withDuration: 0.2) {
            object.frame = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: size.height)
        }
        
    }
    
    @objc private func keyboardWillShow(noti: Notification) {
        isHidden = false
        isActive = true
        let rect = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        UIView.animate(withDuration: 0.25) {
            self.minY = rect.origin.y - self.height
            self.originY = rect.origin.y - self.height
        }
        
    }
    
    @objc private func keyboardWillHide(noti: NSNotification) {
        let rect = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        isActive = false
        UIView.animate(withDuration: 0.25, animations: {
            self.minY = rect.origin.y - self.height - 34
            self.originY = rect.origin.y - self.height - 34
        }) { (_) in
            if !self.isMsgInput {
                self.isHidden = true
            }
        }
        
        currentTextViewHeight = self.textView.height
        
    }
    
    @objc private func keyboardFrameChanged(noti: NSNotification) {
        let rect = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        
        UIView.animate(withDuration: 0.25) {
            if self.isActive {
                self.minY = rect.origin.y - self.height
                self.originY = rect.origin.y - self.height
            }
            
        }
    }
    
    public func setIndex(currentIndex: Int) -> FriendMomentInputView {
        if index != currentIndex {
            draft = ""
        }
        index = currentIndex
        return self
    }
    
    public func hide() {
        isHidden = true
        self.textView.resignFirstResponder()
    }
    
    public func moveToBottom() {
        textView.resignFirstResponder();
    }
    
    public func show() -> FriendMomentInputView {
        self.isHidden = false
        self.textView.becomeFirstResponder()
        return self
    }
    
}

extension FriendMomentInputView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLable.isHidden = textView.text.count > 0
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            complectionHandler?(textView.text, index)
            textView.text = ""
            if isMsgInput && self.textView.height > 40.0 {
                UIView.animate(withDuration: 0.2) {
                    self.minY += textView.height - 30
                    self.textView.frame = CGRect(x: 20, y: 5, width: self.width - 40, height: 30)
                    self.height = 40
                }
            }
            return false
        }
        return true
    }
}
