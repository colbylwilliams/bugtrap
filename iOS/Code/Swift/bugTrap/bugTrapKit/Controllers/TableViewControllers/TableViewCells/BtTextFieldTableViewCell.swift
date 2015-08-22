//
//  BtTextFieldTableViewCell.swift
//  bugTrap
//
//  Created by Colby L Williams on 6/30/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import UIKit

class BtTextFieldTableViewCell: BtNewBugDetailsTableViewCell, UITextFieldDelegate {
	
	@IBOutlet weak var TextField: UITextField!
	@IBOutlet weak var PlaceholderLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		PlaceholderLabel.hidden	= TextField.hasText()
	}
	
	
	func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
		PlaceholderLabel.hidden	= !string.isEmpty || range.location > 0
		return true
	}

	
	override func setData(title: String? = nil, detail: String? = nil, placeholder: String? = nil, auxiliary: String? = nil) {
		TextField.text = detail ?? ""
		PlaceholderLabel.hidden	= TextField.hasText()
		PlaceholderLabel.text = detail == nil || detail!.isEmpty ? auxiliary ?? "" : ""
	}
	
	
	func textFieldShouldBecomeFirstResponder() -> Bool {
		if !TextField.hasText() {
			TextField.becomeFirstResponder()
			return true
		}
		return false
	}
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		TextField.resignFirstResponder()
		return false
	}
}