//
//  XJEmoticonTextAttachment.swift
//  表情键盘界面布局
//
//  Created by xj on 9/3/16.
//  Copyright © 2016 xj. All rights reserved.
//

import UIKit

class XJEmoticonTextAttachment: NSTextAttachment {
    //保存对应表情的文字
    var chs:String?
    /**
     根据表情模型，创建表情字符串
        */
    static func imageText(emoticon:XJEmoticon,font:UIFont) -> NSAttributedString {
        //1.创建附件
        let attachment = XJEmoticonTextAttachment()
        attachment.chs = emoticon.chs
        attachment.image = UIImage(contentsOfFile: emoticon.imagePath!)
        let s = font.lineHeight
        
        attachment.bounds = CGRectMake(0, -4, s,s)
        //2.根据附件创建属性字符串
        return NSAttributedString(attachment: attachment)
    }
}






























