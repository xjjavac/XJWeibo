//
//  XJOAuthViewController.swift
//  XJWeibo
//
//  Created by xj on 8/30/16.
//  Copyright © 2016 xj. All rights reserved.
//

import UIKit
import SVProgressHUD
class XJOAuthViewController: UIViewController {
    let WB_App_Key = "168579185"
    let WB_App_Secret = "06bbe1e73c4da1ddeaeebcbbb2ec28f5"
    let WB_redirect_uri = "https://xjswift.github.io"
    
    override func loadView() {
        webView.delegate = self
        view = webView
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //0.初始化导航条
        navigationItem.title = "枪炮玫瑰微博"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "关闭", style: .Plain, target: self, action: #selector(self.close))
        //1.获取未授权的RequestToken
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(WB_App_Key)&redirect_uri=\(WB_redirect_uri)"
        let url = NSURL(string: urlStr)
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
        
        

        
    }
    func close() -> Void {
        dismissViewControllerAnimated(true, completion: nil)
    }
   //MARK: - 懒加载
    private lazy var webView:UIWebView = {
        let wv = UIWebView()
        return wv
    }()
    

}
extension XJOAuthViewController:UIWebViewDelegate{

    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool{
        //1.判断是否是授权回调页面，如果不是就继续加载
        let urlStr = request.URL!.absoluteString
        
        if !urlStr.hasPrefix(WB_redirect_uri) {
            return true
        }
        //2.判断是否授权成功
        let codeStr = "code="
        if request.URL!.query!.hasPrefix(codeStr) {
            //授权成功
            let code = request.URL!.query!.substringFromIndex(codeStr.endIndex)
            //2.利用已经授权的RequestToken换取AccessToken
            loadAccessToken(code)
        }else{
        
            //取消授权
            close()
        }
        return false
    }
    func webViewDidStartLoad(webView: UIWebView) {
        //提示用户正在加载
        SVProgressHUD.showInfoWithStatus("正在加载。。。")
        SVProgressHUD.setDefaultMaskType(.Black)
    }
    func webViewDidFinishLoad(webView: UIWebView) {
       SVProgressHUD.dismiss()
    }
    
    /**
     换取AccessToken
     
     - parameter code: 已经授权的RequestToken
     */
    func loadAccessToken(code:String) -> Void {
        //1.定义路径
        let path = "oauth2/access_token"
        //2.封装参数
        var params = [String:String]()
        params.updateValue(WB_App_Key, forKey: "client_id")
        params.updateValue(WB_App_Secret, forKey: "client_secret")
        params.updateValue("authorization_code", forKey: "grant_type")
        params.updateValue(code, forKey: "code")
        params.updateValue(WB_redirect_uri, forKey: "redirect_uri")
        //发送POST请求
        XJNetworkTools.shareNetworkTools().POST(path, parameters: params, progress: { (progress) in
            
            }, success: { (_, json) in
                //1.字典转模型
                let account = XJUserAccount()
                account.setValuesForKeysWithDictionary(json as! [String:AnyObject])
                //2.获取用户信息
                account.loadUserInfo({ (account, error) in
                    if account != nil{
                        account!.saveAccount()
                        //去欢迎界面
                        NSNotificationCenter.defaultCenter().postNotificationName(XJSwithchRootViewControllerKey, object: false)
                        return
                    }
                    SVProgressHUD.showInfoWithStatus("网络不给力")
                    SVProgressHUD.setDefaultMaskType(.Black)
                })
                //2.归档模型
//                account.saveAccount()
            }) { (_, error) in
                print(error)
        }
    }
}
































