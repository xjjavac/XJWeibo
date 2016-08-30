//
//  XJNetworkTools.swift
//  XJWeibo
//
//  Created by xj on 8/30/16.
//  Copyright © 2016 xj. All rights reserved.
//

import UIKit
import AFNetworking
class XJNetworkTools: AFHTTPSessionManager {
    static let tools:XJNetworkTools = {
        //注意：baseURL一定要以/结尾
        let url = NSURL(string: "https://api.weibo.com/")
        let t = XJNetworkTools(baseURL: url)
        //设置AFN能够接收的数据类型
        t.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json", "text/json", "text/javascript", "text/plain") as? Set<String>
        return t
    }()
    /**
     *  获取单例的方法
     */
    static func shareNetworkTools() -> XJNetworkTools {
        return tools
    }
}













