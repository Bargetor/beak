//
//  BBDateExtension.swift
//  Beak
//
//  Created by 马进 on 2016/12/14.
//  Copyright © 2016年 马进. All rights reserved.
//

import Foundation

extension Date{
    public func format(formatStr: String) -> String{
        let format = DateFormatter()
        format.dateFormat = formatStr
        return format.string(from: self)
    }
}
