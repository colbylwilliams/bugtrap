//
//  BtSettingsNavigationController.swift
//  bugTrap
//
//  Created by Colby L Williams on 6/30/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import UIKit

class BtSettingsNavigationController: BtNavigationController {

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		if let loginControllerName = TrackerService.Shared.currentTracker?.type.loginControllerName {
			if let loginController = storyboard?.instantiateViewControllerWithIdentifier(loginControllerName) {
				showViewController(loginController, sender: self)
			}
		} else {
			Log.info(self, "CurrentTracker == nil")
		}
	}
}