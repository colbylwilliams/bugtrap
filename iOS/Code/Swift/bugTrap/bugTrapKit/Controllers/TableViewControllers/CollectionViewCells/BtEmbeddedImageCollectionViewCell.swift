//
//  BtEmbeddedImageCollectionViewCell.swift
//  bugTrap
//
//  Created by Colby L Williams on 6/30/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import UIKit

class BtEmbeddedImageCollectionViewCell: UICollectionViewCell {
    
	@IBOutlet weak var ImageView: UIImageView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
//		layer.borderWidth = 0.5
//		layer.borderColor = Colors.LightGray.cgColor
	}
	
	func setData(image: UIImage?)
	{
		ImageView.image = image
	}
}