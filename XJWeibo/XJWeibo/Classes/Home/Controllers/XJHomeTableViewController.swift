//
//  XJHomeTableViewController.swift
//  XJWeibo
//
//  Created by xj on 8/26/16.
//  Copyright © 2016 xj. All rights reserved.
//

import UIKit

class XJHomeTableViewController: XJBaseTableViewController {
    let XJHomeReuseIdentifier = "XJHomeReuseIdentifier"
    
    //保存微博数组
    var statuses = [XJStatus](){
        //当别人设置完毕数据，就刷新表格
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //1.如果没有登录，就设置未登录界面的信息
        if !userLogin {
            visitorView.setupVisitorInfo(true, imageName: "visitordiscover_feed_image_house", message: "关注一些人，回这里看看有什么惊喜")
            return
        }
        //2.初始化导航条
        setupNav()
        //3.注册通知，监听菜单
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.change), name: XJPopoverAnimatorWillShow, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.change), name: XJPopoverAnimatorWillDismiss, object: nil)
        //注册一个cell
        tableView.registerClass(XJStatusTableViewCell.classForCoder(), forCellReuseIdentifier: XJHomeReuseIdentifier)
//        tableView.estimatedRowHeight = 200

        
        tableView.separatorStyle = .None
        //4.加载微博数据
        loadData()
    }
    private func loadData() -> () {
        XJStatus.loadStatuses { (models, error) in
            if error != nil{
                return
            }
            self.statuses = models!
        }
    }
    deinit{
    //移除通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    func change() -> Void {
        let titleBtn = navigationItem.titleView as! XJTitleButton
        titleBtn.selected = !titleBtn.selected
        
    }
    private func setupNav() -> Void {
        //1.初始化化左右按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem.creatBarButtonItem("navigationbar_friendattention", target: self, action: #selector(self.letfItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem.creatBarButtonItem("navigationbar_pop", target: self, action: #selector(self.rightItemClick))
        //2.初始化化标题按钮
        let titleBtn = XJTitleButton()
        titleBtn.setTitle("xjswift ", forState: UIControlState.Normal)
        titleBtn.sizeToFit()
        titleBtn.addTarget(self, action: #selector(self.titleBtnClick(_:)), forControlEvents: .TouchUpInside)
        navigationItem.titleView = titleBtn
    }
    func titleBtnClick(btn:XJTitleButton) -> Void {
        //1.修改箭头方向
//        btn.selected = !btn.selected
        //2.弹出菜单
        let sb = UIStoryboard(name: "PopoverViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        //2.1设置转场代理
        //默认情况下modal会移除以前控制器的view,替换为当前弹出的view
        //如果自定义转场，那么就不会移除以前控制器的view
        vc?.transitioningDelegate = popoverAnimator
        
        //2.2设置转场的样式
        vc?.modalPresentationStyle = UIModalPresentationStyle.Custom
        presentViewController(vc!, animated: true, completion: nil)
    }
    func letfItemClick() -> Void {
        
    }
    func rightItemClick() -> Void {
        let sb = UIStoryboard(name: "QRCodeViewController", bundle: NSBundle.mainBundle())
        let vc = sb.instantiateInitialViewController()
        presentViewController(vc!, animated: true, completion: nil)
        
        
    }
    
    //MARK: - 懒加载
    private lazy var popoverAnimator:XJPopoverAnimator = {
        let pa = XJPopoverAnimator()
        pa.presentFrame = CGRectMake(100, 56, 200, 350)
        return pa
    
    }()
    //微博行高德缓存，利用字典作为容器，key就是微博的id,值就是对应微博的行高
    var rowCache = [Int:CGFloat]()
    override func didReceiveMemoryWarning() {
        //清空缓存
        rowCache.removeAll()
    }
}
extension XJHomeTableViewController{
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses.count
        
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(XJHomeReuseIdentifier, forIndexPath: indexPath) as! XJStatusTableViewCell
        cell.status = statuses[indexPath.row]
        
        return cell
        
    }
    
    //返回行高
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //1.取出对应行的模型
        let status = statuses[indexPath.row]
        //2.判断缓存中有没有
        if let height = rowCache[status.id] {
            return height
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(XJHomeReuseIdentifier) as! XJStatusTableViewCell
        
        //2.拿到对应行的行高
        
        let rowHeight =  cell.rowHeight(status)
        rowCache.updateValue(rowHeight, forKey: status.id)
        return rowHeight
        
    }
}









































