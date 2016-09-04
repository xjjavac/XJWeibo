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
    private override init(baseURL url: NSURL?, sessionConfiguration configuration: NSURLSessionConfiguration?) {
        super.init(baseURL: url, sessionConfiguration: configuration)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
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
    /**
     发送微博
     
     - parameter text:            需要发送的正文
     - parameter image:           需要发送的图片
     - parameter successCallback: 成功的回调
     - parameter errorCallback:   失败的回调
     */
    func sendStatus(text:String,image:UIImage?,successCallback:(status:XJStatus)->(),errorCallback:(error:NSError)->()) -> Void {
        
        var path = "2/statuses/"
        let params = ["access_token":XJUserAccount.loadAccount()!.access_token,"status":text]
        if  image != nil {
            //发送图片微博
            path += "upload.json"
            POST(path, parameters: params, constructingBodyWithBlock: { (formData) in
                //1.将数据转换为二进制
                let data = UIImagePNGRepresentation(image!)
                formData.appendPartWithFileData(data!, name: "pic", fileName: "xj.png", mimeType: "application/octet-stream")
                }, progress: nil, success: { (_, json) in
                    successCallback(status: XJStatus(dict: json as! [String:AnyObject]))
                    
                }, failure: { (_, error) in
                    errorCallback(error: error)
                    
            })
        }else{
            //发送文字微博
            path += "update.json"
            POST(path, parameters: params, progress: nil, success: { (_, json) in
                successCallback(status: XJStatus(dict: json as! [String:AnyObject]))
            }) { (_, error) in
               errorCallback(error: error)
            }
        }

    }
}

































