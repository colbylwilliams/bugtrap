//
//  DoneDoneProxy.swift
//  bugTrap
//
//  Created by Colby L Williams on 8/25/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation
import UIKit

class DoneDoneProxy : TrackerProxy {
    
    let restProxy = RestProxy()
	
	var subdomain = ""
	
	required init () {
		
	}
    
	
	func getUrl(path: String) -> NSURL {

        let urlString = "https://\(subdomain).mydonedone.com/issuetracker/api/v2/\(path)"
		// Log.debug("DoneDoneProxy getUrl", urlString)
        let url = NSURL(string: urlString)
        return url!
    }
	
	
	
	func authenticate(data trackerData: [DataKeys : String], callback: (Result<Bool>) -> ()) {
		
		if let sub = trackerData[DataKeys.Subdomain] { // Do we have a subdomain?
			self.subdomain = sub
			// Log.debug("DoneDoneProxy Subdomain", self.subdomain)
		} else if subdomain.isEmpty { // Maybe we already have this saved
			Log.error("DoneDoneProxy authenticate", "Error Initializing DoneDoneProxy: No Subdomain")
			callback(.Error(NSError(domain: "DoneDoneProxy", code: 401, userInfo: nil)))
		}
		
		var username = "", password = ""
		
		if let user = trackerData[DataKeys.UserName] { // Do we have a username?
			username = user
			// Log.debug("DoneDoneProxy Username", user)
		} else {
			Log.error("DoneDoneProxy authenticate", "Error Initializing DoneDoneProxy: No Username")
			callback(.Error(NSError(domain: "DoneDoneProxy", code: 401, userInfo: nil)))
		}
		
		if let pass = trackerData[DataKeys.Password] { // Do we have a password?
			password = pass
			// Log.debug("DoneDoneProxy Password", pass)
		} else {
			Log.error("DoneDoneProxy authenticate", "Error Initializing DoneDoneProxy: No Password")
			callback(.Error(NSError(domain: "DoneDoneProxy", code: 401, userInfo: nil)))
		}
		
		if !username.isEmpty && !password.isEmpty {
			self.restProxy.setAuthentication(.Basic, username: username, password: password)
			verifyAuthentication(callback)
		} else {
			Log.error("DoneDoneProxy authenticate", "Error Initializing DoneDoneProxy: No Username or Password")
			callback(.Error(NSError(domain: "DoneDoneProxy", code: 401, userInfo: nil)))
		}
	}
	


    func verifyAuthentication(callback: (Result<Bool>) -> ()) {

		Log.info("DoneDoneProxy verifyAuthentication")
		
		let url = getUrl("projects.json")
		
		restProxy.get(url, authenticationType: .Basic) { result in
			switch result {
			case let .Error(error):
				callback(.Error(error))
				return
			case  .Value(_):
				callback(.Value(Wrapped(true)))
			}
		}
    }
	
	
	
