//
//  JIRALoginViewController.swift
//  bugTrap
//
//  Created by Nate Rickard on 8/28/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import UIKit

class JIRALoginViewController: TrackerLoginController, UITextFieldDelegate {

    @IBOutlet var ServerField: UITextField!
    @IBOutlet var UserNameField: UITextField!
    @IBOutlet var PasswordField: UITextField!
	@IBOutlet var ActivityIndicator: UIActivityIndicatorView!
	
	
    override var trackerType : TrackerType {
        get {
            return TrackerType.JIRA
        }
    }
    
	
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        ServerField.becomeFirstResponder()
    }
	
	
	override func populatePlaceholderLabels(showPlaceholders: Bool) {
		ServerField.placeholder   = showPlaceholders ? DataKeys.Server.string   : ""
		UserNameField.placeholder = showPlaceholders ? DataKeys.UserName.string : ""
		PasswordField.placeholder = showPlaceholders ? DataKeys.Password.string : ""
	}
	

	override func keychainDataLoaded(storedData: Dictionary<DataKeys, String>) {

		if let subdomain = storedData[DataKeys.Server] {
			ServerField.text = subdomain
		}
		
		if let username = storedData[DataKeys.UserName] {
			UserNameField.text = username
		}
		
		if let password = storedData[DataKeys.Password] {
			PasswordField.text = password
		}
    }

	

	func textFieldShouldReturn(textField: UITextField!) -> Bool {
		
		if textField == ServerField {
            UserNameField.becomeFirstResponder()
        }
		
        if textField == UserNameField {
            PasswordField.becomeFirstResponder()
        }
		
        if textField == PasswordField {
            PasswordField.resignFirstResponder()
            validateValuesAndLogin()
        }
        
        return false;
    }
	
	
	
    func validateValuesAndLogin() {
        
        if !ServerField.hasText() {
            ServerField.becomeFirstResponder()
			return
        }
		
        if !UserNameField.hasText() {
            UserNameField.becomeFirstResponder()
			return
        }
		
        if !PasswordField.hasText() {
            PasswordField.becomeFirstResponder()
			return
        }
		
		ActivityIndicator.startAnimating()
		ActivityIndicator.hidden = false
		
		let trackerData = [DataKeys.Server: ServerField.text!, DataKeys.UserName: UserNameField.text!, DataKeys.Password: PasswordField.text!]
		
		// store the data in the keychain
		keychain.StoreKeyValues(trackerData)
		
		let dataValid = TrackerService.Shared.setCurrentTrackerType(.JIRA)
		
		if !dataValid {
			Log.error("JIRALoginViewController invalid data", trackerData)
			return
		}
		
		//var tracker = TrackerService.Shared.getTrackerInstance(TrackerType.DoneDone)
		
		TrackerService.Shared.currentTracker?.authenticate(data: trackerData) { authResult in
			
			switch authResult {
			case let .Error(error):
				// failure
//				if error.domain == HttpStatus.type {
				
					let message = "Unable to login to JIRA with the information provided\n" +
						((error.code == HttpStatus.Unauthorized.rawValue || error.code == HttpStatus.PaymentRequired.rawValue || error.code == HttpStatus.Forbidden.rawValue) ? "\nReview Username and Password\nthen try again" : "\nReview Server then try again")

					let errorDialog = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
						errorDialog.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
					
					self.presentViewController(errorDialog, animated: true) {
						
						let trackerData = [DataKeys.Server: "", DataKeys.UserName: "", DataKeys.Password: ""]
						
						// clear the data in the keychain
						self.keychain.StoreKeyValues(trackerData)
					}
//				}
			case let .Value(result):
				// This isn't right
				self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
			}
			
			self.ActivityIndicator.stopAnimating()
		}
	}
}