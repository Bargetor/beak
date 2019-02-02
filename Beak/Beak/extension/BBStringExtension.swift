//
//  BBStringExtension.swift
//  Beak
//
//  Created by 马进 on 2016/12/6.
//  Copyright © 2016年 马进. All rights reserved.
//

import Foundation

extension String {
    
    public func substringWithRange(_ range: NSRange) -> String! {
        let r = (self.index(self.startIndex, offsetBy: range.location) ..< self.index(self.startIndex, offsetBy: range.location + range.length))
        return String(self[r])
    }
    
    public func urlencode() -> String {
        let urlEncoded = self.replacingOccurrences(of: " ", with: "+")
        let chartset = NSMutableCharacterSet(bitmapRepresentation: (CharacterSet.urlQueryAllowed as NSCharacterSet).bitmapRepresentation)
        chartset.removeCharacters(in: "!*'();:@&=$,/?%#[]")
        return urlEncoded.addingPercentEncoding(withAllowedCharacters: chartset as CharacterSet)!
    }
    
    public func length() -> Int{
        return self.count
    }
    
    public func format(arguments: CVarArg...) -> String{
        return String(format: self, arguments: arguments)
    }
    
    public mutating func replaceSubrange(_ range: NSRange, with replacementString: String) -> String {
        if(range.location >= self.count){
            self.append(replacementString)
            return self
        }
        
        
        if let newRange: Range<String.Index> = self.range(for: range){
            self.replaceSubrange(newRange, with: replacementString)
        }
        
        return self
    }
    
    func range(for range: NSRange) -> Range<String.Index>? {
        guard range.location != NSNotFound else { return nil }
        
        guard let fromUTFIndex = self.utf16.index(self.utf16.startIndex, offsetBy: range.location, limitedBy: self.utf16.endIndex) else { return nil }
        guard let toUTFIndex = self.utf16.index(fromUTFIndex, offsetBy: range.length, limitedBy: self.utf16.endIndex) else { return nil }
        guard let fromIndex = String.Index(fromUTFIndex, within: self) else { return nil }
        guard let toIndex = String.Index(toUTFIndex, within: self) else { return nil }
        
        return fromIndex ..< toIndex
    }
    
}

