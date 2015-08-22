//
//  BtOverlayViewController.swift
//  bugTrap
//
//  Created by Colby L Williams on 8/23/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation
import UIKit

class BtOverlayViewController: UIViewController {
	
	var tapGesture = UITapGestureRecognizer()
	var panGesture = UIPanGestureRecognizer()
	
	var trigger = UIImageView()
	
	var triggerCenter: CGPoint = CGPoint.zeroPoint
//	var triggerCenterBoundsCache = CGRect(x: UIScreen.mainScreen().bounds.midX - 20, y: UIScreen.mainScreen().bounds.midY - 20, width: 40, height: 40)
	
	let triggerCenterBounds = CGRect(x: UIScreen.mainScreen().bounds.midX - 20, y: UIScreen.mainScreen().bounds.midY - 20, width: 40, height: 40)
	
	var triggerBounds = CGRectInset(UIScreen.mainScreen().bounds, 20, 20)
	
	
	init() {
		super.init(nibName: nil, bundle: nil)
		
		view = BtOverlayView()
		
		initTrigger()
		
		initGestureRecognizers()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		trigger.addGestureRecognizer(tapGesture)
		trigger.addGestureRecognizer(panGesture)
	}
	
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		let frame = CGRect(x: 4, y: view.bounds.height - 94, width: 40, height: 40)
		
		UIView.animateWithDuration(1, animations: {
			self.trigger.alpha = 1
		}) { _ in
			UIView.animateWithDuration(0.8) {
				self.trigger.frame = frame
			}
		}
	}
	
	
	override func viewWillDisappear(animated: Bool) {

		trigger.removeGestureRecognizer(tapGesture)
		trigger.removeGestureRecognizer(panGesture)
		
		super.viewWillDisappear(animated)
	}
	
	
	func initTrigger () {
		
		trigger.frame = triggerCenterBounds
		trigger.contentMode = .ScaleAspectFit
		trigger.image = UIImage(named: "i_trigger")
		trigger.alpha = 0;
		
		trigger.userInteractionEnabled = true
		
		view.addSubview(trigger)
	}
	
	
	func initGestureRecognizers() {
		
		tapGesture.addTarget(self, action: "handleTapGesture:")
		panGesture.addTarget(self, action: "handlePanGesture:")
	}

	
	func handleTapGesture (tap: UITapGestureRecognizer) {
		
		if tap.state == .Recognized {
			
			var image: UIImage
			
			UIGraphicsBeginImageContextWithOptions(UIScreen.mainScreen().bounds.size, true, 0)
			
			UIApplication.sharedApplication().windows[0].drawViewHierarchyInRect(UIScreen.mainScreen().bounds, afterScreenUpdates: false)
			
			image = UIGraphicsGetImageFromCurrentImageContext()
			
			UIGraphicsEndImageContext()
			
			TrapState.Shared.addSnapshotImageForSdk(image) { _ in
				
				let kitStoryboard = UIStoryboard(name: "bugTrapKit", bundle: self.nibBundle)
				
				let navController = kitStoryboard.instantiateViewControllerWithIdentifier("BtAnnotateImageNavigationController")

				self.presentViewController(navController, animated: false, completion: nil)
			}
		}
	}
	
	
	func handlePanGesture (pan: UIPanGestureRecognizer) {
		
		switch pan.state {
		case .Changed:

			let translation = pan.translationInView(view)
			
			let center = CGPoint(x: triggerCenter.x + translation.x, y: triggerCenter.y + translation.y)
			
			if triggerBounds.contains(center) {
				trigger.center = center
			}
			
		case .Began: triggerCenter = trigger.center
			
		case .Ended: triggerCenter = CGPoint.zeroPoint
			
		default: return
		}
	}
	
	func toggleTriggerVisibility() {
		trigger.hidden = !trigger.hidden
	}
}