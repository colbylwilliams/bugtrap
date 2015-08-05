//
//  BtPopupImageCollectionViewCell.swift
//  bugTrap
//
//  Created by Colby L Williams on 11/28/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import UIKit

class BtPopupImageCollectionViewCell: UICollectionViewCell {
	
	@IBOutlet var ImageView: UIImageView!
	
	var isSelected = false
	
	func setData(image: UIImage?)
	{
		ImageView.image = image
	}	
}