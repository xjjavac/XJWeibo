//
//  XJStatusTableViewBottomView.swift
//  XJWeibo
//
//  Created by xj on 9/1/16.
//  Copyright © 2016 xj. All rights reserved.
//

import UIKit

class XJStatusTableViewBottomView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        //初始化UI
        setupUI()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI() -> () {
        self.backgroundColor = UIColor(white: 0.2, alpha: 0.5)
        //1.添加子控件
        addSubview(retweetBtn)
        addSubview(unlikeBtn)
        addSubview(commonBtn)
          }
    //MARK: - 懒加载
    //转发
    let screenW = UIScreen.mainScreen().bounds.width/3
    
    override func layoutSubviews() {
        super.layoutSubviews()
        retweetBtn.frame = CGRectMake(0, 0, screenW, 44)
        unlikeBtn.frame = CGRectMake(screenW, 0, screenW, 44)
        commonBtn.frame = CGRectMake(2*screenW, 0, screenW, 44)
    }
    private lazy var retweetBtn: UIButton = UIButton.createButton("timeline_icon_retweet", title: "转发")
    //赞
    private lazy var unlikeBtn: UIButton = UIButton.createButton("timeline_icon_unlike", title: "赞")
    
    //评论
    private lazy var commonBtn: UIButton = UIButton.createButton("timeline_icon_comment", title: "评论")

}
