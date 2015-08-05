using System;
using System.Threading.Tasks;
using UIKit;
using Photos;
using Foundation;
using System.Collections.Generic;

namespace bugTrapKit
{
	public class Photos
	{
		string albumLocalIdentifier;

		// this function will check if the asset corresponding to the localIdentifier passed in is already in the bugTrap album.
		// If it is, it will update the existing asset and return nil in the callback, otherwise, a new (duplicate) will be created
		// and the localIdentifier of the newly created asset will be returned by the callback

		public async Task<string> UpdateAsset (UIImage updatedSnapshot, string localIdentifier)
		{
			var tcs = new TaskCompletionSource<string> ();

			var collectionLocalIdentifier = await GetAlbumLocalIdentifier();

			if (string.IsNullOrEmpty(collectionLocalIdentifier)) return null;

			// get the bugTrap album
			var bugTrapAlbum = PHAssetCollection.FetchAssetCollections(new [] { collectionLocalIdentifier }, null)?.firstObject as PHAssetCollection;
			if (bugTrapAlbum != null) {

				// get the asset for the localIdentifier
				var asset = PHAsset.FetchAssetsUsingLocalIdentifiers(new [] { localIdentifier }, null)?.firstObject as PHAsset;
				if (asset != null) {

					// get all the albums containing this asset
					var containingAssetResults = PHAssetCollection.FetchAssetCollections(asset, PHAssetCollectionType.Album, null);
					if (containingAssetResults != null) {
						
						// check if any of the albums is the bugTrap album.  if the asset is already in the bugTrap album, update the existing asset.
						if (containingAssetResults.Contains(bugTrapAlbum)) {

							// retrieve a PHContentEditingInput object
							asset.RequestContentEditingInput(null, async (input, info) => 

								PHPhotoLibrary.SharedPhotoLibrary.PerformChanges(() => {
								
								var editAssetOutput = new PHContentEditingOutput (input);
								editAssetOutput.AdjustmentData = new PHAdjustmentData ("io.bugtrap.bugTrap", "1.0.0", NSData.FromString("io.bugtrap.bugTrap"));
								
								var editAssetJpegData = updatedSnapshot.AsJPEG(1);
								editAssetJpegData.Save(editAssetOutput.RenderedContentUrl, true);

								var editAssetRequest = PHAssetChangeRequest.ChangeRequest(asset);
								editAssetRequest.ContentEditingOutput = editAssetOutput;

							}, (success, error) => {

								if (success) {

									if (!tcs.TrySetResult(null)) {
										var ex = new Exception ("UpdateAsset Failed");
										tcs.TrySetException(ex);
										// Log.Error(ex);
									}

								} else if (error != null) {
									// Log.Error("Photos", error);
									if (!tcs.TrySetResult(null)) {
										var ex = new Exception (error.LocalizedDescription);
										tcs.TrySetException(ex);
										// Log.Error(ex);
									}
								}
							}));
									
						} else {// if the asset isn't in the bugTrap album, create a new asset and put it in the album, and leave the original unchanged

							string newLocalIdentifier = null;

							PHPhotoLibrary.SharedPhotoLibrary.PerformChanges(() => {

								// create a new asset from the UIImage updatedSnapshot
								var createAssetRequest = PHAssetChangeRequest.FromImage(updatedSnapshot);

								// create a request to make changes to the bugTrap album
								var collectionRequest = PHAssetCollectionChangeRequest.ChangeRequest(bugTrapAlbum);

								// get a reference to the new localIdentifier
								newLocalIdentifier = createAssetRequest.PlaceholderForCreatedAsset.LocalIdentifier;

								// add the newly created asset to the bugTrap album
								collectionRequest.AddAssets(new [] { createAssetRequest.PlaceholderForCreatedAsset });

							}, (success, error) => {

								if (success) {

									if (!tcs.TrySetResult(newLocalIdentifier)) {
										var ex = new Exception ("UpdateAsset Failed");
										tcs.TrySetException(ex);
										// Log.Error(ex);
									}

								} else if (error != null) {
									// Log.Error("Photos", error);
									if (!tcs.TrySetResult(null)) {
										var ex = new Exception (error.LocalizedDescription);
										tcs.TrySetException(ex);
										// Log.Error(ex);
									}
								}
							});
						}
					}
				}
			} else { // couldn't find the bugTrap album - user probably deleted it while the app was open

				albumLocalIdentifier = null;

				var identifier = await createAlbumAndSaveLocalIdentifier();

				if (!string.IsNullOrEmpty(identifier)) return await UpdateAsset(updatedSnapshot, localIdentifier);

				if (!tcs.TrySetResult(null)) {
					var ex = new Exception ("UpdateAsset Failed");
					tcs.TrySetException(ex);
					// Log.Error(ex);
				}
			}

			return await tcs.Task;
		}


