//
//  ViewController.swift
//  myPDF
//
//  Created by Martin Brunner on 29.11.14.
//  Copyright (c) 2014 Martin Brunner. All rights reserved.
//

import UIKit
import Foundation

@objc (ViewController)

class ViewController: UIViewController {
    @IBOutlet weak var pdfTextView: UITextView!
  
   // let pdfTextView = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
                setText()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func goButtonPressed(sender: UIButton) {

        testIt()

    }

    func testIt() {
        
        let path =  NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true)
        println("Path: \(path)")
        
        let docDirectory: AnyObject = path[0]
        let filePath = docDirectory.stringByAppendingPathComponent("myFile.pdf")
        
        let fManager = NSFileManager.defaultManager()
        if  fManager.createFileAtPath(filePath, contents: nil, attributes: nil)  {
            println("Success")
   //         string4.writeToFile(filePath, atomically: true, encoding: NSUnicodeStringEncoding, error: nil)
            
        }
        else {
            println("Failed")
        }
        
//        var frameSetter = CTFramesetterCreateWithAttributedString(myString)
        var frameSetter = CTFramesetterCreateWithAttributedString(pdfTextView.attributedText)
    
         if (frameSetter != nil)   {
        
            // Create the PDF context using the default page size of 612 x 792.
            UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil)
        
            var currentRange: CFRange = CFRangeMake(0, 0)
            var currentPage = 0
            var done:Bool = false
        
    
            // Mark the beginning of a new page.
            UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
            
            // Draw a page number at the bottom of each page.
            currentPage++
            self.drawPageNumber(currentPage)
            
            // Render the current page and update the current range to
            // point to the beginning of the next page.
            currentRange = renderPagewithTextRange(currentRange, frameSetter: frameSetter)
            // If we're at the end of the text, exit the loop.
    
                println("once done")
    
        
            // Close the PDF context and write the contents out.
            UIGraphicsEndPDFContext();
            // Release the framewetter.
        } //end if
         else {
            println("FrameSetter didnt work")
        }
        
    }
    
