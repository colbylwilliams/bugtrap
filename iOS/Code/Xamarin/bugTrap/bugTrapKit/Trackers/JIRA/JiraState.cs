using System;
using System.Collections.Generic;

namespace bugTrapKit.Jira
{
	public class JiraState : ITrackerState
	{
		public JiraState ()
		{
		}

		#region ITrackerState implementation

		public void Reset ()
		{
			throw new NotImplementedException ();
		}

		public void SortActiveBugDetailValues ()
		{
			throw new NotImplementedException ();
		}

		public string GetValueForDetail (int detailIndex)
		{
			throw new NotImplementedException ();
		}

		public BugCellTypes GetActiveCellType ()
		{
			throw new NotImplementedException ();
		}

		public int GetCountForActiveBugDetail ()
		{
			throw new NotImplementedException ();
		}

		public Dictionary<DataKeys, string> GetActiveTitleDetail ()
		{
			throw new NotImplementedException ();
		}

		public CellData GetActiveCellDetails (int selectedIndex)
		{
			throw new NotImplementedException ();
		}

		public string ActiveBugDetailTitle {
			get {
				throw new NotImplementedException ();
			}
		}

		public int ActiveBugDetail {
			get {
				throw new NotImplementedException ();
			}
			set {
				throw new NotImplementedException ();
			}
		}

		public bool IsActiveTopLevelDetail {
			get {
				throw new NotImplementedException ();
			}
		}

		Dictionary<int, BugDetails.DetailType> trackerDetails;

		public Dictionary<int, BugDetails.DetailType> TrackerDetails {
			get {
				if (trackerDetails == null)
					trackerDetails = new Dictionary<int, BugDetails.DetailType> {
						{ (int)JiraDetail.Images, BugDetails.DetailType.Images },
						{ (int)JiraDetail.Project, BugDetails.DetailType.Selection },
						{ (int)JiraDetail.Summary, BugDetails.DetailType.TextField },
						{ (int)JiraDetail.IssueType, BugDetails.DetailType.Selection },
						{ (int)JiraDetail.Description, BugDetails.DetailType.TextView },
						{ (int)JiraDetail.Priority, BugDetails.DetailType.Selection },
						{ (int)JiraDetail.Assignee, BugDetails.DetailType.Selection }
						// { (int)JiraDetail.DueDate, BugDetails.DetailType.
						// { (int)JiraDetail.Environment, BugDetails.DetailType.
						// { (int)JiraDetail.FixVersions, BugDetails.DetailType.
						// { (int)JiraDetail.Versions, BugDetails.DetailType.
						// { (int)JiraDetail.Labels, BugDetails.DetailType.
					};

				return trackerDetails;
			}
		}

		public CellData GetTrackerDetailCell (int detailIndex, bool populateValue)
		{
			throw new NotImplementedException ();
		}

		public List<CellData> TrackerDetailCells {
			get {
				throw new NotImplementedException ();
			}
		}

		//		public int TrackerSections {
		//			get {
		//				throw new NotImplementedException ();
		//			}
		//		}

		public bool HasProject {
			get {
				throw new NotImplementedException ();
			}
		}

		public string BugTitle {
			get {
				throw new NotImplementedException ();
			}
			set {
				throw new NotImplementedException ();
			}
		}

		public string BugDescription {
			get {
				throw new NotImplementedException ();
			}
			set {
				throw new NotImplementedException ();
			}
		}

		public DateTime? BugDueDate {
			get {
				throw new NotImplementedException ();
			}
			set {
				throw new NotImplementedException ();
			}
		}

		public bool IsValid {
			get {
				throw new NotImplementedException ();
			}
		}

		#endregion
	}
}