		public Task<List<NSData>> GetImageDataForLocalIdentifiers (List<string> localIdentifiers)
		{
			var tcs = new TaskCompletionSource<List<NSData>> ();

			var returnImageData = new List<NSData> ();

			PHPhotoLibrary.RequestAuthorization(status => {

				if (status == PHAuthorizationStatus.Authorized) {

					var assetResults = PHAsset.FetchAssetsUsingLocalIdentifiers(localIdentifiers.ToArray(), null);
//					if (assetResults != null) {
					assetResults?.Enumerate((NSObject obj, nuint idx, out bool stop) => {//async (obj, idx, stop) => {
						stop = false;

						var asset = obj as PHAsset;
						if (asset != null) {

							/*var dataRequest = */
							PHImageManager.DefaultManager.RequestImageData(asset, null, (data, dataUti, orientation, info) => {

								returnImageData.Add(data);

								if (idx == Convert.ToUInt32(assetResults.Count - 1)) {

									if (!tcs.TrySetResult(returnImageData)) {
										var ex = new Exception ("GetImageForLocalIdentifier Failed");
										tcs.TrySetException(ex);
										// Log.Error(ex);
									}
								}
							});
						}
					});
//					}
				} else {
					var ex = new Exception ("Unauthorized");
					tcs.TrySetException(ex);
					// Log.Error(ex);
				}
			});

			return tcs.Task;
		}


		// static TaskCompletionSource<UIImage> tcsGetImageForLocalIdentifier;

		public Task<UIImage> GetImageForLocalIdentifier (string localIdentifier)
		{
			// tcsGetImageForLocalIdentifier = new TaskCompletionSource<UIImage> ();

			// if (tcsGetImageForLocalIdentifier == null || (int)tcsGetImageForLocalIdentifier.Task.Status >= 5) {
			// tcsGetImageForLocalIdentifier = new TaskCompletionSource<UIImage> ();
			// } else if ((int)tcsGetImageForLocalIdentifier.Task.Status <= 4) {
			// return tcsGetImageForLocalIdentifier.Task;
			// }

			var tcs = new TaskCompletionSource<UIImage> ();

			PHPhotoLibrary.RequestAuthorization(status => {
			
				if (status == PHAuthorizationStatus.Authorized) {
				
					var asset = PHAsset.FetchAssetsUsingLocalIdentifiers(new [] { localIdentifier }, null)?.firstObject as PHAsset;
					if (asset != null) {

						/*var dataRequest = */
						PHImageManager.DefaultManager.RequestImageData(asset, null, (data, dataUti, orientation, info) => {

							if (!tcs.TrySetResult(new UIImage (data))) {
								var ex = new Exception ("GetImageForLocalIdentifier Failed");
								tcs.TrySetException(ex);
								// Log.Error(ex);
							}
						});
					}
				} else {
					var ex = new Exception ("Unauthorized");
					tcs.TrySetException(ex);
					// Log.Error(ex);
				}
			});

			return tcs.Task;
		}



		public Task<bool> DeleteAssets (List<PHAsset> assets)
		{
			var tcs = new TaskCompletionSource<bool> ();

			if (assets.IsEmpty()) tcs.TrySetResult(false);

			PHPhotoLibrary.RequestAuthorization(status => {

				if (status == PHAuthorizationStatus.Authorized) {

					PHPhotoLibrary.SharedPhotoLibrary.PerformChanges(() => 

						PHAssetChangeRequest.DeleteAssets(assets.ToArray()), (success, error) => {
						
						if (!tcs.TrySetResult(success)) {
							var ex = new Exception ("DeleteAssets Failed");
							tcs.TrySetException(ex);
							// Log.Error(ex);
						}
					});
					
				} else {
					var ex = new Exception ("Unauthorized");
					tcs.TrySetException(ex);
					// Log.Error(ex);
				}
			});

			return tcs.Task;
		}



