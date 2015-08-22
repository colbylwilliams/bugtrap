//
//  AppsCollectionViewCell.swift
//  SampleHostApp
//
//  Created by Colby Williams on 8/22/15.
//  Copyright © 2015 bugTrap. All rights reserved.
//

import UIKit;
import CoreGraphics;

class AppsCollectionViewCell : UICollectionViewCell
{
	@IBOutlet weak var BackgroundStyleView: UIView!
	
	@IBOutlet weak var AppIconImageView: UIImageView!
	
	@IBOutlet weak var AppNameValueLabel: UILabel!
	
	@IBOutlet weak var SessionsInLastValueLabel: UILabel!
	
	@IBOutlet weak var SessionsInLastLabel: UILabel!
	
	@IBOutlet weak var OpenIssuesValueLabel: UILabel!
	
	@IBOutlet weak var OpenIssuesLabel: UILabel!
	
	@IBOutlet weak var UsersInLastValueLabel: UILabel!
	
	@IBOutlet weak var UsersInLastLabel: UILabel!
	
	@IBOutlet weak var UsersExperiencingIssuesValueLabel: UILabel!
	
	@IBOutlet weak var UsersExperiencingIssuesLabel: UILabel!
	
	
	var configuredShadow = false
	
	func setContent(cellSize: CGSize, app: String) {
		
		AppNameValueLabel.text = app;
		
		if !configuredShadow {
			
			configuredShadow = true
			
			BackgroundStyleView.layer.shadowOffset = CGSize.zeroSize;
			BackgroundStyleView.layer.shadowColor = UIColor.blackColor().CGColor;
			BackgroundStyleView.layer.cornerRadius = 3;
			BackgroundStyleView.layer.shadowRadius = 4;
			BackgroundStyleView.layer.shadowOpacity = 0.1;
			BackgroundStyleView.layer.shadowPath = UIBezierPath(rect: CGRect (x: 0, y: 4, width: cellSize.width - 12, height: cellSize.height - 14)).CGPath;
		}
	}
}