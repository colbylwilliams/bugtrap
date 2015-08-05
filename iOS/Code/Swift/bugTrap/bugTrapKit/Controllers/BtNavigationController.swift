//
//  BtNavigationController.swift
//  bugTrap
//
//  Created by Colby L Williams on 11/20/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import UIKit

class BtNavigationController: UINavigationController {

	override func viewDidLoad() {
		super.viewDidLoad()
		
		if TrapState.Shared.inActionExtension {
			navigationBar.barTintColor = nil
			navigationBar.tintColor = Colors.Theme.uiColor
			navigationBar.titleTextAttributes?.updateValue(Colors.Black.uiColor, forKey: NSForegroundColorAttributeName)
		}
	}

	
//	func presentSettingsNavController (animate: Bool, block: (() -> Void)?) {
//		let kitStoryboard = UIStoryboard(name: "bugTrapKit", bundle: nil)
//		
//		if let settingsNavController = kitStoryboard.instantiateViewControllerWithIdentifier("BtSettingsNavigationController") as? UINavigationController {
//			presentViewController(settingsNavController, animated: animate, completion: block)
//		}
//	}
	
	func presentNewBugDetailsNavController (animate: Bool, block: (() -> Void)?) {
		let kitStoryboard = UIStoryboard(name: "bugTrapKit", bundle: nil)
		
		if let newBugDetailsNavController = kitStoryboard.instantiateViewControllerWithIdentifier("BtNewBugDetailsNavigationController") as? UINavigationController {
			presentViewController(newBugDetailsNavController, animated: animate, completion: block)
		}
	}

	func presentAnnotateImageNavController (animate: Bool, block: (() -> Void)?) {
		let kitStoryboard = UIStoryboard(name: "bugTrapKit", bundle: nil)
	
		if let annotateImageNavController = kitStoryboard.instantiateViewControllerWithIdentifier("BtAnnotateImageNavigationController") as? BtAnnotateImageNavigationController {
			presentViewController(annotateImageNavController, animated: animate, completion: block)
		}
	}
	
	override func prefersStatusBarHidden() -> Bool {
		return true
	}
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
}