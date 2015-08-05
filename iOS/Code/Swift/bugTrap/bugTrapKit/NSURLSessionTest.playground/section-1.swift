// Playground - noun: a place where people can play

import Foundation
import XCPlayground

XCPSetExecutionShouldContinueIndefinitely()


let url = NSURL(string: "https://bluetube.mydonedone.com/issuetracker/api/v2/projects.json")

let config = NSURLSessionConfiguration.defaultSessionConfiguration()
let userPasswordString = "c0lby:bluetube123"
let userPasswordData = userPasswordString.dataUsingEncoding(NSUTF8StringEncoding)
let base64EncodedCredential = userPasswordData!.base64EncodedStringWithOptions(nil)

let authString = "Basic \(base64EncodedCredential)"

config.HTTPAdditionalHeaders = ["Authorization" : authString]

let session = NSURLSession(configuration: config)

let task = session.dataTaskWithURL(url) {
	(let data, let response, let error) in
	
	if let httpResponse = response as? NSHTTPURLResponse {
		
		var err: NSError?
		
		let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &err) as Array<AnyObject>

		
		
		
		if let e = err {
			println("error occurred: \(e.localizedDescription)")
		} else {
			for elem: AnyObject in jsonData {
				let id = elem["id"] as Int
				let title = elem["title"]
				println("Id = \(id), \(title)")
			}
		}
	}
}

// Uncomment below to run:

// task.resume()
