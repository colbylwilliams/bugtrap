//
//  BtImageCollectionViewContainerTableViewCell.swift
//  bugTrap
//
//  Created by Colby L Williams on 6/30/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import UIKit

class BtEmbeddedImageCollectionViewTableViewCell : BtNewBugDetailsTableViewCell {

	@IBOutlet weak var EmbeddedImageCollectionView: BtEmbeddedImageCollectionView!
	
	var collectionView: BtEmbeddedImageCollectionView {
		return EmbeddedImageCollectionView
	}
	
	override func setData(title: String? = nil, detail: String? = nil, placeholder: String? = nil, auxiliary: String? = nil) {

	}
	
	func reloadCollectionView() {
		EmbeddedImageCollectionView.reloadData()
	}
}