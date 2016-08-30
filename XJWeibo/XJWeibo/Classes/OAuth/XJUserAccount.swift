//
//  XJUserAccount.swift
//  XJWeibo
//
//  Created by xj on 8/30/16.
//  Copyright © 2016 xj. All rights reserved.
//

import UIKit
import SVProgressHUD
class XJUserAccount: NSObject ,NSCoding{
    //用户授权的唯一票据，用于调用微博的开放接口，同时也是第三方应用验证微博用户登录的唯一票据，第三方应用应该用该票据和自己应用内的用户建立唯一影射关系，来识别登录状态，不能使用本返回值里的UID字段来做登录识别。
    var access_token = ""
    //access_token的生命周期，单位是秒数。
    var expires_in = 0{
        didSet{
        
            expires_Date = NSDate(timeIntervalSinceNow: Double(expires_in))
            print(expires_Date)
        }
    }
    var expires_Date = NSDate()
    //授权用户的UID，本字段只是为了方便开发者，减少一次user/show接口调用而返回的，第三方应用不能用此字段作为用户登录状态的识别，只有access_token才是用户授权的唯一票据。
    var uid = 0
    
    var avatar_large = ""
    var screen_name = ""
    
    override init() {
        super.init()
    }
    /**
     返回用户是否登录
     */
    static func userLogin() -> Bool {
        return XJUserAccount.loadAccount() != nil
    }
    //MARK: - 保存和读取 Keyed
    func saveAccount() -> Void {
//        let path = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).last!
//        let filePath = (path as NSString).stringByAppendingPathComponent("account.plist")
        
        NSKeyedArchiver.archiveRootObject(self, toFile: "account.plist".cacheDir())
        
    }
    static var account:XJUserAccount?
    static func loadAccount() -> XJUserAccount? {
//        let path = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).last!
//        let filePath = (path as NSString).stringByAppendingPathComponent("account.plist")
        if account != nil {
            return account
        }
        account = NSKeyedUnarchiver.unarchiveObjectWithFile("account.plist".cacheDir()) as? XJUserAccount
        if account?.expires_Date.compare(NSDate()) == NSComparisonResult.OrderedAscending {
            return nil
        }
        return account
        
    }
    //MARK: - nscoding
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeInteger(expires_in, forKey: "expires_in")
        aCoder.encodeInteger(uid, forKey: "uid")
        aCoder.encodeObject(expires_Date, forKey: "expires_Date")
        aCoder.encodeObject(screen_name, forKey: "screen_name")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
    }
    required init?(coder aDecoder: NSCoder){
        access_token = aDecoder.decodeObjectForKey("access_token") as! String
        expires_in = aDecoder.decodeIntegerForKey("expires_in")
        uid = aDecoder.decodeIntegerForKey("uid")
        expires_Date = aDecoder.decodeObjectForKey("expires_Date") as! NSDate
        screen_name = aDecoder.decodeObjectForKey("screen_name") as! String
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as! String
    
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    func loadUserInfo(finished:(account:XJUserAccount?,error:NSError?)->Void) -> Void {
        let path = "2/users/show.json"
        let params = ["access_token":access_token,"uid":uid]
        XJNetworkTools.shareNetworkTools().GET(path, parameters: params, progress: { (_) in
            
            }, success: { (_, JSON) in
                if let dict = JSON as? [String:AnyObject]{
                    self.screen_name = dict["screen_name"] as! String
                    self.avatar_large = dict["avatar_large"] as! String
//                self.saveAccount()
                    finished(account: self, error: nil)
                    return
                }
                finished(account: nil, error: nil)
            }) { (_, error) in
                print(error)
                finished(account: nil, error: error)
        }
        
    }
    override var description: String{
        get{
            let properties = ["access_token","expires_in","uid"]
            let dict = self.dictionaryWithValuesForKeys(properties)
            return "\(dict)"
            
            
        }
    }
    
}









