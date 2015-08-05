using System;
using System.Collections.Generic;

namespace bugTrapKit.Pivotal
{
	public class PivotalState : ITrackerState
	{
		public PivotalState ()
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
						{ (int)PivotalDetail.Images, BugDetails.DetailType.Images },
						{ (int)PivotalDetail.Project, BugDetails.DetailType.Selection },
						{ (int)PivotalDetail.Name, BugDetails.DetailType.TextField },
						{ (int)PivotalDetail.Description, BugDetails.DetailType.TextView },
						{ (int)PivotalDetail.StoryType, BugDetails.DetailType.Selection },
						{ (int)PivotalDetail.Deadline, BugDetails.DetailType.DateDisplay },
						{ (int)PivotalDetail.Owners, BugDetails.DetailType.Selection },
						{ (int)PivotalDetail.Labels, BugDetails.DetailType.Selection },
						{ (int)PivotalDetail.Followers, BugDetails.DetailType.Selection }
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