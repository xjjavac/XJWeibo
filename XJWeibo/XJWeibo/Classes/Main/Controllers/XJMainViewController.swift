//
//  XJMainViewController.swift
//  XJWeibo
//
//  Created by xj on 8/26/16.
//  Copyright © 2016 xj. All rights reserved.
//

import UIKit

class XJMainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = UIColor.orangeColor()
        
        /*
        //1.创建首页
        let home = XJHomeTableViewController()
        
        home.tabBarItem.image = UIImage(named: "tabbar_home")
        home.tabBarItem.selectedImage = UIImage(named: "tabbar_home_highlighted")
//        home.tabBarItem.title = "首页"
//        home.navigationItem.title = "首页"
        home.title = "首页"
        //2.给首页包装一个导航控制器
        let nav = UINavigationController()
        nav.addChildViewController(home)
        
        //3.将导航控制器添加到当前控制器上
        addChildViewController(nav)
        */
        addChildViewController(XJHomeTableViewController(), title: "首页", imageName: "tabbar_home")
        addChildViewController(XJMessageTableViewController(), title: "消息", imageName: "tabbar_message_center")
        addChildViewController(XJDiscoverTableViewController(), title: "广场", imageName: "tabbar_discover")
        addChildViewController(XJProfileTableViewController(), title: "我", imageName: "tabbar_profile")
    }
    /**
     初始化只控制器
     
     - parameter childController: 需要初始化的子控制器
     - parameter title:           子控制器的标题
     - parameter imageName:       子控制器的图片
     */
    private func addChildViewController(childController:UIViewController,title:String,imageName:String) -> Void {
        
        //1.设置首页对应的数据
        childController.tabBarItem.image = UIImage(named: imageName)
        childController.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        childController.title = "首页"
        
        //2.给首页包装一个导航控制器
        let nav = UINavigationController()
        nav.addChildViewController(childController)
        
        //3.将导航控制器添加到当前控制器上
        addChildViewController(nav)
        
    }
    
    

    

}

















