//
//  PivotalProxy.swift
//  bugTrap
//
//  Created by Colby L Williams on 10/19/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation
import UIKit

class PivotalProxy : TrackerProxy {

    let restProxy = RestProxy()

    var token = ""

	
	required init() {
		
	}


    func getUrl(path: String) -> NSURL {
		let urlString = "https://www.pivotaltracker.com/services/v5/\(path)"
        let url = NSURL(string: urlString)
        return url!
    }

	
	
	func authenticate(data trackerData: [DataKeys : String], callback: (Result<Bool>) -> ()) {
		
		if let tok = trackerData[DataKeys.Token] { // Check for the token first
			token = tok
		}
		
		if !token.isEmpty { // Do we have a token?  If so, try to authenticate
			
			restProxy.setAuthentication(.Token, token: token)
			verifyAuthentication(callback)
		
		} else {
			
			Log.error("PivotalProxy init", "Error Initializing PivotalProxy: No Token.  Attempting to get Token with Username and Password.")
			
			var username = "", password = ""
			
			if let user = trackerData[DataKeys.UserName] { // Do we have a username?
			
				username = user

			} else {
				Log.error("PivotalProxy init", "Error Initializing PivotalProxy: No Username")
				callback(.Error(NSError(domain: "PivotalProxy", code: 401, userInfo: nil)))
			}
		
			if let pass = trackerData[DataKeys.Password] { // Do we have a password?
			
				password = pass
			
			} else {
				Log.error("PivotalProxy init", "Error Initializing PivotalProxy: No Password")
				callback(.Error(NSError(domain: "PivotalProxy", code: 401, userInfo: nil)))
			}
		
			if !username.isEmpty && !password.isEmpty { // Do we have both username and password?  If so try to authenticate
				
				self.restProxy.setAuthentication(.Basic, username: username, password: password)
				verifyAuthentication(callback)

			} else {
				Log.error("PivotalProxy authenticate", "Error Initializing PivotalProxy: No Username or Password")
				callback(.Error(NSError(domain: "PivotalProxy", code: 401, userInfo: nil)))
			}
		}
	}

	


    func verifyAuthentication(callback: (Result<Bool>) -> ()) {

		Log.info("PivotalProxy verifyAuthentication")
		
		if self.token.isEmpty {

			let url = NSURL(string: "https://www.pivotaltracker.com/services/v5/me")

			restProxy.get(url!, authenticationType: .Basic) { result in

				switch result {
				case let .Error(error):
					callback(.Error(error))
					return
				case let .Value(wrapped):
					if let json = wrapped.value {
						
						let pivotalMe = PivotalMe.deserialize(json)
						
							Log.info("PivotalProxy", pivotalMe)

						if let newToken = pivotalMe?.apiToken {
							
							self.token = newToken
							
							self.restProxy.setAuthentication(.Token, token: newToken)
							
							Analytics.Shared.trackerLogin(TrackerType.PivotalTracker.rawValue)
							
							callback(.Value(Wrapped(true)))
						} else {
							callback(.Value(Wrapped(false)))
						}
						
					} else {
						callback(.Value(Wrapped(false)))
					}
				}
			}
		} else {
			getProjects() { projectsResult in
				switch projectsResult {
				case let .Error(error):
					callback(.Error(error))
				case .Value(_):
					Analytics.Shared.trackerLogin(TrackerType.PivotalTracker.rawValue)
					callback(.Value(Wrapped(true)))
				}
			}
        }
    }



    func getProjects(callback: (Result<[PivotalProject]>) -> ()) {

        let url = getUrl("projects")

        restProxy.get(url, authenticationType: .Token) { result in
            switch result {
            case let .Error(error):
                callback(.Error(error))
                return
            case let .Value(wrapped):
				if let json = wrapped.value {
					let pivotalProjects = PivotalProject.deserializeAll(json)
					callback(.Value(Wrapped(pivotalProjects)))
				} else {
					callback(.Value(Wrapped(nil)))
				}
            }
        }
    }



//    func getProjectDetails(project: SimpleItem, callback: (Result<PivotalProject>) -> ()) {
//
//        let url = getUrl("projects/\(project.id!).json")
//
//        restProxy.get(url, authenticationType: .Token) { result in
//            switch result {
//            case let .Error(error):
//                callback(.Error(error))
//                return
//            case let .Value(wrapped):
//				if let json = wrapped.value {
//					let project = PivotalProject.deserialize(json)
//					callback(.Value(Wrapped(project)))
//				} else {
//					callback(.Value(Wrapped(nil)))
//				}
//			}
//        }
//    }



