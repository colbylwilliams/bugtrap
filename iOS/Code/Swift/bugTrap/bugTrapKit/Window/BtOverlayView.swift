//
//  BtOverlayView.swift
//  bugTrap
//
//  Created by Colby L Williams on 8/23/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

class BtOverlayView: UIView {

	init() {
		super.init(frame: UIScreen.mainScreen().bounds)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}