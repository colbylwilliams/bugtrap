//
//  Keychain.swift
//  bugTrap
//
//  Created by Colby L Williams on 11/14/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation
import Security
import UIKit

class Keychain<TService : Stringable>
{
    let service : TService

    init(service: TService) {
        self.service = service
    }

    func GetStoredKeyValues () -> Dictionary<DataKeys, String> {

		// Log.info(logString, "GetStoredKeyValues")

        var dict = [DataKeys : String]()

        // this query setup will return all matches for the given service (DoneDone, JIRA, etc.)
		let keychainQuery = [
			kSecClass as String				: kSecClassGenericPassword,
			kSecAttrService as String		: self.service.string,
			kSecReturnAttributes as String	: kCFBooleanTrue,
			kSecReturnData as String		: kCFBooleanTrue,
			kSecMatchLimit as String		: kSecMatchLimitAll ]

        var dataTypeRef : AnyObject?

		
		let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)

        if status == errSecSuccess {

			if let retrievedData = dataTypeRef as? NSArray {

                // now look thru the returned dictionary and return the DataKeys stored for this service
                for value in retrievedData {

                    let match = value as! NSDictionary

                    let dataKey = DataKeys(rawValue: match[kSecAttrAccount as String] as! String)

                    let encodedValue = match[NSString(string: "v_Data")] as! NSData
                    let decodedValue = NSString(data: encodedValue, encoding: NSUTF8StringEncoding)

					dict[dataKey!] = decodedValue as? String
                }
			}
			
		} else {
			
			printErrorForSecStatus(status)
		}

		return dict
    }



	func StoreKeyValues (values: Dictionary<DataKeys, String>!) -> Bool {

		Log.info(logString, "StoreKeyValues")

		var success = false

		for keyValue in values {

			let keychainQuery = [
				kSecClass as String				: kSecClassGenericPassword,
				kSecAttrService as String		: self.service.string,
				kSecAttrAccount as String		: keyValue.0.rawValue,
				kSecAttrAccessGroup as String	: AppKeys.AccessGroup.string,
				kSecValueData as String			: keyValue.1.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)! ]


			// Delete any existing items
			SecItemDelete(keychainQuery as CFDictionaryRef)

			// Add the new keychain item
			let status: OSStatus = SecItemAdd(keychainQuery as CFDictionaryRef, nil)

			success = status == errSecSuccess

			if !success {
				printErrorForSecStatus(status)
			}
		}

		return success
	}


	func printErrorForSecStatus(status: OSStatus) {

		switch (status) {
			case errSecSuccess:					Log.info(logString,  "No error.")
			case errSecUnimplemented:			Log.error(logString, "Error: Function or operation not implemented.")
			case errSecIO:						Log.error(logString, "Error: I/O error bummers")
			case errSecOpWr:					Log.error(logString, "Error: file already open with with write permission")
			case errSecParam:					Log.error(logString, "Error: One or more parameters passed to a function where not valid.")
			case errSecAllocate:				Log.error(logString, "Error: Failed to allocate memory.")
			case errSecUserCanceled:			Log.error(logString, "Error: User canceled the operation.")
			case errSecBadReq:					Log.error(logString, "Error: Bad parameter or invalid state for operation.")
			case errSecInternalComponent:		Log.error(logString, "Error: errSecInternalComponent")
			case errSecNotAvailable:			Log.error(logString, "Error: No keychain is available. You may need to restart your computer.")
			case errSecDuplicateItem:			Log.info(logString,  "The specified item already exists in the keychain.")
			case errSecItemNotFound:			Log.info(logString,  "The specified item could not be found in the keychain.")
			case errSecInteractionNotAllowed:	Log.error(logString, "Error: User interaction is not allowed.")
			case errSecDecode:					Log.error(logString, "Error: Unable to decode the provided data.")
			case errSecAuthFailed:				Log.error(logString, "Error: The user name or passphrase you entered is not correct.")
			default:							Log.error(logString, "Error: Unknown")
		}
	}

	var logString: String {
		return "Keychain<\(service.string)>"
	}
}