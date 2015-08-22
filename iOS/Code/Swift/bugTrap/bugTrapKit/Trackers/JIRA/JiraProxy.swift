//
//  JiraProxy.swift
//  bugTrap
//
//  Created by Colby L Williams on 8/25/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

class JiraProxy : TrackerProxy {
	
	let restProxy = RestProxy()
	
	var server = ""
	
	required init () {
		
	}
	
	
	func getUrl(path: String) -> NSURL {
		
//		var urlString = "https://bugtrap.atlassian.net/rest/api/2/\(path)"
		let urlString = "\(self.server)/rest/api/2/\(path)"
		// Log.debug("JiraProxy getUrl", urlString)
		let url = NSURL(string: urlString)
		return url!
	}
	
	
	func authenticate(data trackerData: [DataKeys : String], callback: (Result<Bool>) -> ()) {
		
		if let srv = trackerData[DataKeys.Server] { // Do we have a subdomain?
		
			server = srv
	
		} else if server.isEmpty {
			
			Log.error("JiraProxy authenticate", "Error Initializing JiraProxy: No Server")
			callback(.Error(NSError(domain: "JiraProxy", code: 401, userInfo: nil)))
			
		}
		
		var username = "", password = ""
		
		if let user = trackerData[DataKeys.UserName] { // Do we have a username?
			
			username = user
			
		} else {
			Log.error("JiraProxy init", "Error Initializing JiraProxy: No Username")
			callback(.Error(NSError(domain: "JiraProxy", code: 401, userInfo: nil)))
		}
		
		if let pass = trackerData[DataKeys.Password] { // Do we have a password?
			
			password = pass
			
		} else {
			Log.error("JiraProxy init", "Error Initializing JiraProxy: No Password")
			callback(.Error(NSError(domain: "JiraProxy", code: 401, userInfo: nil)))
		}
		
		if !username.isEmpty && !password.isEmpty { // Do we have both username and password?  If so try to authenticate
			
			self.restProxy.setAuthentication(.Basic, username: username, password: password)
			verifyAuthentication(callback)
			
		} else {
			Log.error("JiraProxy authenticate", "Error Initializing JiraProxy: No Username or Password")
			callback(.Error(NSError(domain: "JiraProxy", code: 401, userInfo: nil)))
		}
	}
	
	
	
	func verifyAuthentication(callback: (Result<Bool>) -> ()) {
		
		Log.info("JiraProxy verifyAuthentication")
		
		let url = getUrl("project")
		
		restProxy.get(url, authenticationType: .Basic) { result in
			switch result {
			case let .Error(error):
				callback(.Error(error))
				return
			case .Value(_):
				Analytics.Shared.trackerLogin(TrackerType.JIRA.rawValue)
				callback(.Value(Wrapped(true)))
			}
		}
	}
	
	
	
	func getIssueCreateMeta(callback: (Result<JiraIssueCreateMeta>) -> ()) {
		
		let url = getUrl("issue/createmeta?expand=projects.issuetypes.fields")
		
		restProxy.get(url, authenticationType: .Basic) { result in
			switch result {
			case let .Error(error):
				callback(.Error(error))
				return
			case let .Value(wrapped):
				if let json = wrapped.value {
//					Log.debug("JiraProxy getIssueCreateMeta", json)
					if let meta = JiraIssueCreateMeta.deserialize(json) {
						callback(.Value(Wrapped(meta)))
					} else {
						callback(.Value(Wrapped(nil)))
					}
				} else {
					callback(.Value(Wrapped(nil)))
				}
			}
		}
	}

	
	
	func getProjects(callback: (Result<[JiraProject]>) -> ()) {
		
		var projects = [JiraProject]()
		let url = getUrl("project")
		var json : JSON?
		
		restProxy.get(url, authenticationType: .Basic) { result in
			switch result {
			case let .Error(error):
				callback(.Error(error))
				return
			case let .Value(wrapped):
				json = wrapped.value
			}
			
			let simpleProjects = JiraSimpleItem.deserializeAll(json!)
			
			let projectCount = simpleProjects.count
			var detailCount = 0
			
			for simpleProject in simpleProjects {
				//get the details
				self.getProjectDetails(simpleProject) { result in

					detailCount++
					
					switch result {
					case let .Error(error):
						//let's just not add this project
						Log.error("JiraProxy", error)
					case let .Value(wrapped):
						if let project = wrapped.value {
							projects.append(project)
						}
					}
					
					//are we finished?
					if detailCount == projectCount {
						callback(.Value(Wrapped(projects)))
					}
				}
			}
		}
	}
	
	
	
	func getProjectDetails(project: JiraSimpleItem, callback: (Result<JiraProject>) -> ()) {
		
		// let url = getUrl("projects/\(project.id!).json")
		
		let url = NSURL(string: project.selfUrl)
		
		restProxy.get(url!, authenticationType: .Basic) { result in
			switch result {
			case let .Error(error):
				callback(.Error(error))
				return
			case let .Value(wrapped):
				if let json = wrapped.value {
					let project = JiraProject.deserialize(json)
					callback(.Value(Wrapped(project)))
				} else {
					callback(.Value(Wrapped(nil)))
				}
			}
		}
	}
	
	
	
