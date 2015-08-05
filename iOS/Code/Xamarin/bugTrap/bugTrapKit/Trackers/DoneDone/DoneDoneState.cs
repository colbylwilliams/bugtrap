using System;
using System.Collections.Generic;
using System.Linq;

namespace bugTrapKit.DoneDone
{
	public class DoneDoneState : ITrackerState
	{
		public DoneDoneState ()
		{
		}

		public Keychain<TrackerType> Keychain { get; set; }

		public bool Authenticated { get; set; }

		public List<DoneDoneProject> Projects = new List<DoneDoneProject> ();

		public DoneDoneIssue NewIssue = new DoneDoneIssue ();

		public List<DoneDoneSimpleItem> PriorityLevels = new List<DoneDoneSimpleItem> ();

		public List<DoneDonePerson> ProjectPeople = new List<DoneDonePerson> ();

		DoneDoneDetail activeDetail = DoneDoneDetail.Project;

		public int ActiveBugDetail {
			get { return (int)activeDetail; }
			set { activeDetail = (DoneDoneDetail)value; }
		}



		#region ITrackerState implementation

		public void Reset ()
		{
			NewIssue = new DoneDoneIssue ();
			if (Projects.Count == 1) SetProjectByIndex(0);
		}


		public void SortActiveBugDetailValues ()
		{
//			switch ActiveDoneDoneDetail {
//			case .Images, .Title, .Description, .DueDate:
//				break
//			case .Project:
//				Projects = sorted(Projects, { $0.value < $1.value })
//			case .Priority:
//				PriorityLevels = sorted(PriorityLevels, { $0.id < $1.id })
//			case .Fixer, .Tester, .Notify:
//				ProjectPeople = sorted(ProjectPeople, { $0.value < $1.value })
//			case .Tags:
//				NewIssue.project.tags = sorted(NewIssue.project.tags, { $0.value < $1.value })
//			}
		}

		public string GetValueForDetail (int detailIndex)
		{
			var detail = (DoneDoneDetail)detailIndex;

			switch (detail) {
			case DoneDoneDetail.Images:
				return string.Empty;
			case DoneDoneDetail.Project:
				return NewIssue.Project.Value;
			case DoneDoneDetail.Title:
				return NewIssue.Value;
			case DoneDoneDetail.Description:
				return NewIssue.Description;
			case DoneDoneDetail.Priority:
				return NewIssue.Priority.Value;
			case DoneDoneDetail.Fixer:
				return NewIssue.Fixer.Value;
			case DoneDoneDetail.Tester:
				return NewIssue.Tester.Value;
			case DoneDoneDetail.DueDate:
				return NewIssue.DueDate != null ? NewIssue.DueDate.Value.ToString() : string.Empty;
			case DoneDoneDetail.Tags:
				return NewIssue.Tags.IsEmpty() ? "none" : string.Format("{0}{1}", NewIssue.Tags.Count, (NewIssue.Tags.Count > 1 ? "tags" : "tag")); //$"{NewIssue.Tags.Count}{(NewIssue.Tags.Count > 1 ? "tags" : "tag")}";
			case DoneDoneDetail.Notify:
				return NewIssue.CCdUsers.IsEmpty() ? "none" : NewIssue.CCdUsers.Count > 1 ? string.Format("{0} people", NewIssue.Tags.Count) : NewIssue.CCdUsers[0].Value; // $"{NewIssue.Tags.Count} people" : NewIs s ue.CCdUsers[0].Value;
			default:
				return string.Empty;
			}
		}


		//		Dictionary<int, BugDetails.DetailType> trackerDetails;
		//
		//		public Dictionary<int, BugDetails.DetailType> TrackerDetails {
		//			get {
		//				if (trackerDetails == null)
		//					trackerDetails = new Dictionary<int, BugDetails.DetailType> {
		//						{ (int)DoneDoneDetail.Images, BugDetails.DetailType.Images },
		//						{ (int)DoneDoneDetail.Project, BugDetails.DetailType.Selection },
		//						{ (int)DoneDoneDetail.Title, BugDetails.DetailType.TextField },
		//						{ (int)DoneDoneDetail.Description, BugDetails.DetailType.TextView },
		//						{ (int)DoneDoneDetail.Priority, BugDetails.DetailType.Selection },
		//						{ (int)DoneDoneDetail.Fixer, BugDetails.DetailType.Selection },
		//						{ (int)DoneDoneDetail.Tester, BugDetails.DetailType.Selection },
		//						{ (int)DoneDoneDetail.DueDate, BugDetails.DetailType.DateDisplay },
		//						{ (int)DoneDoneDetail.Tags, BugDetails.DetailType.Selection },
		//						{ (int)DoneDoneDetail.Notify, BugDetails.DetailType.Selection }
		//					};
		//
		//				return trackerDetails;
		//			}
		//		}

		public CellData GetTrackerDetailCell (int detailIndex, bool populateValue)
		{
			var cellData = TrackerDetailCells[detailIndex];

			if (populateValue) cellData.Set(DataKeys.Detail, GetValueForDetail(detailIndex));

			return cellData;
		}


