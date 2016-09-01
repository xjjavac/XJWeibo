//
//  XJUIButton+XJExtension.swift
//  XJWeibo
//
//  Created by xj on 8/31/16.
//  Copyright © 2016 xj. All rights reserved.
//

import UIKit

extension UIButton{
    static func createButton(imageName:String,title:String) -> UIButton {
        let btn = UIButton()
        btn.setImage(UIImage(named:imageName), forState: .Normal)
        btn.setTitle(title, forState: .Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(10)
        btn.setBackgroundImage(UIImage(named: "timeline_card_bottom_background"), forState: .Normal)
        btn.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        return btn
    }
}




















