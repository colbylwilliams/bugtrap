//
//  PivotalComment.swift
//  bugTrap
//
//  Created by Colby L Williams on 11/10/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

class PivotalComment : JsonSerializable {

	var id: Int?
	var storyId: Int?
	var epicId: Int?
	var text = ""
	var personId = 0
	var createdAt: NSDate?
	var updatedAt: NSDate?
	var fileAttachmentIds = [Int]()

	var fileAttachments: [PivotalAttachment] = [PivotalAttachment]() {
		willSet {
			fileAttachmentIds = newValue.filter({$0.id != nil}).map({$0.id!})
		}
	}

	var googleAttachmentIds = [Int]()
	var commitIdentifier = ""
	var commitType = ""
	var kind = ""


	init() {

	}


	init(storyId: Int?) {
		self.storyId = storyId
	}


	init(id: Int?, storyId: Int?, epicId: Int?, text: String, personId: Int, fileAttachmentIds: [Int], googleAttachmentIds: [Int], commitIdentifier: String, commitType: String, kind: String) {

		self.id = id
		self.storyId = storyId
		self.epicId = epicId
		self.text = text
		self.personId = personId
//		self.createdAt = createdAt
//		self.updatedAt = updatedAt
		self.fileAttachmentIds = fileAttachmentIds
		self.googleAttachmentIds = googleAttachmentIds
		self.commitIdentifier = commitIdentifier
		self.commitType = commitType
		self.kind = kind

	}


	class func deserialize (json: JSON) -> PivotalComment? {

		var storyId: Int?
		var epicId: Int?
//		var createdAt: NSDate?
//		var updatedAt: NSDate?

		if let id = json["id"].int {

			if let storyIdW = json["story_id"].int {
				storyId = storyIdW
			}

			if let epicIdW = json["epic_id"].int {
				epicId = epicIdW
			}

			let text = json["text"].stringValue

			let personId = json["person_id"].intValue

	//		if let createdAtW = json["created_at"].nSDate? {
	//			createdAt = createdAtW
	//		}

	//		if let updatedAtW = json["updated_at"].nSDate? {
	//			updatedAt = updatedAtW
	//		}

			var fileAttachmentIds = [Int]()
			
			for item in json["file_attachment_ids"].arrayValue {
				if let idW = item.int {
					fileAttachmentIds.append(idW)
				}
			}

			var googleAttachmentIds = [Int]()
			
			for item in json["google_attachment_ids"].arrayValue {
				if let idW = item.int {
					googleAttachmentIds.append(idW)
				}
			}

			let commitIdentifier = json["commit_identifier"].stringValue

			let commitType = json["commit_type"].stringValue

			let kind = json["kind"].stringValue

			return PivotalComment(id: id, storyId: storyId, epicId: epicId, text: text, personId: personId, fileAttachmentIds: fileAttachmentIds, googleAttachmentIds: googleAttachmentIds, commitIdentifier: commitIdentifier, commitType: commitType, kind: kind)
		}

		return nil
	}


	class func deserializeAll(json: JSON) -> [PivotalComment] {

		var items = [PivotalComment]()

		if let jsonArray = json.array {
			for item: JSON in jsonArray {
				if let pivotalComment = deserialize(item) {
					items.append(pivotalComment)
				}
			}
		}

		return items
	}


	func serialize () -> NSMutableDictionary {

		let dict = NSMutableDictionary()

//		 dict.setValue(id == nil ? nil : id!, forKey: PivotalFields.NewCommentFields.Id.rawValue)

//		dict.setValue(storyId == nil ? nil : storyId!, forKey: PivotalFields.NewCommentFields.StoryId.rawValue)

//		dict.setValue(epicId == nil ? nil : epicId!, forKey: PivotalFields.NewCommentFields.EpicId.rawValue)

		dict.setObject(text, forKey: PivotalFields.NewCommentFields.Text.rawValue)

//		dict.setObject(personId, forKey: PivotalFields.NewCommentFields.PersonId.rawValue)

//		dict.setObject(fileAttachmentIds, forKey: PivotalFields.NewCommentFields.FileAttachmentIds.rawValue)

		if fileAttachments.count > 0 {
			let attachmentsJson = fileAttachments.map({$0.serialize()})
			dict.setObject(attachmentsJson, forKey: PivotalFields.NewCommentFields.FileAttachments.rawValue)
		}

//		dict.setObject(googleAttachmentIds, forKey: PivotalFields.NewCommentFields.GoogleAttachmentIds.rawValue)

//		dict.setObject(commitIdentifier, forKey: PivotalFields.NewCommentFields.CommitIdentifier.rawValue)

//		dict.setObject(commitType, forKey: PivotalFields.NewCommentFields.CommitType.rawValue)

//		dict.setObject(kind, forKey: PivotalFields.NewCommentFields.Kind.rawValue)

		return dict
	}
}
