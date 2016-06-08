//
//  ViewController.swift
//  DrawBoardDemo
//
//  Created by 刘畅 on 16/6/8.
//  Copyright © 2016年 ifdoo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let drawView = LCDrawView(frame: self.view.bounds)
        self.view.addSubview(drawView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

