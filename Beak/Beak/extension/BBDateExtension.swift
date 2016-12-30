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
        format.timeZone = TimeZone(abbreviation: "UTC")
        return format.string(from: self)
    }
}

extension Date{
    
    public func addLocalTimeZoneInterval() -> Date{
        let zone = TimeZone.current
        let interval = TimeInterval(zone.secondsFromGMT(for: self))
        return self.addingTimeInterval(interval)
    }
    
    // MARK:  Date comparison
    
    /**
     Checks if self is after input NSDate
     
     :param: date NSDate to compare
     :returns: True if self is after the input NSDate, false otherwise
     */
    public func isAfter(date: Date) -> Bool{
        return (self.compare(date) == ComparisonResult.orderedDescending)
    }
    
    /**
     Checks if self is before input NSDate
     
     :param: date NSDate to compare
     :returns: True if self is before the input NSDate, false otherwise
     */
    public func isBefore(date: Date) -> Bool{
        return (self.compare(date) == ComparisonResult.orderedAscending)
    }
    
    
    // MARK: Getter
    
    /**
     Date year
     */
    public var year : Int {
        get {
            return getComponent(.year)
        }
    }
    
    /**
     Date month
     */
    public var month : Int {
        get {
            return getComponent(.month)
        }
    }
    
    /**
     Date weekday
     */
    public var weekday : Int {
        get {
            return getComponent(.weekday)
        }
    }
    
    /**
     Date weekMonth
     */
    public var weekMonth : Int {
        get {
            return getComponent(.weekOfMonth)
        }
    }
    
    
    /**
     Date days
     */
    public var days : Int {
        get {
            return getComponent(.day)
        }
    }
    
    /**
     Date hours
     */
    public var hours : Int {
        
        get {
            return getComponent(.hour)
        }
    }
    
    /**
     Date minuts
     */
    public var minutes : Int {
        get {
            return getComponent(.minute)
        }
    }
    
    /**
     Date seconds
     */
    public var seconds : Int {
        get {
            return getComponent(.second)
        }
    }
    
    /**
     Returns the value of the NSDate component
     
     :param: component NSCalendarUnit
     :returns: the value of the component
     */
    
    public func getComponent (_ component : Calendar.Component) -> Int {
        let calendar = Calendar.current
        
        return calendar.component(component, from: self)
    }
}
