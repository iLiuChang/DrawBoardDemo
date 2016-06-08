//
//  LCDrawView.swift
//  DrawBoardDemo
//
//  Created by 刘畅 on 16/6/8.
//  Copyright © 2016年 ifdoo. All rights reserved.
//

import UIKit

class LCDrawView: UIView {
    private var lastLayer: CAShapeLayer!
    private var lastPath: UIBezierPath!
    private var layers: [CAShapeLayer]!
    private var cancelLayers: [CAShapeLayer]!
    
    // MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        layers = []
        cancelLayers = []
        initButtons(frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private mothods
    func initButtons(frame: CGRect) {
        let titles = ["删除","撤销","恢复"]
        let BtnW = frame.width / 3
        for i in 0 ..< titles.count {
           let button = UIButton()
            button.tag = 100 + i
            button.frame = CGRectMake(BtnW * CGFloat(i), 20, BtnW, 30)
            button.setTitle(titles[i], forState: .Normal)
            button.setTitleColor(UIColor.blueColor(), forState: .Normal)
            button.setTitleColor(UIColor.lightGrayColor(), forState: .Highlighted)
            button.addTarget(self, action: #selector(self.click(_:)), forControlEvents: .TouchUpInside)
            self.addSubview(button)
        }
    }
    // 获取点
    func pointWithTouches(touches: Set<UITouch>) -> CGPoint {
        let touch = (touches as NSSet).anyObject()
        return (touch?.locationInView(self))!
    }
    
    func initStartPath(startPoint: CGPoint) {
        let path = UIBezierPath()
        path.lineWidth = 2
        // 线条拐角
        path.lineCapStyle = .Round
        // 终点处理
        path.lineJoinStyle = .Round
        // 设置起点
        path.moveToPoint(startPoint)
        lastPath = path
        
        let shaperLayer = CAShapeLayer()
        shaperLayer.path = path.CGPath
        shaperLayer.fillColor = UIColor.clearColor().CGColor
        shaperLayer.lineCap = kCALineCapRound
        shaperLayer.lineJoin = kCALineJoinRound
        shaperLayer.strokeColor = UIColor.redColor().CGColor
        shaperLayer.lineWidth = path.lineWidth
        self.layer.addSublayer(shaperLayer)
        lastLayer = shaperLayer
        layers.append(shaperLayer)
    }
    
    // MARK: - response events
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let point = self.pointWithTouches(touches)
        if event?.allTouches()?.count == 1 {
            initStartPath(point)
        }
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let point = self.pointWithTouches(touches)
        if event?.allTouches()?.count == 1 {
            // 终点
            lastPath.addLineToPoint(point)
            lastLayer.path = lastPath.CGPath
        }
    }
    func click(button: UIButton) {
        let tag = button.tag
        switch tag {
        case 100:
            remove()
        case 101:
            cancel()
        case 102:
            redo()
        default:
            break
        }
    }
    
    // 删除
    func remove() {
        if layers.count == 0 {
            return
        }
        for slayer in layers {
            slayer.removeFromSuperlayer()
        }
        layers.removeAll()
        cancelLayers.removeAll()
    }
    
    // 撤销
    func cancel() {
       
        if layers.count == 0 {
            return
        }
        layers.last?.removeFromSuperlayer()
        cancelLayers.append(layers.last!)
        layers.removeLast()
    }
    
    // 恢复
    func redo() {
        if cancelLayers.count == 0 {
            return
        }
        self.layer.addSublayer(cancelLayers.last!)
        layers.append(cancelLayers.last!)
        cancelLayers.removeLast()
    }
 
    
    
  
}
