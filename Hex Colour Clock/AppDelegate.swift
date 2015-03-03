//
//  AppDelegate.swift
//  Hex Colour Clock
//
//  Created by Colin Cameron on 02/03/2015.
//  Copyright (c) 2015 Colin Cameron. All rights reserved.
//

import Cocoa

extension String {
    
    subscript(range: Range<Int>) -> String {
        return self[advance(startIndex, range.startIndex)..<advance(startIndex, range.endIndex)];
    }
    
    func toHexColor() -> NSColor {
        
        func hexToCGFloat(color: String) -> CGFloat {
            var result: CUnsignedInt = 0;
            let scanner: NSScanner = NSScanner(string: color);
            scanner.scanHexInt(&result);
            return CGFloat(result) / 255;
        }
        
        let red = hexToCGFloat(self[1...2]);
        let green = hexToCGFloat(self[3...4]);
        let blue = hexToCGFloat(self[5...6]);
        
        return NSColor(calibratedRed: red, green: green, blue: blue, alpha: 1);
    }
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var timeLabel: NSTextField!
    @IBOutlet weak var alwaysOnTopMenuItem: NSMenuItem!
    
    var dateFormatter: NSDateFormatter!
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        
        window.movableByWindowBackground = true;
        
        dateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = "#HHmmss";
        
        let timer = NSTimer(timeInterval:1, target: self, selector: "updateDisplay", userInfo: nil, repeats: true);
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes);
        
        updateDisplay();
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    func updateDisplay() {
        let date = NSDate();
        let timeString = dateFormatter.stringFromDate(date);
        
        dispatch_async(dispatch_get_main_queue()) {
            self.timeLabel.stringValue = timeString;
            self.window.backgroundColor = timeString.toHexColor();
        }
    }
    
    @IBAction func changeAlwaysOnTop(sender: AnyObject) {
        if (alwaysOnTopMenuItem.state == NSOnState) {
            alwaysOnTopMenuItem.state = NSOffState;
            window.level = Int(CGWindowLevelForKey(Int32(kCGNormalWindowLevelKey)));
        } else {
            alwaysOnTopMenuItem.state = NSOnState;
            window.level = Int(CGWindowLevelForKey(Int32(kCGStatusWindowLevelKey)));
        }
    }
}

