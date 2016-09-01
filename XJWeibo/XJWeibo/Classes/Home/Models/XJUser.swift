//
//  XJUser.swift
//  XJWeibo
//
//  Created by xj on 8/31/16.
//  Copyright © 2016 xj. All rights reserved.
//

import UIKit

class XJUser: NSObject {
    //用户id
    var id = 0
    //好友显示名称
    var name = ""
    //用户头像地址
    var profile_image_url = ""
    //是否认证，true是，false不是
    var verified = false
    //用户认证类型 -1没有认证 0 认证用户 2，3，5企业认证 220达人
    var verified_type = -1 {
        didSet{
            switch verified_type {
            case 0:
                verifiedImage = UIImage(named: "avatar_vip")
            case 2,3,5:
                verifiedImage = UIImage(named: "avatar_enterprise_vip")
            case 220:
                verifiedImage = UIImage(named: "avatar_grassroot")
            default:
                verifiedImage = nil
            }
        
        }
    }
    //保存当前用户的认证图片
    var verifiedImage:UIImage?
    
    var mbrank:Int = 0{
        didSet{
            if mbrank > 0&&mbrank < 7 {
                mbrankImage = UIImage(named: "common_icon_membership_level\(mbrank)" )
            }
        }
    }
    var mbrankImage:UIImage?
    
    //字典 转模型
    override init() {
        super.init()
    }
    init(dict: [String:AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    //打印当前模型
    var properties = ["id","name","profile_image_url","verified","verified_type"]
    override var description: String{
        get{
            let dict = dictionaryWithValuesForKeys(properties)
            
            return "\(dict)"
        }
    }
    
    
    
}





















