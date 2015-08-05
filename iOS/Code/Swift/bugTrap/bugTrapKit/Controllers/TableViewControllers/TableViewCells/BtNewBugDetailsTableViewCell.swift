//
//  BtNewBugDetailsTableViewCell.swift
//  bugTrap
//
//  Created by Colby L Williams on 6/30/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import UIKit

class BtNewBugDetailsTableViewCell : UITableViewCell {
	
	func setData(title: String? = nil, detail: String? = nil, placeholder: String? = nil, auxiliary: String? = nil) {
		textLabel?.text = title ?? ""
		detailTextLabel?.text = detail ?? ""
	}
}