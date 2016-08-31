//
//  XJNewfeatureCollectionViewController.swift
//  XJWeibo
//
//  Created by xj on 8/30/16.
//  Copyright © 2016 xj. All rights reserved.
//

import UIKit
import SnapKit

private let reuseIdentifier = "reuseIdentifier"

class XJNewfeatureCollectionViewController: UICollectionViewController {
    //页面个数
    private let pageCount = 4
    //b布局对象
    private var layout = XJNewfeatureLayout()
    //因为系统指定的初始化构造方法是带参数的（collectionViewLayout）,而不是不带参数的，所以不用心写
    init(){
        super.init(collectionViewLayout: layout)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       //1.注册一个cell
        collectionView?.registerClass(XJNewfeatureCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        

    }
    
    //MARK: - UICollectionViewDataSource
    //1.返回一共有多少个cell
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return pageCount
    }
    //2.返回对应indexPath的cell
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //1.获取cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! XJNewfeatureCell
        
        //2.设置cell的数据
       cell.imageIndex = indexPath.item
        //3.返回cell
        return cell
    }
    //完全显示一个cell之后调用
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        //1.拿到当前显示的cell对应的索引
        let path = collectionView.indexPathsForVisibleItems().last!
    
        if path.item == pageCount - 1 {
            //2.拿到当前索引对应的cell
            let cell = collectionView.cellForItemAtIndexPath(path) as! XJNewfeatureCell
            //3.让cell执行按钮动画
            cell.startBtnAnimation()
            
        }
        
        
    }
}
//swift中一个文件是可以定义多个类的
class XJNewfeatureCell:UICollectionViewCell{
    //保存图片的索引
    //swift中被private修饰的东西，如果是在同一个文件中是可以访问的
    private var imageIndex:Int = 0{
        willSet{
            iconView.image = UIImage(named: "new_feature_\(newValue+1)")
            if newValue != 3 {
                startButton.hidden = true
            }
        }
    }
    func startBtnAnimation() -> Void {
        
            startButton.hidden = false
            //执行动画
            startButton.transform = CGAffineTransformMakeScale(0.0, 0.0)
            startButton.userInteractionEnabled = false
            UIView.animateWithDuration(1.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue:0), animations: {
                //清空形变
                self.startButton.transform = CGAffineTransformIdentity
                }, completion: { (xj) in
                    self.startButton.userInteractionEnabled = true
            })
        

    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        //1.初始化UI
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func startBtnClick() -> () {
        //去主页，注意点：企业开发中如果要切换根控制器，最好都在appdelegate中切换
        NSNotificationCenter.defaultCenter().postNotificationName(XJSwithchRootViewControllerKey, object: true)
    }
    /**
     1.初始化UI
     */
    func setupUI() -> () {
        //1.添加子控件到contentView上
        contentView.addSubview(iconView)
        contentView.addSubview(startButton)
        //2.布局子控件的位置
        iconView.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        startButton.snp_makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(contentView.snp_bottom).offset(-160)
        }
        
    }

    //MARK: - 懒加载
    private lazy var iconView = UIImageView()
     lazy var startButton:UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "new_feature_button"), forState: .Normal)
        btn.setBackgroundImage(UIImage(named: "new_feature_button_highlighted"), forState: .Highlighted)
        btn.hidden = true
        btn.addTarget(self, action: #selector(self.startBtnClick), forControlEvents: .TouchUpInside)
        return btn
    }()
    
}

private class XJNewfeatureLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        //1.设置layout布局
        itemSize = UIScreen.mainScreen().bounds.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .Horizontal
        //2.设置 collectionView的属性
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.bounces = false
        collectionView?.pagingEnabled = true
    }
}


































