//
//  SegueUtil.swift
//  BBIOSCommon
//  转场工具
//  Created by Bargetor on 15/7/26.
//  Copyright (c) 2015年 BesideBamboo. All rights reserved.
//

import Foundation

open class BBSegueUtil {
    
    open class func getCurrentViewController() -> UIViewController?{
        var vcResult: UIViewController? = nil
        guard var window = UIApplication.shared.keyWindow else{
            return vcResult
        }
        
        if window.windowLevel != UIWindowLevelNormal {
            for tempWindow in UIApplication.shared.windows{
                if tempWindow.windowLevel == UIWindowLevelNormal{
                    window = tempWindow
                    break
                }
            }
        }
        
        guard let frontView = window.subviews.last else{
            return vcResult
        }
        
        var nextResponder = frontView.next
        
        while ((nextResponder?.next) != nil) {
            nextResponder = nextResponder?.next
        }
        
        if nextResponder!.isKind(of: UIViewController.self){
            vcResult = nextResponder as? UIViewController
        }else{
            vcResult = window.rootViewController
        }
        
        if vcResult!.isKind(of: UINavigationController.self){
            return vcResult?.childViewControllers.last
        }else{
            return vcResult
        }
        
    }
    
    open class func pushTo(_ from: UIViewController, to: UIViewController, animated: Bool = true){
        if from.isKind(of: UINavigationController.self){
            let from = from as! UINavigationController
            from.pushViewController(to, animated: animated)
        }else{
            from.navigationController?.pushViewController(to, animated: animated)
        }
        
    }
    
    open class func pushToMain(_ from: UIViewController, viewControllerName: String, animated: Bool = true){
        pushTo(from, storyboardName: "Main", viewControllerName: viewControllerName, animated: animated)
    }
    
    open class func pushTo(_ from: UIViewController, storyboardName: String, viewControllerName: String, animated: Bool = true){
        let sb = UIStoryboard(name: storyboardName, bundle: nil)
        
        let vc = sb.instantiateViewController(withIdentifier: viewControllerName)
        
        from.navigationController?.pushViewController(vc, animated: animated)
    }
    
    
    open class func mainStoryboardTo(_ from: UIViewController, viewControllerName: String, param: AnyObject? = nil){
        storyboardTo(from, storyboardName: "Main", viewControllerName: viewControllerName, param: param)
    }
    
    open class func storyboardTo(_ from: UIViewController, storyboardName: String, viewControllerName: String, param: AnyObject? = nil){
        let sb = UIStoryboard(name: storyboardName, bundle: nil)
        
        let vc = sb.instantiateViewController(withIdentifier: viewControllerName)
        vc.segueParam = param
        
        from.present(vc, animated: true, completion: nil)
    }
    
    open class func pop(_ from: UIViewController, animated: Bool = true){
        if from.isKind(of: UINavigationController.self){
            let from = from as! UINavigationController
            from.popViewController(animated: animated)
        }else{
            from.navigationController?.popViewController(animated: animated)
        }
    }
}