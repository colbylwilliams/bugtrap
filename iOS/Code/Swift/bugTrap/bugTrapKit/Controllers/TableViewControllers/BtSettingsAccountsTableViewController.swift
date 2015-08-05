//
//  BtSettingsAccountsTableViewController.swift
//  bugTrap
//
//  Created by Colby L Williams on 6/30/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import UIKit
import MessageUI

class BtSettingsAccountsTableViewController: BtTableViewController, MFMailComposeViewControllerDelegate {
    
	@IBOutlet var versionLabel: UILabel!
	
    var trackerTypes : [TrackerStatus : [TrackerType]]?
	var trackerUsers : [TrackerType : String]?
    
    override func viewDidLoad() {
		super.viewDidLoad()
		
		screenName = GAIKeys.ScreenNames.trackerAccounts
		
		versionLabel.text = Settings.versionBuildString
		
        trackerTypes = TrackerService.Shared.getTrackerTypesByStatus()
		
		trackerUsers = TrackerService.Shared.getUsernamesForEnabledTrackerTypes(trackerTypes![TrackerStatus.Enabled]!)
    }

	
	
	@IBAction func DoneButtonClick(sender: AnyObject) {
		navigationController!.dismissViewControllerAnimated(true, completion: nil)
	}
	

	
	@IBAction func letUsKnowClicked(sender: AnyObject) {
		if MFMailComposeViewController.canSendMail() {
			let mailComposeViewController = configuredMailComposeViewController()
			presentViewController(mailComposeViewController, animated: true, completion: nil)
		} else {
			let sendMailErrorController = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .Alert)
			presentViewController(sendMailErrorController, animated: true, completion: nil)
		}
	}
	
	
	func configuredMailComposeViewController() -> MFMailComposeViewController {
		let mailComposerVC = MFMailComposeViewController()
			mailComposerVC.mailComposeDelegate = self
		
			mailComposerVC.setToRecipients([AppKeys.ContactEmail.string])
			mailComposerVC.setSubject("App: Tracker Integration")
			mailComposerVC.setMessageBody("Please provide the Tracker\'s name, a link to its website, and a link to the API documentation.", isHTML: false)
		
		return mailComposerVC
	}
	
	
	func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
		controller.dismissViewControllerAnimated(true, completion: nil)
	}
	
	
	// #pragma mark - Table view data source
	
	override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
		return 2
	}
	
	override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
		return section == 0 ? trackerTypes![TrackerStatus.Enabled]!.count : trackerTypes![TrackerStatus.ComingSoon]!.count
	}
		
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

		let cell = tableView.dequeueReusableCellWithIdentifier("BtSettingsAccountTableViewCell") as! BtSettingsAccountTableViewCell
		
		let status = TrackerStatus(rawValue: indexPath.section + 2)!
		
        let tracker = trackerTypes![status]![indexPath.row]
		
		let enabled = indexPath.section == 0
		
        cell.textLabel?.text = tracker.rawValue
		cell.textLabel?.textColor = enabled ? Colors.Black.uiColor : Colors.Gray.uiColor
		
        cell.detailTextLabel?.text = enabled && tracker.enabled ? trackerUsers![tracker] : "coming soon"
        cell.detailTextLabel?.textColor = enabled ? Colors.Theme.uiColor : Colors.LightGray.uiColor
        cell.accessoryType = enabled ? .DisclosureIndicator : .None
		if let imageName = tracker.smallImageName {
			cell.imageView?.image = UIImage(named: imageName)
		} else {
			cell.imageView?.image = nil
		}
		
		return cell
	}
	

	override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return indexPath.section == 0
	}
	
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
		tableView.cellForRowAtIndexPath(indexPath)!.selected = false
		
		if indexPath.section == 0 {
            
            let status = TrackerStatus(rawValue: indexPath.section + 2)!
            
            let tracker = trackerTypes![status]![indexPath.row]
			
			if let loginControllerName = tracker.loginControllerName {
				if let loginController = storyboard?.instantiateViewControllerWithIdentifier(loginControllerName) {
					showViewController(loginController, sender: self)
				}
			}
		}
	}
	
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return indexPath.section == 0 ? 44.0 : 40.0
	}
	
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String {
		return section == 0 ? "Issue Trackers" : ""
	}

	
	override func prefersStatusBarHidden() -> Bool {
		return true
	}
}