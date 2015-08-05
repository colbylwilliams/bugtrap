using System.Collections.Generic;

namespace bugTrapKit.DoneDone
{

	public class DoneDoneProject : DoneDoneSimpleItem
	{
		public int TotalIssuesInProject { get; set; }

		public bool ReleaseBuildsEnabled { get; set; }

		public List<DoneDoneTag> Tags { get; set; }

		public bool HasTags {
			get {
				return Tags != null && Tags.Count > 0;
			}
		}
	}
}