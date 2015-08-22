//
//  PivotalTrackerLoginViewController.swift
//  bugTrap
//
//  Created by Colby L Williams on 10/23/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import UIKit

class PivotalTrackerLoginViewController: TrackerLoginController {
	
	@IBOutlet var TokenField: UITextField!
	@IBOutlet var UsernameField: UITextField!
	@IBOutlet var PasswordField: UITextField!
	@IBOutlet var ActivityIndicator: UIActivityIndicatorView!
	
	
	override var trackerType : TrackerType {
		get {
			return TrackerType.PivotalTracker
		}
	}
	
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		UsernameField.becomeFirstResponder()
	}
	
	
	override func populatePlaceholderLabels(showPlaceholders: Bool) {
		TokenField.placeholder = showPlaceholders ? DataKeys.Token.string : ""
		UsernameField.placeholder  = showPlaceholders ? DataKeys.UserName.string  : ""
		PasswordField.placeholder  = showPlaceholders ? DataKeys.Password.string  : ""
	}
	
	
	override func keychainDataLoaded(storedData: Dictionary<DataKeys, String>) {
		
		if let token = storedData[DataKeys.Token] {
			TokenField.text = token
		}
		
		if let username = storedData[DataKeys.UserName] {
			UsernameField.text = username
		}
		
		if let password = storedData[DataKeys.Password] {
			PasswordField.text = password
		}
	}
	
	
	
	func textFieldShouldReturn(textField: UITextField!) -> Bool
	{
		if textField == TokenField {
			TokenField.resignFirstResponder()
			validateValuesAndLogin()
		}
		
		if textField == UsernameField {
			PasswordField.becomeFirstResponder()
		}
		
		if textField == PasswordField {
			PasswordField.resignFirstResponder()
			validateValuesAndLogin()
		}
		
		return false
	}
	
	
	
	func validateValuesAndLogin() {
		
//		if !TokenField.hasText() {
//			TokenField.becomeFirstResponder()
//			return
//		}
		
		let hasToken = TokenField.hasText()
		
		if !hasToken {
			if !UsernameField.hasText() {
				UsernameField.becomeFirstResponder()
				return
			}
			if !PasswordField.hasText() {
				PasswordField.becomeFirstResponder()
				return
			}
		}
		
		ActivityIndicator.startAnimating()
		ActivityIndicator.hidden = false
		
		let token = hasToken ? TokenField.text! : ""
		let username = hasToken ? UsernameField.hasText() ? UsernameField.text! : "" : UsernameField.text!
		let password = hasToken ? PasswordField.hasText() ? PasswordField.text! : "" : PasswordField.text!
		
		let trackerData = [DataKeys.Token: token, DataKeys.UserName: username, DataKeys.Password: password]
		
		Log.info("PivotalTrackerLoginViewController", trackerData)
		
		// store the data in the keychain
		keychain.StoreKeyValues(trackerData)
		
		let dataValid = TrackerService.Shared.setCurrentTrackerType(.PivotalTracker)

		if !dataValid {
			Log.error("PivotalTrackerLoginViewController invalid data", trackerData)
			return
		}

		//var tracker = TrackerService.Shared.getTrackerInstance(TrackerType.DoneDone)
		
		TrackerService.Shared.currentTracker?.authenticate(data: trackerData) { authResult in
			
			switch authResult {
			case let .Error(error):
				// failure
				if error.domain == HttpStatus.type {
					
					let message = "Unable to login to Pivotal Tracker with the information provided\n" +
						((error.code == HttpStatus.Unauthorized.rawValue || error.code == HttpStatus.PaymentRequired.rawValue || error.code == HttpStatus.Forbidden.rawValue) ? "\nReview Username and Password\nthen try again" : "")
					
					let errorDialog = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
						errorDialog.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
					
					self.presentViewController(errorDialog, animated: true) {
						
						let trackerData = [DataKeys.Token: "", DataKeys.UserName: "", DataKeys.Password: ""]
						
						// clear the data in the keychain
						self.keychain.StoreKeyValues(trackerData)
					}
				}
			case let .Value(result):
				if let success = result.value {
					if success && !hasToken {
						if let proxy = TrackerService.Shared.currentTracker?.trackerProxy as? PivotalProxy {
							let trackerDataWithToken = [DataKeys.Token: proxy.token, DataKeys.UserName: username, DataKeys.Password: password]
							self.keychain.StoreKeyValues(trackerDataWithToken)
						}
					}
					
					// This isn't right
					self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
				}
			}
			
			self.ActivityIndicator.stopAnimating()
		}
	}
}