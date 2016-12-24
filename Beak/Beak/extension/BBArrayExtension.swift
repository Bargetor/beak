//
//  BBArrayExtension.swift
//  Beak
//
//  Created by 马进 on 2016/12/13.
//  Copyright © 2016年 马进. All rights reserved.
//

import Foundation

extension Array{
    
    public func subArrayWithRange(_ location: Int, length: Int) -> Array<Element>?{
        let count = self.count
        if(location >= count){
            return nil
        }
        var result = Array()
        let rangeEnd = location + length
        let end =  rangeEnd >= count ? count : rangeEnd
        
        for item in self[location ..< end]{
            result.append(item)
        }
        
        return result
        
    }
    
    public func toUnsafeMutablePointer() -> UnsafeMutablePointer<Element>{
        let points: UnsafeMutablePointer<Element> = UnsafeMutablePointer.allocate(capacity: self.count)
        for i in 0 ..< self.count{
            let item = self[i]
            points[i] = item
        }
        
        return points
    }
    
    public mutating func appendAll(_ elements: [Element]?){
        guard let elements = elements else{
            return
        }
        
        for element in elements{
            self.append(element)
        }
    }
    
    public func difference <T: Equatable> (values: [T]...) -> [T] {
        
        var result = [T]()
        
        elements: for e in self {
            if let element = e as? T {
                for value in values {
                    //  if a value is in both self and one of the values arrays
                    //  jump to the next iteration of the outer loop
                    if value.contains(element) {
                        continue elements
                    }
                }
                
                //  element it's only in self
                result.append(element)
            }
        }
        
        return result
        
    }
}

extension Array where Element: Equatable {
    
    /**
     从array中删除一个对象
     
     - parameter object: 要删除的对象
     */
    public mutating func removeObject(_ object: Element) {
        if let index = self.index(of: object) {
            self.remove(at: index)
        }
    }
    
    public func toUnsafeMutablePointer() -> UnsafeMutablePointer<Element>{
        let pointer: UnsafeMutablePointer<Element> = UnsafeMutablePointer(mutating: self)
        return pointer
    }
    
}
