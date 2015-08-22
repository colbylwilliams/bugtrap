//
//  TrapState.swift
//  bugTrap
//
//  Created by Colby L Williams on 8/24/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import UIKit
import Photos

public class TrapState {

	public class var Shared : TrapState {

		struct Static {
			static let instance: TrapState = TrapState()
		}
		
		return Static.instance
	}
	
	init () {
		photos = Photos()
	}

	let photos: Photos
	
	
	private var activeSnapshotImageStore: UIImage?


	public var inSdk = false
	
	
	public var inActionExtension: Bool = false {
		willSet {
			Analytics.Shared.inActionExtension = newValue
		}
	}


	public let deviceDetails = DeviceInfo.toString
	
	public let deviceDetailsJira = DeviceInfo.toJiraString


	private var snapshotImageLocalIdentifiers = [String]()


	private var activeSnapshotImageLocalIdentifier : String?


	private var activeSnapshotImageLocalIdentifierCache : String?


	// used by action extension
	private var extensionSnapshotImages = [UIImage]()

	
	// used by action extension
	private var extensionActiveSnapshotIndex : Int?

	
	// used by action extension
	private var extensionActiveSnapshotIndexCache : Int?

	
	public func getLocalIdentifiersForActiveSnapshots () -> [String] {
		return snapshotImageLocalIdentifiers
	}

	
	public func getLocalIdentifierForActiveSnapshot () -> String? {
		return activeSnapshotImageLocalIdentifier
	}


	public func getExtensionSnapshotImageAtIndex(index: Int) -> UIImage? {
		return (index < extensionSnapshotImages.count) ? extensionSnapshotImages[index] : nil
	}


	public func getExtensionSnapshotImageCount() -> Int {
		return extensionSnapshotImages.count
	}


	public var hasSnapshotImages: Bool {
		return inActionExtension ? !extensionSnapshotImages.isEmpty : !snapshotImageLocalIdentifiers.isEmpty
	}


	public var hasActiveSnapshotImage: Bool {
		return inActionExtension ? extensionActiveSnapshotIndex != nil : activeSnapshotImageLocalIdentifier != nil && activeSnapshotImageStore != nil
	}

	
	public var hasActiveSnapshotImageIdentifier: Bool {
		return inActionExtension ? extensionActiveSnapshotIndex != nil : activeSnapshotImageLocalIdentifier != nil// && activeSnapshotImageStore != nil
	}


	public func hasSnapshotImage(localIdentifier: String) -> Bool {
		return snapshotImageLocalIdentifiers.contains(localIdentifier)
	}


	public var activeSnapshotImage : UIImage? {

		if inActionExtension {
			return (extensionActiveSnapshotIndex != nil && extensionActiveSnapshotIndex < extensionSnapshotImages.count) ? extensionSnapshotImages[extensionActiveSnapshotIndex!] : nil
		} else {
			return activeSnapshotImageStore
		}
	}

	
	public func addActiveSnapshotImage() {
		if let localIdentifier = activeSnapshotImageLocalIdentifier {
			addSnapshotImage(localIdentifier)
		}
	}


	public func addSnapshotImageForSdk(snapshotImage: UIImage, callback:() -> ()) {
		
		inSdk = true
		updateSnapshotImage(snapshotImage, localIdentifier: nil, clearActive: true) { id in
			if let localId = id {
				self.setActiveSnapshotImage(localId, callback: callback)
			}
		}
	}
	
	
	public func addSnapshotImage(localIdentifier: String) {

		if !snapshotImageLocalIdentifiers.contains(localIdentifier) {
			snapshotImageLocalIdentifiers.append(localIdentifier)
		}
	}


	// override used by action extension
	public func addSnapshotImage(snapshotImage: UIImage, makeActive: Bool = false) {

		extensionSnapshotImages.append(snapshotImage)

		if makeActive {
			setActiveSnapshotImage(extensionSnapshotImages.count - 1)
		}
	}

	
	public func removeSnapshotImage (localIdentifier: String) {
		
		if let index = snapshotImageLocalIdentifiers.indexOf(localIdentifier) {
			snapshotImageLocalIdentifiers.removeAtIndex(index)
		}
	}

	
	
