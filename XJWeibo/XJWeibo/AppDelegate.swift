//
//  AppDelegate.swift
//  XJWeibo
//
//  Created by xj on 8/26/16.
//  Copyright © 2016 xj. All rights reserved.
//

import UIKit
//切换控制器通知
let XJSwithchRootViewControllerKey = "XJSwithchRootViewControllerKey"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //注册一个通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.switchRootViewController(_:)), name: XJSwithchRootViewControllerKey, object: nil)
        
        // Override point for customization after application launch.
        //设置导航条和工具条的外观
        //应为外观一旦设置全局有效，所以应该在程序一进来就设置
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        UITabBar.appearance().tintColor = UIColor.orangeColor()
        //1.创建window
        window = UIWindow()
        window?.frame = UIScreen.mainScreen().bounds
        window?.backgroundColor = UIColor.whiteColor()
        //2.创建根控制器
        window?.rootViewController = defaultContoller()
        
        window?.makeKeyAndVisible()
        isNewupdate()
        return true
    }
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    func switchRootViewController(notify:NSNotification) -> () {
        if notify.object as! Bool {
            window?.rootViewController = XJMainViewController()
            
        }else{
            window?.rootViewController = XJWelcomeViewController()
        }
    }
    /**
     用于获取默认界面
     
     - returns: 默认界面
     */
    func defaultContoller() -> UIViewController {
        if XJUserAccount.userLogin() {
            return isNewupdate() ? XJNewfeatureCollectionViewController() : XJWelcomeViewController()
        }
        return XJMainViewController()
    }
    func isNewupdate() -> Bool {
        //1.获取当前软件的版本号
        let currentVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        
        //2.获取以前的软件版本号-->从本地文件中读取（以前自己存储的）
        let sandboxVersion = NSUserDefaults.standardUserDefaults().objectForKey("CFBundleShortVersionString") as? String ?? ""
        //3.比较当前版本号和以前版本号
        if currentVersion.compare(sandboxVersion) == NSComparisonResult.OrderedDescending {
            //3.1如果当前>以前-->有新版本
            //3.1.1存储当前最新的版本号
            //ios7以后就不用调用同步方法了
        NSUserDefaults.standardUserDefaults().setObject(currentVersion, forKey: "CFBundleShortVersionString")
            return true
        }
        //3.2如果当前< | == --> 没有新版本
        return false
    }
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