    func getPeople(projectId: Int, callback: (Result<[PivotalProjectMembership]>) -> ()) {

        let url = getUrl("projects/\(projectId)/memberships")

        restProxy.get(url, authenticationType: .Token) { result in
            switch result {
            case let .Error(error):
                callback(.Error(error))
                return
            case let .Value(wrapped):
				if let json = wrapped.value {
					let memberships = PivotalProjectMembership.deserializeAll(json)
					callback(.Value(Wrapped(memberships)))
				} else {
					callback(.Value(Wrapped(nil)))
				}
            }
        }
    }



	func getProjectLabels(projectId: Int, callback: (Result<[PivotalLabel]>) -> ()) {

		let url = getUrl("projects/\(projectId)/labels")

		restProxy.get(url, authenticationType: .Token) { result in
			switch result {
			case let .Error(error):
				callback(.Error(error))
				return
			case let .Value(wrapped):
				if let json = wrapped.value {
					let labels = PivotalLabel.deserializeAll(json)
					callback(.Value(Wrapped(labels)))
				} else {
					callback(.Value(Wrapped(nil)))
				}
			}
		}
	}



//    func getPriorityLevels(callback: (Result<[SimpleItem]>) -> ()) {
//
//        let url = getUrl("priority_levels.json")
//
//        restProxy.get(url, authenticationType: .Token) { result in
//            switch result {
//            case let .Error(error):
//                callback(.Error(error))
//                return
//			case let .Value(wrapped):
//				if let json = wrapped.value {
//					let priorityLevels = SimpleItem.deserializeAll(json)
//					callback(.Value(Wrapped(priorityLevels)))
//				} else {
//					callback(.Value(Wrapped(nil)))
//				}
//			}
//        }
//    }



    func getDataForUrl(url: String, callback: (Result<NSData>) -> ()) {

		if let nsUrl = NSURL(string: url) {
            restProxy.getData(nsUrl, callback: callback)
        } else {
            callback(.Value(Wrapped(NSData())))
        }
    }



	func uploadAttachments(projectId: Int, callback: (Result<[PivotalAttachment]>) -> ()) {

		Log.info("PivotalProxy", "uploadAttachments")

		let url = getUrl("projects/\(projectId)/uploads")

		TrapState.Shared.getImageDataForSnapshots { imageData in

			let imageCount = imageData.count
			var iterationCount = 0
			
			var attachments = [PivotalAttachment]()

			for image in imageData {

				self.restProxy.postAttachment(url, authenticationType: .Token, attachment: image) { result in
					iterationCount++

					switch result {
					case let .Error(error):
						// let's just not add this project
						Log.error("PivotalProxy", error)
					case let .Value(wrapped):
						if let json = wrapped.value {
							if let attachment = PivotalAttachment.deserialize(json) {
								attachment.projectId = projectId
								attachments.append(attachment)
							}
						}
					}

					// are we finished?
					if iterationCount == imageCount {
						callback(.Value(Wrapped(attachments)))
					}
				}
			}
		}
	}


	func createIssueForProject(issue: PivotalStory, project: PivotalProject, callback: (Result<PivotalStory>) -> ()) {

		Log.info("PivotalProxy", "createIssueForProject")

		let url = getUrl("projects/\(project.id!)/stories")
		// get snapshot ids then itterate
        if TrapState.Shared.hasSnapshotImages {

			self.uploadAttachments(project.id!) { attachmentsResult in

				switch attachmentsResult {
				case let .Error(error):
					//let's just not add this project
					Log.error("PivotalProxy", error)
				case let .Value(wrapped):
					if let attachments = wrapped.value {
						let comment = PivotalComment()
							comment.fileAttachments = attachments
						issue.comments.append(comment)
					}
					
					self.restProxy.post(url, authenticationType: .Token, object: issue) { postResult in
						
						switch postResult {
						case let .Error(error):
							callback(.Error(error))
							return
						case let .Value(wrapped):
							if let json = wrapped.value {
								let story = PivotalStory.deserialize(json)
								callback(.Value(Wrapped(story)))
							} else {
								callback(.Value(Wrapped(nil)))
							}
						}
					}
				}
			}
        } else { //no attachments to post
			restProxy.post(url, authenticationType: .Token, object: issue) { result in
                switch result {
                case let .Error(error):
                    callback(.Error(error))
                    return
				case let .Value(wrapped):
					if let json = wrapped.value {
						let story = PivotalStory.deserialize(json)
						callback(.Value(Wrapped(story)))
					} else {
						callback(.Value(Wrapped(nil)))
					}
				}
			}
		}
	}
}