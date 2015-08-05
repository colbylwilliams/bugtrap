using System;

namespace bugTrapKit.Pivotal
{
	public class PivotalTracker : TrackerInstance<PivotalState, PivotalProxy>
	{
		public PivotalTracker (TrackerType trackerType) : base(trackerType)
		{
		}
	}
}

