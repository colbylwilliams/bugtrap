using System;
using UIKit;
using System.Collections.Generic;

namespace bugTrapKit
{
	public class BtTrackerLoginViewController : BtViewController, IUITextFieldDelegate
	{
		public Keychain<TrackerType> Keychain { get; set; }

		public virtual TrackerType TrackerType { get; }

		public BtTrackerLoginViewController (IntPtr handle) : base(handle)
		{
		}

		public override void ViewDidLoad ()
		{
			base.ViewDidLoad();

			ScreenName = string.Format(GAIKeys.ScreenNames.TrackerAccounts, TrackerType);

			Keychain = new Keychain<TrackerType> (TrackerType);

			PopulatePlaceholderLabels(TraitCollection.Contains(UITraitCollection.FromVerticalSizeClass(UIUserInterfaceSizeClass.Compact)));
		}

		public override void TraitCollectionDidChange (UITraitCollection previousTraitCollection)
		{
			if (previousTraitCollection != null) base.TraitCollectionDidChange(previousTraitCollection);

			PopulatePlaceholderLabels(TraitCollection.Contains(UITraitCollection.FromVerticalSizeClass(UIUserInterfaceSizeClass.Compact)));
		}

		public override void ViewWillAppear (bool animated)
		{
			base.ViewWillAppear(animated);

			// get the stored keys for this service type
			var storedKeys = Keychain.GetStoredKeyValues();

			if (storedKeys.Count > 0) {
				// if they exist, allow derived controllers to use the data
				KeychainDataLoaded(storedKeys);
			}
		}

		// override in derived controllers to do something when the stored keychain data is loaded
		public virtual void KeychainDataLoaded (Dictionary<DataKeys, string> storedData)
		{
			throw new NotImplementedException ();
		}

		// override in derived controllers to populate the placeholder property on the Fields,
		// as the labels above the fields will be hidden in landscape on iPhones
		public virtual void PopulatePlaceholderLabels (bool showPlaceholders)
		{
			throw new NotImplementedException ();
		}

		public override bool PrefersStatusBarHidden () => true;
	}
}