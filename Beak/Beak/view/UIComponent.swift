//
//  UIComponent.swift
//  BBIOSCommon
//
//  Created by Bargetor on 16/4/29.
//  Copyright © 2016年 BesideBamboo. All rights reserved.
//

import Foundation
import Bond

public protocol UIViewModel{
    //init function 不能有任何数据加载的代码，否则很容易导致在UI未绑定前，数据已经更新
    
    //    func bidirectionalBind(component: UIComponent, data: AnyObject?)
    
}

public protocol UIComponent{
    var subComponent: Array<UIComponent>?{ get set }
    
    func initUITemplate(_ withViewModel: UIViewModel?)
    
    func bindViewModel(viewModel withViewModel: UIViewModel?)
    
    func layout()
    
    /**
     该方法的源调用方为 vc 的 viewDidLayoutSubviews, 在布局完成后调用，此时已有完整的frame信息
     编写代码时应手动的在vc的方法中调用
     */
    func viewDidLayout()
}


public protocol UIComponentLifecycle{
    
}


extension UIView : UIComponent{
    open var subComponent: Array<UIComponent>?{
        get{
            return self.subComponent
        }
        
        set(newValue){
            self.subComponent = newValue
        }
    }
    
    open func initUITemplate(_ withViewModel: UIViewModel? = nil) {
        for subView in self.subviews {
            subView.initUITemplate(withViewModel)
        }
    }
    
    open func bindViewModel(viewModel withViewModel: UIViewModel? = nil){
        
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

extension UIViewController{
    
    open func initUITemplate(_ withViewModel: UIViewModel? = nil) {
        for subView in self.view.subviews {
            subView.initUITemplate(withViewModel)
        }
    }
    
    open func bindViewModel(viewModel withViewModel: UIViewModel? = nil){
        
    }
    
    open func layout() {
        for subView in self.view.subviews {
            subView.layout()
        }
    }
}


extension UIView : UIComponentLifecycle{
    
}
