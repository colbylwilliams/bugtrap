using System;

namespace bugTrapKit.DoneDone
{

	public class DoneDoneIssueListItem : DoneDoneIssueBase
	{
		public DateTime LastUpdatedOn { get; set; }

		public DoneDoneSimpleItem LastUpdater { get; set; }

		public DateTime LastViewedOn { get; set; }

		public bool IsPublicIssue { get; set; }
	}
}