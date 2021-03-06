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
    
    @discardableResult
    open func setSwipeGesture(for direction: UISwipeGestureRecognizer.Direction, target: AnyObject?, selector: Selector) -> UISwipeGestureRecognizer{
        self.isUserInteractionEnabled = true
        let swipe = UISwipeGestureRecognizer(target: target, action: selector)
        swipe.direction = direction
        self.addGestureRecognizer(swipe)
        
        return swipe
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
    
    open func inMinTouchRect(inside point: CGPoint, minBounds: CGSize = CGSize(width: 44.0, height: 44.0)) -> Bool{
        
        //获取当前button的实际大小
        var bounds = self.bounds
        
        //若原热区小于44x44，则放大热区，否则保持原大小不变
        let widthDelta = max(minBounds.width - bounds.size.width, 0)
        
        let heightDelta = max(minBounds.height - bounds.size.height, 0)
        
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
    
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
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

public extension UIColor{
    public func toImage() -> UIImage{
        return UIImage(color: self) ?? UIImage()
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

extension UIView{
    open func addBorder(edges: [UIRectEdge], color: UIColor = UIColor.white, thickness: CGFloat = 1.0, inset: CGFloat = 0) -> [UIView]{
        var allView: [UIView] = []
        for edge in edges{
            let views = self.addBorder(edges: edge, color: color, thickness: thickness, inset: inset)
            allView.appendAll(views)
        }
        
        return allView
    }
    
    open func addBorder(edges: UIRectEdge, color: UIColor = UIColor.white, thickness: CGFloat = 1.0, inset: CGFloat = 0) -> [UIView] {
        
        var borders = [UIView]()
        
        func border() -> UIView {
            let border = UIView(frame: CGRect.zero)
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            return border
        }
        
        if edges.contains(.top) || edges.contains(.all) {
            let top = border()
            addSubview(top)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[top(==thickness)]",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["top": top]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(inset)-[top]-(inset)-|",
                                               options: [],
                                               metrics: ["inset": inset],
                                               views: ["top": top]))
            borders.append(top)
        }
        
        if edges.contains(.left) || edges.contains(.all) {
            let left = border()
            addSubview(left)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[left(==thickness)]",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["left": left]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(inset)-[left]-(inset)-|",
                                               options: [],
                                               metrics: ["inset": inset],
                                               views: ["left": left]))
            borders.append(left)
        }
        
        if edges.contains(.right) || edges.contains(.all) {
            let right = border()
            addSubview(right)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:[right(==thickness)]-(0)-|",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["right": right]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(inset)-[right]-(inset)-|",
                                               options: [],
                                               metrics: ["inset": inset],
                                               views: ["right": right]))
            borders.append(right)
        }
        
        if edges.contains(.bottom) || edges.contains(.all) {
            let bottom = border()
            addSubview(bottom)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:[bottom(==thickness)]-(0)-|",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["bottom": bottom]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(inset)-[bottom]-(inset)-|",
                                               options: [],
                                               metrics: ["inset": inset],
                                               views: ["bottom": bottom]))
            borders.append(bottom)
        }
        
        return borders
    }
}

