//
//  BtImageCollectionViewCell.swift
//  bugTrap
//
//  Created by Colby L Williams on 10/28/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import UIKit

class BtImageCollectionViewCell: UICollectionViewCell {
	
	@IBOutlet var ImageView: UIImageView!
	@IBOutlet var SelectButton: UIButton!
	@IBOutlet var SelectedOverlay: UIView!
	
	var lIsSelected = false
	
	func setData(image: UIImage?)
	{
		ImageView.image = image
	}
	
	func setIsSelected (isSelected: Bool)
	{
		// selected = isSelected
		self.lIsSelected = isSelected
		SelectedOverlay.hidden = !isSelected
	}
}
