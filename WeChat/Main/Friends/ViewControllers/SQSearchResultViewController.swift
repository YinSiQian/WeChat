//
//  SQSearchResultViewController.swift
//  WeChat
//
//  Created by ysq on 2017/10/7.
//  Copyright © 2017年 ysq. All rights reserved.
//

import UIKit

class SQSearchResultViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

     
        
        let centerView = UIView()
        centerView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        centerView.center = self.view.center
        centerView.backgroundColor = UIColor.white
        self.view.addSubview(centerView)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension SQSearchResultViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