	func getPeople(projectKey: String, callback: (Result<[JiraUser]>) -> ()) {
		
		let url = getUrl("user/assignable/multiProjectSearch?projectKeys=\(projectKey)")
//		var json : JSON?
		
		restProxy.get(url, authenticationType: .Basic) { result in
			switch result {
			case let .Error(error):
				callback(.Error(error))
				return
			case let .Value(wrapped):
				if let json = wrapped.value {
					let people: [JiraUser] = JiraUser.deserializeAll(json)
					callback(.Value(Wrapped(people)))
				} else {
					callback(.Value(Wrapped(nil)))
				}
			}
			
//			let simplePeople = JiraSimpleItem.deserializeAll(json!)
//			
//			let peopleCount = simplePeople.count
//			var detailCount = 0
//			
//			for simplePerson in simplePeople {
//				//get the details
//				self.getPersonDetails(simplePerson) { result in
//					detailCount++
//					
//					switch result {
//					case let .Error(error):
//						//let's just not add this project
//						Log.error("JiraProxy", error)
//					case let .Value(wrapped):
//						if let person = wrapped.value {
//							people.append(person)
//						}
//					}
//					
//					//are we finished?
//					if detailCount == peopleCount {
//						callback(.Value(Wrapped(people)))
//					}
//				}
//			}
		}
	}
	
	
	
	func getPersonDetails(person: JiraSimpleItem, callback: (Result<JiraUser>) -> ()) {
		
		let url = getUrl("people/\(person.id!).json")
		
		restProxy.get(url, authenticationType: .Basic) { result in
			switch result {
			case let .Error(error):
				callback(.Error(error))
				return
			case let .Value(wrapped):
				if let json = wrapped.value {
					let person = JiraUser.deserialize(json)
					callback(.Value(Wrapped(person)))
				} else {
					callback(.Value(Wrapped(nil)))
				}
			}
		}
	}
	
	
	
//	func getPersonImage(person: JiraUser, callback: (Result<UIImage?>) -> ()) {
//		
//		if !person.avatarUrl.isEmpty {
//			let url = getUrl(person.avatarUrl)
//			
//			restProxy.getData(url) { result in
//				switch result {
//				case let .Error(error):
//					callback(.Error(error))
//					return
//				case let .Value(wrapped):
//					if let data = wrapped.value {
//						callback(.Value(Wrapped(UIImage(data: data))))
//					} else {
//						callback(.Value(Wrapped(nil)))
//					}
//				}
//			}
//		} else {
//			callback(.Value(Wrapped(nil)))
//		}
//	}
	
	
	
	func getPriorityLevels(callback: (Result<[JiraPriority]>) -> ()) {
		
		let url = getUrl("priority")
		
		restProxy.get(url, authenticationType: .Basic) { result in
			switch result {
			case let .Error(error):
				callback(.Error(error))
				return
			case let .Value(wrapped):
				if let json = wrapped.value {
					let priorityLevels:[JiraPriority] = JiraPriority.deserializeAll(json)
					callback(.Value(Wrapped(priorityLevels)))
				} else {
					callback(.Value(Wrapped(nil)))
				}
			}
		}
	}
	
	
	
	func getDataForUrl(url: String, callback: (Result<NSData>) -> ()) {
		if let nsUrl = NSURL(string: url) {
			restProxy.getData(nsUrl, callback: callback)
		} else {
			callback(.Value(Wrapped(NSData())))
		}
	}
	
	
	
	func uploadAttachments(issueId: Int, callback: (Result<[JiraSimpleItem]>) -> ()) {
		
		Log.info("JiraProxy", "uploadAttachments")
		
		let url = getUrl("issue/\(issueId)/attachments")
		
		TrapState.Shared.getImageDataForSnapshots { imageData in
			
			let imageCount = imageData.count
			var iterationCount = 0
			
			var attachments = [JiraSimpleItem]()
			
			for image in imageData {
				
				self.restProxy.postAttachment(url, authenticationType: .Basic, attachment: image) { result in
					iterationCount++
					
					switch result {
					case let .Error(error):
						// let's just not add this project
						Log.error("JiraProxy", error)
					case let .Value(wrapped):
						if let json = wrapped.value {
							// Log.debug("JiraProxy", json)
							if let attachment = JiraSimpleItem.deserialize(json) {
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

	

	
	func createIssueForProject(issue: JiraIssue, project: JiraProject, callback: (Result<JiraSimpleItem>) -> ()) {
		
		let url = getUrl("issue/")
		

			restProxy.post(url, authenticationType: .Basic, object: issue) { result in
				switch result {
				case let .Error(error):
					callback(.Error(error))
					return
				case let .Value(wrapped):
					if let json = wrapped.value {
						if let issue = JiraIssue.deserialize(json) {
							
							if TrapState.Shared.hasSnapshotImages {
								
								self.uploadAttachments(issue.id!) { attachmentsResult in
									
									switch attachmentsResult {
									case let .Error(error):
										//let's just not add this project
										Log.error("JiraProxy", error)
									case let .Value(wrapped):
										if let _ = wrapped.value {
											// Log.debug("JiraProxy", attachments)
											callback(.Value(Wrapped(issue)))
										}
									}
								}
							} else {
								callback(.Value(Wrapped(issue)))
							}
						}

						// callback(.Value(Wrapped(issue)))
					} else {
						callback(.Value(Wrapped(nil)))
					}
				}
			}
		
	}
}