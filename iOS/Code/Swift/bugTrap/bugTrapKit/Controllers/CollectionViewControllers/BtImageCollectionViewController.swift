//
//  BtImageCollectionViewController.swift
//  bugTrap
//
//  Created by Colby L Williams on 10/28/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import UIKit
import Photos

let reuseIdentifier = "Cell"

class BtImageCollectionViewController: BtCollectionViewController, UICollectionViewDelegateFlowLayout, PHPhotoLibraryChangeObserver {

	let size = (UIScreen.mainScreen().bounds.width - 6) / 4
	
	let scale = UIScreen.mainScreen().scale
	
	let storyboardId = "BtImageCollectionViewController", imageCell = "BtImageCollectionViewCell", addImageCell = "BtAddImageCollectionViewCell"
	
	@IBOutlet var activityButton: UIBarButtonItem!
	
	@IBOutlet var cancelButton: UIBarButtonItem!
	
	@IBOutlet var trashButton: UIBarButtonItem!
	
	@IBOutlet var titleButton: UIButton!
	
	@IBOutlet var editButton: UIBarButtonItem!
	
	@IBOutlet var doneButton: UIBarButtonItem!
	
	@IBOutlet var addButton: UIBarButtonItem!
	
	@IBOutlet var noImageDetail: UILabel!
	@IBOutlet var noImageTitle: UILabel!
	@IBOutlet var noImageView: UIView!
	
	
	var cellSize = CGSize.zeroSize, thumbSize = CGSize.zeroSize
	
	var selecting = false
	
	var editIndexes: [NSIndexPath] = []
	
	var fetchOptions = PHFetchOptions()
	
	var assetsFetchResults: PHFetchResult?
	
	var imageRequests: [NSIndexPath: PHImageRequestID] = [:]
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		fetchOptions.sortDescriptors = [ NSSortDescriptor(key: "modificationDate", ascending: false) ]
		
		TrapState.Shared.getAlbumLocalIdentifier() { _ in
			self.assetsFetchResults = PHAsset.fetchAssetsWithMediaType(.Image, options: self.fetchOptions)
			// PHPhotoLibrary.sharedPhotoLibrary().registerChangeObserver(self)
		}
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		screenName = GAIKeys.ScreenNames.selectSnapshot
		
		cellSize = CGSize(width: size, height: size)
		
		thumbSize = CGSize(width: cellSize.width * scale, height: cellSize.height * scale)
		
		noImageView.frame = UIScreen.mainScreen().bounds
		
