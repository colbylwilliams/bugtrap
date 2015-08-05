//
//  DoneDonePerson.swift
//  bugTrap
//
//  Created by Colby L Williams on 8/25/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

class DoneDonePerson : DoneDoneSimpleItem {

	var companyId = 0

	var companyName = ""

	var firstName = ""

	var lastName = ""

	var profileEmail = ""

	var accountEmail = ""

	var mobilePhone = ""

	var officePhone = ""

	var fax = ""

	var avatarUrl = ""


	init(id: Int, coId: Int, coName: String, fName: String, lName: String, pEmail: String, aEmail: String, mPhone: String, oPhone: String, fPhone: String, avatar: String) {
		super.init(id: id, value: "\(fName) \(lName)")
		self.companyId = coId
		self.companyName = coName
		self.firstName = fName
		self.lastName = lName
		self.profileEmail = pEmail
		self.accountEmail = aEmail
		self.mobilePhone = mPhone
		self.officePhone = oPhone
		self.fax = fPhone
		self.avatarUrl = avatar
	}

	override class func deserialize (json: JSON) -> DoneDonePerson? {

		if let id = json["id"].int {

			let coId = json["company_id"].intValue

			let coName = json["company_name"].stringValue

			let fName = json["first_name"].stringValue

			let lName = json["last_name"].stringValue

			let pEmail = json["profile_email"].stringValue

			let aEmail = json["account_email"].stringValue

			let mPhone = json["mobile_phone"].stringValue

			let oPhone = json["office_phone"].stringValue

			let fPhone = json["fax"].stringValue

			let avatar = json["avatar_url"].stringValue

			return DoneDonePerson(id: id, coId: coId, coName: coName, fName: fName, lName: lName, pEmail: pEmail, aEmail: aEmail, mPhone: mPhone, oPhone: oPhone, fPhone: fPhone, avatar: avatar)
		}

		return nil
	}


	var fullName: String {
		return "\(firstName) \(lastName)"
	}

	var initials: String {
		return "\(firstName.isEmpty ? firstName : (firstName as NSString).substringToIndex(1))\(lastName.isEmpty ? lastName : (lastName as NSString).substringToIndex(1))".lowercaseString
	}
}