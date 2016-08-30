//
//  XJBaseTableViewController.swift
//  XJWeibo
//
//  Created by xj on 8/27/16.
//  Copyright © 2016 xj. All rights reserved.
//

import UIKit

class XJBaseTableViewController: UITableViewController,XJVisitorViewDelegate{
    //定义一个变量保存用户当前是否登录
    var userLogin = true
    //定义属性保存未登录界面
    var visitorView:XJVisitorView = XJVisitorView()
    
    override func loadView() {
        userLogin ? super.loadView():setupVisitorView()
        
    }
    
    // MARK - 内部控制方法
    /**
     创建未登录界面
     */
    func setupVisitorView() -> Void {
        visitorView.delegate = self
        view = visitorView
        
        //设置导航条未登录按钮
//        navigationController?.navigationBar.tintColor = UIColor.orangeColor()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .Plain, target: self, action: #selector(self.registerBtnWillClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .Plain, target: self, action: #selector(self.loginBtnWillClick))
    }
    func registerBtnWillClick() {
        print(#function)
    }
    func loginBtnWillClick() {
        print(#function)
    }

}

























