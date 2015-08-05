using System;
using UIKit;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Foundation;
using Photos;

namespace bugTrapKit
{
	public class TrapState
	{
		// static readonly TrapState shared = new TrapState { Photos = new Photos () };

		public static TrapState Shared { get; } = new TrapState { Photos = new Photos () };

		Photos Photos;

		UIImage ActiveSnapshotImageStore;

		bool inActionExtension;

		public bool InActionExtension {
			get { return inActionExtension; }
			set {
				inActionExtension = value;
				// Analytics.Shared.InActionExtension = inActionExtension;
			}
		}

		// public string DeviceDetails = DeviceInfo.String;
		// public string DeviceDetailsJira = DeviceInfo.JiraString;

		List<string> snapshotImageLocalIdentifiers = new List<string> ();

		string activeSnapshotImageLocalIdentifier;
		// string activeSnapshotImageLocalIdentifierCache;

		// used by action extension
		List<UIImage> extensionSnapshotImages = new List<UIImage> ();

		// used by action extension
		nint? extensionActiveSnapshotIndex;
		// may need ot be nullable

		// used by action extension
		// nint? extensionActiveSnapshotIndexCache;
		// may need ot be nullable

		public string[] LocalIdentifiersForActiveSnapshots {
			get { return snapshotImageLocalIdentifiers.ToArray(); }
		}

		public string LocalIdentifiersForActiveSnapshot {
			get { return activeSnapshotImageLocalIdentifier; }
		}

		public UIImage GetExtensionSnapshotImageAtIndex (nint index)
		{
			return (index < extensionSnapshotImages.Count) ? extensionSnapshotImages.NIndexer(index) : null;
		}

		public int ExtensionSnapshotImageCount {
			get { return extensionSnapshotImages.Count; }
		}

		public bool HasSnapshotImages {
			get { return inActionExtension ? !extensionSnapshotImages.IsEmpty() : !snapshotImageLocalIdentifiers.IsEmpty(); }
		}

		public bool HasActiveSnapshotImage {
			get { return inActionExtension ? extensionActiveSnapshotIndex.HasValue : !string.IsNullOrEmpty(activeSnapshotImageLocalIdentifier) && ActiveSnapshotImageStore != null; }
		}

		public bool HasActiveSnapshotImageIdentifier {
			get { return inActionExtension ? extensionActiveSnapshotIndex.HasValue : !string.IsNullOrEmpty(activeSnapshotImageLocalIdentifier); }
		}

		public bool HasSnapshotImage (string localIdentifier)
		{
			return snapshotImageLocalIdentifiers.Contains(localIdentifier);
		}

		public UIImage ActiveSnapshotImage {
			get {
				if (inActionExtension) {
					return (extensionActiveSnapshotIndex.HasValue && extensionActiveSnapshotIndex.Value < extensionSnapshotImages.Count) ? extensionSnapshotImages[extensionActiveSnapshotIndex.Int32Value()] : null;
				} else {
					return ActiveSnapshotImageStore;
				}
			}
		}

		public void AddActiveSnapshotImage ()
		{
			if (!string.IsNullOrEmpty(activeSnapshotImageLocalIdentifier)) {
				AddSnapshotImage(activeSnapshotImageLocalIdentifier);
			}
		}

		public void AddSnapshotImage (string localIdentifier)
		{
			if (!snapshotImageLocalIdentifiers.Contains(localIdentifier)) {
				snapshotImageLocalIdentifiers.Add(localIdentifier);
			}
		}

		// override used by action extension
		public void AddSnapshotImage (UIImage snapshotImage, bool makeActive = false)
		{
			extensionSnapshotImages.Add(snapshotImage);

			if (makeActive) {
				SetActiveSnapshotImage(extensionSnapshotImages.Count - 1);
			}
		}

		public void RemoveSnapshotImage (string localIdentifier)
		{
			// var instance = snapshotImageLocalIdentifiers.FirstOrDefault(s => s == localIdentifier);
			// snapshotImageLocalIdentifiers.Remove(instance);
			snapshotImageLocalIdentifiers.Remove(localIdentifier);
		}

		public void DeactivateActiveSnapshotImage ()
		{
			if (inActionExtension) {
				extensionActiveSnapshotIndex = null;
			} else {
				activeSnapshotImageLocalIdentifier = null;
				ActiveSnapshotImageStore = null; // check
			}
				
		}

