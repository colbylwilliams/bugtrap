using System;

namespace bugTrapKit.Jira
{
	public class JiraTracker : TrackerInstance<JiraState, JiraProxy>
	{
		public JiraTracker (TrackerType trackerType) : base(trackerType)
		{
		}
	}
}