//
//  Settings.swift
//  bugTrap
//
//  Created by Colby L Williams on 11/22/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

struct Settings  {
	
	
	enum SettingsKey : String {
		
		case VersionNumber =	"VersionNumber"
		case BuildNumber =		"BuildNumber"
		case UserReferenceKey = "UserReferenceKey"
		case FirstLaunch =		"FirstLaunch"
		case AnnotateTool =		"AnnotateTool"
		case AnnotateColor =	"AnnotateColor"
	}
	
	
	static func registerDefaultSettings() {
		
		if let path = NSBundle.mainBundle().pathForResource("Settings", ofType: "bundle")?.stringByAppendingString("Root.plist") {
			
			let keyString = "Key", defaultString = "DefaultValue"
			
			if let settings = NSDictionary(contentsOfFile: path) {
				
				if let preferences = settings.valueForKey("PreferenceSpecifiers") as? [NSDictionary] {
				
					var registrationDictionary = [String : AnyObject]()
					
					for var i = 0; i < preferences.count; i++ {
					
						let prefSpecification = NSDictionary(dictionary: preferences[i])
						
						if let key = prefSpecification.valueForKey(keyString) as? String {
							
							if let def: AnyObject = prefSpecification.valueForKey(defaultString) {
								
								registrationDictionary[key] = def
							}
						}
					}
					
					NSUserDefaults.standardUserDefaults().registerDefaults(registrationDictionary)
					NSUserDefaults.standardUserDefaults().synchronize()
				}
			}
		}
		
		firstLaunch
		userReferenceKey
	}
	

	static func setValue (value: AnyObject, forKey: SettingsKey) {
		setValue(value, forKey: forKey.rawValue)
	}

	static func setValue (value: AnyObject, forKey: String) {
		NSUserDefaults.standardUserDefaults().setValue(value, forKey: forKey)
	}
	
	static func getString (forKey: SettingsKey) -> String {
		return getString(forKey.rawValue)
	}

	static func getString (forKey: String) -> String {
		return NSUserDefaults.standardUserDefaults().stringForKey(forKey) ?? ""
	}
	
	static func getInt (forKey: SettingsKey) -> Int {
		return getInt(forKey.rawValue)
	}

	static func getInt (forKey: String) -> Int {
		return NSUserDefaults.standardUserDefaults().integerForKey(forKey)
	}

	static func getBool (forKey: SettingsKey) -> Bool {
		return getBool(forKey.rawValue)
	}

	static func getBool (forKey: String) -> Bool {
		return NSUserDefaults.standardUserDefaults().boolForKey(forKey)
	}

	
	
	// MARK: About
	
	static var versionNumber: String {
		return getString(.VersionNumber)
	}
	
	static var buildNumber: String {
		return getString(.BuildNumber)
	}
	
	static var versionBuildString: String {
		return "v\(versionNumber) b\(buildNumber)"
	}
	
	
	
	// MARK: Annotation
	
	static var annotateTool: Annotate.Tool {
		get {
			return Annotate.Tool(rawValue: getInt(.AnnotateTool))!
		}
		set {
			setValue(newValue.rawValue, forKey: .AnnotateTool)
		}
	}
	
	static var annotateColor: Annotate.Color {
		get {
			return Annotate.Color(rawValue: getInt(.AnnotateColor))!
		}
		set {
			setValue(newValue.rawValue, forKey: .AnnotateColor)
		}
	}
	

	
	// MARK: Config
	
	static var firstLaunch: Bool {
		
		let firstL = !getBool(.FirstLaunch) // this is actually false if it's the first time the app is launched
		
		if firstL {
			setValue(true, forKey: .FirstLaunch)
			
			// Give these some good defaults
			annotateTool = Annotate.Tool.Marker
			annotateColor = Annotate.Color.Green
		}
		
		return firstL
	}
	
	
	
	// MARK: Reporting
	
	static var userReferenceKey: String {
		var key = getString(.UserReferenceKey)
		if key.isEmpty {
			key = UIDevice.currentDevice().identifierForVendor?.UUIDString ?? "unknown"
			setValue(key, forKey: .UserReferenceKey)
		}
		return key
	}
}