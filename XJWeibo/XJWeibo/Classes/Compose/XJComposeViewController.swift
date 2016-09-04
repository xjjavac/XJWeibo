//
//  XJComposeViewController.swift
//  XJWeibo
//
//  Created by xj on 9/2/16.
//  Copyright © 2016 xj. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD
class XJComposeViewController: UIViewController {
    //表情键盘
    private lazy var emoticonVc:XJEmoticonViewController = {
        return XJEmoticonViewController {[weak self](emoticon) in
            self!.textView.insertEmoticon(emoticon)
        }
    }()
    //图片选择器
    private lazy var photoSelectorVc:XJPhotoSelectorViewController = XJPhotoSelectorViewController()
    var toolbarBottomCons:Constraint?
    var photoViewHeightCons:Constraint?
    override func viewDidLoad() {
        super.viewDidLoad()
        //0.注册通知监听键盘弹出和消失
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillChangeFrame(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        view.backgroundColor = UIColor.whiteColor()
        
        
        addChildViewController(emoticonVc)
        addChildViewController(photoSelectorVc)
        //1.初始化导航条
        setupNav()
        //2.初始化输入框
        setupInputView()
        //初始化图片选择器
        setupPhotoView()
        //3.初始化工具条
        setupToolbar()
        
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
//        if (photoViewHeightCons as! NSLayoutConstraint).constant == 0 {
            //3主动召唤神龙
        if photoSelectorVc.view.frame.height == 0 {
            textView.becomeFirstResponder()
        }
        
//        }
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //4主动隐藏键盘
        textView.resignFirstResponder()
    }
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    func keyboardWillChangeFrame(notify:NSNotification) -> () {
        //1.取出键盘最终的frame
        let value = notify.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        let rect = value.CGRectValue()
        //取出键盘的动画节奏
        let curve = notify.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber
        
        UIView.animateWithDuration(0.25) { [weak self] in
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: curve.integerValue)!)
            self!.toolbarBottomCons?.updateOffset(-(UIScreen.mainScreen().bounds.height - rect.origin.y))
        }
        
    }
    //MARK: - 1.初始化导航条
    /**
     //1.初始化导航条
     */
    private func setupNav() -> () {
        //1.1添加左边按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .Plain, target: self, action: #selector(self.close))
        //1.2添加右边按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .Plain, target: self, action: #selector(self.sendStatus))
        navigationItem.rightBarButtonItem?.enabled = false
        //1.3添加中间视图
        let titleView = UIView()
        titleView.frame = CGRectMake(0, 0, 100, 32)
        let label1 = UILabel()
        label1.font = UIFont.systemFontOfSize(15)
        label1.text = "发送微博"
        label1.sizeToFit()
        titleView.addSubview(label1)
        let label2 = UILabel()
        label2.font = UIFont.systemFontOfSize(13)
        label2.textColor = UIColor.darkGrayColor()
        label2.text = XJUserAccount.loadAccount()?.screen_name
        label2.sizeToFit()
        titleView.addSubview(label2)
        label1.snp_makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        label2.snp_makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        navigationItem.titleView = titleView
        
        
    }
    /**
     1.1关闭控制器
     */
    func close() -> () {
        dismissViewControllerAnimated(true, completion: nil)
    }
    /**
     1.2发送文本微博
     */
    func sendStatus() -> () {
        let text = textView.emoticonAttributedText()
        let image = photoSelectorVc.pictureImages.first
        
        
        XJNetworkTools.shareNetworkTools().sendStatus(text, image: image, successCallback: { (status) in
            //1.2.1提示用户发送成功
            SVProgressHUD.showSuccessWithStatus("发送成功")
            SVProgressHUD.setDefaultMaskType(.Black)
            //1.2.2关闭发送界面
            self.close()
            }) { (error) in
                print(error)
                //1.2.3提示用户发送失败
                SVProgressHUD.showSuccessWithStatus("发送失败")
                SVProgressHUD.setDefaultMaskType(.Black)
        }
    }
    //MARK: - 2.初始化输入框
    /**
     2.初始化输入框
     */
    func setupInputView(){
        //2.1添加子控件
        view.addSubview(textView)
        textView.addSubview(placeholderLabel)
        textView.alwaysBounceVertical = true
        textView.keyboardDismissMode = .OnDrag
        //2.2布局子控件
        textView.snp_makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        placeholderLabel.snp_makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(8)
        }
    
    }
    private func setupToolbar(){
        //1.添加子控件
        
        
        view.addSubview(toolbar)
        view.addSubview(tipLabel)
        var items = [UIBarButtonItem]()
        items.append(UIBarButtonItem.creatBarButtonItem("compose_toolbar_picture", target: self, action: #selector(self.selectPicture)))
        items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
        items.append(UIBarButtonItem.creatBarButtonItem("compose_mentionbutton_background", target: self, action: nil))
        items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
        items.append(UIBarButtonItem.creatBarButtonItem("compose_trendbutton_background", target: self, action: nil))
        items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
        items.append(UIBarButtonItem.creatBarButtonItem("compose_emoticonbutton_background", target: self, action: #selector(self.inputEmoticon)))
        items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
        items.append(UIBarButtonItem.creatBarButtonItem("compose_addbutton_background", target: self, action: nil))
        toolbar.items = items
        //布局toolbar
        let width = UIScreen.mainScreen().bounds.size.width
        toolbar.snp_makeConstraints { (make) in
          toolbarBottomCons =  make.bottom.equalToSuperview().constraint
            make.left.equalToSuperview()
            make.size.equalTo(CGSizeMake(width, 44))
        }
            tipLabel.snp_makeConstraints { (make) in
            make.right.equalTo(toolbar.snp_right)
            make.bottom.equalTo(toolbar.snp_top)
        }
        
        
    }
    func selectPicture() -> Void {
        //1.关闭键盘
        textView.resignFirstResponder()
        //2.调整图片选择器的高度
        photoViewHeightCons?.updateOffset(UIScreen.mainScreen().bounds.height*0.6)
    }
    func setupPhotoView() -> Void {
        //1.添加图片选择器
        view.insertSubview(photoSelectorVc.view, belowSubview: toolbar)
        //2.布局图片选择器
        let size = UIScreen.mainScreen().bounds.size
        let width = size.width
        let height:CGFloat = 0
        photoSelectorVc.view.snp_makeConstraints { (make) in
            photoViewHeightCons = make.height.equalTo(height).constraint
            make.width.equalTo(width)
            make.bottom.equalTo(view.snp_bottom)
            make.left.equalTo(view.snp_left)
        }
        
        
    }
    func inputEmoticon() -> Void {
        //1.关闭键盘
        textView.resignFirstResponder()
        //2.设置inputView
        textView.inputView = (textView.inputView != nil) ? nil : emoticonVc.view
        //3.从新召唤出键盘
        textView.becomeFirstResponder()
    }
    //MARK: - 懒加载
    private lazy var textView:UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFontOfSize(20)
        tv.delegate = self
        return tv
    }()
    private lazy var placeholderLabel:UILabel = {
        let label = UILabel()
        label.text = "分享新鲜事..."
        label.font = UIFont.systemFontOfSize(20)
        label.textColor = UIColor.darkGrayColor()
        return label
    }()
    private lazy var toolbar = UIToolbar()
    private lazy var tipLabel:UILabel = {
        let label = UILabel()
        
        return label
    }()
    //MARK: - 接收到内存警告
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

    //MARK: - TextView代理
private let maxTipTextLength = 10
extension XJComposeViewController:UITextViewDelegate{
    func textViewDidChange(textView: UITextView) {
        placeholderLabel.hidden = textView.hasText()
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
        //当前已经输入的内容长度
        let count = textView.emoticonAttributedText().characters.count
        let result = maxTipTextLength - count
        
        tipLabel.textColor = result > 0 ?UIColor.darkGrayColor():UIColor.redColor()
        tipLabel.text = count == 0 ? "": "\(result)"
    }
}

























