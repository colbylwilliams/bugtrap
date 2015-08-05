//
//  BtImageNavigationController.swift
//  bugTrap
//
//  Created by Colby L Williams on 10/28/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import UIKit

class BtImageNavigationController: BtNavigationController {

	// class let storyboardId = "BtImageNavigationController"
	
	var selectingSnapshotImagesForExport = false
	
	override func prefersStatusBarHidden() -> Bool {
		return true
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
}
