//
//  BtDatePickerTableViewCell.swift
//  bugTrap
//
//  Created by Colby L Williams on 6/30/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import UIKit

class BtDatePickerTableViewCell: BtNewBugDetailsTableViewCell {

	@IBOutlet weak var DatePicker: UIDatePicker!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		DatePicker.minimumDate = NSDate()
		
		DatePicker.setDate(NSDate(timeIntervalSinceNow: 866400), animated: false)
	}
	
	override func setData(title: String? = nil, detail: String? = nil, placeholder: String? = nil, auxiliary: String? = nil) {

	}
	
	func setData (date: NSDate, animate: Bool) {
		DatePicker.setDate(date, animated: animate)
	}
}