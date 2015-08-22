//
//  RestProxy.swift
//  bugTrap
//
//  Created by Colby L Williams on 11/14/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

class RestProxy : NSObject {

    //var data: NSMutableData = NSMutableData()

    var authHeader: String?

    let sessionConfig: NSURLSessionConfiguration
	
    override init() {
        
        self.sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        super.init()
    }
	
	
	func setAuthentication(authenticationType: AuthenticationType, username: String = "", password: String = "", token: String = "") {

		switch (authenticationType) {
			
		case .Basic: // DoneDone
			
			if !username.isEmpty && !password.isEmpty {
				
				let credentials = "\(username):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!.base64EncodedStringWithOptions([])
				
				authHeader = "Basic \(credentials)"
				
			} else {
				Log.error("RestProxy setAuthentication", "Attempt to set Basic Authentication Failed.  No Username or Passowrd")
			}
			
		case .Token: // Pivotal
			
			if !token.isEmpty {
			
				authHeader = token

			} else {
				Log.error("RestProxy setAuthentication", "Attempt to set Token Authentication Failed.  No Token")
			}
		}
	}
	
	
	
	func getAuthenticatedRequest(url: NSURL, authenticationType: AuthenticationType, method: HttpMethod = HttpMethod.Get, contentType: String = ContentType.Json.rawValue) -> NSMutableURLRequest {
		
		let request = getRequest(url, method: method)
		
			request.addValue(contentType, forHTTPHeaderField: "Content-Type")

		if let header = authHeader {
			
			switch (authenticationType) {
				
			case .Basic: // DoneDone
				
				request.addValue(header, forHTTPHeaderField: "Authorization")
				
				request.addValue("nocheck", forHTTPHeaderField: "X-Atlassian-Token")
				
			case .Token: // Pivotal
				
				request.addValue(header, forHTTPHeaderField: "X-TrackerToken")
			}
		} else {
			Log.error ("RestProxy authHeader has no value")
		}
		
		Log.info("RestProxy getAuthenticatedRequest", authHeader)
		
		return request
	}
	
	
	
    func getRequest(url: NSURL, method: HttpMethod = HttpMethod.Get) -> NSMutableURLRequest {
        let request = NSMutableURLRequest()
			request.URL = url
			request.HTTPMethod = method.string
        
        return request
    }
	
	
	
	func get(url: NSURL, authenticationType: AuthenticationType, callback: (Result<JSON>) -> ()) {

        let session = NSURLSession(configuration: sessionConfig)
        
		let task = session.dataTaskWithRequest(getAuthenticatedRequest(url, authenticationType: authenticationType)){ (data, response, error) in
            self.processJSONResponse(data, response: response, error: error, callback: callback)
        }
        
        task.resume()
    }

	
	
    func getData(url: NSURL, callback : (Result<NSData>) -> ()) {
        
        let session = NSURLSession(configuration: sessionConfig)
        
        let task = session.dataTaskWithRequest(getRequest(url)) { (data, response, error) in

            if error == nil {
                if let httpResponse = response as? NSHTTPURLResponse {
                    if httpResponse.statusCode == HttpStatus.Ok.rawValue {
						dispatch_async(dispatch_get_main_queue()) {
							callback(.Value(Wrapped(data)))
						}
                    } else {
                        let err = NSError(domain: HttpStatus.type, code: httpResponse.statusCode, userInfo: nil)
						dispatch_async(dispatch_get_main_queue()) {
							callback(.Error(err))
						}
                    }
                }
            } else {
				Log.error("RestProxy processJSONResponse", error)
				dispatch_async(dispatch_get_main_queue()) {
					callback(.Error(error!))
				}
            }
        }
        
        task.resume()
    }
	
	
	
    func processJSONResponse(data: NSData!, response: NSURLResponse!, error: NSError!, callback: (Result<JSON>) -> ()) {
        
        if error == nil {
			
            if let httpResponse = response as? NSHTTPURLResponse {
				
				if httpResponse.statusCode == HttpStatus.Ok.rawValue || httpResponse.statusCode == HttpStatus.Created.rawValue {
                    
					let json = JSON(data: data)
					
                    if let jsonError = json.error {
						Log.info("RestProxy processJSONResponse", json)
						dispatch_async(dispatch_get_main_queue()) {
							callback(.Error(jsonError))
						}
                    } else {
						Log.info("RestProxy processJSONResponse", json)
						dispatch_async(dispatch_get_main_queue()) {
							callback(.Value(Wrapped(json)))
						}
                    }
                } else {
                    let err = NSError(domain: HttpStatus.type, code: httpResponse.statusCode, userInfo: nil)
					Log.error("RestProxy processJSONResponse", error)
                    dispatch_async(dispatch_get_main_queue()) {
                        callback(.Error(err))
                    }
                }
            }
        } else {
			Log.error("RestProxy processJSONResponse", error)
            dispatch_async(dispatch_get_main_queue()) {
                callback(.Error(error))
            }
        }
    }
	
	
	
