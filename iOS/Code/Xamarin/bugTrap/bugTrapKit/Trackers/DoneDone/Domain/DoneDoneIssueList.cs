using System.Collections.Generic;

namespace bugTrapKit.DoneDone
{

	public class DoneDoneIssueList
	{
		public int TotalIssues { get; set; }

		public List<DoneDoneIssueListItem> Issues { get; set; }
	}
}