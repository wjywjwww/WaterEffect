//
//  ViewController.swift
//  关于贝塞尔曲线
//
//  Created by sks on 17/6/5.
//  Copyright © 2017年 besttone. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let slimeView = JYSlimeView.getInstance()
        self.view.addSubview(slimeView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

