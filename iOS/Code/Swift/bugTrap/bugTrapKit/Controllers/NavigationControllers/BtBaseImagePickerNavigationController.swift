//
//  BtBaseImagePickerNavigationController.swift
//  bugTrap
//
//  Created by Colby L Williams on 8/25/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import UIKit
import MobileCoreServices

class BtBaseImagePickerNavigationController: BtBaseNavigationViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
	
	func selectImageFromLibrary (forExportFlow: Bool = false) {
		
		if UIImagePickerController.isSourceTypeAvailable(.SavedPhotosAlbum) {
			
			var imagePicker = UIImagePickerController()
			
			imagePicker.delegate = self
			imagePicker.sourceType = .SavedPhotosAlbum
			imagePicker.mediaTypes =  [kUTTypeImage as AnyObject]
			imagePicker.allowsEditing = false
			
			presentViewController(imagePicker, animated: true, completion: nil)
		}
	}
	
	func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: NSDictionary!) {
		
		if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
			println(info)
//			TrapState.Shared.addSnapshotImage(image, makeActive: true)
		}

		dismissViewControllerAnimated(true, completion: nil)
	}
	
	func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
		
		dismissViewControllerAnimated(true, completion: nil)
	}
}