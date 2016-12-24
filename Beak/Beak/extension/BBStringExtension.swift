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
        let r = (self.characters.index(self.startIndex, offsetBy: range.location) ..< self.characters.index(self.startIndex, offsetBy: range.location + range.length))
        return self.substring(with: r)
    }
    
    public func urlencode() -> String {
        let urlEncoded = self.replacingOccurrences(of: " ", with: "+")
        let chartset = NSMutableCharacterSet(bitmapRepresentation: (CharacterSet.urlQueryAllowed as NSCharacterSet).bitmapRepresentation)
        chartset.removeCharacters(in: "!*'();:@&=$,/?%#[]")
        return urlEncoded.addingPercentEncoding(withAllowedCharacters: chartset as CharacterSet)!
    }
    
    public func length() -> Int{
        return self.characters.count
    }
    
    public func format(arguments: CVarArg...) -> String{
        return String(format: self, arguments: arguments)
    }
}
