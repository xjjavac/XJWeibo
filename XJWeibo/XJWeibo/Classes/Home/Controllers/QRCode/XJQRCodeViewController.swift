//
//  XJQRCodeViewController.swift
//  XJWeibo
//
//  Created by xj on 8/29/16.
//  Copyright © 2016 xj. All rights reserved.
//

import UIKit
import AVFoundation
class XJQRCodeViewController: UIViewController,UITabBarDelegate {
    //冲击波视图
    @IBOutlet weak var scanLineView: UIImageView!
    //扫描容器高度约束
    @IBOutlet weak var containerHeightCons: NSLayoutConstraint!
    //冲击波视图顶部约束
    @IBOutlet weak var scanLineCons: NSLayoutConstraint!
    //底部视图
    @IBOutlet weak var customTabBar: UITabBar!
    @IBAction func closeBtnClick(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //1.设置底部视图默认选中第0个
        customTabBar.selectedItem = customTabBar.items![0]
        customTabBar.delegate = self
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //1.开始冲击波动画
        startAnimation()
        //2.开始扫描
        startScan()
    }
    /**
     扫描二维码
     */
    func startScan() -> Void {
        //1.判断是否能够将输入添加到回话中
        if !session.canAddInput(deviceInput){
            return
        }
        //2.判断是否能够将输出添加到动画中
        if !session.canAddOutput(output) {
            return
        }
        //3.将输入和输出都添加到回话中
        session.addInput(deviceInput)
        session.addOutput(output)
        //4.设置输出能够解析的数据类型
        //注意：设置能够解析的数据类型，一定要在输出对象添加到回话之后设置，否则会报错
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        //5.设置输出对象的代理，只要解析成功就会通知代理
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        //添加预览图层
        view.layer.insertSublayer(previewLayer, atIndex: 0)
        //6.告诉session开始扫描
        session.startRunning()
    }
    //执行动画
    func startAnimation() -> Void {
        //让约束从顶部开始
        scanLineCons.constant = -containerHeightCons.constant
        scanLineView.layoutIfNeeded()
        //执行冲击波动画
        
        UIView.animateWithDuration(2.0, animations: {
            //1.修改约束
            self.scanLineCons.constant = self.containerHeightCons.constant
            //设置动画指定的次数
            UIView.setAnimationRepeatCount(MAXFLOAT)
            //2.强制更新界面
            self.scanLineView.layoutIfNeeded()
            }, completion: nil)
    }
    //MARK: - UITabBarDelegate
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if item.tag == 1 {
            containerHeightCons.constant = 300
        }else{
            containerHeightCons.constant = 150
        }
        scanLineView.layer.removeAllAnimations()
        startAnimation()
    }
    //MARK: - 懒加载
    //回话
    private lazy var session = AVCaptureSession()
    //拿到输入设备
    private lazy var deviceInput:AVCaptureDeviceInput? = {
        //获取摄像头
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeAudio)
       
        do{
            let input =  try AVCaptureDeviceInput(device: device)
            return input
        }catch{
            print(error)
            return nil
        }
        
    }()
    //拿到输出对象
    private lazy var output = AVCaptureMetadataOutput()
    //创建预览图层
    private lazy var previewLayer:AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: self.session)
        layer.frame = UIScreen.mainScreen().bounds
        return layer
    
    }()
}

extension XJQRCodeViewController:AVCaptureMetadataOutputObjectsDelegate{

    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!){
        print(metadataObjects)
    }
}

















































