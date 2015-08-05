using System;
using System.Threading.Tasks;
using System.Collections.Generic;

// usingstatic bugTrapKit.DoneDone.DoneDoneDetail;

namespace bugTrapKit.DoneDone
{
	public class DoneDoneTracker : TrackerInstance<DoneDoneState, DoneDoneProxy>
	{
		public DoneDoneTracker (TrackerType trackerType) : base(trackerType)
		{
		}

		public async override Task PostAuthDataFetch ()
		{
			await LoadProjects();
			await LoadPriorityLevels();
		}

		public async override Task<bool> LoadDataForActiveDetail ()
		{
			var detail = (DoneDoneDetail)State.ActiveBugDetail;

			switch (detail) {
			case DoneDoneDetail.Project:
				if (State.Projects.IsEmpty()) return (await LoadProjects() != null);
				break;
			case DoneDoneDetail.Fixer:
			case DoneDoneDetail.Tester:
			case DoneDoneDetail.Notify:

				if (State.ProjectPeople.IsEmpty()) {
					var projectId = State.NewIssue.Project.Id;
					if (projectId <= 0) return (await LoadPeople(projectId) != null);
				}
				break;
			}

			return false;
		}



		public async Task<List<DoneDoneProject>> LoadProjects () =>
			State.Projects = await Proxy.GetProjects();


		public async Task<List<DoneDoneSimpleItem>> LoadPriorityLevels () =>
			State.PriorityLevels = await Proxy.GetPriorityLevels();


		public async Task<List<DoneDonePerson>> LoadPeople (int projectId) =>
			State.ProjectPeople = await Proxy.GetPeople(projectId);


		public async Task SetProjectByIndex (int index)
		{
			var projectId = State.SetProjectByIndex(index)?.Id ?? 0;
			State.ProjectPeople = await Proxy.GetPeople(projectId);
		}


		public override bool UpdateIssueFromSelection (int selectedIndex)
		{
			var detail = (DoneDoneDetail)State.ActiveBugDetail;

			switch (detail) {
			case DoneDoneDetail.Project:
				SetProjectByIndex(selectedIndex);
				break;
			case DoneDoneDetail.Priority:
				State.NewIssue.Priority = State.PriorityLevels[selectedIndex];
				break;
			case DoneDoneDetail.Fixer:
				State.NewIssue.Fixer = State.ProjectPeople[selectedIndex];
				break;
			case DoneDoneDetail.Tester:
				State.NewIssue.Tester = State.ProjectPeople[selectedIndex];
				break;
			case DoneDoneDetail.Tags:
				var tag = State.NewIssue.Project.Tags[selectedIndex];
				if (!State.NewIssue.Tags.Remove(tag)) State.NewIssue.Tags.Add(tag);
				break;
			case DoneDoneDetail.Notify:
				var person = State.ProjectPeople[selectedIndex];
				if (!State.NewIssue.CCdUsers.Remove(person)) State.NewIssue.CCdUsers.Add(person);
				break;
			}

			return (detail == DoneDoneDetail.Tags || detail == DoneDoneDetail.Notify);
		}



		public async override Task<bool> CreateIssue ()
		{
			var success = (await Proxy.CreateIssueForProject(State.NewIssue) != null);

			if (success) {
				// Analytics.Shared.IssueSent(TrackerType.)
				// Analytics.Shared.issueSent(self.type.googleAnalyticsMetricIndex, trackerName: self.type.rawValue)
				// Analytics.Shared.activity(self.type.activityType, completed: true)
			}

			return success;
		}
	}
}