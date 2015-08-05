//
//  DeviceInfo.swift
//  bugTrap
//
//  Created by Colby L Williams on 12/9/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

struct DeviceInfo {


//	static var deviceType : String {
//
//		let platform = UIDevice.currentDevice().model
//
//		if platform == "iPhone1,1" { return "iPhone 1G" }
//		if platform == "iPhone1,2" { return "iPhone 3G" }
//		if platform == "iPhone2,1" { return "iPhone 3GS" }
//		if platform == "iPhone3,1" { return "iPhone 4" }
//		if platform == "iPhone3,2" { return "iPhone 4" }
//		if platform == "iPhone3,3" { return "Verizon iPhone 4" }
//		if platform == "iPhone4,1" { return "iPhone 4S" }
//		if platform == "iPhone5,1" { return "iPhone 5 (GSM)" }
//		if platform == "iPhone5,2" { return "iPhone 5 (GSM+CDMA)" }
//		if platform == "iPhone5,3" { return "iPhone 5C (GSM)" }
//		if platform == "iPhone5,4" { return "iPhone 5C (GSM+CDMA)" }
//		if platform == "iPhone6,1" { return "iPhone 5S (GSM)" }
//		if platform == "iPhone6,2" { return "iPhone 5S (GSM+CDMA)" }
//		if platform == "iPhone7,1" { return "iPhone 6+" }
//		if platform == "iPhone7,2" { return "iPhone 6" }
//
//		if platform == "iPod1,1"   { return "iPod Touch 1G" }
//		if platform == "iPod2,1"   { return "iPod Touch 2G" }
//		if platform == "iPod3,1"   { return "iPod Touch 3G" }
//		if platform == "iPod4,1"   { return "iPod Touch 4G" }
//		if platform == "iPod5,1"   { return "iPod Touch 5G" }
//
//		if platform == "iPad1,1"   { return "iPad" }
//		if platform == "iPad2,1"   { return "iPad 2 (WiFi)" }
//		if platform == "iPad2,2"   { return "iPad 2 (GSM)" }
//		if platform == "iPad2,3"   { return "iPad 2 (CDMA)" }
//		if platform == "iPad2,4"   { return "iPad 2 (WiFi)" }
//		if platform == "iPad2,5"   { return "iPad Mini (WiFi)" }
//		if platform == "iPad2,6"   { return "iPad Mini (GSM)" }
//		if platform == "iPad2,7"   { return "iPad Mini (GSM+CDMA)" }
//		if platform == "iPad3,1"   { return "iPad 3 (WiFi)" }
//		if platform == "iPad3,2"   { return "iPad 3 (GSM+CDMA)" }
//		if platform == "iPad3,3"   { return "iPad 3 (GSM)" }
//		if platform == "iPad3,4"   { return "iPad 4 (WiFi)" }
//		if platform == "iPad3,5"   { return "iPad 4 (GSM)" }
//		if platform == "iPad3,6"   { return "iPad 4 (GSM+CDMA)" }
//		if platform == "iPad4,1"   { return "iPad Air (WiFi)" }
//		if platform == "iPad4,2"   { return "iPad Air (Cellular)" }
//		if platform == "iPad4,3"   { return "iPad Air" }
//		if platform == "iPad4,4"   { return "iPad Mini 2G (WiFi)" }
//		if platform == "iPad4,5"   { return "iPad Mini 2G (Cellular)" }
//		if platform == "iPad4,6"   { return "iPad Mini 2G" }
//
//		if platform == "i386" 	   { return "Simulator" }
//		if platform == "x86_64"    { return "Simulator" }
//
//		return "other"
//	}




	static let name = UIDevice.currentDevice().name // String e.g. "My iPhone"
	static let model = UIDevice.currentDevice().model // String { get } // e.g. @"iPhone", @"iPod touch"
	static let modelLocalized = UIDevice.currentDevice().localizedModel // String { get } // localized version of model
	static let systemName = UIDevice.currentDevice().systemName // String { get } // e.g. @"iOS"
	static let systemVersion = UIDevice.currentDevice().systemVersion // String { get } // e.g. @"4.0"

	static let identifierForVendor = UIDevice.currentDevice().identifierForVendor // NSUUID! { get } // a UUID that may be used to uniquely identify the device, same across apps from a single vendor.

	static var toString : String {

		let name	= "Name : \(self.name)"

		let model	= "Model : \(self.model)"

		let system	= "System :  iOS \(self.systemVersion)"

		let uuid	= "UDID : \(identifierForVendor?.UUIDString)"

		let trap	= "*- captured with [bugTrap](http://bugtrap.io) -*"

		let format	= "\n\n\n##Device Details\n*****\n\(name)\n\(model)\n\(system)\n\(uuid)\n*****\n\(trap)"

		return format
	}

	static var toJiraString : String {
		
		let name	= "Name : \(self.name)"
		
		let model	= "Model : \(self.model)"
		
		let system	= "System :  iOS \(self.systemVersion)"
		
		let uuid	= "UDID : \(identifierForVendor?.UUIDString)"
		
		let trap	= "??captured with [bugTrap|http://bugtrap.io]??"
		
		let format	= "\n\n\nh4. Device Details\n----\n\(name)\n\(model)\n\(system)\n\(uuid)\n----\n\(trap)"
		
		return format
	}

	
	// let orientation = UIDevice.currentDevice().orientation // UIDeviceOrientation { get } // return current device orientation.  this will return UIDeviceOrientationUnknown unless device orientation
	// let userInterfaceIdiom = UIDevice.currentDevice().userInterfaceIdiom // UIUserInterfaceIdiom { get }



}