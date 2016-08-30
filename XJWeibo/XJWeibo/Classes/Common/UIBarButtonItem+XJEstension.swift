//
//  UIBarButtonItem+XJEstension.swift
//  XJWeibo
//
//  Created by xj on 8/29/16.
//  Copyright © 2016 xj. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    static func creatBarButtonItem(imageName:String,target: AnyObject?,action: Selector) -> UIBarButtonItem {
        let btn = UIButton()
        btn.setImage(UIImage(named:imageName), forState: .Normal)
        btn.setImage(UIImage(named:"\(imageName)_highlighted"), forState: .Highlighted)
        btn.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        btn.sizeToFit()
        return UIBarButtonItem(customView: btn)
    }
}
