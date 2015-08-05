//
//  BtTitlePlaceholderTableViewCell.swift
//  bugTrap
//
//  Created by Colby L Williams on 8/22/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import UIKit

class BtTitlePlaceholderTableViewCell: BtNewBugDetailsTableViewCell {
	
	@IBOutlet weak var TitleLabel: UILabel!
	@IBOutlet weak var DetailLabel: UILabel!
	@IBOutlet weak var PlaceholderLabel: UILabel!
	
	override func setData(title: String? = nil, detail: String? = nil, placeholder: String? = nil, auxiliary: String? = nil) {
		TitleLabel.text = detail == nil || detail!.isEmpty ? "" : title
		DetailLabel.text = detail ?? ""
		PlaceholderLabel.text = detail == nil || detail!.isEmpty ? auxiliary ?? "" : ""
	}
}