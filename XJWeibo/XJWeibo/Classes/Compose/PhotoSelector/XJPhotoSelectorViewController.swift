//
//  XJPhotoSelectorViewController.swift
//  图片选择器
//
//  Created by xj on 9/3/16.
//  Copyright © 2016 xj. All rights reserved.
//

import UIKit
private let XJPhotoSelectorCellReuseIdentifier = "XJPhotoSelectorCellReuseIdentifier"
class XJPhotoSelectorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    func setupUI() -> Void {
        //1.添加子控件
        view.addSubview(collectionView)
        
       
    }
    /**
     布局子控件
     */
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.frame = view.bounds
    }
    //MARK: - 懒加载
    private lazy var collectionView: UICollectionView = {
        let clv = UICollectionView(frame: CGRectZero, collectionViewLayout: XJPhotoSelectorViewLayout())
        clv.registerClass(XJPhotoSelectorCell.self, forCellWithReuseIdentifier: XJPhotoSelectorCellReuseIdentifier)
        clv.dataSource = self
        
        return clv
    }()
    lazy var pictureImages = [UIImage]()
}
extension XJPhotoSelectorViewController:UICollectionViewDataSource,XJPhotoSelectorCellDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureImages.count + 1
//        return 10
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(XJPhotoSelectorCellReuseIdentifier, forIndexPath: indexPath) as! XJPhotoSelectorCell
        cell.backgroundColor = UIColor.greenColor()
        
        cell.image = (pictureImages.count == indexPath.item) ?  nil : pictureImages[indexPath.item]
        cell.photoCellDelegate = self
        return cell
        
    }
    func photoDidAddSelector(cell: XJPhotoSelectorCell) {
        //1.判断能否打开照片库
        if !UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary){
            return
        }
        //2.创建图片选择器
        let vc = UIImagePickerController()
        vc.delegate = self
        //设置允许用户编辑选中的图片
        //开放中如果需要上传头像，那么请让用户编辑之后再上传
        //这样可以得到一张正方形的图片，以便于后期处理（圆行）
//        vc.allowsEditing = true
        presentViewController(vc, animated: true, completion: nil)
        
        
    }
    func photoDidRemoveSelector(cell: XJPhotoSelectorCell) {
        //1.从数组中移除“当前点击”的图片
        let indexPath = collectionView.indexPathForCell(cell)
        pictureImages.removeAtIndex(indexPath!.item)
        //2.刷新表格
        collectionView.reloadData()
    }
    /**
     选中相片之后调用
     - parameter picker:      促发事件的控制器
     - parameter image:       当前选中的图片
     - parameter editingInfo: 编辑之后的图片
     */
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        /** 
        注意： 一般情况下，只要涉及到从相册中获取图片的功能，都需要处理内存
         一般情况下一个应用程序启动会占用20M左右的内存，当内存飙升
         到500M左右的时候系统就会发生内存警告，此时就需要释放内存，否则就会闪退
         只要内存释放到100M左右，那么系统就不会闪退我们的应用程序
         也就是说一个应用程序占用的内存20~100时时比较安全的内存范围
         */
        
        pictureImages.append(image.imageWithScale(300))
        collectionView.reloadData()
        //注意：如果实现了该方法，需要我们自己关闭图片选择器
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}
@objc
protocol XJPhotoSelectorCellDelegate:NSObjectProtocol {
    optional func photoDidAddSelector(cell:XJPhotoSelectorCell)
    optional func photoDidRemoveSelector(cell:XJPhotoSelectorCell)
}
class XJPhotoSelectorCell: UICollectionViewCell {
    weak var photoCellDelegate:XJPhotoSelectorCellDelegate?
    var image:UIImage?{
        didSet{
            if image != nil {
                removeButton.hidden = false
                addButton.setBackgroundImage(image!, forState: .Normal)
                
                addButton.userInteractionEnabled = false
            }else{
                removeButton.hidden = true
                addButton.userInteractionEnabled = true
                addButton.setBackgroundImage(UIImage(named: "compose_pic_add"), forState: .Normal)
                addButton.setBackgroundImage(UIImage(named: "compose_pic_add_highlighted"), forState: .Highlighted)
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    func setupUI() -> () {
        //1.添加子控件
        contentView.addSubview(addButton)
        contentView.addSubview(removeButton)
        //2.布局子控件
    }
    /**
     //2.布局子控件
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        addButton.frame = contentView.bounds
        removeButton.frame.origin.y = 2
        removeButton.sizeToFit()
        removeButton.frame.origin.x = contentView.frame.width - 2 - removeButton.frame.size.width
        
    }
    func removeBtnClick() -> Void {
        photoCellDelegate?.photoDidRemoveSelector!(self)
    }
    func addBtnClick() -> Void {
        photoCellDelegate?.photoDidAddSelector!(self)
    }
    //MARK: - 懒加载
    private lazy var removeButton:UIButton = {
        let btn = UIButton()
        btn.hidden = true
        btn.setBackgroundImage(UIImage(named: "compose_photo_close"), forState: .Normal)
        btn.addTarget(self, action: #selector(self.removeBtnClick), forControlEvents: .TouchUpInside)
        return btn
    }()
    
    private lazy var addButton:UIButton = {
        let btn = UIButton()
        btn.imageView?.contentMode = .ScaleAspectFill
        btn.setBackgroundImage(UIImage(named: "compose_pic_add"), forState: .Normal)
        btn.setBackgroundImage(UIImage(named: "compose_pic_add_highlighted"), forState: .Highlighted)
        btn.addTarget(self, action: #selector(self.addBtnClick), forControlEvents: .TouchUpInside)
        return btn
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class XJPhotoSelectorViewLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        super.prepareLayout()
        itemSize = CGSizeMake(80, 80)
        minimumLineSpacing = 10
        minimumInteritemSpacing = 10
        sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
    }
}














































