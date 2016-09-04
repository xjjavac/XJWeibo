//
//  UIImage+Category.swift
//  图片选择器
//
//  Created by xj on 9/3/16.
//  Copyright © 2016 xj. All rights reserved.
//

import UIKit

extension UIImage{
    /**
     根据传入的宽度生成一张图片
     按照图片的宽高比来压缩以前的图片
     
     - parameter width:
     */
    func imageWithScale(width:CGFloat) -> UIImage {
        //1.根据宽度计算高度
        let height = width * size.height/size.width
        //2.按照宽高比绘制一张新的图片
        let currentSize = CGSizeMake(width, height)
        UIGraphicsBeginImageContext(currentSize)
        drawInRect(CGRect(origin: CGPointZero, size: currentSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
        
    }
}


























