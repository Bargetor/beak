//
//  BBUIViewExtension.swift
//  Beak
//
//  Created by 马进 on 2016/12/7.
//  Copyright © 2016年 马进. All rights reserved.
//

import Foundation

extension UIView{
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
