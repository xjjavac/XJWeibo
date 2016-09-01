//
//  UILabel+XJExtension.swift
//  XJWeibo
//
//  Created by xj on 8/31/16.
//  Copyright © 2016 xj. All rights reserved.
//

import UIKit

extension UILabel{
    //快速创建一个UILabel
    static func createLabel(color:UIColor,fontSize:CGFloat) -> UILabel {
        let label = UILabel()
        label.textColor = color
        label.font = UIFont.systemFontOfSize(fontSize)
        return label
    }

}

















