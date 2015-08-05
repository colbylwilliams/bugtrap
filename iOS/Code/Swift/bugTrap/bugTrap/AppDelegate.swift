//
//  AppDelegate.swift
//  bugTrap
//
//  Created by Colby L Williams on 8/22/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
	var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .None)
        
        return true
    }
    
	func applicationWillResignActive(application: UIApplication) {
		NSUserDefaults.standardUserDefaults().synchronize()
	}
}
