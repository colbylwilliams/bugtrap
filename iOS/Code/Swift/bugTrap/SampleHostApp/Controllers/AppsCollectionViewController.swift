//
//  AppsCollectionViewController.swift
//  SampleHostApp
//
//  Created by Colby Williams on 8/22/15.
//  Copyright © 2015 bugTrap. All rights reserved.
//


import Foundation;
import UIKit;
import CoreGraphics;

class AppsCollectionViewController : UICollectionViewController, UICollectionViewDelegateFlowLayout
{
	
	let apps = [ "BloodPressureX", "bugTrap", "bugTrap Debug", "VervetaCRM.Android", "VervetaCRM.iOS", "Glucose X" ]
	
	
	override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return apps.count
	}
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AppsCollectionViewCell", forIndexPath: indexPath) as! AppsCollectionViewCell

		let app = apps[indexPath.row]
		
		cell.setContent(cellSize, app: app)
		
		return cell
	}
	
	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		if let tabController = storyboard?.instantiateViewControllerWithIdentifier("AppTabBarController") {
			showViewController(tabController, sender: self)
		}
	}

	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}

	let cellSize = CGSize(width: UIScreen.mainScreen().bounds.height > UIScreen.mainScreen().bounds.width ? UIScreen.mainScreen().bounds.width - 8 : (UIScreen.mainScreen().bounds.width - 12) / 2, height: 280)
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		return cellSize
	}
}