		static TaskCompletionSource<string> albumLocalIdTcs;

		public Task<string> GetAlbumLocalIdentifier ()
		{
			if (albumLocalIdTcs == null || (int)albumLocalIdTcs.Task.Status >= 5) {
				albumLocalIdTcs = new TaskCompletionSource<string> ();
			} else if ((int)albumLocalIdTcs.Task.Status <= 4) {
				return albumLocalIdTcs.Task;
			}

			PHPhotoLibrary.RequestAuthorization(async status => {
			
				if (status == PHAuthorizationStatus.Authorized) {

					if (!string.IsNullOrEmpty(albumLocalIdentifier)) {
						
						albumLocalIdTcs.TrySetResult(albumLocalIdentifier);

					} else {

						var keychain = new Keychain<TrapAlbum> (new TrapAlbum ());
						var values = keychain.GetStoredKeyValues();

						var identifier = values.ContainsKey(DataKeys.LocalIdentifier) ? values[DataKeys.LocalIdentifier] : null;
						if (identifier != null) {

							// ensure the album with that localIdentifier is there
							var collection = PHAssetCollection.FetchAssetCollections(new [] { identifier }, null)?.firstObject as PHAssetCollection;
							if (collection != null) {
									
								albumLocalIdentifier = identifier;

								if (!albumLocalIdTcs.TrySetResult(identifier)) {
									var ex = new Exception ("GetAlbumLocalIdentifier Failed");
									albumLocalIdTcs.TrySetException(ex);
									// Log.Error(ex);
								}
							} else {
								if (!albumLocalIdTcs.TrySetResult(await createAlbumAndSaveLocalIdentifier())) {
									var ex = new Exception ("GetAlbumLocalIdentifier Failed");
									albumLocalIdTcs.TrySetException(ex);
									// Log.Error(ex);
								}
							}
						} else {
							if (!albumLocalIdTcs.TrySetResult(await createAlbumAndSaveLocalIdentifier())) {
								var ex = new Exception ("GetAlbumLocalIdentifier Failed");
								albumLocalIdTcs.TrySetException(ex);
								// Log.Error(ex);
							}
						}
					}
				} else {
					var ex = new Exception ("Unauthorized");
					albumLocalIdTcs.TrySetException(ex);
					// Log.Error(ex);
				}
			});

			return albumLocalIdTcs.Task;
		}



		Task<string> createAlbumAndSaveLocalIdentifier ()
		{
			var tcs = new TaskCompletionSource<string> ();

			string collectionLocalIdentifier = null;

			PHPhotoLibrary.SharedPhotoLibrary.PerformChanges(() => {

				var request = PHAssetCollectionChangeRequest.CreateAssetCollection("bugTrap");

				collectionLocalIdentifier = request.PlaceholderForCreatedAssetCollection.LocalIdentifier;
			
			}, (success, error) => {

				if (success && !string.IsNullOrEmpty(collectionLocalIdentifier)) {

					var keychain = new Keychain<TrapAlbum> (new TrapAlbum ());

					// ensure the album with that localIdentifier is 
					var collectionResult = PHAssetCollection.FetchAssetCollections(new [] { collectionLocalIdentifier }, null);
					if (collectionResult != null) {

						var collection = collectionResult.firstObject as PHAssetCollection;
						if (collection != null) {

							albumLocalIdentifier = collectionLocalIdentifier;

							if (!tcs.TrySetResult(albumLocalIdentifier)) {
								var ex = new Exception ("createAlbumAndSaveLocalIdentifier Failed");
								tcs.TrySetException(ex);
								// Log.Error(ex);
							}

							keychain.StoreKeyValues(new Dictionary<DataKeys, string> {
								{ DataKeys.LocalIdentifier, albumLocalIdentifier }
							});
						}
					} else {
						var ex = new Exception ("createAlbumAndSaveLocalIdentifier Failed");
						tcs.TrySetException(ex);
						// Log.Error(ex);
					}
				} else {
					var ex = new Exception ("createAlbumAndSaveLocalIdentifier Failed");
					tcs.TrySetException(ex);
					// Log.Error(ex);
				}
			});

			return tcs.Task;
		}
	}

	public class TrapAlbum
	{
		
	}
}