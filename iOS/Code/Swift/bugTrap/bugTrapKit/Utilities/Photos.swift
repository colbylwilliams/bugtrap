//
//  Photos.swift
//  bugTrap
//
//  Created by Colby L Williams on 11/20/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Photos
import Foundation

public class Photos {

	private var albumLocalIdentifier: String = ""
	private let formatIdentifier: String = "io.bugtrap.bugTrap"
	private let formatVersion: String = "1.0.0"

	
	// this function will check if the asset corresponding to the localIdentifier passed in is already in the bugTrap album.
	// If it is, it will update the existing asset and return nil in the callback, otherwise, a new (duplicate) will be created 
	// and the localIdentifier of the newly created asset will be returned by the callback
	public func updateAsset (updatedSnapshot: UIImage, localIdentifier: String?, callback: ((String?) -> ())) {

		getAlbumLocalIdentifier { collectionLocalIdentifier in

			if collectionLocalIdentifier.isEmpty {
				callback(nil)
				return
			}

			// get the bugTrap album
			if let bugTrapAlbum = PHAssetCollection.fetchAssetCollectionsWithLocalIdentifiers([collectionLocalIdentifier], options: nil).firstObject as? PHAssetCollection  {

				// if we passed in null for the localIdentifier, we just want to save the image and
				// get a new identifier (most likely being used as the sdk)
				if localIdentifier == nil {
					self.saveAsset(updatedSnapshot, bugTrapAlbum: bugTrapAlbum, callback: callback)
					return
				}
				
				// get the asset for the localIdentifier
				if let asset = PHAsset.fetchAssetsWithLocalIdentifiers([localIdentifier!], options: nil).firstObject as? PHAsset {

					// get all the albums containing this asset
					// check if any of the albums is the bugTrap album.
					// if the asset is already in the bugTrap album, update the existing asset.
					if PHAssetCollection.fetchAssetCollectionsContainingAsset(asset, withType: .Album, options: nil).containsObject(bugTrapAlbum) {

						// retrieve a PHContentEditingInput object
						asset.requestContentEditingInputWithOptions(nil) { input, info in

							PHPhotoLibrary.sharedPhotoLibrary().performChanges({

								let editAssetOutput = PHContentEditingOutput(contentEditingInput: input!)

									editAssetOutput.adjustmentData = PHAdjustmentData(formatIdentifier: "io.bugtrap.bugTrap", formatVersion: "1.0.0", data: NSData())

								let editAssetJpegData = UIImageJPEGRepresentation(updatedSnapshot, 1.0)

									editAssetJpegData!.writeToURL(editAssetOutput.renderedContentURL, atomically: true)

								let editAssetRequest = PHAssetChangeRequest(forAsset: asset)

									editAssetRequest.contentEditingOutput = editAssetOutput

							}, completionHandler: { success, error in

								dispatch_async(dispatch_get_main_queue()) {
									callback(nil)
								}

								if success {

								} else if error != nil {
									Log.error("Photos", error)
								}
							})
						}

					// if the asset isn't in the bugTrap album, create a new asset and put it in the album, and leave the original unchanged
					} else {

						self.saveAsset(updatedSnapshot, bugTrapAlbum: bugTrapAlbum, callback: callback)
					}
				}
			} else { // couldn't find the bugTrap album - user probably deleted it while the app was open

				self.albumLocalIdentifier = ""

				self.createAlbumAndSaveLocalIdentifier() { id in
					if !id.isEmpty {
						self.updateAsset(updatedSnapshot, localIdentifier: localIdentifier, callback: callback)
					} else { callback(nil) }
				}
			}
		}
	}


	func saveAsset(updatedSnapshot: UIImage, bugTrapAlbum: PHAssetCollection, callback: ((String?) -> ())) {
		
		var newLocalIdentifier: String?
		
		PHPhotoLibrary.sharedPhotoLibrary().performChanges({
			
			// create a new asset from the UIImage updatedSnapshot
			let createAssetRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(updatedSnapshot)
			
			// create a request to make changes to the bugTrap album
			if let collectionRequest = PHAssetCollectionChangeRequest(forAssetCollection: bugTrapAlbum) {
				
				// get a reference to the placeholder
				if let placeholder = createAssetRequest.placeholderForCreatedAsset {
					
					// get a reference to the new localIdentifier
					newLocalIdentifier = placeholder.localIdentifier
					
					// add the newly created asset to the bugTrap album
					collectionRequest.addAssets([placeholder])
				}
			}
			}, completionHandler: { success, error in
				
				dispatch_async(dispatch_get_main_queue()) {
					callback(newLocalIdentifier)
				}
				
				if success {
					
				} else if error != nil {
					Log.error("Photos", error)
				}
		})
	}
	

