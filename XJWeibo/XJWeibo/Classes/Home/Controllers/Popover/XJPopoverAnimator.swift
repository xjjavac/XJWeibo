//
//  XJPopoverAnimator.swift
//  XJWeibo
//
//  Created by xj on 8/29/16.
//  Copyright © 2016 xj. All rights reserved.
//

import UIKit
//定义常量保存通知的名称
let XJPopoverAnimatorWillShow = "XJPopoverAnimatorWillShow"
let XJPopoverAnimatorWillDismiss = "XJPopoverAnimatorWillDismiss"


class XJPopoverAnimator: NSObject,UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning{
    //记录当前是否是展开
    var isPresent = false
    //定义属性保存菜单的大小
    var presentFrame = CGRectZero
    //实现代理方法，告诉系统谁来负责转场动画
    //UIPresentationController ios8推出的专门用于负责转场动画的
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        let pc = XJPopoverPresentationController(presentedViewController: presented, presentingViewController: presenting)
        pc.presentFrame = presentFrame
        return pc
    }
    /**
     告诉系统谁来负责Modal的展现动画
     
     - parameter presented:  被展现视图
     - parameter presenting: 发起的视图
     
     - returns: 谁来负责
     */
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        isPresent = true
        //发送通知，通知控制器即将展开
        NSNotificationCenter.defaultCenter().postNotificationName(XJPopoverAnimatorWillShow, object: self)
        return self
    }
    //MARK: - 只要实现了以下方法，那么系统自带的默认动画就没有了，所有东西都需要程序员自己来实现
    /**
     告诉系统谁来负责Modal的消失
     
     - parameter dismissed: 被关闭的视图
     
     - returns: 谁来负责
     */
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        isPresent = false
        //发送通知，通知控制器即将关闭
        NSNotificationCenter.defaultCenter().postNotificationName(XJPopoverAnimatorWillDismiss, object: self)
        return self
    }
    /**
     返回动画时长
     
     - parameter transitionContext: 上下文，里面保存了动画需要的所有参数
     
     - returns: 动画时长
     */
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval{
        return 0.5
        
    }
    /**
     告诉系统如何动画，无论是展现还是消失都会调用这个方法
     
     - parameter transitionContext: 上下文，里面保存了动画需要的所有参数
     */
    func animateTransition(transitionContext: UIViewControllerContextTransitioning){
        //1.拿到展现视图
        //        let toVc = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        //        let fromVc = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        if isPresent {
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
            toView?.transform = CGAffineTransformMakeScale(1.0, 0.0)
            //注意： 一定要将视图添加到容器上
            transitionContext.containerView()?.addSubview(toView!)
            toView?.layer.anchorPoint = CGPointMake(0.5, 0)
            //2.执行动画
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
                //2.1 清空transform
                toView?.transform = CGAffineTransformIdentity
            }) { (xj) in
                //2.2动画执行完毕，一定要告诉系统
                //如果不写，可能导致一些未知错误
                transitionContext.completeTransition(true)
            }
            
            
        }else{
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
                fromView?.transform = CGAffineTransformMakeScale(1.0, 0.00001)
                }, completion: { (xj) in
                    transitionContext.completeTransition(true)
            })
            
            
        }
        
    }
}

