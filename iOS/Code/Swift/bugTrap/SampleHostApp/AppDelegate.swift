//
//  AppDelegate.swift
//  SampleHostApp
//
//  Created by Colby Williams on 8/22/15.
//  Copyright © 2015 bugTrap. All rights reserved.
//

import UIKit
import bugTrapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?


	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		
		UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
		
		bugTrapKit.Shared.Start()
		
		return true
	}
}