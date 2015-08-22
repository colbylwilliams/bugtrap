//
//  bugTrapKit.swift
//  bugTrap
//
//  Created by Colby Williams on 8/21/15.
//  Copyright © 2015 bugTrap. All rights reserved.
//

import Foundation

public class bugTrapKit {
	
	public class var Shared : bugTrapKit {
		
		struct Static {
			static let instance: bugTrapKit = bugTrapKit(window: BtOverlayWindow())
		}
		
		return Static.instance
	}
	
	internal let btWindow: BtOverlayWindow
	
	internal init (window: BtOverlayWindow) {
		btWindow = window
	}
	
	public func Start() {
		btWindow.frame = UIScreen.mainScreen().bounds
		btWindow.windowLevel = UIWindowLevelStatusBar
		btWindow.makeKeyAndVisible()
	}
	
	public func ToggleTriggerVisibility() {
		if let root = btWindow.rootViewController as? BtOverlayViewController {
			root.toggleTriggerVisibility()
		}
	}
}