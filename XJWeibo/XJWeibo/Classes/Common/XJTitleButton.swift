//
//  XJTitleButton.swift
//  XJWeibo
//
//  Created by xj on 8/29/16.
//  Copyright © 2016 xj. All rights reserved.
//

import UIKit

class XJTitleButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        setImage(UIImage(named: "navigationbar_arrow_down"), forState: UIControlState.Normal)
        setImage(UIImage(named: "navigationbar_arrow_up"), forState: UIControlState.Selected)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
//        titleLabel?.frame.offsetInPlace(dx: -imageView!.bounds.width, dy: 0)
//        imageView?.frame.offsetInPlace(dx: titleLabel!.bounds.width, dy: 0)
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = titleLabel!.frame.size.width
        
    }

}





















