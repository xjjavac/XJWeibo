//
//  XJStatus.swift
//  XJWeibo
//
//  Created by xj on 8/31/16.
//  Copyright © 2016 xj. All rights reserved.
//

import UIKit
import SDWebImage
class XJStatus: NSObject {
    //微博创建时间
    var created_at = ""{
        didSet{
            let createdDate = NSDate.dateWithStr(created_at)
            created_at = createdDate.descDate
            
        }
    }
    //微博ID
    var id = 0
    //微博信息内容
    var text = ""
    //微博来源
    var source = ""{
        didSet{
            //1.截取字符串
            
            if source != "" {
                //1.1获取开始截取的位置
                let startLocation = (source as NSString).rangeOfString(">").location + 1
                
                //1.2获取截取的长度
                let length = (source as NSString).rangeOfString("<", options: .BackwardsSearch).location - startLocation
                
                //1.3截取字符串
                source = "来自:"+(source as NSString).substringWithRange(NSMakeRange(startLocation, length))
            }
        
        }
    }
    
    //配图数组
    var pic_urls = [[String:AnyObject]](){
        didSet{
            //1.初始化数组
            storedPicUrls = [NSURL]()
            //2.遍历取出所有的图片路径字符串
            for dict in pic_urls {
                if let urlStr = dict["thumbnail_pic"] {
                    storedPicUrls?.append(NSURL(string: urlStr as! String)!)
                }
            }
        }
    }
    var storedPicUrls:[NSURL]?
    //用户信息
    var user = XJUser()
    
    //加载微博数据
    static func loadStatuses(finished:(models:[XJStatus]?,error:NSError?)->()){
        let path = "2/statuses/home_timeline.json"
        let params = ["access_token":XJUserAccount.loadAccount()!.access_token]
        XJNetworkTools.shareNetworkTools().GET(path, parameters: params, progress: { (_) in
            
            }, success: { (_, json) in
                //1.取出statuses key对应的数组（存储的都是字典）
                //2.遍历数组，将字典转换为模型
                let models = dict2Model(json!["statuses"] as! [[String:AnyObject]])
                //3.缓存微博配图
                cacheStatusImages(models, finished: finished)
                //3.通过闭包将数据传递给调用者
//                finished(models: models, error: nil)
            }) { (_, error) in
                print(error)
                finished(models: nil, error: error)
        }
        
    
    }
    static func cacheStatusImages(list:[XJStatus],finished:(models:[XJStatus]?,error:NSError?)->()) -> () {
        //1.创建一个组
        let group = dispatch_group_create()
        //1.缓存图片
        for status in list {
            //1.1判断当前微博是否有配图，如果没有就直接跳过
            if status.storedPicUrls == nil {
                continue
            }
            for url in status.storedPicUrls! {
                //将当前的下载操作添加到组中
                dispatch_group_enter(group)
                    SDWebImageManager.sharedManager().downloadImageWithURL(url, options: SDWebImageOptions(rawValue:0), progress: nil, completed: { (_, _, _, _, _) in
                    dispatch_group_leave(group)
                })
            }
        }
        dispatch_group_notify(group, dispatch_get_main_queue()) { 
            finished(models: list, error: nil)
        }
    }
    static func dict2Model(list:[[String:AnyObject]]) -> [XJStatus] {
        var models = [XJStatus]()
        for dict in list {
            models.append(XJStatus(dict: dict))
        }
        return models
        
    }
    override init() {
        super.init()
    }
    //字典转模型
    init(dict:[String:AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    override func setValue(value: AnyObject?, forKey key: String) {
        //1.判断当前是否正在给微博字典的user字典赋值
        if key == "user" {
            //2.根据user key 对应的字典创建一个模型
            user = XJUser(dict: value as! [String:AnyObject])
            return
        }
        super.setValue(value, forKey: key)
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    //打印当前模型
    var properties = ["created_at","id","text","source","pic_urls"]
    override var description: String{
        get{
            let dict = dictionaryWithValuesForKeys(properties)
            return "\(dict)"
        }
    
    }
}
























