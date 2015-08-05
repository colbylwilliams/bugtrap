using System;
using System.Collections.Generic;

namespace bugTrapKit
{
	public enum TrackerType
	{
		None,
		Assembla,
		Axosoft,
		Basecamp,
		Bitbucket,
		DoneDone,
		FogBugz,
		GitHub,
		JIRA,
		Lighthouse,
		PivotalTracker
	}

	public class TrackerTypes
	{
		public static List<TrackerType> Values = new List<TrackerType> {
			TrackerType.None,
			TrackerType.Assembla,
			TrackerType.Axosoft,
			TrackerType.Basecamp,
			TrackerType.Bitbucket,
			TrackerType.DoneDone,
			TrackerType.FogBugz,
			TrackerType.GitHub,
			TrackerType.JIRA,
			TrackerType.Lighthouse,
			TrackerType.PivotalTracker
		};
	}

	public static class TrackerTypeExtensions
	{
		public static bool Enabled (this TrackerType trackerType)
		{
			return trackerType.Status() == TrackerStatus.Enabled;
		}

		public static bool Valid (this TrackerType trackerType, Dictionary<DataKeys, string> creditials)
		{
			switch (trackerType) {
			case TrackerType.None:
				return false;
			case TrackerType.Assembla:
				return false;
			case TrackerType.Axosoft:
				return false;
			case TrackerType.Basecamp:
				return false;
			case TrackerType.Bitbucket:
				return false;
			case TrackerType.DoneDone:
				return (creditials.ContainsKey(DataKeys.Subdomain) && creditials.ContainsKey(DataKeys.UserName) && creditials.ContainsKey(DataKeys.Password)) &&
				(creditials[DataKeys.Subdomain] != null && creditials[DataKeys.UserName] != null && creditials[DataKeys.Password] != null);
			case TrackerType.FogBugz:
				return false;
			case TrackerType.GitHub:
				return false;
			case TrackerType.JIRA:
				return (creditials.ContainsKey(DataKeys.Server) && creditials.ContainsKey(DataKeys.UserName) && creditials.ContainsKey(DataKeys.Password)) &&
				(creditials[DataKeys.Server] != null && creditials[DataKeys.UserName] != null && creditials[DataKeys.Password] != null);
			case TrackerType.Lighthouse:
				return false;
			case TrackerType.PivotalTracker:
				return (creditials.ContainsKey(DataKeys.Token) || (creditials.ContainsKey(DataKeys.UserName) && creditials.ContainsKey(DataKeys.Password))) &&
				(creditials[DataKeys.Token] != null || (creditials[DataKeys.UserName] != null && creditials[DataKeys.Password] != null));
			default:
				return false;
			}
		}


		public static TrackerStatus Status (this TrackerType trackerType)
		{
			switch (trackerType) {
			case TrackerType.None:
				return TrackerStatus.Disabled;
			case TrackerType.Assembla:
				return TrackerStatus.ComingSoon;
			case TrackerType.Axosoft:
				return TrackerStatus.ComingSoon;
			case TrackerType.Basecamp:
				return TrackerStatus.ComingSoon;
			case TrackerType.Bitbucket:
				return TrackerStatus.ComingSoon;
			case TrackerType.DoneDone:
				return TrackerStatus.Enabled;
			case TrackerType.FogBugz:
				return TrackerStatus.ComingSoon;
			case TrackerType.GitHub:
				return TrackerStatus.ComingSoon;
			case TrackerType.JIRA:
				return TrackerStatus.Enabled;
			case TrackerType.Lighthouse:
				return TrackerStatus.ComingSoon;
			case TrackerType.PivotalTracker:
				return TrackerStatus.Enabled;
			default:
				return TrackerStatus.Disabled;
			}
		}

		public static string SmallImageName (this TrackerType trackerType)
		{
			switch (trackerType) {
			case TrackerType.None:
				return null; // "logo_none";
			case TrackerType.Assembla:
				return null; // "logo_assembla";
			case TrackerType.Axosoft:
				return null; // "logo_axosoft";
			case TrackerType.Basecamp:
				return null; // "logo_basecamp";
			case TrackerType.Bitbucket:
				return null; // "logo_bitbucket";
			case TrackerType.DoneDone:
				return "logo_donedone";
			case TrackerType.FogBugz:
				return null; // "logo_fogbugz";
			case TrackerType.GitHub:
				return null; // "logo_github";
			case TrackerType.JIRA:
				return "logo_jira";
			case TrackerType.Lighthouse:
				return null; // "logo_lighthouse";
			case TrackerType.PivotalTracker:
				return "logo_pivotaltracker";
			default:
				return null;
			}
		}


