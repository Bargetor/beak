//
//  BBLoggerUtil.swift
//  Beak
//
//  Created by 马进 on 2016/12/6.
//  Copyright © 2016年 马进. All rights reserved.
//

import Foundation
import XCGLogger

open class BBLoggerUtil{
    
    open class func info(_ closure: String?){
        XCGLogger.info(closure)
    }
    
    open class func error(_ closure: String?){
        XCGLogger.error(closure)
        
    }
    
    open class func debug(_ closure: String?){
        XCGLogger.debug(closure)
    }
    
    open class func verbose(_ closure: String?){
        XCGLogger.verbose(closure)
    }
    
    open class func warning(_ closure: String?){
        XCGLogger.warning(closure)
    }
    
    open class func severe(_ closure: String?){
        XCGLogger.severe(closure)
    }
}
