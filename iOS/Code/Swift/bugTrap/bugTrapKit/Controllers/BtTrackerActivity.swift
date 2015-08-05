//
//  BtTrackerActivity.swift
//  bugTrap
//
//  Created by Colby L Williams on 9/24/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import UIKit

class BtTrackerActivity: UIActivity {

	let type: TrackerType
	
	let title : String
	let icon : UIImage

	init(trackerType: TrackerType) {
		self.type	= trackerType
		self.title	= trackerType.rawValue
		self.icon	= UIImage(named: trackerType.activityImageName!)!
	}
	
	override func activityImage() -> UIImage? {
		return icon
	}
	
	override func activityTitle() -> String? {
		return title
	}
	
	override func activityType() -> String? {
		return type.activityType
	}
	
	override class func activityCategory() -> UIActivityCategory {
		return .Share
	}
	
	override func canPerformWithActivityItems(activityItems: [AnyObject]) -> Bool {
		return true
	}
	
	override func prepareWithActivityItems(activityItems: [AnyObject]) {
		
	}
	
	override func activityViewController() -> UIViewController? {
		
		//TrackerService.Shared.setCurrentTrackerType(type)

		let kitStoryboard = UIStoryboard(name: "bugTrapKit", bundle: nil)
		
		if TrackerService.Shared.setCurrentTrackerType(type) && TrackerService.Shared.currentTracker != nil && TrackerService.Shared.currentTracker!.Authenticated {
			
			if TrapState.Shared.inActionExtension {
				return kitStoryboard.instantiateViewControllerWithIdentifier("BtNewBugDetailsNavigationController") as? UINavigationController
			} else {
				// TrapState.Shared.selectingSnapshotImagesForExport = true
				if let imageNavigationController = kitStoryboard.instantiateViewControllerWithIdentifier("BtImageNavigationController") as? BtImageNavigationController {
					// TrapState.Shared.addActiveSnapshotImage()
					imageNavigationController.selectingSnapshotImagesForExport = true
					return imageNavigationController
				}
				Analytics.Shared.activity(self.type.activityType, completed: false)
				return nil
			}
		}
		
//		if TrackerService.Shared.CurrentTracker == nil {
//			println("TrackerService.Shared.CurrentTracker == nil")
//		} else if !TrackerService.Shared.CurrentTracker!.trackerState.Authenticated {
//			println("TrackerService.Shared.CurrentTracker!trackerState.Authenticated == false")
//		}
		
		return kitStoryboard.instantiateViewControllerWithIdentifier("BtSettingsNavigationController") as? UINavigationController
	}
	
	override func performActivity() {
		
		activityDidFinish(true)
	}
}