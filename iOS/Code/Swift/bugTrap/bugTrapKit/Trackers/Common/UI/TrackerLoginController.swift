//
//  TrackerLoginController.swift
//  bugTrap
//
//  Created by Colby L Williams on 11/14/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import UIKit

class TrackerLoginController: BtViewController, UITextFieldDelegate {
	
    var keychain : Keychain<TrackerType>!
	
    // no abstract or virtual in swift, but we will override this to return the proper TrackerType
    var trackerType : TrackerType? {
        get {
            NSException(name: "Abstract Member", reason: "trackerType must be overridden in derived classes", userInfo: nil).raise()
            return nil
        }
    }
	
	

	override func viewDidLoad() {
        super.viewDidLoad()
		
		screenName = "\(GAIKeys.ScreenNames.trackerAccounts) (\(trackerType!.rawValue))"
		
        keychain = Keychain<TrackerType>(service: trackerType!)
		
		populatePlaceholderLabels(traitCollection.containsTraitsInCollection(UITraitCollection(verticalSizeClass: .Compact)))
    }
	
	
	
	override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)

		populatePlaceholderLabels(traitCollection.containsTraitsInCollection(UITraitCollection(verticalSizeClass: .Compact)))
	}
	
	
	
    override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
        // get the stored keys for this service type
        let storedKeys = keychain.GetStoredKeyValues()
        
        if storedKeys.count > 0 {
            // if they exist, allow derived controllers to use the data
            keychainDataLoaded(storedKeys);
		}
    }
	
	
	
    // override in derived controllers to do something when the stored keychain data is loaded
    func keychainDataLoaded(storedData : Dictionary<DataKeys, String>) {
        NSException(name: "Abstract Member", reason: "keychainDataLoaded must be overridden in derived classes", userInfo: nil).raise()
    }
	
	
	
    // override in derived controllers to populate the placeholder property on the Fields, as the labels above the fields will be hidden in landscape on iPhones
	func populatePlaceholderLabels (showPlaceholders: Bool) {
		NSException(name: "Abstract Member", reason: "populatePlaceholderLabels must be overridden in derived classes", userInfo: nil).raise()
	}
	
	
	
	override func prefersStatusBarHidden() -> Bool {
		return true
	}
}