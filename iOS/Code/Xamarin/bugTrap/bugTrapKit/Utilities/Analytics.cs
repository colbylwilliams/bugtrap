using System;

namespace bugTrapKit
{
	public class Analytics
	{
		static readonly Analytics shared = new Analytics ();

		public static Analytics Shared { get; } = new Analytics ();

		public bool InActionExtension { get; set; }

		// bool contextSet;

		string context { 
			get { return InActionExtension ? "Action Extension" : "Application"; }
		}

		public void ScreenView (string screenName)
		{
			
		}

		public void IssueSent (uint trackerIndex, string trackerName)
		{
			
		}

		public void TrackerLogin (string trackerName)
		{
			
		}

		public void Activity (string activityType, bool completed)
		{
			
		}

		public void LogError (string description, bool fatal = false)
		{
			
		}
	}

	static class GAIEventCategory
	{
		public static string Tracker = "Tracker";
		public static string Activity = "Activity";
	}

	static class GAIEventAction
	{
		public static string Login = "Login";
		public static string SubmitIssue = "Submit Issue";
		public static string Completed = "Completed";
		public static string Cancelled = "Cancelled";
	}

}