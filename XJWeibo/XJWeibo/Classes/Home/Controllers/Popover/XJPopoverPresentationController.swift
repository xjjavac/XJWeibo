//
//  XJPopoverPresentationController.swift
//  XJWeibo
//
//  Created by xj on 8/29/16.
//  Copyright © 2016 xj. All rights reserved.
//

import UIKit

class XJPopoverPresentationController: UIPresentationController {
    //定义属性保存菜单的大小
    var presentFrame = CGRectZero
    
    /**
     初始化方法，用于创建负责转场动画的对象
     
     - parameter presentedViewController:  被展现的控制器
     - parameter presentingViewController: 发起的控制器
     
     - returns: 负责转场动画的对象
     */
    override init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
    }
    /**
     即将布局转场子视图时调用
     */
    override func containerViewWillLayoutSubviews() {
        //修改弹出视图的大小
        //containerView  容器视图
        // presentedView()  被展现的视图
        if presentFrame == CGRectZero {
            presentedView()?.frame = CGRect(x: 100, y: 56, width: 200, height: 200)
            
        }else{
            presentedView()?.frame = presentFrame
        }
        //2.在容器视图上添加一个蒙版，插入到展现视图的下面
        //因为展现视图和蒙版都在一个视图上，而后添加的会盖住先添加的
        containerView?.insertSubview(coverView, atIndex: 0)
    }
    //MARK: - 懒加载
    private lazy var coverView: UIView = {
        //1.创建view
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.2)
        view.frame = UIScreen.mainScreen().bounds
        //2.添加监听
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.close))
        view.addGestureRecognizer(tap)
        return view
    
    }()
    func close() -> Void {
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}























