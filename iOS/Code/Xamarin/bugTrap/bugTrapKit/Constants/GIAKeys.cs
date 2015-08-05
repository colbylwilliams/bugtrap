namespace bugTrapKit
{
	public static class GAIKeys
	{
		#if DEBUG
		public static string TrackingID = "UA-56018703-2";
		#else
		public static string TrackingID = "UA-56018703-3";
		#endif

		public static class ScreenNames
		{
			public static string AnnotateSnapshot = "Annotate Snapshot";
			public static string SelectSnapshot = "Select Snapshot";
			public static string EditSnapshots = "Edit Snapshots";
			public static string AddSnapshots = "Add Snapshots";
			public static string TrackerAccounts = "Tracker Accounts ({0})";
			public static string BugDetails = "Bug Details";
			public static string BugDetailsSelect = "Bug Details Select";
		}
	}
}