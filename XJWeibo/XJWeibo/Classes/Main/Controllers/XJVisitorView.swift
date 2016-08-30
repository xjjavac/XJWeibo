//
//  XJVisitorView.swift
//  XJWeibo
//
//  Created by xj on 8/27/16.
//  Copyright © 2016 xj. All rights reserved.
//

import UIKit
import SnapKit
//swift中定义协议：必须遵守NSObjectProtocol
protocol XJVisitorViewDelegate:NSObjectProtocol{
    //登录回调
    func loginBtnWillClick() -> Void
    //注册回调
    func registerBtnWillClick() -> Void
}
class XJVisitorView: UIView {
    //定义一个属性保存代理对象
    //一定要加上weak,避免循环引用
    weak var delegate:XJVisitorViewDelegate?
    func setupVisitorInfo(isHome:Bool,imageName:String,message:String) -> Void {
        //如果不是首页，就隐藏转盘
        iconView.hidden = !isHome
        //修改中间图标
        homeIcom.image = UIImage(named:imageName)
        //修改文本
        messageLabel.text = message
        //判断是否需要执行动画
        if isHome {
            startAnimation()
        }
    }
    func loginBtnClick() -> Void {
       delegate?.loginBtnWillClick()
    }
    func registerBtnClick() -> Void {
        delegate?.registerBtnWillClick()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        //1.添加子控件
        addSubview(iconView)
        addSubview(maskBGView)
        addSubview(homeIcom)
        addSubview(messageLabel)
        addSubview(loginButton)
        loginButton.addTarget(self, action: #selector(self.loginBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        addSubview(registerButton)
        registerButton.addTarget(self, action: #selector(self.registerBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        //2.布局子控件
        //2.1设置背景
        iconView.snp_makeConstraints { (make) in
            make.center.equalTo(self)
        }
        //2.2设置小房子
        homeIcom.snp_makeConstraints { (make) in
            make.center.equalTo(self)
        }
        //2.3设置文本
        messageLabel.snp_remakeConstraints { (make) in
            make.top.equalTo(iconView.snp_bottom)
            make.width.equalTo(UIScreen.mainScreen().bounds.width*2/3)
            make.centerX.equalTo(iconView)
        }
        //2.4设置按钮
        registerButton.snp_makeConstraints { (make) in
            make.top.equalTo(messageLabel.snp_bottom).offset(20)
            make.left.equalTo(messageLabel)
            make.size.equalTo(CGSizeMake(100, 30))
        }
        loginButton.snp_makeConstraints { (make) in
            make.top.equalTo(messageLabel.snp_bottom).offset(20)
            make.right.equalTo(messageLabel)
            make.size.equalTo(registerButton)
        }
        //设置蒙版
        maskBGView.snp_makeConstraints { (make) in
            make.center.equalTo(iconView)
            make.edges.equalTo(self)
        }
    }
    
    
    //swift推荐我们自定义一个控件，要么用纯代码，要么就用xib/storyboard
    required init?(coder aDecoder: NSCoder) {
        //如果通过xib/storyboard创建该类，那么就会崩溃
        fatalError("init(coder:) has not been implemented")
    
    }
    //MARK: - 内部控制方法
    private func startAnimation() -> Void {
        //1.创建动画
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        
        //2.设置动画属性
        anim.toValue = 2*M_PI
        anim.duration = 20
        anim.repeatCount = MAXFLOAT
        anim.removedOnCompletion = false
        //3.将动画添加到图层上
        iconView.layer.addAnimation(anim, forKey: nil)
    }
    
    //MARK: - 懒加载控件
    /// 转盘
    private lazy var iconView:UIImageView = {
        let iv = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
        return iv
    
    }()
    /// 图标
    private lazy var homeIcom:UIImageView = {
        let iv = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
        return iv
    
    }()
    /// 文本
    private lazy var messageLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor.darkGrayColor()
        label.textAlignment = .Center
        label.text = "啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦"
        return label
    }()
    //登录按钮
    private lazy var loginButton:UIButton = {
        let btn = UIButton()
        btn.setTitle("登录", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        return btn
    }()
    //注册按钮
    private lazy var registerButton:UIButton = {
        let btn = UIButton()
        btn.setTitle("注册", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        
        return btn
    
    }()
    private lazy var maskBGView:UIImageView = {
        let iv = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
        return iv
    }()
}





























