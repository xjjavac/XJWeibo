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
//        tabBar.tintColor = UIColor.orangeColor()
        //添加子控制器
        addChildViewControllers()
//        print(tabBar.subviews)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        print("------")
//        print(tabBar.subviews)
        //添加加号按钮
        setupComposeBtn()
        
    }
    
    func composeBtnClick(btn:UIButton) -> Void {
        print(#function)
    }
    
    //MARK -添加加号按钮
    func setupComposeBtn() -> Void {
        //1.添加加号按钮
        tabBar.addSubview(composeBtn)
        //2.调整加号按钮的位置
        let width = UIScreen.mainScreen().bounds.size.width / CGFloat(viewControllers!.count)
        let rect = CGRect(x: 0, y: 0, width: width, height: 49)
        //第一个参数：是frame的大小
        //第二个参数:是x得方向偏移的大小
        //第三个参数：是y方向偏移的大小
        composeBtn.frame = CGRectOffset(rect, 2*width, 0)
        composeBtn.addTarget(self, action: #selector(self.composeBtnClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    /**
     添加所有子控制器
     */
    private func addChildViewControllers() -> Void {
        //1.获取json文件的路径
        let path = NSBundle.mainBundle().pathForResource("XJMainVCSettings.json", ofType: nil)
        
        
        //2.通过文件路径创建NSData
        if let jsonPath = path {
            let jsonData = NSData(contentsOfFile: jsonPath)
            do{
                //有可能发生异常的代码放到这里
                //3.序列化json数据 --> Array
                let dictArr = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers)
                //4.遍历数组，动态创建控制器和设置数据
                for dict in dictArr as! [[String:String]] {
                    addChildViewController(dict["vcName"]!, title: dict["title"]!, imageName: dict["imageName"]!)
                    
                }
            }catch{
                //发生异常之后会执行的代码
                print(error)
                print("2222")
                //2.添加子控制器
                addChildViewController("XJHomeTableViewController", title: "首页", imageName: "tabbar_home")
                addChildViewController("XJMessageTableViewController", title: "消息", imageName: "tabbar_message_center")
                addChildViewController("XJDiscoverTableViewController", title: "广场", imageName: "tabbar_discover")
                addChildViewController("XJProfileTableViewController", title: "我", imageName: "tabbar_profile")
            }
            
        }else{
            
            //2.添加子控制器
            addChildViewController("XJHomeTableViewController", title: "首页", imageName: "tabbar_home")
            addChildViewController("XJMessageTableViewController", title: "消息", imageName: "tabbar_message_center")
            addChildViewController("XJDiscoverTableViewController", title: "广场", imageName: "tabbar_discover")
            addChildViewController("XJProfileTableViewController", title: "我", imageName: "tabbar_profile")
            
            
            
        }

    }
    /**
     初始化只控制器
     
     - parameter childController: 需要初始化的子控制器
     - parameter title:           子控制器的标题
     - parameter imageName:       子控制器的图片
     */
//    private func addChildViewController(childController:UIViewController,title:String,imageName:String) -> Void {
    private func addChildViewController(childControllerName:String,title:String,imageName:String) -> Void {
//        <XJWeibo.XJHomeTableViewController: 0x7fc62341ef20>
//        print(childController)
        // -1.动态获取命名空间
        let ns = NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as! String
        //0.将字符串转换为类
        //0.1默认情况下命名空间就是项目的名称,但是命名空间名称是可以修改的
        let cls:AnyClass? = NSClassFromString("\(ns)." + childControllerName)
        
        //0.2 通过类创建对象
        //0.2.1将anyClass转换为指定的类型
        let vcCls = cls as! UIViewController.Type
        let vc = vcCls.init()
        
       
        
        
        //1.设置首页对应的数据
        vc.tabBarItem.image = UIImage(named: imageName)
        vc.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        vc.title = title
        
        //2.给首页包装一个导航控制器
        let nav = UINavigationController()
        nav.addChildViewController(vc)
        
        //3.将导航控制器添加到当前控制器上
        addChildViewController(nav)
        
    }
    
    //MARK: -懒加载
    private lazy var composeBtn:UIButton = {
        let btn = UIButton()
        
        //设置前景图片
        btn.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: .Normal)
        btn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: .Highlighted)
        //设置背景图片
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: .Normal)
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: .Highlighted)
        
        return btn
    }()

    

}














































