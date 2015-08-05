//
//  PivotalAttachment.swift
//  bugTrap
//
//  Created by Colby L Williams on 11/10/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

class PivotalAttachment : JsonSerializable {

	var id: Int?
	var projectId: Int?
	var filename = ""
	var uploaderId = 0
	var thumbnailable = false
	var height = 0
	var width = 0
	var size = 0
	var downloadUrl = ""
	var contentType = ""
	var uploaded = false
	var bigUrl = ""
	var thumbnailUrl = ""
	var kind = ""

	init(id: Int?, projectId: Int?, filename: String, uploaderId: Int, thumbnailable: Bool, height: Int, width: Int, size: Int, downloadUrl: String, contentType: String, uploaded: Bool, bigUrl: String, thumbnailUrl: String, kind: String) {

		self.id = id
		self.projectId = projectId
		self.filename = filename
		self.uploaderId = uploaderId
		self.thumbnailable = thumbnailable
		self.height = height
		self.width = width
		self.size = size
		self.downloadUrl = downloadUrl
		self.contentType = contentType
		self.uploaded = uploaded
		self.bigUrl = bigUrl
		self.thumbnailUrl = thumbnailUrl
		self.kind = kind
	}

	class func deserialize (json: JSON) -> PivotalAttachment? {

		var projectId: Int?

		if let id = json["id"].int {

			if let projectIdW = json["project_id"].int {
				projectId = projectIdW
			}

			let filename = json["filename"].stringValue

			let uploaderId = json["uploader_id"].intValue

			let thumbnailable = json["thumbnailable"].boolValue

			let height = json["height"].intValue

			let width = json["width"].intValue

			let size = json["size"].intValue

			let downloadUrl = json["download_url"].stringValue

			let contentType = json["content_type"].stringValue

			let uploaded = json["uploaded"].boolValue

			let bigUrl = json["big_url"].stringValue

			let thumbnailUrl = json["thumbnail_url"].stringValue

			let kind = json["kind"].stringValue

			return PivotalAttachment(id: id, projectId: projectId, filename: filename, uploaderId: uploaderId, thumbnailable: thumbnailable, height: height, width: width, size: size, downloadUrl: downloadUrl, contentType: contentType, uploaded: uploaded, bigUrl: bigUrl, thumbnailUrl: thumbnailUrl, kind: kind)
		}

		return nil
	}

	class func deserializeAll(json: JSON) -> [PivotalAttachment] {

		var items = [PivotalAttachment]()

		if let jsonArray = json.array {
			for item: JSON in jsonArray {
				if let pivotalAttachment = deserialize(item) {
					items.append(pivotalAttachment)
				}
			}
		}

		return items
	}

	func serialize () -> NSMutableDictionary {

		let dict = NSMutableDictionary()

		dict.setValue(projectId == nil ? nil : Int(projectId!), forKey: PivotalFields.NewAttachmentFields.ProjectId.rawValue)

		dict.setValue(id == nil ? nil : id!, forKey: PivotalFields.NewAttachmentFields.Id.rawValue)

		dict.setObject(filename, forKey: PivotalFields.NewAttachmentFields.Filename.rawValue)

		dict.setObject(uploaderId, forKey: PivotalFields.NewAttachmentFields.UploaderId.rawValue)

		dict.setObject(thumbnailable, forKey: PivotalFields.NewAttachmentFields.Thumbnailable.rawValue)

		dict.setObject(height, forKey: PivotalFields.NewAttachmentFields.Height.rawValue)

		dict.setObject(width, forKey: PivotalFields.NewAttachmentFields.Width.rawValue)

		dict.setObject(size, forKey: PivotalFields.NewAttachmentFields.Size.rawValue)

		dict.setObject(downloadUrl, forKey: PivotalFields.NewAttachmentFields.DownloadUrl.rawValue)

		dict.setObject(contentType, forKey: PivotalFields.NewAttachmentFields.ContentType.rawValue)

		dict.setObject(uploaded, forKey: PivotalFields.NewAttachmentFields.Uploaded.rawValue)

		dict.setObject(bigUrl, forKey: PivotalFields.NewAttachmentFields.BigUrl.rawValue)

		dict.setObject(thumbnailUrl, forKey: PivotalFields.NewAttachmentFields.ThumbnailUrl.rawValue)

		dict.setObject(kind, forKey: PivotalFields.NewAttachmentFields.Kind.rawValue)

		return dict
	}
}

