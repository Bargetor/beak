//
//  BBUIViewExtension.swift
//  Beak
//
//  Created by 马进 on 2016/12/7.
//  Copyright © 2016年 马进. All rights reserved.
//

import Foundation

extension UIView {
    
    open func setTapGesture(_ target: AnyObject?, action: Selector){
        self.isUserInteractionEnabled = true
        
        let tapGR = UITapGestureRecognizer(target: target, action: action)
        //        tapGR.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGR)
    }
    
    open func removeAllSubView(){
        for subview in self.subviews{
            subview.removeFromSuperview()
        }
    }
    
}

extension UIView{
    
    open func inMinTouchRect(inside point: CGPoint) -> Bool{
        
        //获取当前button的实际大小
        var bounds = self.bounds
        
        //若原热区小于44x44，则放大热区，否则保持原大小不变
        let widthDelta = max(44.0 - bounds.size.width, 0)
        
        let heightDelta = max(44.0 - bounds.size.height, 0)
        
        //扩大bounds
        bounds = bounds.insetBy(dx: -0.5 * widthDelta, dy: -0.5 * heightDelta)
        
        //如果点击的点 在 新的bounds里，就返回YES
        return bounds.contains(point)
    }
}