	public func getImageDataForLocalIdentifiers(localIdentifiers: [String], callback: ([NSData]) -> ()) {

		var returnImageData = [NSData]()

		PHPhotoLibrary.requestAuthorization{ status in
			if status == .Authorized {

				let assetResults = PHAsset.fetchAssetsWithLocalIdentifiers(localIdentifiers, options: nil)
					assetResults.enumerateObjectsUsingBlock{ object, idx, _ in
						if let asset = object as? PHAsset {
							PHImageManager.defaultManager().requestImageDataForAsset(asset, options: nil) { imageData, dataUTI, orientation, info in
								if let imageDataForAsset = imageData {
									returnImageData.append(imageDataForAsset)
								}
								
								if idx == assetResults.count - 1 {
									callback(returnImageData)
								}
							}
						}
					}
				
			}
		}
	}



	public func getImageForLocalIdentifier(localIdentifier: String, callback:(UIImage?) -> ()) {

		PHPhotoLibrary.requestAuthorization{ status in
			if status == .Authorized {

				if let asset = PHAsset.fetchAssetsWithLocalIdentifiers([localIdentifier], options: nil).firstObject as? PHAsset {
					PHImageManager.defaultManager().requestImageDataForAsset(asset, options: nil) { imageData, dataUTI, orientation, info in
						if let imageDataForAsset = imageData {
							callback(UIImage(data: imageDataForAsset))
						}else { callback(nil) }
					}
				} else { callback(nil) }
			} else { callback(nil) }
		}
	}



	public func deleteAssets(assets: [PHAsset], callback: (() -> ())!) {

		if assets.isEmpty {
			if let cb = callback { cb() }
			return
		}

		PHPhotoLibrary.requestAuthorization{ status in
			if status == .Authorized {

				PHPhotoLibrary.sharedPhotoLibrary().performChanges({

					PHAssetChangeRequest.deleteAssets(assets)

				}, completionHandler:  { success, error in

					if let cb = callback { cb() }

					if success {

					} else if error != nil {
						Log.error("Photos", error)
					}
				})
			} else if let cb = callback { cb() }
		}
	}


	public func getAlbumLocalIdentifier(callback: ((String) -> ())!) {

		PHPhotoLibrary.requestAuthorization{ status in
			if status == .Authorized {

				if !self.albumLocalIdentifier.isEmpty {

					if let cb = callback { cb(self.albumLocalIdentifier) }; return

				} else {

					let keychain = Keychain<TrapAlbum>(service: TrapAlbum())
					let values = keychain.GetStoredKeyValues()

					if let id = values[DataKeys.LocalIdentifier] {
						// ensure the album with that localIdentifier is there
						if let _ = PHAssetCollection.fetchAssetCollectionsWithLocalIdentifiers([id], options: nil).firstObject as? PHAssetCollection {
							self.albumLocalIdentifier = id
							if let cb = callback { cb(self.albumLocalIdentifier) }; return
						} else {
							self.createAlbumAndSaveLocalIdentifier(callback); return
						}
					} else {
						self.createAlbumAndSaveLocalIdentifier(callback); return
					}
				}
			} else if let cb = callback { cb("") }
		}
	}



	private func createAlbumAndSaveLocalIdentifier (callback: ((String) -> ())!) {

		var collectionLocalIdentifier = ""

		PHPhotoLibrary.sharedPhotoLibrary().performChanges({

			let request = PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle("bugTrap")

			collectionLocalIdentifier = request.placeholderForCreatedAssetCollection.localIdentifier

		}, completionHandler:  { success, error in

			if success && !collectionLocalIdentifier.isEmpty {

				let keychain = Keychain<TrapAlbum>(service: TrapAlbum())

				// ensure the album with that localIdentifier is there
				if let _ = PHAssetCollection.fetchAssetCollectionsWithLocalIdentifiers([collectionLocalIdentifier], options: nil).firstObject as? PHAssetCollection {
					self.albumLocalIdentifier = collectionLocalIdentifier
					if let cb = callback { cb(self.albumLocalIdentifier) }
					keychain.StoreKeyValues([DataKeys.LocalIdentifier : self.albumLocalIdentifier]);
					return
				}
				
				self.albumLocalIdentifier = ""
				if let cb = callback { cb(self.albumLocalIdentifier) }
				Log.error("Photos", "Unable to create bugTrap album")

			} else if let e = error {

				self.albumLocalIdentifier = ""
				if let cb = callback { cb(self.albumLocalIdentifier) }
				Log.error("Photos)", e.localizedDescription)
			}
		})
	}
}



class TrapAlbum: Stringable {

	var string: String {
		return "TrapAlbum"
	}
}