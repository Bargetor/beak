//
//  UIComponent.swift
//  BBIOSCommon
//
//  Created by Bargetor on 16/4/29.
//  Copyright © 2016年 BesideBamboo. All rights reserved.
//

import Foundation
import Bond

@objc public protocol UIViewModel{
    //init function 不能有任何数据加载的代码，否则很容易导致在UI未绑定前，数据已经更新
    
    //    func bidirectionalBind(component: UIComponent, data: AnyObject?)
    
}

@objc public protocol UIComponent{
    associatedtype ViewModelType : UIViewModel
    
    func initUITemplate(_ withViewModel: UIViewModel?)
    
    func bindViewModel(viewModel withViewModel: UIViewModel?)
    
    func layout()
    
    /**
     该方法的源调用方为 vc 的 viewDidLayoutSubviews, 在布局完成后调用，此时已有完整的frame信息
     编写代码时应手动的在vc的方法中调用
     */
    func viewDidLayout()
}

@objc public protocol UIComponentForViewController{
    //ui view controller 只能继承与重写这个方法
    func initUITemplate(_ withViewModel: UIViewModel?)
    
    func bindViewModel(_ withViewModel: UIViewModel?)
    
    func layout()
    
}


public protocol UIComponentLifecycle{
    
}



private var viewExtensionViewModel: UInt8 = 0
extension UIView : UIComponent{
    public typealias ViewModelType = UIViewModel

    open var viewModel: ViewModelType?{
        get {
            return objc_getAssociatedObject(self, &viewExtensionViewModel) as? ViewModelType
        }
        set(newValue) {
            objc_setAssociatedObject(self, &viewExtensionViewModel, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    open func initUITemplate(_ withViewModel: UIViewModel? = nil) {
        self.viewModel = withViewModel
        for subView in self.subviews {
            subView.initUITemplate(withViewModel)
        }
    }
    
    open func bindViewModel(viewModel withViewModel: UIViewModel? = nil){
        self.viewModel = withViewModel
    }
    
    open func layout() {
        for subView in self.subviews {
            subView.layout()
        }
    }
    
    open func viewDidLayout() {
        for subView in self.subviews {
            subView.viewDidLayout()
        }
    }
}

extension UIViewController : UIComponentForViewController{
    
    open func initUITemplate(_ withViewModel: UIViewModel?) {
        for subView in self.view.subviews {
            subView.initUITemplate(withViewModel)
        }
    }
    
    open func bindViewModel(_ withViewModel: UIViewModel?){
        
    }
    
    open func layout() {
        for subView in self.view.subviews {
            subView.layout()
        }
    }
}


extension UIView : UIComponentLifecycle{
    
}
