//
//  BtAnnotateImageViewController.swift
//  bugTrap
//
//  Created by Colby L Williams on 6/30/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import UIKit
import Social
import Photos
import MessageUI
import MobileCoreServices

class BtAnnotateImageViewController: BtViewController, UIViewControllerTransitioningDelegate, UIPopoverPresentationControllerDelegate {
	
	@IBOutlet var titleButton: UIButton!
	@IBOutlet var saveButton: UIBarButtonItem!
	@IBOutlet var cancelButton: UIBarButtonItem!
	
	@IBOutlet var settingsButton: UIBarButtonItem!
	@IBOutlet var actionButton: UIBarButtonItem!
	
	@IBOutlet var undoButton: UIBarButtonItem!
	@IBOutlet var redoButton: UIBarButtonItem!
	
	@IBOutlet var barTools: [UIBarButtonItem]!
	@IBOutlet var barColors: [UIBarButtonItem]!
	
	@IBOutlet var noImageDetail: UILabel!
	@IBOutlet var noImageTitle: UILabel!
	@IBOutlet var noImageView: UIView!
	
	var imageNavigationController: BtImageNavigationController? {
		if let navController = navigationController as? BtAnnotateImageNavigationController {
			return navController.imageNavigationController
		}
		return nil
	}
	
	var AnnotateView: BtAnnotateImageView! {
		return view as? BtAnnotateImageView
	}
	
	
	var currentTool: Annotate.Tool = .Marker {
		didSet {
			updateCurrentToolDependencies()
			Settings.annotateTool = currentTool
		}
	}
	
	
	var currentColor: Annotate.Color = .Black {
		didSet {
			updateCurrentColorDependencies()
			Settings.annotateColor = currentColor
		}
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		screenName = GAIKeys.ScreenNames.annotateSnapshot
		
		TrapState.Shared.getAlbumLocalIdentifier(nil)
		
		let tracker = TrackerService.Shared.currentTracker
		
		configureNavBarButtonsForContext()
		
		currentTool = Settings.annotateTool
		currentColor = Settings.annotateColor
		
		noImageView.frame = AnnotateView.bounds // UIScreen.mainScreen().bounds
		
		actionButton.enabled = false;
	}
	
	
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.hidesBarsOnTap = currentTool != Annotate.Tool.Callout
		
		// initial view controller in the context of an extension
		if TrapState.Shared.inActionExtension && navigationController?.extensionContext != nil {
			TrapState.Shared.setActiveSnapshotImage(0)
			AnnotateView.refreshLayoutAndImage()
		}
		
