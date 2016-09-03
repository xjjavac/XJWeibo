//
//  XJEmoticonViewController.swift
//  表情键盘界面布局
//
//  Created by xj on 9/2/16.
//  Copyright © 2016 xj. All rights reserved.
//

import UIKit
private let XJEmoticonCellReuseIdentifier = "XJEmoticonCellReuseIdentifier"
class XJEmoticonViewController: UIViewController {
    //定义一个闭包属性，用于传递选中的表情
    var emoticonDidSelectedCallBack:(emoticon:XJEmoticon)->()
    init(callBack:(emoticon:XJEmoticon)->()){
        self.emoticonDidSelectedCallBack = callBack
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.redColor()
        
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //1.初始化UI
        setupUI()
    }
    /**
     初始化UI
     */
    private func setupUI(){
        //1.添加子控件
        view.addSubview(collectionView)
        view.addSubview(toolbar)
        //2.布局子控件
//        collectionView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, view.bounds.size.height - 44)
//        toolbar.frame = CGRectMake(0, view.bounds.size.height - 44, UIScreen.mainScreen().bounds.size.width, 44)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        var cons = [NSLayoutConstraint]()
        let dict = ["collectionView":collectionView,"toolbar":toolbar]
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: dict)
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[toolbar]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: dict)
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[collectionView]-[toolbar(44)]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: dict)
        view.addConstraints(cons)
        
    }
    func itmeClick(item:UIBarButtonItem){
        
       collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: item.tag), atScrollPosition: .Left, animated: true)
    }
    //MARK: - 懒加载
    private lazy var collectionView:UICollectionView = {
        let clv = UICollectionView(frame: CGRectZero, collectionViewLayout: XJEmoticonLayout())
        clv.registerClass(XJEmoticonCell.self, forCellWithReuseIdentifier: XJEmoticonCellReuseIdentifier)
        clv.dataSource = self
        clv.delegate = self
        return clv
    }()
    private lazy var toolbar: UIToolbar = {
        let bar = UIToolbar()
        bar.tintColor = UIColor.darkGrayColor()
        var items = [UIBarButtonItem]()
        var index = 0
        for title in ["最近","默认","emoji","浪小花"]{
            let item = UIBarButtonItem(title: title, style: .Plain, target: self, action: #selector(self.itmeClick(_:)))
            
            item.tag = index
            index += 1
            items.append(item)
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        bar.items = items
        return bar
    }()
    private lazy var packages:[XJEmoticonPackage] = XJEmoticonPackage.packageList

}
    //MARK: - UICollectionViewDataSource
extension XJEmoticonViewController:UICollectionViewDataSource,UICollectionViewDelegate{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return packages.count
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return packages[section].emoticons?.count ?? 0
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCellWithReuseIdentifier(XJEmoticonCellReuseIdentifier, forIndexPath: indexPath) as! XJEmoticonCell
        cell.backgroundColor = (indexPath.item % 2 == 0) ? UIColor.redColor() : UIColor.greenColor()
        let package = packages[indexPath.section]
        let emoticon = package.emoticons![indexPath.item]
        cell.emoticon = emoticon
        
        return cell
    }
    //MARK: - UICollectionViewDelegate
    /**
     选中某个cell时调用
     */
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //1.处理最近表情，将当前使用的表情添加到最近表情的数组中
        let emoticon = packages[indexPath.section].emoticons![indexPath.item]
        emoticon.times += 1
        packages[0].appendEmoticons(emoticon)
//        collectionView.reloadSections(NSIndexSet(index: 0))
        //2.回调通知使用者当前点击了那个表情
        emoticonDidSelectedCallBack(emoticon: emoticon)
        
    }
}
class XJEmoticonCell: UICollectionViewCell {
    var emoticon:XJEmoticon?{
        didSet{
            //1.判断是否是图片表情
            if emoticon!.chs != nil {
               iconButton.setImage(UIImage(contentsOfFile: emoticon!.imagePath!), forState: .Normal)
            }else{
                iconButton.setImage(nil, forState: .Normal)
            }
            //2.设置emoji表情
            iconButton.setTitle(emoticon!.emojiStr ?? "", forState: .Normal)
            //3.判断是否是删除按钮
            if emoticon!.isRemoveButton {
                iconButton.setImage(UIImage(named: "compose_emotion_delete"), forState: .Normal)
                iconButton.setImage(UIImage(named: "compose_emotion_delete_highlighted"), forState: .Highlighted)
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    private func setupUI() -> Void {
        contentView.addSubview(iconButton)
        iconButton.backgroundColor = UIColor.whiteColor()
        iconButton.frame = CGRectInset(contentView.bounds, 4, 4)
    }
    //MARK: - 懒加载
    private lazy var iconButton:UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFontOfSize(32)
        btn.userInteractionEnabled = false
        return btn
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    //MARK: - 自定义布局
class XJEmoticonLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        super.prepareLayout()
        //1.设置cell相关属性
        let width = collectionView!.bounds.width/7
        itemSize = CGSizeMake(width, width)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .Horizontal
        //2.设置collectionView相关属性
        collectionView?.pagingEnabled = true
        collectionView?.bounces = false
        collectionView?.showsHorizontalScrollIndicator = false
        
        let y = (collectionView!.bounds.size.height - 3*width)*0.5
        collectionView?.contentInset = UIEdgeInsetsMake(y, 0, y, 0)
        
    }
}