	func post<T : JsonSerializable>(url: NSURL, authenticationType: AuthenticationType, object: T, callback: (Result<JSON>) -> ()) {
		
		Log.info("RestProxy post")
		
        let session = NSURLSession(configuration: sessionConfig)
        var err : NSError?
        
        // serialize the data
		let dict = object.serialize()

		Log.info("RestProxy post", dict)
		
		let data: NSData?
		do {
			data = try NSJSONSerialization.dataWithJSONObject(dict, options: [])
		} catch let error as NSError {
			err = error
			data = nil
		}
		
        if err != nil {
            dispatch_async(dispatch_get_main_queue()) {
                callback(.Error(err!))
            }
        }
		
        // create a POST request and attach the data
		let request = getAuthenticatedRequest(url, authenticationType: authenticationType, method: .Post)
			request.HTTPBody = data

        // make the service call
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            self.processJSONResponse(data, response: response, error: error, callback: callback)
        }
        
        task.resume()
    }
	
	

	// Pivotal Tracker
	func postAttachment(url: NSURL, authenticationType: AuthenticationType, attachment: NSData? = nil, callback: (Result<JSON>) -> ()) {
		
		let body: NSMutableData = NSMutableData()
		
		let session = NSURLSession(configuration: sessionConfig)
		
		let boundary = "Boundary-\(NSUUID().UUIDString)"
		
		let name = "file", filename = "bugTrap screen capture.jpeg"
		
		body.appendString("--\(boundary)\r\n")
		
		body.appendString("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n")
		
		body.appendString("Content-Type: \(ContentType.ImageJpeg.rawValue)\r\n\r\n")
		
		body.appendData(attachment!)

		body.appendString("\r\n--\(boundary)--\r\n")
		
		let contentType = "\(ContentType.MultiPartForm.rawValue); boundary=\(boundary)"
		
		// create a POST request and attach the data
		let request = getAuthenticatedRequest(url, authenticationType: authenticationType, method: .Post, contentType: contentType)
			request.HTTPBody = body
		
		
		// make the service call
		let task = session.dataTaskWithRequest(request) { (data, response, error) in
			self.processJSONResponse(data, response: response, error: error, callback: callback)
		}
		
		task.resume()
	}

	
	
	// DoneDone
	func postWithAttachments<T : JsonSerializable>(url: NSURL, authenticationType: AuthenticationType, object: T, attachments: [NSData]? = nil, callback: (Result<JSON>) -> ()) {
        
        if attachments == nil {
			self.post(url, authenticationType: authenticationType, object: object, callback: callback)
            return
        }
        
		var count = 0;
		
		var fieldData = ""
		
        let data: NSMutableData = NSMutableData()

		let session = NSURLSession(configuration: sessionConfig)
		
		let boundary = "------------------------\(NSDate().timeIntervalSince1970 * 1000)"
		
        // get the dictionary of fields for this object and add the data as form-data parts
        let fieldDict = object.serialize()
		
        for keyValue in fieldDict {
			fieldData += "\n--\(boundary)\nContent-Type: \(ContentType.TextPlain.rawValue)\nContent-Disposition: form-data;name=\"\(keyValue.key)\"\n\n\(keyValue.value)"
        }
        
        data.appendData(fieldData.dataUsingEncoding(NSUTF8StringEncoding)!)
        
        for attachment in attachments! {
			
            let name = count == 0 ? "bugTrap screen capture.jpg" : "bugTrap screen capture \(count).jpg"
				count++
			
			let fileInfo = "\n--\(boundary)\nContent-Disposition: filename=\"\(name)\"\nContent-Type: \(ContentType.ImageJpeg.rawValue)\n\n".dataUsingEncoding(NSUTF8StringEncoding)!
				data.appendData(fileInfo)
			
            data.appendData(attachment)
        }
		
		// trailing boundary
		let trailer = "\n--\(boundary)--\n".dataUsingEncoding(NSASCIIStringEncoding)!
			data.appendData(trailer)
		
		
		let contentType = "\(ContentType.MultiPartForm.rawValue); boundary=\(boundary)"
		
        // create a POST request and attach the data
		let request = getAuthenticatedRequest(url, authenticationType: authenticationType, method: .Post, contentType: contentType)
			request.HTTPBody = data
		
		
        // make the service call
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            self.processJSONResponse(data, response: response, error: error, callback: callback)
        }
        
        task.resume()
    }
}