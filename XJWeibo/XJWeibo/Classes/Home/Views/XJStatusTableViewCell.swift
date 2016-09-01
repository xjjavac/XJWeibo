//
//  XJStatusTableViewCell.swift
//  XJWeibo
//
//  Created by xj on 8/31/16.
//  Copyright © 2016 xj. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage
class XJStatusTableViewCell: UITableViewCell {
    let XJPictureReuseIdentifier = "XJPictureReuseIdentifier"
    var sizeconstraint:Constraint!
    
    var status = XJStatus(){
        didSet{

            nameLabel.text = status.user.name
            timeLabel.text = status.created_at
            
            contentLabel.text = status.text
            //设置用户头像
            if let url = NSURL(string: status.user.profile_image_url){
            iconView.sd_setImageWithURL(url)
            }
            //设置认证图标
            verifiedView.image = status.user.verifiedImage
            //设置会员图标
            vipView.image = status.user.mbrankImage
            //设置来源
            sourceLabel.text = status.source
            
            //设置配图的尺寸
            //1.1根据模型计算配图的尺寸
            let size = calculateImageSize()
            
            pictureView.snp_updateConstraints { (make) in
                
                make.size.equalTo(size)
            }
          
            pictureView.reloadData()
            //1.2设置配图的尺寸
            
        }
    }
    