		if !TrapState.Shared.hasActiveSnapshotImageIdentifier {
			saveCurrentSnapshotAndResetState(nil, localIdentifierOfActiveSnapshot: nil)
		}
	}
	
	
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		undoButton.enabled = TrapState.Shared.hasActiveSnapshotImageIdentifier
		redoButton.enabled = TrapState.Shared.hasActiveSnapshotImageIdentifier
		
		let hasImage = AnnotateView.incrementImage != nil
		
		actionButton.enabled = hasImage
		
		if !hasImage {
			UIView.animateWithDuration(0.7, delay: 1.8, options: [.Repeat, .Autoreverse, .CurveEaseInOut, .AllowUserInteraction], animations: {
				self.titleButton.alpha = self.titleButton.alpha < 1.0 ? 1.0 : 0.4
			}, completion: nil)
		}
	}
	
	
	
	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
		
		titleButton.layer.removeAllAnimations()
		titleButton.alpha = 1.0
	}
	
	
	@IBAction func titleClicked(sender: AnyObject) {

		titleButton.layer.removeAllAnimations()
		titleButton.alpha = 1.0

		if imageNavigationController != nil { // this will be nil in Action Extension
			
			if AnnotateView.imageHasChanges { // has the image been altered?
				
				if let annotatedImage = AnnotateView.incrementImage {
					TrapState.Shared.updateActiveSnapshotImage(annotatedImage, clearActive: false) { _ in
						self.presentViewController(self.imageNavigationController!, animated: true, completion: nil)
					}
					return
				}
			}
		
			presentViewController(imageNavigationController!, animated: true, completion: nil)
		
		} else {
			
			if AnnotateView.imageHasChanges { // has the image been altered?
				if let annotatedImage = AnnotateView.incrementImage {
					TrapState.Shared.updateActiveSnapshotImage(annotatedImage, clearActive: false) { _ in
						self.performSegueWithIdentifier("BtPopupImageCollectionViewController", sender: self)
					}
					return
				}
			}
			
			performSegueWithIdentifier("BtPopupImageCollectionViewController", sender: self)
		}
	}
	
	
	
	@IBAction func settingsClicked(sender: AnyObject) {
		
		if let navController = navigationController as? BtAnnotateImageNavigationController {
			navController.presentSettingsNavController(true, block: nil)
		}
	}
	
	
	// this is only called in the context of selecting an image in the BtNewBugDetailsTableViewController
	@IBAction func saveClicked(sender: AnyObject) {
		
		if let annotatedImage = AnnotateView.incrementImage {
			TrapState.Shared.updateActiveSnapshotImage(annotatedImage, clearActive: true) { _ in
				self.dismissViewControllerAnimated(true, completion: nil)
			}
		} else {
			self.dismissViewControllerAnimated(true, completion: nil)
		}
	}
	
	
	
	@IBAction func cancelClicked(sender: AnyObject) {

		if TrapState.Shared.inActionExtension && navigationController?.extensionContext != nil {
			if let navController = navigationController as? BtAnnotateImageNavigationController {
				navController.CompleteExtensionForCancel()
			}
		} else {
			dismissViewControllerAnimated(true) {
				TrapState.Shared.deactivateActiveSnapshotImage()
			}
		}
	}
	
	
	
	@IBAction func actionClicked(sender: AnyObject) {
		
		if let annotatedImage = AnnotateView.incrementImage {
			
			let firstActivityItem = UIImageJPEGRepresentation(annotatedImage, 1.0)
			
			var applicationActivities = [UIActivity]()

			let donedoneActivity = BtTrackerActivity(trackerType: TrackerType.DoneDone)
				
			applicationActivities.append(BtTrackerActivity(trackerType: TrackerType.DoneDone))
			
			applicationActivities.append(BtTrackerActivity(trackerType: TrackerType.PivotalTracker))
			
			applicationActivities.append(BtTrackerActivity(trackerType: TrackerType.JIRA))
			
			let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: [firstActivityItem], applicationActivities: applicationActivities)

				activityViewController.excludedActivityTypes = [
					UIActivityTypePostToWeibo,
					UIActivityTypeAddToReadingList,
					UIActivityTypePostToVimeo,
					UIActivityTypePostToTencentWeibo
				]
			
				// This doesn't get called for the custom activities (BtTrackerActivity)
				activityViewController.completionWithItemsHandler = { activityType, completed, returnedItems, activityError in
					if completed {
						if let typeString = activityType {
							Analytics.Shared.activity(typeString, completed: true)
						}
					} else if activityError != nil {
						Log.error("UIActivityViewController", activityError!.localizedDescription)
					} else if let typeString = activityType {
						Analytics.Shared.activity(typeString, completed: false)
					}
				}

				// set the action but as the popover's anchor for ipad
				activityViewController.popoverPresentationController?.barButtonItem = actionButton
			
			
			// if TrapState.Shared.inActionExtension && AnnotateView.imageHasChanges { // has the image been altered?
			if AnnotateView.imageHasChanges { // has the image been altered?
				
				TrapState.Shared.updateActiveSnapshotImage(annotatedImage, clearActive: false) { _ in
					if let navControllerHack = self.navigationController {
						navControllerHack.presentViewController(activityViewController, animated: true, completion: nil)
					}
					return
				}
			} else {
				navigationController?.presentViewController(activityViewController, animated: true, completion: nil)
			}
		}
	}
	
	
	
	@IBAction func undoClicked(sender: AnyObject) {
		
		if AnnotateView.annotateUndoManager.canUndo {
			AnnotateView.annotateUndoManager.undo()
		}
		updateUndoRedoButtons()
	}
	
	
	
	@IBAction func redoClicked(sender: AnyObject) {

		if AnnotateView.annotateUndoManager.canRedo {
			AnnotateView.annotateUndoManager.redo()
		}
		updateUndoRedoButtons()
	}
	

	
	@IBAction func barToolClicked(sender: AnyObject) {
		
		if sender.tag != Annotate.Tool.Color.rawValue {
			
			currentTool = Annotate.Tool(rawValue: sender.tag)!
			
		} else {

			barColors.sortInPlace { $0.tag < $1.tag }
			
			setToolbarItems(barColors, animated: true)
		}
	}
	
	

	@IBAction func barColorClicked(sender: AnyObject) {
		
		currentColor = Annotate.Color(rawValue: sender.tag / 2)!
		
		setToolbarItems(barTools, animated: true)
	}
	
	
	
	func saveCurrentSnapshotAndResetState(indexOfActiveSnapshot : Int?, localIdentifierOfActiveSnapshot : String?) {
		
		let inExtension = TrapState.Shared.inActionExtension
		
		// one of the two had a value
		if (inExtension ? indexOfActiveSnapshot != nil : localIdentifierOfActiveSnapshot != nil) {
			
			if !TrapState.Shared.hasActiveSnapshotImage {
			
				self.AnnotateView.resetContextAndState()
				
				if inExtension {
					TrapState.Shared.setActiveSnapshotImage(indexOfActiveSnapshot!)
					// refresh to view with the new config / settings
					self.AnnotateView.refreshLayoutAndImage()
				} else {
					TrapState.Shared.setActiveSnapshotImage(localIdentifierOfActiveSnapshot!) {
						// refresh to view with the new config / settings
						self.AnnotateView.refreshLayoutAndImage()
					}
				}
				
			// the view was displaying the image at index TrapState.Shared.indexOfActiveSnapshot, so
			// save the state of that image and annotations, then switch to the index passed to this func
			// if TrapState.Shared.activeSnapshotImageLocalIdentifier != nil && TrapState.Shared.activeSnapshotImageLocalIdentifier != newLocalIdentifier {
			} else if (inExtension ? !TrapState.Shared.isActiveSnapshot(indexOfActiveSnapshot!) : !TrapState.Shared.isActiveSnapshot(localIdentifierOfActiveSnapshot!)) {
				
				if let annotatedImage = AnnotateView.incrementImage {

					self.AnnotateView.resetContextAndState()
					
					if inExtension {
						TrapState.Shared.setActiveSnapshotImage(indexOfActiveSnapshot!)
						// refresh to view with the new config / settings
						self.AnnotateView.refreshLayoutAndImage()
					} else {
						TrapState.Shared.setActiveSnapshotImage(localIdentifierOfActiveSnapshot!) {
							// refresh to view with the new config / settings
							self.AnnotateView.refreshLayoutAndImage()
						}
					}
					
				} else {
					AnnotateView.resetContextAndState()
				}
			
				// the view was displaying the image at index indexOfActiveSnapshotCache, so
				// save the image and annotations, then switch to the index passed to this func (newIndex)
			}
		
			// lose the "No Image" view, we have something to show
			if noImageView.isDescendantOfView(AnnotateView) {
				noImageView.removeFromSuperview()
			}

		} else if TrapState.Shared.hasActiveSnapshotImage {
			
			// lose the "No Image" view, we have something to show
			if noImageView.isDescendantOfView(AnnotateView) {
				noImageView.removeFromSuperview()
			}
			
		} else {
			AnnotateView.resetContextAndState()
			// no image index to display, so let the user know
			AnnotateView.addSubview(noImageView)
			actionButton.enabled = false
		}
 	}
	
	
	
	func updateUndoRedoButtons() {
		// undoButton.enabled = AnnotateView.annotateUndoManager.canUndo
		redoButton.enabled = AnnotateView.annotateUndoManager.canRedo
	}
	
	
	
	func updateCurrentToolDependencies() {
		
		AnnotateView.configureTool(currentTool)
		
		navigationController!.hidesBarsOnTap = currentTool != Annotate.Tool.Callout
		
		for tool in barTools {
			if tool.tag >= 0 && tool.tag != Annotate.Tool.Color.rawValue {
				let bt = Annotate.Tool(rawValue: tool.tag)
				tool.image = bt == currentTool ? bt?.imageOn(currentColor) : bt?.image(currentColor)
			}
		}
	}
	
	
	
	func updateCurrentColorDependencies() {
		
		if let colorTool = barTools.filter( { $0.tag == Annotate.Tool.Color.rawValue } ).first {
			colorTool.image = Annotate.Tool.Color.image(currentColor)
		}
		
		AnnotateView.configureStroke(currentColor.color())
	}

	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "BtPopupImageCollectionViewController" {
			if let popoverController = segue.destinationViewController as? BtPopupImageCollectionViewController {
				popoverController.popoverPresentationController?.delegate = self
				popoverController.popoverPresentationController?.sourceView = titleButton
				popoverController.preferredContentSize = CGSize(width: 300, height: 142)
			}
		}
	}

	
	func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
		return .None
	}
	
	
	
	func configureNavBarButtonsForContext() {
		
		// extension uses the 'flipped' theme with white bars and red icons
		if TrapState.Shared.inActionExtension {
			titleButton.setImage(UIImage(named: "i_logo_web_red"), forState: .Normal)
		}
		
		// selected an existing screenshot from the new bug form - cancel, save
		if let newBugDetailsNavController = navigationController?.presentingViewController as? BtNewBugDetailsNavigationController {
			navigationItem.setLeftBarButtonItems([cancelButton, undoButton], animated: false)
			navigationItem.setRightBarButtonItems([saveButton, redoButton], animated: false)
		} else if TrapState.Shared.inActionExtension {
			navigationItem.setLeftBarButtonItems([cancelButton, undoButton], animated: false)
			navigationItem.rightBarButtonItems?.append(redoButton)
		} else {
			navigationItem.rightBarButtonItems?.append(redoButton)
			navigationItem.leftBarButtonItems?.append(undoButton)
		}
		
		navigationItem.titleView = titleButton
	}

	
	// MARK: UIViewControllerTransitioningDelegate
	
//	func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController!, sourceViewController source: UIViewController) -> UIPresentationController? {
//		// code
//		return nil
//	}
//	
//	
//	func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//		return nil
//	}
//	
//	
//	func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//		return nil
//	}
//	
//	
//	override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
//		AnnotateView.updateContextAndStateForRotation()
//	}
	
	
	override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
		AnnotateView.refreshLayoutAndImageForRotation()
		
		if noImageView.isDescendantOfView(AnnotateView) {
			noImageView.frame = AnnotateView.bounds
//			noImageView.setNeedsDisplay()
		}
	}
	
	override func prefersStatusBarHidden() -> Bool {
		return true
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
}