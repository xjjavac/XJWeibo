//
//  XJEmoticonPackage.swift
//  表情键盘界面布局
//
//  Created by xj on 9/2/16.
//  Copyright © 2016 xj. All rights reserved.
//

import UIKit

class XJEmoticonPackage: NSObject {
    var id:String?
    var group_name_cn:String?
    var emoticons:[XJEmoticon]?
    static let packageList = XJEmoticonPackage.loadPackages()
    
    private static func loadPackages() -> [XJEmoticonPackage] {
        var packages = [XJEmoticonPackage]()
        //0.创建最近组
        let pk = XJEmoticonPackage(id: "")
        pk.group_name_cn = "最近"
        pk.emoticons = [XJEmoticon]()
        pk.appendEmtyEmoticons()
        packages.append(pk)
        
        let path = NSBundle.mainBundle().pathForResource("emoticons.plist", ofType: nil, inDirectory: "Emoticons.bundle")
        let dict = NSDictionary(contentsOfFile: path!)
        let dictArray = dict!["packages"] as! [[String:AnyObject]]
        for d in dictArray {
            let package = XJEmoticonPackage(id: d["id"] as! String)
            
            packages.append(package)
            package.loadEmoticons()
            package.appendEmtyEmoticons()
        }
        return packages
    }
    func loadEmoticons() -> () {
        let emoticonDict = NSDictionary(contentsOfFile: infoPath("info.plist"))
        group_name_cn = emoticonDict!["group_name_cn"] as? String
        let dictArray = emoticonDict!["emoticons"] as! [[String:String]]
        emoticons = [XJEmoticon]()
        var index = 0
        
        for dict in dictArray {
           
            if index == 20 {
                emoticons?.append(XJEmoticon(isRemoveButton: true))
                index = 0
            }
            index += 1
            emoticons?.append(XJEmoticon(dict: dict, id: id!))
            
        }
    }
    func appendEmtyEmoticons() -> Void {
        let count = emoticons!.count % 21
        for _ in count..<20 {
            emoticons?.append(XJEmoticon(isRemoveButton: false))
        }
        emoticons?.append(XJEmoticon(isRemoveButton: true))
        
        
    }
    /**
     用于给最近添加表情
     */
    func appendEmoticons(emoticon:XJEmoticon) -> () {
        //1.判断是否是删除按钮
        if emoticon.isRemoveButton {
            return
        }
        //2.判断当前点击的表情是否已经添加到最近数组中
        let contains = emoticons!.contains(emoticon)
        if !contains {
            emoticons?.removeLast()
            emoticons?.append(emoticon)
            
        }
        //3.对数组进行排序
        var result = emoticons?.sort({ (e1, e2) -> Bool in
            return e1.times > e2.times
        })
        if !contains {
            result?.removeLast()
            result?.append(XJEmoticon(isRemoveButton: true))
        }
        emoticons = result
    }
    func infoPath(fileName:String) ->  String{
        return (XJEmoticonPackage.emoticonPath().stringByAppendingPathComponent(id!) as NSString).stringByAppendingPathComponent(fileName)
    }
    static func emoticonPath() -> NSString {
        return (NSBundle.mainBundle().bundlePath as NSString).stringByAppendingPathComponent("Emoticons.bundle")
    }
    init(id:String) {
        self.id = id
    }
}
class XJEmoticon: NSObject {
    //表情对应的文字
    var chs:String?
    var png:String?{
        didSet{
            imagePath = (XJEmoticonPackage.emoticonPath().stringByAppendingPathComponent(id!) as NSString).stringByAppendingPathComponent(png!)
        }
    }
    var code:String?{
        didSet{
            let scanner = NSScanner(string: code!)
            var result:UInt32 = 0
            scanner.scanHexInt(&result)
            emojiStr = "\(Character(UnicodeScalar(result)))"
            
            
            
        }
    }
    var emojiStr:String?
    var id:String?
    var imagePath:String?
    var isRemoveButton = false
    var times = 0
    init(isRemoveButton:Bool) {
        self.isRemoveButton = isRemoveButton
        super.init()
    }
    init(dict:[String:String],id:String) {
        self.id = id
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
}




