		List<CellData> trackerDetailCells;

		public List<CellData> TrackerDetailCells {
			get {
				if (trackerDetailCells == null) {
					
					trackerDetailCells = new List<CellData> ();

					foreach (DoneDoneDetail item in Enum.GetValues(typeof(DoneDoneDetail))) {
						trackerDetailCells.Add(getCellDataForDetail(item));
					}
				}
				return trackerDetailCells;
			}
		}


		static CellData getCellDataForDetail (DoneDoneDetail detail)
		{
			var cellData = new CellData ();

			switch (detail) {
			case DoneDoneDetail.Images:
				cellData.BugDetailType = BugDetails.DetailType.Images;
				break;
			case DoneDoneDetail.Project:
				cellData.BugDetailType = BugDetails.DetailType.Selection;
				cellData.Set(DataKeys.Auxiliary, "Project *");
				cellData.Set(DataKeys.Title, "Project");
				break;
			case DoneDoneDetail.Title:
				cellData.BugDetailType = BugDetails.DetailType.TextField;
				cellData.Set(DataKeys.Auxiliary, "Title of Issue *");
				cellData.Set(DataKeys.Title, "Title");
				break;
			case DoneDoneDetail.Description:
				cellData.BugDetailType = BugDetails.DetailType.TextView;
				cellData.Set(DataKeys.Auxiliary, "Description of Issue *");
				cellData.Set(DataKeys.Title, "Description");
				break;
			case DoneDoneDetail.Priority:
				cellData.BugDetailType = BugDetails.DetailType.Selection;
				cellData.Set(DataKeys.Auxiliary, "Priority *");
				cellData.Set(DataKeys.Title, "Priority");
				break;
			case DoneDoneDetail.Fixer:
				cellData.BugDetailType = BugDetails.DetailType.Selection;
				cellData.Set(DataKeys.Auxiliary, "Who Will Fix the Issue?");
				cellData.Set(DataKeys.Title, "Fixer");
				break;
			case DoneDoneDetail.Tester:
				cellData.BugDetailType = BugDetails.DetailType.Selection;
				cellData.Set(DataKeys.Auxiliary, "Who Will Verify the Fix?");
				cellData.Set(DataKeys.Title, "Tester");
				break;
			case DoneDoneDetail.DueDate:
				cellData.BugDetailType = BugDetails.DetailType.DateDisplay;
				cellData.Set(DataKeys.Auxiliary, "Due Date");
				cellData.Set(DataKeys.Title, "Due Date");
				break;
			case DoneDoneDetail.Tags:
				cellData.BugDetailType = BugDetails.DetailType.Selection;
				cellData.Set(DataKeys.Auxiliary, "Tags");
				cellData.Set(DataKeys.Title, "Tags");
				break;
			case DoneDoneDetail.Notify:
				cellData.BugDetailType = BugDetails.DetailType.Selection;
				cellData.Set(DataKeys.Auxiliary, "Notify People of Updates");
				cellData.Set(DataKeys.Title, "Notify");
				break;
			}

			// cellData.Set(DataKeys.Detail, GetValueForDetail(detailIndex));

			return cellData;
		}


		public BugCellTypes GetActiveCellType ()
		{
			throw new NotImplementedException ();
		}

		public int GetCountForActiveBugDetail ()
		{
			switch (ActiveDoneDoneDetail) {
			case DoneDoneDetail.Project:
				return Projects.Count;
			case DoneDoneDetail.Priority:
				return PriorityLevels.Count;
			case DoneDoneDetail.Tags:
				return NewIssue.Project.Tags.Count;
			case DoneDoneDetail.Fixer:
			case DoneDoneDetail.Tester:
			case DoneDoneDetail.Notify:
				return ProjectPeople.Count;
			default:
				return 0;
			}
		}

		public Dictionary<DataKeys, string> GetActiveTitleDetail ()
		{
			var dict = new Dictionary<DataKeys, string> ();

			switch (ActiveDoneDoneDetail) {
			case DoneDoneDetail.Fixer:
			case DoneDoneDetail.Tester:
			case DoneDoneDetail.Notify:
				if (NewIssue.Project.Id <= 0) {
					dict[DataKeys.Title] = "No People";
					dict[DataKeys.Detail] = "Make sure you have a Project selected";
				}
				break;
			case DoneDoneDetail.Tags:
				if (NewIssue.Project.Id <= 0) {
					dict[DataKeys.Title] = "No Tags";
					dict[DataKeys.Detail] = "Make sure you have a Project selected";
				} else if (NewIssue.Project.Tags.IsEmpty()) {
					dict[DataKeys.Title] = "No Tags";
					dict[DataKeys.Detail] = "The selected Project doesn\'t have any Tags";
				}
				break;

			//case Images:
			//case Project:
			//case Title:
			//case Description:
			//case Priority:
			//case DueDate:
			default:
				break;
			}

			return dict;
		}