		public async Task SetActiveSnapshotImageAsync (string localIdentifier)
		{
			if (activeSnapshotImageLocalIdentifier == localIdentifier) return;

			DeactivateActiveSnapshotImage();

			activeSnapshotImageLocalIdentifier = localIdentifier;
			ActiveSnapshotImageStore = await Photos.GetImageForLocalIdentifier(localIdentifier);
		}

		// override used by action extension
		public void SetActiveSnapshotImage (nint index)
		{
			if (index < extensionSnapshotImages.Count) {
				extensionActiveSnapshotIndex = index;
			} else {
				extensionActiveSnapshotIndex = null;
			}
			//extensionActiveSnapshotIndex = (index < extensionSnapshotImages.Count) ? index : null;
		}

		public bool IsSelectedSnapshot (string localIdentifier)
		{
			return snapshotImageLocalIdentifiers.Contains(localIdentifier);
		}

		public bool IsActiveSnapshot (string localIdentifier)
		{
			return !string.IsNullOrEmpty(activeSnapshotImageLocalIdentifier) && activeSnapshotImageLocalIdentifier == localIdentifier;
		}

		// override used by action extension
		public bool IsActiveSnapshot (nint index)
		{
			return extensionActiveSnapshotIndex.HasValue && extensionActiveSnapshotIndex.Value == index;
		}

		public void ResetSnapshotImages (bool clearActive = true)
		{
			if (inActionExtension) {
				extensionSnapshotImages = new List<UIImage> ();
			} else {
				snapshotImageLocalIdentifiers = new List<string> ();
			}

			if (clearActive) DeactivateActiveSnapshotImage();
		}

		//*Application: if the asset corresponding to the activeSnapshotImageLocalIdentifier is already in the bugTrap album, that asset
		// will be updated and the function will return nil.  Otherwise a new (duplicate) asset will be created and the function will
		// return the localIdentifier of the newly created asset
		//*Action Extension: this function returns nil
		public Task<string> UpdateActiveSnapshotImage (UIImage updatedShapshot, bool clearActive = false)
		{
			if (inActionExtension) {
				if (extensionActiveSnapshotIndex.HasValue) {
					updateSnapshotImage(updatedShapshot, extensionActiveSnapshotIndex.Value, clearActive);
					return null;
				}
			} else if (!string.IsNullOrEmpty(activeSnapshotImageLocalIdentifier)) {
				return updateSnapshotImage(updatedShapshot, activeSnapshotImageLocalIdentifier, clearActive);
			}
			return null;
		}

		// used by action extension
		void updateSnapshotImage (UIImage updatedSnapshot, nint index, bool clearActive = false)
		{
			if (extensionSnapshotImages.Count > index) extensionSnapshotImages[Convert.ToInt32(index)] = updatedSnapshot;

			if (clearActive) DeactivateActiveSnapshotImage();
		}

		async Task<string> updateSnapshotImage (UIImage updatedSnapshot, string localIdentifier, bool clearActive = false)
		{
			if (clearActive) DeactivateActiveSnapshotImage();

			var newId = await Photos.UpdateAsset(updatedSnapshot, localIdentifier);

			if (newId != null) {
				
				var index = snapshotImageLocalIdentifiers.IndexOf(localIdentifier);

				snapshotImageLocalIdentifiers.Remove(localIdentifier);

				if (index >= 0) {
					snapshotImageLocalIdentifiers.Insert(index, newId);
				} else {
					snapshotImageLocalIdentifiers.Add(newId);
				}

				if (!clearActive) activeSnapshotImageLocalIdentifier = newId;
			}

			return newId;
		}

		public async Task<List<NSData>> GetImageDataForSnapshots ()
		{
			return inActionExtension ? extensionSnapshotImages.Select(i => i.AsJPEG(1)).ToList() : 
				await Photos.GetImageDataForLocalIdentifiers(snapshotImageLocalIdentifiers);
		}

		public async Task DeleteAssets (List<PHAsset> assets)
		{
			if (assets.IsEmpty()) return;

			// check if the snapshot the user is currently annotating is in the list
			if (!string.IsNullOrEmpty(activeSnapshotImageLocalIdentifier)) {
				if (assets.Any(a => a.LocalIdentifier == activeSnapshotImageLocalIdentifier)) {
					DeactivateActiveSnapshotImage();
				}
			}

			await Photos.DeleteAssets(assets);
		}

		public Task<string> GetAlbumLocalIdentifier ()
		{
			return Photos.GetAlbumLocalIdentifier();
		}
	}
}