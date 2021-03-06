//
//  BBSegue.swift
//  BBIOSCommon
//
//  Created by Bargetor on 16/4/26.
//  Copyright © 2016年 BesideBamboo. All rights reserved.
//

import Foundation
import ObjectiveC

public var lastSegueParam: AnyObject?

extension UIViewController{
    public var segueParam: AnyObject?{
        get{
            return objc_getAssociatedObject(self, &lastSegueParam) as AnyObject?
        }
        set(newValue){
            objc_setAssociatedObject(self, &lastSegueParam, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    public func pushForNewNav(_ to: UIViewController){
        BBSegueUtil.pushForNewNav(to: to)
    }
    
    public func pushTo(_ to: UIViewController, params: AnyObject? = nil){
        to.segueParam = params
        BBSegueUtil.pushTo(self, to: to)
    }
    
    public func pop(){
        BBSegueUtil.pop(self)
    }
    
    public func pop(type to: UIViewController.Type){
        BBSegueUtil.popTo(self, toType: to)
    }
    
    public func pop(vc to: UIViewController){
        BBSegueUtil.popTo(self, to: to)
    }
    
    public func presentForRootNav(to: UIViewController, animated: Bool = true, completion: (() -> Swift.Void)? = nil){
        UIApplication.shared.keyWindow?.rootViewController?.present(to, animated: animated, completion: completion)
    }
}

extension UIView{
    
    public func mainStoryboardTo(_ viewControllerName: String, param: AnyObject? = nil){
        guard let vc = BBSegueUtil.getCurrentViewController() else{
            return
        }
        BBSegueUtil.mainStoryboardTo(vc, viewControllerName: viewControllerName, param: param)
    }
    
    public func pushTo(_ to: UIViewController, params: AnyObject? = nil, navigationDelegate: UINavigationControllerDelegate? = nil){
        guard let vc = BBSegueUtil.getCurrentViewController() else{
            return
        }
        
        to.segueParam = params
        BBSegueUtil.pushTo(vc, to: to, navigationDelegate: navigationDelegate)
    }
    
    public func pop(){
        guard let vc = BBSegueUtil.getCurrentViewController() else{
            return
        }
        BBSegueUtil.pop(vc)
    }
    
}
