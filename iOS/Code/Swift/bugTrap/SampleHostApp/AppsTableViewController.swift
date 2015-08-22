//
//  AppsTableViewController.swift
//  SampleHostApp
//
//  Created by Colby Williams on 8/22/15.
//  Copyright © 2015 bugTrap. All rights reserved.
//

import Foundation;
import UIKit;

class AppsTableViewController : UITableViewController//, UITableViewDataSource, UITableViewDelegate
{
	let apps = [ "BloodPressureX", "bugTrap", "bugTrap Debug", "VervetaCRM.Android", "VervetaCRM.iOS", "Glucose X" ]

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return apps.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("AppsTableViewCell", forIndexPath: indexPath) as! AppsTableViewCell
		
		let app = apps[indexPath.row]
		
		cell.setContent(app)
		
		return cell
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if let tabController = storyboard?.instantiateViewControllerWithIdentifier("AppTabBarController") {
			showViewController(tabController, sender: self)
		}
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
}