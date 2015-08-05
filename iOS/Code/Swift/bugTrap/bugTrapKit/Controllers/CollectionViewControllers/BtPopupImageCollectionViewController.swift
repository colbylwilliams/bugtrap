//
//  BtPopupImageCollectionViewController.swift
//  bugTrap
//
//  Created by Colby L Williams on 11/28/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import UIKit

// let reuseIdentifier = "Cell"

class BtPopupImageCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
	
	@IBOutlet var noImageView: UIView!
	@IBOutlet var addButton: UIButton!
		
	let standardCellSize = CGSize(width: 70, height: 125)
		
	let storyboardId = "BtPopupImageCollectionViewController"
		
	let snapshotCell = "BtPopupImageCollectionViewCell"
		
	override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
		
		
		
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return TrapState.Shared.getExtensionSnapshotImageCount()
	}
		
		
		
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
			
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(snapshotCell, forIndexPath: indexPath) as! BtPopupImageCollectionViewCell
			
		cell.setData(TrapState.Shared.getExtensionSnapshotImageAtIndex(indexPath.item))
			
		return cell
	}
		
		
		
	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		saveActiveSnapshotAndAndResetAnnotateImageView(indexPath.item)
	}
		
		
		
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
			
		let size = TrapState.Shared.getExtensionSnapshotImageAtIndex(indexPath.item)!.size
			
		let scale = standardCellSize.height / size.height
			
		return CGSizeApplyAffineTransform(size, CGAffineTransformMakeScale(scale, scale))
	}
		
		
		
	func saveActiveSnapshotAndAndResetAnnotateImageView (index: Int) {
			
		if let annotateImageNavController = presentingViewController?.childViewControllers[0] as? BtAnnotateImageNavigationController {
				
			if let annotateImageController = annotateImageNavController.topViewController as? BtAnnotateImageViewController {
				annotateImageController.saveCurrentSnapshotAndResetState(index, localIdentifierOfActiveSnapshot: nil)
			}
				
		} else if let annotateImageController = presentingViewController?.childViewControllers[0] as? BtAnnotateImageViewController {
			annotateImageController.saveCurrentSnapshotAndResetState(index, localIdentifierOfActiveSnapshot: nil)
		}
			
		dismissViewControllerAnimated(true, completion: nil)
	}
}
