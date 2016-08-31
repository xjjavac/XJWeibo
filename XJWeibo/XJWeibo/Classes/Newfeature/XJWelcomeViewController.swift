//
//  XJWelcomeViewController.swift
//  XJWeibo
//
//  Created by xj on 8/31/16.
//  Copyright © 2016 xj. All rights reserved.
//

import UIKit
import SDWebImage
import SnapKit
class XJWelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //1.添加子控件
        view.addSubview(bgIV)
        view.addSubview(iconView)
        view.addSubview(messageLabel)
        //2.布局子控件
        bgIV.snp_makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        messageLabel.snp_makeConstraints { (make) in
            make.center.equalTo(view)
        }
        iconView.snp_makeConstraints { (make) in
            make.bottom.equalTo(messageLabel.snp_top).offset(-10)
            make.centerX.equalTo(messageLabel)
        }
        if let iconUrl = XJUserAccount.loadAccount()?.avatar_large {
            let url = NSURL(string: iconUrl)!
            iconView.sd_setImageWithURL(url)
            
        }
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        weak var weakSelf = self
        UIView.animateWithDuration(2, animations: {
            weakSelf!.messageLabel.alpha = 1.0
            }) { (_) in
                NSNotificationCenter.defaultCenter().postNotificationName(XJSwithchRootViewControllerKey, object: true)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - 懒加载
    private lazy var bgIV:UIImageView = UIImageView(image: UIImage(named: "ad_background"))
    private lazy var iconView:UIImageView = {
        let iv = UIImageView(image: UIImage(named: "avatar_default_big"))
        iv.layer.cornerRadius = iv.image!.size.width*0.5
        iv.clipsToBounds = true
        return iv
    }()
    private lazy var messageLabel:UILabel = {
        let label = UILabel()
        label.text = "欢迎回来"
        label.sizeToFit()
        label.alpha = 0.0
        return label
    
    }()

}

















