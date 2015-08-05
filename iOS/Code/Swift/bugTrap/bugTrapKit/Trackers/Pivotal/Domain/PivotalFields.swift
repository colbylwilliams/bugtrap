//
//  PivotalFields.swift
//  bugTrap
//
//  Created by Colby L Williams on 10/31/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

class PivotalFields {

	enum NewStoryFields : String, Stringable {

		case ProjectId = "project_id"

		case Name = "name"

		case Description = "description"

		case StoryType = "story_type"

		case CurrentState = "current_state"

		case Estimate = "estimate"

		case AcceptedAt = "accepted_at"

		case Deadline = "deadline"

		case RequestedById = "requested_by_id"

		case OwnedById = "owned_by_id"

		case OwnerIds = "owner_ids"

		case Labels = "labels"

		case LabelIds = "label_ids"

		case Tasks = "tasks"

		case FollowerIds = "follower_ids"

		case Comments = "comments"

		case CreatedAt = "created_at"

		case BeforeId = "before_id"

		case AfterId = "after_id"

		case IntegrationId = "integration_id"

		case ExternalId = "external_id"

		case ClNumbers = "cl_numbers"

		var string: String {
			return self.rawValue
		}
	}


	enum NewPersonFields : String, Stringable {

		case Id = "id"

		case Name = "name"

		case Initials = "initials"

		case Username = "username"

		case TimeZone = "time_zone"

		case ApiToken = "api_token"

		case HasGoogleIdentity = "has_google_identity"

		case ProjectIds = "project_ids"

		case WorkspaceIds = "workspace_ids"

		case Email = "email"

		case ReceivesInAppNotifications = "receives_in_app_notifications"

		case CreatedAt = "created_at"

		case UpdatedAt = "updated_at"

		case Kind = "kind"

		var string: String {
			return self.rawValue
		}
	}

	enum NewAttachmentFields : String, Stringable {

		case Id = "id"

		case ProjectId = "project_id"

		case Filename = "filename"

		case UploaderId = "uploader_id"

		case Thumbnailable = "thumbnailable"

		case Height = "height"

		case Width = "width"

		case Size = "size"

		case DownloadUrl = "download_url"

		case ContentType = "content_type"

		case Uploaded = "uploaded"

		case BigUrl = "big_url"

		case ThumbnailUrl = "thumbnail_url"

		case Kind = "kind"

		var string: String {
			return self.rawValue
		}
	}

	enum NewCommentFields : String {

		case Id = "id"

		case StoryId = "story_id"

		case EpicId = "epic_id"

		case Text = "text"

		case PersonId = "person_id"

		case FileAttachmentIds = "file_attachment_ids"

		case FileAttachments = "file_attachments"

		case GoogleAttachmentIds = "google_attachment_ids"

		case CommitIdentifier = "commit_identifier"

		case CommitType = "commit_type"

		case Kind = "kind"

	}
}