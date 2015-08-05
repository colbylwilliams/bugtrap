//
//  BtViewController.swift
//  bugTrap
//
//  Created by Colby L Williams on 11/20/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import UIKit

class BtViewController: UIViewController {

	var screenName: String? = nil
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		updateScreenName()
	}
	
	func updateScreenName () {
		if let name = screenName {
			Analytics.Shared.screenView(name)
		}
	}
	
	func updateScreenName (name: String) {
		if name != screenName {
			screenName = name
			updateScreenName()
		}
	}
	
	override func prefersStatusBarHidden() -> Bool {
		return true
	}
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
}