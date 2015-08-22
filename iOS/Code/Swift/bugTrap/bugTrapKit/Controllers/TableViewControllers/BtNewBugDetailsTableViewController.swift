//
//  BtNewBugDetailsTableViewController.swift
//  bugTrap
//
//  Created by Colby L Williams on 6/30/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import UIKit
import Photos

class BtNewBugDetailsTableViewController : BtTableViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	@IBOutlet var saveButton: UIBarButtonItem!
	@IBOutlet var submitButton: UIBarButtonItem!
	@IBOutlet var cancelButton: UIBarButtonItem!
	@IBOutlet var activityButton: UIBarButtonItem!
	@IBOutlet var activityIndicator: UIActivityIndicatorView!

	let scale = UIScreen.mainScreen().scale
	
	let cellSize = CGSize(width: 125, height: 125)
	var thumbSize = CGSize.zeroSize
	
	var didAssignTitleFirstResponder = false
	
    //index path will be updated to the date picker cell when it's selected
    var datePickerIndexPath : NSIndexPath!
	
	
	var datePickerCellOpen: Bool = false {
		didSet {
			tableView.reloadSections(NSIndexSet(index: datePickerIndexPath.section), withRowAnimation: .Automatic)
		}
	}
	
	var assetsFetchResults: PHFetchResult?
	
	var imageRequests: [Int: PHImageRequestID] = [:]
	
	var options = PHFetchOptions()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		if let tracker = TrackerService.Shared.currentTracker {
			screenName = "\(GAIKeys.ScreenNames.bugDetails) (\(tracker.type.rawValue))"
		}
		
		thumbSize = CGSize(width: cellSize.width * scale, height: cellSize.height * scale)
		
		options.sortDescriptors = [ NSSortDescriptor(key: "modificationDate", ascending: false) ]
		
		assetsFetchResults = PHAsset.fetchAssetsWithLocalIdentifiers(TrapState.Shared.getLocalIdentifiersForActiveSnapshots(), options: self.options)
	}
	
	
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController!.hidesBarsOnTap = false
		
		if !isMovingToParentViewController() {
			
			if let state = TrackerService.Shared.currentTracker?.trackerState {
				
				tableView.reloadSections(NSIndexSet(index: state.ActiveBugDetail), withRowAnimation: .Automatic)
			}
			
			assetsFetchResults = PHAsset.fetchAssetsWithLocalIdentifiers(TrapState.Shared.getLocalIdentifiersForActiveSnapshots(), options: self.options)
			reloadEmbeddedImageCollectinView()
		}
	}

	
	
	func reloadEmbeddedImageCollectinView() {
		if TrapState.Shared.hasSnapshotImages {
			if let imageCell = (tableView.visibleCells.filter({$0 as? BtEmbeddedImageCollectionViewTableViewCell != nil})).first as? BtEmbeddedImageCollectionViewTableViewCell {
				imageCell.reloadCollectionView()
			}
		}
	}
	
	

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		validateBugDetails()
		
        if let state = TrackerService.Shared.currentTracker?.trackerState {
			if state.IsActiveTopLevelDetail && state.hasProject {
				if let textFieldCell = (tableView.visibleCells.filter({$0 as? BtTextFieldTableViewCell != nil})).first as? BtTextFieldTableViewCell {
					didAssignTitleFirstResponder = textFieldCell.textFieldShouldBecomeFirstResponder()
				}
			}
		}
	}
	
	
	
	override func canBecomeFirstResponder() -> Bool {
		return true
	}
	
	
	
	override func becomeFirstResponder() -> Bool {
		
		validateBugDetails()
		
		if didAssignTitleFirstResponder {
			
			didAssignTitleFirstResponder = false
			
			if let textViewCell = (tableView.visibleCells.filter({$0 as? BtTextViewTableViewCell != nil})).first as? BtTextViewTableViewCell {
				tableView.scrollRectToVisible(tableView.rectForRowAtIndexPath(tableView.indexPathForCell(textViewCell)!), animated: true)
				textViewCell.textViewShouldBecomeFirstResponder()
			}
		}
		
		return true
	}
	
	
	
	
	// MARK: Table view data source
	
	
	override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
		if let details = TrackerService.Shared.currentTracker?.TrackerDetails {
			return details.count
		}
		return 0
	}
	
	
	
	override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
		if let isDate = TrackerService.Shared.currentTracker?.TrackerDetails[section]?.isDate() {
			return isDate && datePickerCellOpen ? 2 : 1
		}
		return 1
	}
	
	
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		if indexPath.row > 0 {
			return tableView.dequeueReusableCellWithIdentifier(BugDetails.DetailType.DatePicker(NSDate(), "Date").cellId(), forIndexPath: indexPath) as! BtNewBugDetailsTableViewCell
		}
		
		if let tracker = TrackerService.Shared.currentTracker {
			
			if let cellValue = tracker.TrackerDetails[indexPath.section] {
				
				let value = tracker.trackerState.getValueForDetail(indexPath.section)
			
				let cell = tableView.dequeueReusableCellWithIdentifier(cellValue.cellId(), forIndexPath: indexPath) as! BtNewBugDetailsTableViewCell
				
				switch cellValue {
				
				case .Images:
					cell.setData()
				
				case let .Selection (label, title):
					cell.setData(title, detail: value, auxiliary: label)
				
				case let .TextField (label, title):
					cell.setData(title, detail: value, auxiliary: label)
				
				case let .TextView (label, title):
					cell.setData(title, detail: value, auxiliary: label)
				
				case let .DateDisplay (label, title):
					cell.setData(title, detail: value, auxiliary: label)
				
				case let .DatePicker (_, label):
					cell.setData(label)
				}
			
				return cell
			}
		}
		
		return tableView.dequeueReusableCellWithIdentifier("BtTitlePlaceholderTableViewCell", forIndexPath: indexPath) as! BtNewBugDetailsTableViewCell
	}
	
		
		
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		
		if indexPath.row > 0 {
			return 163.0
		}
		
		if let height = TrackerService.Shared.currentTracker?.TrackerDetails[indexPath.section]?.cellHeight() {
			return height
		}
		
		return 44.0
	}
	
	
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
		tableView.cellForRowAtIndexPath(indexPath)!.selected = false
        
		TrackerService.Shared.currentTracker?.trackerState.ActiveBugDetail = indexPath.section
        
		if let cellType = TrackerService.Shared.currentTracker?.trackerState.getActiveCellType() {
			
			switch cellType {
            
			case .Selection:
				if let newBugDetailSelectTvController = storyboard!.instantiateViewControllerWithIdentifier("BtNewBugDetailsSelectTableViewController") as? BtNewBugDetailsSelectTableViewController {
					showViewController(newBugDetailSelectTvController, sender: self)
				}
            
			case .Date:
				datePickerIndexPath = NSIndexPath(forRow: 1, inSection: indexPath.section)
				datePickerCellOpen = !datePickerCellOpen
            
			default: break;
			}
		}
	}
	
	
	
	@IBAction func tapRecognized(sender: AnyObject) {
		didAssignTitleFirstResponder = false
		validateBugDetails()
		view.endEditing(true)
	}
	
	
	
	@IBAction func cancelClicked(sender: AnyObject) {

		TrapState.Shared.resetSnapshotImages()
		dismissControllerAndResetTrapState(false)
		TrackerService.Shared.setCurrentTrackerType(.None)
	}
	
	
	
	@IBAction func saveClicked(sender: AnyObject) {
        
        navigationController!.dismissViewControllerAnimated(true, completion: nil)
	}
	
	
	
	@IBAction func submitClicked(sender: AnyObject) {
		
        if validateBugDetails() {
			
			// TODO color the activity indicator red
			if TrapState.Shared.inActionExtension {
				activityIndicator.color = Colors.Theme.uiColor
			}

			navigationItem.setRightBarButtonItem(activityButton, animated: true)
			
            TrackerService.Shared.currentTracker?.createIssue() { result in
                switch result {
                case let .Error(error):
					Log.error(self.screenName!, error)
					self.dismissControllerAndResetTrapState(true)
                case let .Value(wrapped):
					self.dismissControllerAndResetTrapState(true)
					if let boolResult = wrapped.value {
						Log.info(boolResult)
					}
                }
            }
		}
	}
	
	
	
	@IBAction func datePickerValueChanged(sender: UIDatePicker) {
		
		if let dateDisplayCell = (tableView.visibleCells.filter({$0 as? BtDateDisplayTableViewCell != nil})).first as? BtDateDisplayTableViewCell {

			if let _ = TrackerService.Shared.currentTracker?.trackerState {
				
				TrackerService.Shared.currentTracker?.trackerState.bugDueDate = sender.date

				if let index = tableView.indexPathForCell(dateDisplayCell) {
					tableView.reloadRowsAtIndexPaths([ index ], withRowAnimation: UITableViewRowAnimation.None)
				}
			}
		}
	}
	
	
	
	func dismissControllerAndResetTrapState(successful: Bool) {
		
		navigationItem.setRightBarButtonItem(submitButton, animated: true)
		
		if TrapState.Shared.inActionExtension {
		
			if navigationController?.extensionContext != nil {

				if let navController = navigationController as? BtAnnotateImageNavigationController {
				
					if successful {
						navController.CompleteExtensionForSubmit()
					} else {
						navController.CompleteExtensionForCancel()
					}
				}
				
			} else if let navController = presentingViewController?.childViewControllers[0] as? BtAnnotateImageNavigationController {
				
				if navController.extensionContext != nil {
					
					if successful {
						navController.CompleteExtensionForSubmit()
					} else {
						navController.CompleteExtensionForCancel()
					}
				}
			}
		} else {
			
			TrapState.Shared.resetSnapshotImages()
			
			TrackerService.Shared.resetAndRemoveCurrentTracker()
			
			navigationController?.dismissViewControllerAnimated(true) {
				
			}
		}
	}
	
	
	
	func validateBugDetails () -> Bool {

		if let state = TrackerService.Shared.currentTracker?.trackerState {
			
			if let textFieldCell = (tableView.visibleCells.filter({$0 as? BtTextFieldTableViewCell != nil})).first as? BtTextFieldTableViewCell {
				if textFieldCell.TextField.hasText() {
					TrackerService.Shared.currentTracker?.trackerState.bugTitle = textFieldCell.TextField.text ?? ""
				}
			}
		
			if let textViewCell = (tableView.visibleCells.filter({$0 as? BtTextViewTableViewCell != nil})).first as? BtTextViewTableViewCell {
				if textViewCell.TextView.hasText() {
					TrackerService.Shared.currentTracker?.trackerState.bugDescription = textViewCell.TextView.text
				}
			}

			submitButton.enabled = state.isValid
		
			return state.isValid
		}
		
		return false
	}
	
	
	
	func getScaledSizeForAsset(asset: PHAsset, scaleSize: Bool) -> CGSize {
		
		let size = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
		
		var scaled = (standardSize.height / size.height)
		
		if scaleSize {
			scaled *= scale
		}
		
		return CGSizeApplyAffineTransform(size, CGAffineTransformMakeScale(scaled, scaled))
	}
	
	
	
	// #pragma mark - Collection view data source

	let addSnapshotCell = "BtEmbeddedAddImageCollectionViewCell", snapshotCell = "BtEmbeddedImageCollectionViewCell"
	
	
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

		var assetFetchResultsCount = 0
		
		if let assetFetchResults = assetsFetchResults {
			assetFetchResultsCount = assetFetchResults.count
		}

		return TrapState.Shared.inActionExtension ? TrapState.Shared.getExtensionSnapshotImageCount() : assetFetchResultsCount + 1
	}
	
	
	
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		
		if TrapState.Shared.inActionExtension {
			
			let cell = collectionView.dequeueReusableCellWithReuseIdentifier(snapshotCell, forIndexPath: indexPath) as! BtEmbeddedImageCollectionViewCell
			
			cell.setData(TrapState.Shared.getExtensionSnapshotImageAtIndex(indexPath.item))
			
			return cell
			
		} else if indexPath.item == 0 {
		
			return collectionView.dequeueReusableCellWithReuseIdentifier(addSnapshotCell, forIndexPath: indexPath) as UICollectionViewCell

		} else {
			
			let cell = collectionView.dequeueReusableCellWithReuseIdentifier(snapshotCell, forIndexPath: indexPath) as! BtEmbeddedImageCollectionViewCell
		
			let manager = PHImageManager.defaultManager()
			
			let index = indexPath.item - 1
		
			if let request = imageRequests[index] {
				manager.cancelImageRequest(request)
			}
			
			let asset = assetsFetchResults![index] as! PHAsset
		
			imageRequests[index] = manager.requestImageForAsset(asset, targetSize: getScaledSizeForAsset(asset, scaleSize: true), contentMode: .AspectFill, options: nil) { (result, _) in
				cell.setData(result)
			}
			
			return cell
		}
	}
	
	
	
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		
		if TrapState.Shared.inActionExtension {
			
			TrapState.Shared.setActiveSnapshotImage(indexPath.item)
			displayAnnotateImageNavigationController()
			
		} else if indexPath.item == 0 {

			if let _ = navigationController as? BtNewBugDetailsNavigationController {
				
				if let annotateImageNavController = presentingViewController?.childViewControllers[0] as? BtAnnotateImageNavigationController {
					dismissViewControllerAnimated(true) {
						if let imageNavController = annotateImageNavController.imageNavigationController {
							imageNavController.selectingSnapshotImagesForExport = true;
							annotateImageNavController.presentViewController(imageNavController, animated: true) {}
						}
					}
				} else if let annotateImageNavController = presentingViewController as? BtAnnotateImageNavigationController {
					dismissViewControllerAnimated(true) {
						if let imageNavController = annotateImageNavController.imageNavigationController {
							imageNavController.selectingSnapshotImagesForExport = true;
							annotateImageNavController.presentViewController(imageNavController, animated: true) {}
						}
					}
				}
			}
			
			return
			
		} else {
			
			let asset = assetsFetchResults![indexPath.item - 1] as! PHAsset
			
			TrapState.Shared.setActiveSnapshotImage(asset.localIdentifier) {
				self.displayAnnotateImageNavigationController()
			}
		}
	}


	func displayAnnotateImageNavigationController () {
		if let annotateImageNavController = storyboard?.instantiateViewControllerWithIdentifier("BtAnnotateImageNavigationController") as? BtAnnotateImageNavigationController {
			presentViewController(annotateImageNavController, animated: true, completion: nil)
		}
	}
	
	
	
	let standardSize = CGSize(width: 70, height: 125)
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

		if TrapState.Shared.inActionExtension {
			
			// let index = indexPath.item - (TrapState.Shared.inActionExtension ? 0 : 1)
			
			if let size = TrapState.Shared.getExtensionSnapshotImageAtIndex(indexPath.item)?.size {
			
				let scaled = standardSize.height / size.height
			
				return CGSizeApplyAffineTransform(size, CGAffineTransformMakeScale(scaled, scaled))
			
			} else {
				return standardSize
			}

		}
		
		if indexPath.item == 0 {
		
			return standardSize
				
		} else {
				
			let index = indexPath.item - 1
				
			// let manager = PHImageManager.defaultManager()
				
			let asset = assetsFetchResults![index] as! PHAsset
			
			return getScaledSizeForAsset(asset, scaleSize: false)
		}
	}
	
	
	override func prefersStatusBarHidden() -> Bool {
		return true
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
}