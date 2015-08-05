//
//  BtAnnotateImageNavigationController.swift
//  bugTrap
//
//  Created by Colby L Williams on 6/30/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import UIKit
// import Foundation
import MobileCoreServices

class BtAnnotateImageNavigationController: BtNavigationController {

	var snap: UIView?
	var snapshot: UIView?
	var container: UIView?

	var continueNewBugFlowOnDidAppear = false
	var manuallyInitiatedSettingsFlow = false

	var imageNavigationController: BtImageNavigationController?

	required override init(coder aDecoder: NSCoder) {

		Settings.registerDefaultSettings()
		Analytics.Shared

		super.init(coder: aDecoder)
	}


	override func loadView() {
		super.loadView()

		if let context = self.extensionContext {

			TrapState.Shared.inActionExtension = true

			for inputItem in context.inputItems {
				if let item = inputItem as? NSExtensionItem {
					if let providers = item.attachments as? [NSItemProvider] {

						for provider in providers {
						 if provider.hasItemConformingToTypeIdentifier(kUTTypeImage as NSString as String) {
							provider.loadItemForTypeIdentifier(kUTTypeImage as NSString as String, options: nil) { data, error in
								// Log.debug("adding new snapshot image...")
								if let nsData = NSData(contentsOfURL: data as NSURL) {
									if let image = UIImage(data: nsData) {
										TrapState.Shared.addSnapshotImage(image, makeActive: TrapState.Shared.hasActiveSnapshotImageIdentifier)
									}
								}
							}
						}
						}
					}
				}
			}
		} else if imageNavigationController == nil {

			let kitStoryboard = UIStoryboard(name: "bugTrapKit", bundle: nil)

			imageNavigationController = kitStoryboard.instantiateViewControllerWithIdentifier("BtImageNavigationController") as? BtImageNavigationController
			imageNavigationController?.modalTransitionStyle = .CrossDissolve
		}
	}



	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

		if !manuallyInitiatedSettingsFlow {
			if let presentedController = presentedViewController as? BtSettingsNavigationController {
				continueNewBugFlowOnDidAppear = TrackerService.Shared.hasCurrentAuthenticatedTracker
				if !continueNewBugFlowOnDidAppear {
					TrackerService.Shared.setCurrentTrackerType(.None)
				}
			}
		} else {
			manuallyInitiatedSettingsFlow = false
			TrackerService.Shared.setCurrentTrackerType(.None)
		}

		if self.extensionContext != nil {
			setNavigationBarHidden(true, animated: false)
			setToolbarHidden(true, animated: false)
		}
	}



	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)

		if self.extensionContext != nil {
			setNavigationBarHidden(false, animated: true)
			setToolbarHidden(false, animated: true)
		}

		if continueNewBugFlowOnDidAppear {

			if self.extensionContext != nil {

				let kitStoryboard = UIStoryboard(name: "bugTrapKit", bundle: nil)

				if let controller = kitStoryboard.instantiateViewControllerWithIdentifier("BtNewBugDetailsNavigationController") as? UINavigationController {
					presentViewController(controller, animated: true, completion: nil)
				}

			} else if imageNavigationController != nil {

				imageNavigationController?.selectingSnapshotImagesForExport = true
				presentViewController(imageNavigationController!, animated: true, completion: nil)
			}

			continueNewBugFlowOnDidAppear = false
		}
	}



	func CompleteExtensionForSubmit () {
		if let context = self.extensionContext {
			extensionTrapState()
			context.completeRequestReturningItems(self.extensionContext!.inputItems, completionHandler: nil)
		}
	}



	func CompleteExtensionForCancel () {
		if let context = self.extensionContext {
			extensionTrapState()
			context.cancelRequestWithError(NSError(domain: "bugTrap", code: 0, userInfo: nil))
		}
	}


	func presentSettingsNavController (animate: Bool, block: (() -> Void)?) {

		manuallyInitiatedSettingsFlow = true

		let kitStoryboard = UIStoryboard(name: "bugTrapKit", bundle: nil)

		if let settingsNavController = kitStoryboard.instantiateViewControllerWithIdentifier("BtSettingsNavigationController") as? UINavigationController {
			presentViewController(settingsNavController, animated: animate, completion: block)
		}
	}


	func extensionTrapState() {

		TrapState.Shared.resetSnapshotImages()
		TrackerService.Shared.resetAndRemoveCurrentTracker()
	}
}