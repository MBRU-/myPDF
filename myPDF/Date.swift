//
//  Date.swift
//  myPDF
//
//  Created by Martin Brunner on 30.11.14.
//  Copyright (c) 2014 Martin Brunner. All rights reserved.
//

import Foundation

let kDateFormat = 1
let kTimeFormat = 2

class Date {
    
    class func toString(#dateOrTime: Int) -> String {
        var formatString = ""
        if dateOrTime == kDateFormat {
            formatString = "dd-MM-yyyy"
        }
        else if dateOrTime == kTimeFormat {
            formatString = "dd-MM-yyyy / HH.mm.ss"
        }
        
        let myDate:NSDate = NSDate()
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = formatString
        
        let dateString = dateStringFormatter.stringFromDate(myDate)
        
        return dateString
    }
}
