//
//  BtOverlayWindow.swift
//  bugTrap
//
//  Created by Colby L Williams on 8/23/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

class BtOverlayWindow: UIWindow {
	
	init() {
		super.init(frame: UIScreen.mainScreen().bounds)
		
		let btOverlayViewController = BtOverlayViewController()

		rootViewController = btOverlayViewController

		addSubview(btOverlayViewController.view)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	

	override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {

		let result = super.hitTest(point, withEvent: event)
		
		return result is BtOverlayView ? nil : result
	}
}