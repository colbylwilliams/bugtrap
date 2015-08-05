using System;
using Foundation;
using System.IO;
using UIKit;

using static Foundation.NSUserDefaults;

namespace bugTrapKit
{
	static class SettingsKeys
	{
		public static string VersionNumber = "VersionNumber";
		public static string BuildNumber = "BuildNumber";
		public static string UserReferenceKey = "UserReferenceKey";
		public static string FirstLaunch = "FirstLaunch";
		public static string AnnotateTool = "AnnotateTool";
		public static string AnnotateColor = "AnnotateColor";
	}


	public static class Settings
	{
		#region Utilities

		public static void RegisterDefaultSettings ()
		{
			var path = Path.Combine(NSBundle.MainBundle.PathForResource("Settings", "bundle"), "Root.plist");

			using (NSString keyString = new NSString ("Key"), defaultString = new NSString ("DefaultValue"), preferenceSpecifiers = new NSString ("PreferenceSpecifiers"))
			using (var settings = NSDictionary.FromFile(path))
			using (var preferences = (NSArray)settings.ValueForKey(preferenceSpecifiers))
			using (var registrationDictionary = new NSMutableDictionary ()) {
				for (nuint i = 0; i < preferences.Count; i++)
					using (var prefSpecification = preferences.GetItem<NSDictionary>(i))
					using (var key = (NSString)prefSpecification.ValueForKey(keyString))
						if (key != null)
							using (var def = prefSpecification.ValueForKey(defaultString))
								if (def != null)
									registrationDictionary.SetValueForKey(def, key);

				StandardUserDefaults.RegisterDefaults(registrationDictionary);
				Synchronize();
			}
		}

		public static void Synchronize () => StandardUserDefaults.Synchronize();

		public static void SetSetting (string key, string value) => StandardUserDefaults.SetString(value, key);

		public static void SetSetting (string key, bool value) => StandardUserDefaults.SetBool(value, key);

		public static void SetSetting (string key, int value) => StandardUserDefaults.SetInt(value, key);

		public static int Int32ForKey (string key) => Convert.ToInt32(NSUserDefaults.StandardUserDefaults.IntForKey(key));

		public static bool BoolForKey (string key) => StandardUserDefaults.BoolForKey(key);

		public static string StringForKey (string key) => StandardUserDefaults.StringForKey(key);

		#endregion


		#region About

		public static string VersionNumber => StringForKey(SettingsKeys.VersionNumber);

		public static string BuildNumber => StringForKey(SettingsKeys.BuildNumber);

		public static string VersionBuildString => $"v{VersionNumber} b{BuildNumber}";

		#endregion


		#region Annotation

		public static Annotate.Tool AnnotateTool {
			get {
				return (Annotate.Tool)Int32ForKey(SettingsKeys.AnnotateTool);
			}
			set {
				SetSetting(SettingsKeys.AnnotateTool, (int)value);
			}
		}

		public static Annotate.Color AnnotateColor {
			get {
				return (Annotate.Color)Int32ForKey(SettingsKeys.AnnotateColor);
			}
			set {
				SetSetting(SettingsKeys.AnnotateColor, (int)value);
			}
		}

		#endregion


		#region Config

		public static bool FirstLaunch {
			get {
				// this is actually false if it's the first time the app is launched
				var firstL = !BoolForKey(SettingsKeys.FirstLaunch);

				if (firstL) {
					SetSetting(SettingsKeys.FirstLaunch, true);

					// Give these some good defaults
					AnnotateTool = Annotate.Tool.Marker;
					AnnotateColor = Annotate.Color.Green;
				}

				return firstL;
			}
		}

		#endregion


		#region Reporting

		public static string UserReferenceKey {
			get {
				var key = StringForKey(SettingsKeys.UserReferenceKey);

				if (string.IsNullOrEmpty(key)) {

					#if DEBUG
					key = "DEBUG";
					#else
					key = UIDevice.CurrentDevice.IdentifierForVendor.AsString();
					#endif

					SetSetting(SettingsKeys.UserReferenceKey, key);
				}

				return key;
			}
		}

		#endregion
	}
}