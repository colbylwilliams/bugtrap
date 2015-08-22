//
//  BtSettingsLoginViewController.swift
//  bugTrap
//
//  Created by Colby L Williams on 6/30/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import UIKit

class DoneDoneLoginViewController: TrackerLoginController {
	
	@IBOutlet var SubdomainField: UITextField!
	@IBOutlet var UsernameField: UITextField!
	@IBOutlet var PasswordField: UITextField!
	@IBOutlet var ActivityIndicator: UIActivityIndicatorView!
	
	
    override var trackerType : TrackerType {
        get {
            return TrackerType.DoneDone
        }
    }
	

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		SubdomainField.becomeFirstResponder()
	}

	
	override func populatePlaceholderLabels(showPlaceholders: Bool) {
		SubdomainField.placeholder = showPlaceholders ? DataKeys.Subdomain.string : ""
		UsernameField.placeholder  = showPlaceholders ? DataKeys.UserName.string  : ""
		PasswordField.placeholder  = showPlaceholders ? DataKeys.Password.string  : ""
	}
	
	
    override func keychainDataLoaded(storedData: Dictionary<DataKeys, String>) {
		
		if let subdomain = storedData[DataKeys.Subdomain] {
			SubdomainField.text = subdomain
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
		if textField == SubdomainField {
			UsernameField.becomeFirstResponder()
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
		
		if !SubdomainField.hasText() {
			SubdomainField.becomeFirstResponder()
			return
		}
		if !UsernameField.hasText() {
			UsernameField.becomeFirstResponder()
			return
		}
		if !PasswordField.hasText() {
			PasswordField.becomeFirstResponder()
			return
		}
		
		ActivityIndicator.startAnimating()
		ActivityIndicator.hidden = false
		
        let trackerData = [DataKeys.Subdomain: SubdomainField.text!, DataKeys.UserName: UsernameField.text!, DataKeys.Password: PasswordField.text!]
        
        // store the data in the keychain
		keychain.StoreKeyValues(trackerData)
		
		let dataValid = TrackerService.Shared.setCurrentTrackerType(.DoneDone)
		
		if !dataValid {
			Log.error("DoneDoneLoginViewController invalid data", trackerData)
			return
		}
        
        //var tracker = TrackerService.Shared.getTrackerInstance(TrackerType.DoneDone)
		
        TrackerService.Shared.currentTracker?.authenticate(data: trackerData) { authResult in
            
            switch authResult {
            case let .Error(error):
                // failure
                if error.domain == HttpStatus.type {
					
					let message = "Unable to login to DoneDone with the information provided\n" +
						((error.code == HttpStatus.Unauthorized.rawValue || error.code == HttpStatus.PaymentRequired.rawValue) ? "\nReview Username & Password\nthen try again" : error.code == HttpStatus.NotFound.rawValue ? "\nReview Subdomain then try again" : "")
						
					let errorDialog = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
						errorDialog.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
					
					self.presentViewController(errorDialog, animated: true) {
						
						let trackerData = [DataKeys.Subdomain: "", DataKeys.UserName: "", DataKeys.Password: ""]
						
						// clear the data in the keychain
						self.keychain.StoreKeyValues(trackerData)
					}
                }
            case .Value(_):
				// This isn't right
				self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            }
			
			self.ActivityIndicator.stopAnimating()
        }
    }
}