		public static string ActivityImageName (this TrackerType trackerType)
		{
			switch (trackerType) {
			case TrackerType.None:
				return null; // "logo_activity_none";
			case TrackerType.Assembla:
				return null; // "logo_activity_assembla";
			case TrackerType.Axosoft:
				return null; // "logo_activity_axosoft";
			case TrackerType.Basecamp:
				return null; // "logo_activity_basecamp";
			case TrackerType.Bitbucket:
				return null; // "logo_activity_bitbucket";
			case TrackerType.DoneDone:
				return "logo_activity_donedone";
			case TrackerType.FogBugz:
				return null; // "logo_activity_fogbugz";
			case TrackerType.GitHub:
				return null; // "logo_activity_github";
			case TrackerType.JIRA:
				return "logo_activity_jira";
			case TrackerType.Lighthouse:
				return null; // "logo_activity_lighthouse";
			case TrackerType.PivotalTracker:
				return "logo_activity_pivotaltracker";
			default:
				return null;
			}
		}


		public static string LoginControllerName (this TrackerType trackerType)
		{
			switch (trackerType) {
			case TrackerType.None:
				return null; // "logo_none";
			case TrackerType.Assembla:
				return null; // "logo_assembla";
			case TrackerType.Axosoft:
				return null; // "logo_axosoft";
			case TrackerType.Basecamp:
				return null; // "logo_basecamp";
			case TrackerType.Bitbucket:
				return null; // "logo_bitbucket";
			case TrackerType.DoneDone:
				return "DoneDoneLogin";
			case TrackerType.FogBugz:
				return null; // "logo_fogbugz";
			case TrackerType.GitHub:
				return null; // "logo_github";
			case TrackerType.JIRA:
				return "JiraLogin";
			case TrackerType.Lighthouse:
				return null; // "logo_lighthouse";
			case TrackerType.PivotalTracker:
				return "PivotalTrackerLogin";
			default:
				return null;
			}
		}


		public static string ActivityType (this TrackerType trackerType)
		{
			switch (trackerType) {
			case TrackerType.None:
				return "io.bugtrap.trackers.None";
			case TrackerType.Assembla:
				return "io.bugtrap.trackers.Assembla";
			case TrackerType.Axosoft:
				return "io.bugtrap.trackers.Axosoft";
			case TrackerType.Basecamp:
				return "io.bugtrap.trackers.Basecamp";
			case TrackerType.Bitbucket:
				return "io.bugtrap.trackers.Bitbucket";
			case TrackerType.DoneDone:
				return "io.bugtrap.trackers.DoneDone";
			case TrackerType.FogBugz:
				return "io.bugtrap.trackers.FogBugz";
			case TrackerType.GitHub:
				return "io.bugtrap.trackers.GitHub";
			case TrackerType.JIRA:
				return "io.bugtrap.trackers.JIRA";
			case TrackerType.Lighthouse:
				return "io.bugtrap.trackers.Lighthouse";
			case TrackerType.PivotalTracker:
				return "io.bugtrap.trackers.PivotalTracker";
			default:
				return null;
			}
		}


		public static uint GoogleAnalyticsMetricIndex (this TrackerType trackerType)
		{
			switch (trackerType) {
			case TrackerType.None:
				return 0;
			case TrackerType.Assembla:
				return 10;
			case TrackerType.Axosoft:
				return 1;
			case TrackerType.Basecamp:
				return 2;
			case TrackerType.Bitbucket:
				return 3;
			case TrackerType.DoneDone:
				return 4;
			case TrackerType.FogBugz:
				return 5;
			case TrackerType.GitHub:
				return 6;
			case TrackerType.JIRA:
				return 7;
			case TrackerType.Lighthouse:
				return 8;
			case TrackerType.PivotalTracker:
				return 9;
			default:
				return 0;
			}
		}

	}
}

