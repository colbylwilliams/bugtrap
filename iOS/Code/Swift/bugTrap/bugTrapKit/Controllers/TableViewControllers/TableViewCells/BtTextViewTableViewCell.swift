//
//  BtTextViewTableViewCell.swift
//  bugTrap
//
//  Created by Colby L Williams on 6/30/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import UIKit

class BtTextViewTableViewCell: BtNewBugDetailsTableViewCell, UITextViewDelegate {
	
	@IBOutlet weak var TextView: UITextView!
	@IBOutlet weak var PlaceholderLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		PlaceholderLabel.hidden = TextView.hasText()
	}
	
	func textViewDidChange(textView: UITextView) {
		PlaceholderLabel.hidden = TextView.hasText()
	}
	
	override func setData(title: String? = nil, detail: String? = nil, placeholder: String? = nil, auxiliary: String? = nil) {
		TextView.text = detail ?? ""
		PlaceholderLabel.hidden	= TextView.hasText()
		PlaceholderLabel.text = detail == nil || detail!.isEmpty ? auxiliary ?? "" : ""
	}
	
	func textViewShouldBecomeFirstResponder() {
		TextView.becomeFirstResponder()
	}
}