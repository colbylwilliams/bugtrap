//
//  BtAddImageCollectionViewCell.swift
//  bugTrap
//
//  Created by Colby L Williams on 10/28/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import UIKit

class BtAddImageCollectionViewCell: UICollectionViewCell {
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		// addImageLabel.textColor = Colors.Theme.uiColor
		
		layer.borderWidth = 0.5
		layer.borderColor = Colors.LightGray.cgColor
	}
}
