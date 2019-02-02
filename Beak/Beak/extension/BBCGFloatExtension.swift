//
//  BBCGFloatExtension.swift
//  Beak
//
//  Created by 马进 on 2016/12/22.
//  Copyright © 2016年 马进. All rights reserved.
//

import Foundation

extension CGFloat {
    
    public func toRadians() -> CGFloat {
        return (self * CGFloat.pi) / 180.0
    }
    
    public func toDegrees() -> CGFloat {
        return self * 180.0 / CGFloat.pi
    }
    
}