	func getProjects(callback: (Result<[DoneDoneProject]>) -> ()) {
        
        var projects = [DoneDoneProject]()
        let url = getUrl("projects.json")
        var json : JSON?
        
        restProxy.get(url, authenticationType: .Basic) { result in
            switch result {
            case let .Error(error):
                callback(.Error(error))
                return
            case let .Value(wrapped):
                json = wrapped.value
            }
            
            let simpleProjects = DoneDoneSimpleItem.deserializeAll(json!)
            
            let projectCount = simpleProjects.count
            var detailCount = 0
            
            for simpleProject in simpleProjects {
                //get the details
                self.getProjectDetails(simpleProject) { result in
                    detailCount++
                    
                    switch result {
                    case let .Error(error):
                        //let's just not add this project
                        Log.error("DoneDoneProxy", error)
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
	
	
    
    func getProjectDetails(project: DoneDoneSimpleItem, callback: (Result<DoneDoneProject>) -> ()) {
        
        let url = getUrl("projects/\(project.id!).json")
        
        restProxy.get(url, authenticationType: .Basic) { result in
            switch result {
            case let .Error(error):
                callback(.Error(error))
                return
            case let .Value(wrapped):
				if let json = wrapped.value {
					let project = DoneDoneProject.deserialize(json)
					callback(.Value(Wrapped(project)))
				} else {
					callback(.Value(Wrapped(nil)))
				}
            }
        }
    }
	
	
	
    func getPeople(projectId: Int, callback: (Result<[DoneDonePerson]>) -> ()) {
        
        var people = [DoneDonePerson]()
        let url = getUrl("projects/\(projectId)/people.json")
        var json : JSON?
        
        restProxy.get(url, authenticationType: .Basic) { result in
            switch result {
            case let .Error(error):
                callback(.Error(error))
                return
            case let .Value(wrapped):
                json = wrapped.value
            }
            
            let simplePeople = DoneDoneSimpleItem.deserializeAll(json!)
            
            let peopleCount = simplePeople.count
            var detailCount = 0
            
            for simplePerson in simplePeople {
                //get the details
                self.getPersonDetails(simplePerson) { result in
                    detailCount++
                    
                    switch result {
                    case let .Error(error):
                        //let's just not add this project
                        Log.error("DoneDoneProxy", error)
                    case let .Value(wrapped):
						if let person = wrapped.value {
							people.append(person)
						}
                    }
                    
                    //are we finished?
                    if detailCount == peopleCount {
                        callback(.Value(Wrapped(people)))
                    }
                }
            }
        }
    }
	
	
	
    func getPersonDetails(person: DoneDoneSimpleItem, callback: (Result<DoneDonePerson>) -> ()) {
        
        let url = getUrl("people/\(person.id!).json")
        
        restProxy.get(url, authenticationType: .Basic) { result in
            switch result {
            case let .Error(error):
                callback(.Error(error))
                return
            case let .Value(wrapped):
				if let json = wrapped.value {
					let person = DoneDonePerson.deserialize(json)
					callback(.Value(Wrapped(person)))
				} else {
					callback(.Value(Wrapped(nil)))
				}
            }
        }
    }
	
	
    
    func getPersonImage(person: DoneDonePerson, callback: (Result<UIImage?>) -> ()) {
        
        if !person.avatarUrl.isEmpty {
            let url = getUrl(person.avatarUrl)
            
            restProxy.getData(url) { result in
                switch result {
                case let .Error(error):
                    callback(.Error(error))
                    return
                case let .Value(wrapped):
					if let data = wrapped.value {
						callback(.Value(Wrapped(UIImage(data: data))))
					} else {
			            callback(.Value(Wrapped(nil)))
					}
                }
            }
        } else {
            callback(.Value(Wrapped(nil)))
        }
    }
	
	
	
    func getPriorityLevels(callback: (Result<[DoneDoneSimpleItem]>) -> ()) {
		
        let url = getUrl("priority_levels.json")
        
        restProxy.get(url, authenticationType: .Basic) { result in
            switch result {
            case let .Error(error):
                callback(.Error(error))
                return
			case let .Value(wrapped):
				if let json = wrapped.value {
					let priorityLevels = DoneDoneSimpleItem.deserializeAll(json)
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
	
	
	
    func createIssueForProject(issue: DoneDoneIssue, project: DoneDoneProject, callback: (Result<DoneDoneSimpleItem>) -> ()) {
		
		let url = getUrl("projects/\(project.id!)/issues.json")
		
        if TrapState.Shared.hasSnapshotImages {
            
			TrapState.Shared.getImageDataForSnapshots { imageData in
				
				self.restProxy.postWithAttachments(url, authenticationType: .Basic, object: issue, attachments: imageData) { result in
					switch result {
					case let .Error(error):
						callback(.Error(error))
						return
					case let .Value(wrapped):
						if let json = wrapped.value {
							let issue = DoneDoneIssue.deserialize(json)
							callback(.Value(Wrapped(issue)))
						} else {
							callback(.Value(Wrapped(nil)))
						}
					}
				}
            }
        } else { //no attachments to post
            restProxy.post(url, authenticationType: .Basic, object: issue) { result in
                switch result {
                case let .Error(error):
                    callback(.Error(error))
                    return
                case let .Value(wrapped):
					if let json = wrapped.value {
						let issue = DoneDoneIssue.deserialize(json)
						callback(.Value(Wrapped(issue)))
					} else {
						callback(.Value(Wrapped(nil)))
					}
                }
            }
        }
    }
}