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

		Log.info(service.string, "Keychain -- GetStoredKeyValues")

        var dict = [DataKeys : String]()

        //this query setup will return all matches for the given service (DoneDone, JIRA, etc.)
		var keychainQuery = [
			kSecClass as String				: kSecClassGenericPassword,
			kSecAttrService as String		: self.service.string,
			kSecReturnAttributes as String	: kCFBooleanTrue,
			kSecReturnData as String		: kCFBooleanTrue,
			kSecMatchLimit as String		: kSecMatchLimitAll ]

        var dataTypeRef : Unmanaged<AnyObject>?

        // Search for the keychain items
        let status: OSStatus = SecItemCopyMatching(keychainQuery as CFDictionaryRef, &dataTypeRef)

        if status == errSecSuccess {

            //some managed/unmanaged pointer garbage is needed
            if let opaque = dataTypeRef?.toOpaque() {

                //basically take the pointer and turn it into an object
                let retrievedData = Unmanaged<NSArray>.fromOpaque(opaque).takeUnretainedValue()

                //now look thru the returned dictionary and return the DataKeys stored for this service
                for value in retrievedData {

                    let match = value as! NSDictionary

                    let dataKey = DataKeys(rawValue: match[kSecAttrAccount as String] as String)

                    let encodedValue = match[NSString(string: "v_Data")] as NSData
                    let decodedValue = NSString(data: encodedValue, encoding: NSUTF8StringEncoding)

					dict[dataKey!] = decodedValue
                }
			}
		} else {
			printErrorForSecStatus(status)
		}

		return dict
    }



	func StoreKeyValues (values: Dictionary<DataKeys, String>!) -> Bool {

		Log.info(service.string, "Keychain -- StoreKeyValues")

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
			case errSecSuccess:					Log.info(service.string, "Keychain Error: No error.")
			case errSecUnimplemented:			Log.error(service.string, "Keychain Error: Function or operation not implemented.")
			// case errSecIO:					Log.error(service.string, "Keychain Error: I/O error bummers")
			// case errSecOpWr:					Log.error(service.string, "Keychain Error: file already open with with write permission")
			case errSecParam:					Log.error(service.string, "Keychain Error: One or more parameters passed to a function where not valid.")
			case errSecAllocate:				Log.error(service.string, "Keychain Error: Failed to allocate memory.")
			// case errSecUserCanceled:			Log.error(service.string, "Keychain Error: User canceled the operation.")
			// case errSecBadReq:				Log.error(service.string, "Keychain Error: Bad parameter or invalid state for operation.")
			// case errSecInternalComponent:	Log.error(service.string, "Keychain Error: errSecInternalComponent")
			case errSecNotAvailable:			Log.error(service.string, "Keychain Error: No keychain is available. You may need to restart your computer.")
			case errSecDuplicateItem:			Log.info(service.string, "Keychain Error: The specified item already exists in the keychain.")
			case errSecItemNotFound:			Log.info(service.string, "Keychain Error: The specified item could not be found in the keychain.")
			case errSecInteractionNotAllowed:	Log.error(service.string, "Keychain Error: User interaction is not allowed.")
			case errSecDecode:					Log.error(service.string, "Keychain Error: Unable to decode the provided data.")
			case errSecAuthFailed:				Log.error(service.string, "Keychain Error: The user name or passphrase you entered is not correct.")
			default:							Log.error(service.string, "Keychain Error: Unknown")
		}
	}
}