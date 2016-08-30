//
//  String+XJExtension.swift
//  XJWeibo
//
//  Created by xj on 8/30/16.
//  Copyright © 2016 xj. All rights reserved.
//

import UIKit

extension String{
    /**
     *  将当前字符串拼接到cache目录后面
     */
    func cacheDir() -> String {
        let path = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).last! as NSString
        return path.stringByAppendingPathComponent((self as NSString).lastPathComponent)
    }
    /**
     *  将当前字符串拼接到doc目录后面
     */
    func docDir() -> String {
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last! as NSString
        return path.stringByAppendingPathComponent((self as NSString).lastPathComponent)
        
    }
    /**
     *  将当前字符串拼接到tmp目录后面
     */
    func temDir() -> String {
        let path = NSTemporaryDirectory() as NSString
        return path.stringByAppendingPathComponent((self as NSString).lastPathComponent)
        
    }
}
