		collectionView?.allowsMultipleSelection = true
	}
	
	
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		PHPhotoLibrary.sharedPhotoLibrary().registerChangeObserver(self)
		
		if let navController = navigationController as? BtImageNavigationController {
			selecting = navController.selectingSnapshotImagesForExport
		}
		
		updateViewConfiguration(false, updateScreenName: false, reloadData: true)

		if let selectedIndexes = collectionView?.indexPathsForSelectedItems() {
			for index in selectedIndexes {
				collectionView?.deselectItemAtIndexPath(index as NSIndexPath, animated: false)
			}
		}
	}
	
	
	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)

		PHPhotoLibrary.sharedPhotoLibrary().unregisterChangeObserver(self)
	}
	
	
	// MARK: PHPhotoLibraryChangeObserver
	
	func indexPathsFromIndexSet(indexSet: NSIndexSet) -> [NSIndexPath] {
		
		var indexPaths = [NSIndexPath]()

		indexSet.enumerateIndexesUsingBlock { idx, _ in
			indexPaths.append(NSIndexPath(forItem: idx, inSection: 0))
		}
		
		return indexPaths
	}

	
	func photoLibraryDidChange(changeInstance: PHChange) {
		
		dispatch_async(dispatch_get_main_queue()) {

			if let assets = self.assetsFetchResults {
			
				// check if there are changes to the assets (insertions, deletions, updates)
				if let collectionChanges = changeInstance.changeDetailsForFetchResult(assets) {

					self.assetsFetchResults = collectionChanges.fetchResultAfterChanges
					
					// get the new fetch result
					if !collectionChanges.hasIncrementalChanges || collectionChanges.hasMoves {

						self.collectionView?.reloadData()
						
					} else { //if collectionChanges.hasIncrementalChanges {

						var removedIndexes	= [NSIndexPath]()
						var insertedIndexes = [NSIndexPath]()
						var changedIndexes	= [NSIndexPath]()
						
						if let removed = collectionChanges.removedIndexes {
							removedIndexes = self.indexPathsFromIndexSet(removed)
						}
						
						if let inserted = collectionChanges.insertedIndexes {
							insertedIndexes = self.indexPathsFromIndexSet(inserted)
						}
						
						if let changed = collectionChanges.changedIndexes {
							changedIndexes = self.indexPathsFromIndexSet(changed)
						}
						
						// if we have incremental diffs, tell the collection view to animate insertions and deletions
						self.collectionView?.performBatchUpdates({
							
							if !removedIndexes.isEmpty {
								self.collectionView?.deleteItemsAtIndexPaths(removedIndexes)
							}
							
							if !insertedIndexes.isEmpty {
								self.collectionView?.insertItemsAtIndexPaths(insertedIndexes)
							}
							
							if !changedIndexes.isEmpty {
								self.collectionView?.reloadItemsAtIndexPaths(changedIndexes)
							}
							
						}) { _ in
						
						}
					}
				}
			}
		}
	}
	
	
	
	override func editButtonItem() -> UIBarButtonItem {
		return editButton
	}
	
	
	
	override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}

	
	var itemCountForConfiguration: Int {
		
		var resultsCount = 0, extensionSnapshotImageCount = TrapState.Shared.getExtensionSnapshotImageCount()
		
		if let results = assetsFetchResults {
			resultsCount = results.count
		}
		
		return TrapState.Shared.inActionExtension ? extensionSnapshotImageCount : resultsCount
	}
	
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		return itemCountForConfiguration
	}
	
	
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(imageCell, forIndexPath: indexPath) as! BtImageCollectionViewCell
		
		if TrapState.Shared.inActionExtension {
		
			cell.setData(TrapState.Shared.getExtensionSnapshotImageAtIndex(indexPath.item))
			
			cell.setIsSelected(TrapState.Shared.isActiveSnapshot(indexPath.item))

		} else {
		
			let manager = PHImageManager.defaultManager()
		
			if let request = imageRequests[indexPath] {
				manager.cancelImageRequest(request)
			}
		
			let asset = assetsFetchResults![indexPath.item] as! PHAsset
		
			imageRequests[indexPath] = manager.requestImageForAsset(asset, targetSize: thumbSize, contentMode: .AspectFill, options: nil) { (result, _) in
				cell.setData(result)
			}

			// cell.selected = TrapState.Shared.isSelectedSnapshot(asset.localIdentifier)
			
			// cell.setSelected(TrapState.Shared.isSelectedSnapshot(asset.localIdentifier))
		}
		
		return cell
	}
	

	
	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		
		// Log.debug(self, "didSelect")
		
		if TrapState.Shared.inActionExtension {
			self.saveActiveSnapshotAndResetAnnotateImageView(indexPath.item, localIdentifier: nil)
			return
		}
		
		if editing && !editIndexes.contains(indexPath) {
			
			editIndexes.append(indexPath)

		} else if selecting { // selecting images to add to an Issue
			
			let asset = assetsFetchResults![indexPath.item] as! PHAsset
			
			TrapState.Shared.addSnapshotImage(asset.localIdentifier)
			
		} else {
			
			let asset = assetsFetchResults![indexPath.item] as! PHAsset
			
			if let selectedItems = collectionView.indexPathsForSelectedItems()?.filter({ $0 as NSIndexPath != indexPath }) {
				collectionView.performBatchUpdates({
					for item in selectedItems {
						collectionView.deselectItemAtIndexPath(item, animated: true)
					}
				}, completion: nil)
			}
			
			saveActiveSnapshotAndResetAnnotateImageView(nil, localIdentifier: asset.localIdentifier)
		}
	}
	
	override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
		// Log.debug(self, "shouldSelect")
		return true
	}
	
	override func collectionView(collectionView: UICollectionView, shouldDeselectItemAtIndexPath indexPath: NSIndexPath) -> Bool {

		// Log.debug(self, "shouldDeselect")
		
		let deselect = editing || selecting
		
		if !deselect {
			saveActiveSnapshotAndResetAnnotateImageView(nil, localIdentifier: TrapState.Shared.getLocalIdentifierForActiveSnapshot())
		}
		
		return deselect
	}
	
	
	override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
		
		// Log.debug(self, "didDeselect")
		
		if editing {
			
			if let index = editIndexes.indexOf(indexPath) {
				editIndexes.removeAtIndex(index)
			}
			
		} else if selecting { // selecting images to add to an Issue
			
			let asset = assetsFetchResults![indexPath.item] as! PHAsset
			
			TrapState.Shared.removeSnapshotImage(asset.localIdentifier)
		
			// may need to accout for this view presented over the new bug details tvc
			// TrackerService.Shared.setCurrentTrackerType(.None) // why?
			
		} else {
			
			let asset = assetsFetchResults![indexPath.item] as! PHAsset
			
			saveActiveSnapshotAndResetAnnotateImageView(nil, localIdentifier: asset.localIdentifier)
		}
	}
	

	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		return cellSize
	}
	
	
	
	func saveActiveSnapshotAndResetAnnotateImageView (indexForExtension: Int?, localIdentifier: String?) {
		
		if let navController = navigationController as? BtImageNavigationController {
			navController.selectingSnapshotImagesForExport = false
		}
		
		if let annotateImageNavController = presentingViewController?.childViewControllers[0] as? BtAnnotateImageNavigationController {
			
			if let annotateImageController = annotateImageNavController.topViewController as? BtAnnotateImageViewController {
				annotateImageController.saveCurrentSnapshotAndResetState(indexForExtension, localIdentifierOfActiveSnapshot: localIdentifier)
			}
			
		} else if let annotateImageController = presentingViewController?.childViewControllers[0] as? BtAnnotateImageViewController {
			annotateImageController.saveCurrentSnapshotAndResetState(indexForExtension, localIdentifierOfActiveSnapshot: localIdentifier)
		}
		
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	
	
	@IBAction func titleClicked(sender: UIButton) {

		editIndexes = []
		
		editing = false;
		
		updateViewConfiguration(false, reloadData: selecting)
		
		TrapState.Shared.resetSnapshotImages(false)
		
		if let navController = navigationController as? BtImageNavigationController {
			navController.selectingSnapshotImagesForExport = false
		}
		
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	
	@IBAction func cancelClicked(sender: UIBarButtonItem) {
		
		// cancel should only appear if selecting screenshots for a new bug, or in edit state (delete)
		
		if editing {
			
			editing = false
			
			updateViewConfiguration()
			
			collectionView?.reloadItemsAtIndexPaths(editIndexes)
			
			editIndexes = []
			
		} else if selecting {
			
			TrapState.Shared.resetSnapshotImages()
			
			if let navController = navigationController as? BtImageNavigationController {
				navController.selectingSnapshotImagesForExport = false
			}
			
			dismissViewControllerAnimated(true, completion: nil)
		}
	}
	
	
	@IBAction func trashClicked(sender: UIBarButtonItem) {
		
		editing = false
		
		updateViewConfiguration(showActivity: true)
		
		let editAssets = editIndexes.map({ self.assetsFetchResults![$0.item] as! PHAsset })
		
		TrapState.Shared.deleteAssets(editAssets) {
			self.editIndexes = []
			dispatch_async(dispatch_get_main_queue()) {
				self.updateViewConfiguration()
			}
		}
	}

	
	@IBAction func editClicked(sender: UIBarButtonItem) {
		
		editing = true
		
		updateViewConfiguration()
	}
	
	
	@IBAction func doneClicked(sender: UIBarButtonItem) {
		
		if selecting {
			
			if let navController = navigationController as? BtImageNavigationController {
				navController.selectingSnapshotImagesForExport = false
			}

			if let annotateImageNavController = presentingViewController?.childViewControllers[0] as? BtAnnotateImageNavigationController {
				dismissViewControllerAnimated(true) {
					annotateImageNavController.presentNewBugDetailsNavController(true, block: nil)
				}
			} else if let annotateImageNavController = presentingViewController as? BtAnnotateImageNavigationController {
				dismissViewControllerAnimated(true) {
					annotateImageNavController.presentNewBugDetailsNavController(true, block: nil)
				}
			}
			
		} else {
			
			dismissViewControllerAnimated(true, completion: nil)
		}
	}
	
	
	@IBAction func addClicked(sender: UIBarButtonItem) {
		
//		adding = true

//		updateViewConfiguration(reloadData: true)
		
		//presentViewController(libraryNavigationController, animated: true, completion: nil)
	}
	
	
	func updateViewConfiguration(animate: Bool = true, reloadData: Bool = false, updateScreenName: Bool = true, showActivity: Bool = false) {
		
//		if itemCountForConfiguration == 0 && !noImageView.isDescendantOfView(view){
		if itemCountForConfiguration == 0 && !noImageView.isDescendantOfView(view){
			view.addSubview(noImageView)
		} else if noImageView.isDescendantOfView(view) {
			noImageView.removeFromSuperview()
		}
		
		if updateScreenName {
			self.updateScreenName(editing ? GAIKeys.ScreenNames.editSnapshots : GAIKeys.ScreenNames.selectSnapshot)
		}
		
		collectionView?.allowsMultipleSelection = true
		
		let leftItem =	selecting || editing ? cancelButton : editButton
		let rightItem = showActivity ? activityButton : editing ? trashButton : selecting ? doneButton : nil // addButton
		
		if navigationItem.leftBarButtonItem != leftItem {
			navigationItem.setLeftBarButtonItem(leftItem, animated: animate)
		}
		
		if navigationItem.rightBarButtonItem != rightItem {
			navigationItem.setRightBarButtonItem(rightItem, animated: animate)
		}
		
		if reloadData {
		
			if TrapState.Shared.inActionExtension {
				
				collectionView?.reloadData()
			
			} else if let oldCount = assetsFetchResults?.count {
				
				TrapState.Shared.getAlbumLocalIdentifier() { _ in
					
					PHPhotoLibrary.sharedPhotoLibrary().unregisterChangeObserver(self)
					
					self.assetsFetchResults = PHAsset.fetchAssetsWithMediaType(.Image, options: self.fetchOptions)
					
					if self.assetsFetchResults?.count > oldCount {
						
						dispatch_async(dispatch_get_main_queue()) {
							
							self.collectionView!.reloadData()
						}
					}
					
					PHPhotoLibrary.sharedPhotoLibrary().registerChangeObserver(self)
				}
			}
		}

//		} else if let oldCount = assetsFetchResults?.count {
//			
//			TrapState.Shared.getAlbumLocalIdentifier() { _ in
//				
//				PHPhotoLibrary.sharedPhotoLibrary().unregisterChangeObserver(self)
//				
//				self.assetsFetchResults = PHAsset.fetchAssetsWithMediaType(.Image, options: self.fetchOptions)
//				
//				if self.assetsFetchResults?.count > oldCount {
//					
//					dispatch_async(dispatch_get_main_queue()) {
//						
//						self.collectionView!.reloadData()
//					}
//				}
//				
//				PHPhotoLibrary.sharedPhotoLibrary().registerChangeObserver(self)
//			}
//		}
	}
	
	
	override func prefersStatusBarHidden() -> Bool {
		return true
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
	
    // MARK: UICollectionViewDelegate
}