    //自定义一个类需要重写的init方法是 designated
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //初始化UI
        setupUI()
        //初始化配图
        setupPictureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI() -> () {
        //1.添加子控件
        contentView.addSubview(iconView)
        contentView.addSubview(verifiedView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(vipView)
        contentView.addSubview(timeLabel)
        contentView.addSubview(sourceLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(footerView)
        contentView.addSubview(pictureView)
        //2.布局子控件
        iconView.snp_makeConstraints { (make) in
            make.top.equalTo(contentView.snp_top).offset(10)
            make.left.equalTo(contentView.snp_left).offset(10)
            make.size.equalTo(CGSizeMake(50, 50))
        }
        verifiedView.snp_makeConstraints { (make) in
            make.centerX.equalTo(iconView.snp_right)
            make.centerY.equalTo(iconView.snp_bottom)
            make.size.equalTo(CGSizeMake(14, 14))
        }
        nameLabel.snp_makeConstraints { (make) in
            make.top.equalTo(iconView)
            make.left.equalTo(iconView.snp_right).offset(10)
        }
        vipView.snp_makeConstraints { (make) in
            make.top.equalTo(nameLabel)
            make.left.equalTo(nameLabel.snp_right).offset(10)
        }
        timeLabel.snp_makeConstraints { (make) in
            make.bottom.equalTo(iconView.snp_bottom)
            make.left.equalTo(iconView.snp_right).offset(10)
        }
        sourceLabel.snp_makeConstraints { (make) in
            make.left.equalTo(timeLabel.snp_right).offset(10)
            make.top.equalTo(timeLabel)
        }
        contentLabel.snp_makeConstraints { (make) in
            make.top.equalTo(iconView.snp_bottom).offset(10)
            make.left.equalTo(iconView)
            
            
        }
        pictureView.snp_makeConstraints { (make) in
            make.left.equalTo(contentLabel)
            make.top.equalTo(contentLabel.snp_bottom).offset(10)
            make.size.equalTo(CGSizeMake(290, 290))
           
            
        }
        footerView.snp_makeConstraints { (make) in
            
            make.top.equalTo(pictureView.snp_bottom).offset(10)
            make.size.equalTo(CGSizeMake(UIScreen.mainScreen().bounds.width, 44))
        }
        
    }
    func rowHeight(status:XJStatus) -> CGFloat {
        //1.为了能够调用didSet,计算配图的高度
        self.status = status
        //2.强制跟新界面
        self.layoutIfNeeded()
        //3.返回底部视图的最大得Y值
        return CGRectGetMaxY(footerView.frame)
    }
    /**
     计算配图尺寸
     */
    func calculateImageSize() -> CGSize {
        //1.取出配图个数
        let count = status.storedPicUrls?.count
        
        //2.如果没有配图zero
        if count == 0 || count == nil {
            return CGSizeZero
        }
        //3.如果只有一张配图，返回图片的实际大小
        if count == 1 {
            //3.1 取出缓存的图片
            let key = status.storedPicUrls?.first?.absoluteString
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(key!)
            pictureLayout.itemSize = image.size
            //3.2返回缓存 图片的尺寸
            return image.size
            
        }
        //4.如果有4张配图，计算田字格的大小
        let width:CGFloat = 90
        let margin:CGFloat = 10
        pictureLayout.itemSize = CGSizeMake(width, width)
        if count == 4 {
            let viewWidth = width*2 + margin
            return CGSizeMake(viewWidth, viewWidth)
            
        }
        
        
        //5.如果是其他（多张），计算九宫格的大小
        //5.1计算列数
        let colNumber = 3
        //5.2计算行数
        let rowNumber = (count! - 1)/3 + 1
        let viewWidth = CGFloat(colNumber)*width + (CGFloat(colNumber) - 1) * margin
        let viewHeight = CGFloat(rowNumber) * width + (CGFloat(rowNumber) - 1) * margin
        
        return CGSizeMake(viewWidth, viewHeight)
        
        
    }
    /**
     初始化配图的相关属性
     */
    private func setupPictureView(){
        //1.注册cell
        pictureView.registerClass(XJPictureViewCell.self, forCellWithReuseIdentifier: XJPictureReuseIdentifier)
        pictureView.dataSource = self
        //2.设置cell之间的间隙
        pictureLayout.minimumLineSpacing = 10
        pictureLayout.minimumInteritemSpacing = 10
        //3.设置配图的背景颜色
        pictureView.backgroundColor = UIColor.whiteColor()
    }
    //MARK: - 懒加载
    //头像
    private lazy var iconView:UIImageView = {
        let iv = UIImageView(image: UIImage(named: "avatar_default_big"))
        return iv
    }()
    //认证图标
    private lazy var verifiedView = UIImageView(image: UIImage(named: "avatar_enterprise_vip"))
    //昵称
    private lazy var nameLabel:UILabel = UILabel.createLabel(UIColor.darkGrayColor(), fontSize:14)
    //会员图标
    private lazy var vipView = UIImageView(image: UIImage(named: "common_icon_membership"))
    //时间
    private lazy var timeLabel:UILabel = UILabel.createLabel(UIColor.darkGrayColor(), fontSize:14)
    //来源
    private lazy var sourceLabel:UILabel = UILabel.createLabel(UIColor.darkGrayColor(), fontSize:14)
    //正文
    private lazy var contentLabel:UILabel = {
        let label = UILabel.createLabel(UIColor.darkGrayColor(), fontSize:15)
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 20
        return label
    }()
    private lazy var pictureLayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private lazy var pictureView:UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: self.pictureLayout)
    //底部工具条
    private lazy var footerView:XJStatusTableViewBottomView = XJStatusTableViewBottomView()
}


extension XJStatusTableViewCell: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return status.storedPicUrls?.count ?? 0
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //1.取出cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(XJPictureReuseIdentifier, forIndexPath: indexPath) as! XJPictureViewCell
        //2.设置数据
        cell.imageURL = status.storedPicUrls![indexPath.item]
        //3.返回cell
        return cell
    }
}
class XJPictureViewCell: UICollectionViewCell {
    //定义属性接收外界传人的数据
    var imageURL:NSURL?{
        didSet{
            iconImageView.sd_setImageWithURL(imageURL!)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        //1.添加子控件
        contentView.addSubview(iconImageView)
        //2.布局子控件
        iconImageView.snp_makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - 懒加载
    private lazy var iconImageView:UIImageView = UIImageView()
}



