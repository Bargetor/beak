//
//  BBUIViewExtension.swift
//  Beak
//
//  Created by 马进 on 2016/12/7.
//  Copyright © 2016年 马进. All rights reserved.
//

import Foundation

extension UIView {
    
    @discardableResult
    open func setTapGesture(_ target: AnyObject?, action: Selector) -> UITapGestureRecognizer{
        self.isUserInteractionEnabled = true
        
        let tapGR = UITapGestureRecognizer(target: target, action: action)
        //        tapGR.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGR)
        return tapGR
    }
    
    @discardableResult
    open func setPanGesture(_ target: AnyObject?, selector: Selector) -> UIPanGestureRecognizer{
        self.isUserInteractionEnabled = true
        let panGR = UIPanGestureRecognizer(target: target, action: selector)
        self.addGestureRecognizer(panGR)
        
        return panGR
    }
    
    open func removeAllSubView(){
        for subview in self.subviews{
            subview.removeFromSuperview()
        }
    }
    
}

extension UIView{
    
    public func computeContentSize() -> CGSize{
        var contentRect = CGRect.zero;
        for subview in self.subviews  {
            let size = subview.bounds.size
            let frame = CGRect(origin: subview.frame.origin, size: size)
            contentRect = contentRect.union(frame);
        }
        return contentRect.size
    }
    
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

public var isAutoAdjustMinTouchRect: Bool = false
extension UIImageView{
    public var autoAdjustMinTouchRect: Bool?{
        get{
            return objc_getAssociatedObject(self, &isAutoAdjustMinTouchRect) as? Bool
        }
        set(newValue){
            objc_setAssociatedObject(self, &isAutoAdjustMinTouchRect, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        if let auto = self.autoAdjustMinTouchRect, !auto{
            return super.point(inside: point, with: event)
        }else{
           return self.inMinTouchRect(inside: point)
        }
    }
}

public extension UILabel{
    public var autoAdjustMinTouchRect: Bool?{
        get{
            return objc_getAssociatedObject(self, &isAutoAdjustMinTouchRect) as? Bool
        }
        set(newValue){
            objc_setAssociatedObject(self, &isAutoAdjustMinTouchRect, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        if let auto = self.autoAdjustMinTouchRect, !auto{
            return super.point(inside: point, with: event)
        }else{
            return self.inMinTouchRect(inside: point)
        }
    }
}

public extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

extension UIButton{
    public var autoAdjustMinTouchRect: Bool?{
        get{
            return objc_getAssociatedObject(self, &isAutoAdjustMinTouchRect) as? Bool
        }
        set(newValue){
            objc_setAssociatedObject(self, &isAutoAdjustMinTouchRect, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if let auto = self.autoAdjustMinTouchRect, !auto{
            return super.point(inside: point, with: event)
        }else{
            return self.inMinTouchRect(inside: point)
        }
    }
    
    open func setTitleColor(_ color: UIColor?){
        self.setTitleColor(color, for: .normal)
    }
    
    open func setTitle(_ title: String?){
        self.setTitle(title, for: .normal)
    }
    
    open func setTitleFont(_ font: UIFont){
        self.titleLabel?.font = font
    }
    
    open func setImage(_ image: UIImage?){
        self.setImage(image, for: .normal)
    }
}

