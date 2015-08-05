//
//  JiraIssueTypeField.swift
//  bugTrap
//
//  Created by Colby L Williams on 1/26/15.
//  Copyright (c) 2015 bugTrap. All rights reserved.
//

import Foundation

class JiraIssueTypeField : JsonSerializable {

	private struct fields {
		static let required			= "required"
		static let schema			= "schema"
		static let name				= "name"
		static let hasDefaultValue	= "hasDefaultValue"
		static let operations		= "operations"
		static let allowedValues	= "allowedValues"
	}

	var required = false
	var schema = JiraIssueTypeFieldSchema()
	var name = ""
	var hasDefaultValue = false
	var operations = [String]()
	var allowedValues = [JiraSimpleItem]()

	var isEmpty: Bool {
		return name.isEmpty
	}
	
	var hasAllowedValues: Bool {
		return !isEmpty && allowedValues.count > 0 && !allowedValues[0].name.isEmpty && allowedValues[0].id != nil
	}
	

	init() {

	}

	init(required: Bool, schema: JiraIssueTypeFieldSchema, name: String, hasDefaultValue: Bool, operations: [String], allowedValues: [JiraSimpleItem]) {
		self.required = required
		self.schema = schema
		self.name = name
		self.hasDefaultValue = hasDefaultValue
		self.operations = operations
		self.allowedValues = allowedValues
	}

	class func deserialize (json: JSON) -> JiraIssueTypeField?  {

		let required = json[fields.required].boolValue

		let schema = JiraIssueTypeFieldSchema.deserialize(json[fields.schema])

		let name = json[fields.name].stringValue

		let hasDefaultValue = json[fields.hasDefaultValue].boolValue

		var operations = [String]()

		for item in json[fields.operations].arrayValue {
			if let operation = item.string {
				operations.append(operation)
			}
		}

		let allowedValues = JiraSimpleItem.deserializeAll(json[fields.allowedValues])

		return JiraIssueTypeField(required: required, schema: schema!, name: name, hasDefaultValue: hasDefaultValue, operations: operations, allowedValues: allowedValues)
	}

	class func deserializeAll(json: JSON) -> [JiraIssueTypeField] {

		var items = [JiraIssueTypeField]()

		if let jsonArray = json.array {
			for item: JSON in jsonArray {
				if let si = deserialize(item) {
					items.append(si)
				}
			}
		}

		return items
	}


	func serialize () -> NSMutableDictionary {
		let dict = NSMutableDictionary()

		return dict
	}
}
