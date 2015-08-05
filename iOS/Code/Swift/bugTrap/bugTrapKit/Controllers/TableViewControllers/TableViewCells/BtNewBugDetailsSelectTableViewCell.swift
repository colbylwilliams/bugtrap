//
//  BtNewBugDetailsSelectTableViewCell.swift
//  bugTrap
//
//  Created by Colby L Williams on 6/30/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import UIKit

class BtNewBugDetailsSelectTableViewCell: BtNewBugDetailsTableViewCell {

	var loadingKey: NSIndexPath?
	
	var initialsLabel = UILabel()
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		imageView?.layer.cornerRadius = 22.0
		imageView?.layer.masksToBounds = true
		
		initialsLabel.textColor = Colors.Theme.uiColor
		initialsLabel.textAlignment = .Center
		initialsLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 20.0)
		initialsLabel.backgroundColor = Colors.Clear.uiColor
		
		addSubview(initialsLabel)
		
		imageView?.contentMode = UIViewContentMode.ScaleAspectFit
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		if let imageViewFrame = imageView?.frame {
			initialsLabel.frame = imageViewFrame
		}
	}
	
	
	override func setData(title: String? = nil, detail: String? = nil, placeholder: String? = nil, auxiliary: String? = nil) {
		textLabel?.text = title ?? ""
		detailTextLabel!.text = detail ?? ""
		initialsLabel.text = auxiliary ?? ""
	}
	
	
	func setDataWithKey (indexPath: NSIndexPath, title: String? = nil, image: UIImage? = nil, detail: String? = nil, auxiliary: String? = nil) {
		
		loadingKey = indexPath
		
		imageView?.image = image
		
		setData(title, detail: detail, placeholder: nil, auxiliary: auxiliary)
	}


	func setImage(image: UIImage, key: NSIndexPath) -> Bool {
		
		initialsLabel.hidden = key == loadingKey
		
		if key == loadingKey {

//			if let f = imageView?.frame {
//				imageView?.frame = CGRect(x: f.origin.x - 12, y: f.origin.y - 12, width: f.width - 24, height: f.height - 24)
//			}
			
			imageView?.image = image
			
			return true
		}
		
		return false
    }
}