	public func deactivateActiveSnapshotImage() {
		if inActionExtension {
			extensionActiveSnapshotIndex = nil
		} else {
			activeSnapshotImageLocalIdentifier = nil
			activeSnapshotImageStore = nil // check
		}
	}

	
	public func setActiveSnapshotImage (localIdentifier: String, callback:() -> ()) {
		
		if activeSnapshotImageLocalIdentifier == localIdentifier {
			callback()
		} else {
			deactivateActiveSnapshotImage()
			activeSnapshotImageLocalIdentifier = localIdentifier
			photos.getImageForLocalIdentifier(localIdentifier) { image  in
				self.activeSnapshotImageStore = image
				callback()
			}
		}
	}

	
	// override used by action extension
	public func setActiveSnapshotImage (index: Int) {
		extensionActiveSnapshotIndex = (index < extensionSnapshotImages.count) ? index : nil
	}

	
	public func isSelectedSnapshot(localIdentifier: String) -> Bool {
		return snapshotImageLocalIdentifiers.contains(localIdentifier)
	}
	

	public func isActiveSnapshot(localIdentifier: String) -> Bool {
		return activeSnapshotImageLocalIdentifier != nil && activeSnapshotImageLocalIdentifier == localIdentifier
	}


	// override used by action extension
	public func isActiveSnapshot(index: Int) -> Bool {
		return extensionActiveSnapshotIndex != nil && extensionActiveSnapshotIndex == index
	}


	public func resetSnapshotImages(clearActive: Bool = true) {

		if inActionExtension {
			extensionSnapshotImages.removeAll(keepCapacity: false)
		} else {
			snapshotImageLocalIdentifiers.removeAll(keepCapacity: false)
		}

		if clearActive {
			deactivateActiveSnapshotImage()
		}
		
		// selectingSnapshotImagesForExport = false
	}



	//*Application: if the asset corresponding to the activeSnapshotImageLocalIdentifier is already in the bugTrap album, that asset
	// will be updated and the function will return nil.  Otherwise a new (duplicate) asset will be created and the function will
	// return the localIdentifier of the newly created asset
	//*Action Extension: this function returns nil
	public func updateActiveSnapshotImage (updatedSnapshot: UIImage, clearActive: Bool = false, callback: ((String?) -> ())) {

		if inActionExtension {
			if let activeIndex = extensionActiveSnapshotIndex {
				updateSnapshotImage(updatedSnapshot, index: activeIndex, clearActive: clearActive)
				callback(nil)
			}
		} else if let localIdentifier = activeSnapshotImageLocalIdentifier {
			updateSnapshotImage(updatedSnapshot, localIdentifier: localIdentifier, clearActive: clearActive, callback: callback)
		}
	}
	
	
	// used by action extension
	private func updateSnapshotImage (updatedSnapshot: UIImage, index: Int, clearActive: Bool = false) {
		
		if extensionSnapshotImages.count > index {
			extensionSnapshotImages[index] = updatedSnapshot
		}
		
		if clearActive {
			deactivateActiveSnapshotImage()
		}
	}
	

	private func updateSnapshotImage (updatedSnapshot: UIImage, localIdentifier: String?, clearActive: Bool = false, callback: ((String?) -> ())) {
		
		if clearActive {
			deactivateActiveSnapshotImage()
		}

		photos.updateAsset(updatedSnapshot, localIdentifier: localIdentifier) { newId in
			
			if let newIdentifier = newId {
				
				if let oldIdentifier = localIdentifier {

					if let index = self.snapshotImageLocalIdentifiers.indexOf(oldIdentifier) {
						self.snapshotImageLocalIdentifiers.removeAtIndex(index)
						self.snapshotImageLocalIdentifiers.insert(newIdentifier, atIndex: index)
					}
					
				} else {
					
					self.snapshotImageLocalIdentifiers.append(newIdentifier)
				}
				
				if !clearActive {
					self.activeSnapshotImageLocalIdentifier = newIdentifier
				}
			}
			
			callback(newId)
		}
	}


	public func getImageDataForSnapshots(callback: ([NSData]) -> ()) {

		if inActionExtension {

			var returnImageData = [NSData]()
			
			for image in extensionSnapshotImages {
				if let imageDataVal = UIImageJPEGRepresentation(image, 1.0) {
					returnImageData.append(imageDataVal)
				}
			}

			callback(returnImageData)

		} else {
			
			photos.getImageDataForLocalIdentifiers(self.snapshotImageLocalIdentifiers, callback: callback)
		}
	}

	
	public func deleteAssets(assets: [PHAsset], callback: (() -> ())!) {
		
		if assets.isEmpty {
			
			if let cb = callback { cb() }
			
		} else {
			
			// check if the snapshot the user is currently annotating is in the list
			if let activeLocalIdentifier = self.activeSnapshotImageLocalIdentifier {
				if assets.map({ $0.localIdentifier }).contains(activeLocalIdentifier) {
					self.deactivateActiveSnapshotImage()
				}
			}

			photos.deleteAssets(assets, callback: callback)
		}
	}
	

	public func getAlbumLocalIdentifier(callback: ((String) -> ())!) {

		photos.getAlbumLocalIdentifier(callback)
	}
}