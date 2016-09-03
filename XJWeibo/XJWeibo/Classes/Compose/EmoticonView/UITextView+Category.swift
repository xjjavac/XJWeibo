//
//  UITextView+Category.swift
//  表情键盘界面布局
//
//  Created by xj on 9/3/16.
//  Copyright © 2016 xj. All rights reserved.
//

import UIKit

extension UITextView{
    func emoticonAttributedText() -> String {
        var strM = String()
        attributedText.enumerateAttributesInRange(NSMakeRange(0,attributedText.length), options: NSAttributedStringEnumerationOptions(rawValue:0)) {[weak self] (objc, range, _) in
            
            if objc["NSAttachment"] != nil{
                let attachment = objc["NSAttachment"] as! XJEmoticonTextAttachment
                strM += attachment.chs!
            }else{
                strM += (self!.text as NSString).substringWithRange(range)
            }
        }
        return strM
    }
    func insertEmoticon(emoticon:XJEmoticon) -> () {
        //0.处理删除按钮
        if emoticon.isRemoveButton {
            deleteBackward()
        }
        //1.判断当前点击的是否是emoji表情
        if emoticon.emojiStr != nil{
            replaceRange(selectedTextRange!, withText: emoticon.emojiStr!)
        }
        //2.判断当前点击的是否是表情图片
        if emoticon.png != nil{
            //1.创建表情字符串
            
            let imageText = XJEmoticonTextAttachment.imageText(emoticon, font: font!)
            //3.拿到当前所有的内容
            
            let range = selectedRange
            let strM = NSMutableAttributedString(attributedString: attributedText)
            strM.replaceCharactersInRange(range, withAttributedString: imageText)
            strM.addAttribute(NSFontAttributeName, value: font!, range: NSMakeRange(range.location, 1))
            attributedText = strM
            //两个参数：第一个是指定光标所在的位置，第二个参数是选中文本的个数
            selectedRange = NSMakeRange(range.location + 1, 0)
            
        }

    }
    
}