		public CellData GetActiveCellDetails (int selectedIndex)
		{
			var fixer = ActiveDoneDoneDetail.IsPersonDetail() && NewIssue.Fixer.Id == ProjectPeople[selectedIndex].Id;
			var tester = ActiveDoneDoneDetail.IsPersonDetail() && NewIssue.Tester.Id == ProjectPeople[selectedIndex].Id;
			var ccdUser = ActiveDoneDoneDetail.IsPersonDetail() && NewIssue.CCdUsers.Contains(ProjectPeople[selectedIndex]);

			var cellData = new CellData ();

			switch (ActiveDoneDoneDetail) {

			case DoneDoneDetail.Project:
				cellData.Set(DataKeys.Title, Projects[selectedIndex].Value);
				cellData.Selected = Projects[selectedIndex].Id == NewIssue.Project.Id;
				break;
			case DoneDoneDetail.Priority:
				cellData.Set(DataKeys.Title, PriorityLevels[selectedIndex].Value);
				cellData.Selected = PriorityLevels[selectedIndex].Id == NewIssue.Priority.Id;
				break;
			case DoneDoneDetail.Fixer:
				var personFixer = ProjectPeople[selectedIndex];
				cellData.CellType = BugCellTypes.Person;
				cellData.Set(DataKeys.Title, personFixer.FullName);
				cellData.Set(DataKeys.Detail, !fixer ? tester ? "(tester)" : ccdUser ? "(CCd)" : "" : "");
				cellData.Set(DataKeys.Auxiliary, personFixer.Initials);
				cellData.Set(DataKeys.ImageUrl, personFixer.AvatarUrl);
				cellData.Selected = fixer;
				break;
			case DoneDoneDetail.Tester:
				var personTester = ProjectPeople[selectedIndex];
				cellData.CellType = BugCellTypes.Person;
				cellData.Set(DataKeys.Title, personTester.FullName);
				cellData.Set(DataKeys.Detail, !tester ? fixer ? "(fixer)" : ccdUser ? "(CCd)" : "" : "");
				cellData.Set(DataKeys.Auxiliary, personTester.Initials);
				cellData.Set(DataKeys.ImageUrl, personTester.AvatarUrl);
				cellData.Selected = tester;
				break;
			case DoneDoneDetail.Notify:
				var personNotify = ProjectPeople[selectedIndex];
				cellData.CellType = BugCellTypes.Person;
				cellData.Set(DataKeys.Title, personNotify.FullName);
				cellData.Set(DataKeys.Detail, fixer ? "(fixer)" : tester ? "(tester)" : "");
				cellData.Set(DataKeys.Auxiliary, personNotify.Initials);
				cellData.Set(DataKeys.ImageUrl, personNotify.AvatarUrl);
				cellData.Selected = ccdUser;
				break;
			case DoneDoneDetail.Tags:
				cellData.Set(DataKeys.Title, NewIssue.Project.Tags[selectedIndex].Value);
				cellData.Set(DataKeys.Detail, string.Format("({0})", NewIssue.Project.Tags[selectedIndex].NumberOfIssues));// "(\(String(NewIssue.Project.Tags[selectedIndex].NumberOfIssues)))");
				cellData.Selected = NewIssue.Tags.Contains(NewIssue.Project.Tags[selectedIndex]);
				break;
			default:
				break;
			}

			return cellData;
		}


		public string ActiveBugDetailTitle {
			get {
				switch (ActiveDoneDoneDetail) {
				case DoneDoneDetail.Images:
					return string.Empty;
				case DoneDoneDetail.Project:
					return "Project";
				case DoneDoneDetail.Title:
					return string.Empty;
				case DoneDoneDetail.Description:
					return string.Empty;
				case DoneDoneDetail.Priority:
					return "Priority Level";
				case DoneDoneDetail.Fixer:
					return "Fixer";
				case DoneDoneDetail.Tester:
					return "Tester";
				case DoneDoneDetail.DueDate:
					return string.Empty;
				case DoneDoneDetail.Tags:
					return "Tags";
				case DoneDoneDetail.Notify:
					return "Watchers";
				default:
					return string.Empty;
				}
			}
		}

		public DoneDoneDetail ActiveDoneDoneDetail {
			get { return (DoneDoneDetail)ActiveBugDetail; }
		}

		public bool IsActiveTopLevelDetail {
			get { return ActiveDoneDoneDetail == DoneDoneDetail.Project; }
		}


		//		public int TrackerSections {
		//			get { return TrackerDetails.Count; }
		//		}

		public bool HasProject {
			get { return NewIssue.Project.Id > 0; }
		}

		public string BugTitle {
			get { return NewIssue.Value; }
			set { NewIssue.Title = value; }
		}

		public string BugDescription {
			get { return NewIssue.Description; }
			set { NewIssue.Description = value; }
		}

		public DateTime? BugDueDate {
			get { return NewIssue.DueDate; }
			set { NewIssue.DueDate = value; }
		}

		public bool IsValid {
			get { return NewIssue.Valid; }
		}

		#endregion


		public DoneDoneProject SetProjectByIndex (int projectIndex)
		{
			var project = Projects[projectIndex];

			if (NewIssue.Project.Id != project.Id) {
				NewIssue.Project = project;
				return project;
			}

			return null;
		}
	}
}