//Helper PDF Creation
    
    func renderPagewithTextRange ( currentRange:CFRange, frameSetter:CTFramesetterRef ) ->CFRange {
        let currentContext: CGContextRef = UIGraphicsGetCurrentContext()
        CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity)
        
        let frameRect = CGRectMake(72, 72, 468, 648)
        let framePath = CGPathCreateMutable()
        CGPathAddRect(framePath, nil, frameRect)
        
        let frameRef = CTFramesetterCreateFrame(frameSetter, currentRange, framePath, nil)
        
        CGContextTranslateCTM(currentContext, 0, 792)
        CGContextScaleCTM(currentContext, 1.0, -1.0)
        CTFrameDraw(frameRef, currentContext)
        
        var currRange = currentRange
        
        currRange = CTFrameGetVisibleStringRange(frameRef);
        currRange.location += currentRange.length;
        currRange.length = 0;
   
        return currRange
    }
    

    func drawPageNumber ( pageNumber: Int) {
        let pageString:NSString = "Page \(pageNumber)"

        let theFont = UIFont.systemFontOfSize(14)
        let maxSize = CGSizeMake(612, 72);
        let attributes:NSDictionary = [NSFontAttributeName:theFont]
        let pageStringSize = pageString.sizeWithAttributes([NSFontAttributeName:theFont])
        let stringRect = CGRectMake(((612.0 - pageStringSize.width) / 2.0),720.0 + ((72.0 - pageStringSize.height) / 2.0),pageStringSize.width,pageStringSize.height)
        
        pageString.drawInRect(stringRect, withAttributes: attributes)
    }

    func setText() {
        
        let titleFont = UIFont(name: "Helvetica Bold", size: 14)!
        let textFont = UIFont(name: "Helvetica Neue", size: 12)!
        
        let titleParagraph = NSMutableParagraphStyle()
        
        let textParagraph = NSMutableParagraphStyle()
        textParagraph.alignment = NSTextAlignment.Left
        
//        textParagraph.firstLineHeadIndent = 100.0
//        textParagraph.headIndent = 110.0
//        textParagraph.defaultTabInterval = 150.0
        
        var titleAttributes = [NSFontAttributeName:titleFont,NSForegroundColorAttributeName: UIColor.blackColor(), NSParagraphStyleAttributeName: titleParagraph]
        
        var textAttributes = [NSFontAttributeName:textFont,NSForegroundColorAttributeName: UIColor.blackColor(), NSParagraphStyleAttributeName: textParagraph]
        
        let title = "IBM Client Center Research - Client Feedback - \n\n"
        let date =  Date.toString(dateOrTime: kDateFormat)  + "\n\n"
        let client = "UBS Private Banking\n\n"
        let eventMgr = "SSC\n\n"
        let evalAverage = "1.1\n\n"
        let header = "#\tEval.\t\tDate-Time"
        let evalAll = ["2\t1\t","2\t1\t","1\t2\t","1\t1\t","2\t1\t"]
        var attributedText = NSAttributedString(string:"",attributes: titleAttributes)
        var theString = NSMutableAttributedString(attributedString: attributedText)
        
        theString.appendAttributedString(NSAttributedString(string:"IBM Client Center Research - Client Feedback - \n\n",attributes: titleAttributes))
        theString.appendAttributedString(NSAttributedString(string:"Date: \t",attributes: titleAttributes))
        theString.appendAttributedString(NSAttributedString(string:date,attributes: textAttributes))
        
        theString.appendAttributedString(NSAttributedString(string:"Client: \t",attributes: titleAttributes))
        theString.appendAttributedString(NSAttributedString(string:client,attributes: textAttributes))
        
        theString.appendAttributedString(NSAttributedString(string:"Event Mgr: \t",attributes: titleAttributes))
        theString.appendAttributedString(NSAttributedString(string:eventMgr,attributes: textAttributes))
        
        theString.appendAttributedString(NSAttributedString(string:"Evaluation Average: \t",attributes: titleAttributes))
        theString.appendAttributedString(NSAttributedString(string:evalAverage,attributes: textAttributes))

        theString.appendAttributedString(NSAttributedString(string:"#\tEval.\tDate-Time",attributes: titleAttributes))
        
        var i = 1
    
        for eval  in evalAll {
            let str = "\n" + "\(i): \t" + eval + Date.toString(dateOrTime: kTimeFormat)
            var subString = NSAttributedString(string: str , attributes: textAttributes)
            theString.appendAttributedString(subString)
            i++
        }
        pdfTextView.attributedText = theString
    }

    
    
//    var theFont = UIFont.systemFontOfSize(22)
//    theFont = UIFont(name: "Arial", size: 12)!
//    let textAllignement = NSTextAlignment.Right
//    
//    var attributes:NSDictionary = [NSFontAttributeName:theFont,NSForegroundColorAttributeName: UIColor.redColor()]
//    
//    let stringx = CFAttributedStringCreate(nil , "TITEL\n\n", attributes)
//    
//    attributes = [NSFontAttributeName:theFont,NSForegroundColorAttributeName: UIColor.blueColor()]
//    
//    // Prepare the text using a Core Text Framesetter.
//    var myString = CFAttributedStringCreate(nil , pdfTextView.text, attributes)
//    
//    let frameSetter = CTFramesetterCreateWithAttributedString(myString)
//    
//    if (frameSetter != nil)   {
//    
//    // Create the PDF context using the default page size of 612 x 792.
//    UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil)
//    
//    var currentRange: CFRange = CFRangeMake(0, 0)
//    var currentPage = 0
//    var done:Bool = false
//    
//    do {
//    // Mark the beginning of a new page.
//    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
//    
//    // Draw a page number at the bottom of each page.
//    currentPage++
//    self.drawPageNumber(currentPage)
//    
//    // Render the current page and update the current range to
//    // point to the beginning of the next page.
//    currentRange = renderPagewithTextRange(currentRange, frameSetter: frameSetter)
//    
//    // If we're at the end of the text, exit the loop.
//    if (currentRange.location == CFAttributedStringGetLength(myString)) {
//    done = true
//    }
//    done = true
//    println("once done")
//    
//    } while (!done)
//    
//    // Close the PDF context and write the contents out.
//    UIGraphicsEndPDFContext();
//    // Release the framewetter.
//    } //end if
//    else {
//    println("FrameSetter didnt work")
//    }

    
}

