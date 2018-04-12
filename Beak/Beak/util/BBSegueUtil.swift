//
//  SegueUtil.swift
//  BBIOSCommon
//  转场工具
//  Created by Bargetor on 15/7/26.
//  Copyright (c) 2015年 BesideBamboo. All rights reserved.
//

import Foundation

open class BBSegueUtil {
    
//    open class func getCurrentViewController() -> UIViewController?{
//        var vcResult: UIViewController? = nil
//        guard var window = UIApplication.shared.keyWindow else{
//            return vcResult
//        }
//
//        if window.windowLevel != UIWindowLevelNormal {
//            for tempWindow in UIApplication.shared.windows{
//                if tempWindow.windowLevel == UIWindowLevelNormal{
//                    window = tempWindow
//                    break
//                }
//            }
//        }
//
//        guard let frontView = window.subviews.last else{
//            return vcResult
//        }
//
//        var nextResponder = frontView.next
//
//        while ((nextResponder?.next) != nil) {
//            nextResponder = nextResponder?.next
//        }
//
//        if nextResponder!.isKind(of: UIViewController.self){
//            vcResult = nextResponder as? UIViewController
//        }else{
//            vcResult = window.rootViewController
//        }
//
//
//        if vcResult!.isKind(of: UINavigationController.self){
//            vcResult = vcResult?.childViewControllers.last
//        }
//
//        if(vcResult?.presentedViewController != nil){
//            return vcResult?.presentedViewController
//        }else if(vcResult?.presentingViewController != nil){
//            return vcResult?.presentingViewController
//        }else{
//            return vcResult
//        }
//
//    }
    
    open class func getCurrentViewController() -> UIViewController?{
        return getCurrentViewController(from: UIApplication.shared.keyWindow?.rootViewController)
    }
    
    open class func getCurrentViewController(from rootVC: UIViewController?) -> UIViewController?{
        guard let rootVC = rootVC else { return nil }
        var currentVC: UIViewController?
        var currentRootVC: UIViewController? = rootVC
        if ((rootVC.presentedViewController) != nil) {
            currentRootVC = rootVC.presentedViewController
        }
        
        if currentRootVC is UITabBarController{
            currentVC = getCurrentViewController(from: (currentRootVC as? UITabBarController)?.selectedViewController)
        }else if currentRootVC is UINavigationController{
            currentVC = getCurrentViewController(from: (currentRootVC as? UINavigationController)?.visibleViewController)
        }else{
            currentVC = currentRootVC
        }
        
        return currentVC
    }
    
    open class func getCurrentNavigationController() -> UINavigationController?{
        if let currentVC = getCurrentViewController(){
            if currentVC.isKind(of: UINavigationController.self){
                return (currentVC as! UINavigationController)
            }else{
                return currentVC.navigationController
            }
        }
        return nil
        
    }
    
    open class func pushForNewNav(to: UIViewController, animated: Bool = true){
        let nav = UINavigationController(rootViewController: to)
        self.pushTo(to: nav)
    }
    
    open class func pushTo(to: UIViewController, animated: Bool = true){
        guard let from = self.getCurrentViewController() else {return}
        self.pushTo(from, to: to, animated: animated)
    }
    
    open class func pushTo(_ from: UIViewController, to: UIViewController, animated: Bool = true, navigationDelegate: UINavigationControllerDelegate? = nil){
        if from.isKind(of: UINavigationController.self){
            let from = from as! UINavigationController
            if let navDelegate = navigationDelegate{
                from.delegate = navDelegate
            }
            from.pushViewController(to, animated: animated)
        }else{
            if let navDelegate = navigationDelegate{
                from.navigationController?.delegate = navDelegate
            }
            
            if from.navigationController == nil && from.presentingViewController is UINavigationController{
                (from.presentingViewController as? UINavigationController)?.pushViewController(to, animated: animated)
            }else{
                from.navigationController?.pushViewController(to, animated: animated)
            }
            
        }
        
    }
    
    open class func present(to: UIViewController, animated: Bool = true,  completion: (() -> Void)? = nil) {
        if let from = getCurrentViewController(){
            present(from, to: to, animated: animated, completion: completion)
        }
    }
    
    open class func present(_ from: UIViewController, to: UIViewController, animated: Bool = true,  completion: (() -> Void)? = nil) {
        if from.isKind(of: UINavigationController.self){
            let from = from as! UINavigationController
            from.present(to, animated: animated, completion: completion)
        }else{
            from.navigationController?.present(to, animated: animated, completion: completion)
        }
    }
    
    open class func presentForNewNav(to: UIViewController, animated: Bool = true,  completion: (() -> Void)? = nil) {
        if let from = getCurrentViewController(){
            presentForNewNav(from, to: to, animated: animated, completion: completion)
        }
    }
    
    open class func presentForNewNav(_ from: UIViewController, to: UIViewController, animated: Bool = true,  completion: (() -> Void)? = nil) {
        if from.isKind(of: UINavigationController.self){
            let from = from as! UINavigationController
            from.present(to, animated: animated, completion: completion)
        }else{
            let nav = UINavigationController(rootViewController: to)
            from.navigationController?.present(nav, animated: animated, completion: completion)
        }
    }
    
    open class func dismiss(_ from: UIViewController, animated: Bool = true,  completion: (() -> Void)? = nil){
        from.dismiss(animated: animated, completion: completion)
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
            let _ = from.navigationController?.popViewController(animated: animated)
        }
    }
    
    open class func popTo(_ from: UIViewController, toType: UIViewController.Type, animated: Bool = true){        
        if let vc = getFirstVCFromCurrentNavigationController(toType){
            popTo(from, to: vc, animated: animated)
        }
    }
    
    open class func popTo(_ from: UIViewController, to: UIViewController, animated: Bool = true){
        if from.isKind(of: UINavigationController.self){
            let from = from as! UINavigationController
            from.popToViewController(to, animated: animated)
        }else{
            let _ = from.navigationController?.popToViewController(to, animated: animated)
        }
    }
    
    open class func getFirstVCFromCurrentNavigationController(_ type: UIViewController.Type) -> UIViewController?{
        if let currentNav = getCurrentNavigationController(){
            for vc in currentNav.viewControllers{
                if vc.isKind(of: type){
                    return vc
                }
            }
        }
        return nil
    }
    
    open class func removeVCFromCurrentNavigationController(_ vc: UIViewController){
        if let currentNav = getCurrentNavigationController(){
            currentNav.viewControllers.removeObject(vc)
        }
    }
}
