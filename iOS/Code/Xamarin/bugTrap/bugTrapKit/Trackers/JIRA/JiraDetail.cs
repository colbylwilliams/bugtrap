namespace bugTrapKit.Jira
{
	public enum JiraDetail
	{
		Images,
		Project,
		IssueType,
		Summary,
		Priority,
		Description,
		Assignee,
		DueDate,
		Environment,
		FixVersions,
		Versions,
		Labels
	}

	public static class JiraDetailExtensions
	{
		public static string SettingsKey (this JiraDetail detail)
		{
			switch (detail) {
			case JiraDetail.Images:
				return "JiraDetailImages";
			case JiraDetail.Project:
				return "JiraDetailProject";
			case JiraDetail.IssueType:
				return "JiraDetailIssueType";
			case JiraDetail.Summary:
				return "JiraDetailSummary";
			case JiraDetail.Priority:
				return "JiraDetailPriority";
			case JiraDetail.Description:
				return "JiraDetailDescription";
			case JiraDetail.Assignee:
				return "JiraDetailAssignee";
			case JiraDetail.DueDate:
				return "JiraDetailDueDate";
			case JiraDetail.Environment:
				return "JiraDetailEnvironment";
			case JiraDetail.FixVersions:
				return "JiraDetailFixVersions";
			case JiraDetail.Versions:
				return "JiraDetailVersions";
			case JiraDetail.Labels:
				return "JiraDetailLabels";
			default:
				return null;
			}
		}

		public static bool IsPersonDetail (this JiraDetail detail)
		{
			switch (detail) {
			case JiraDetail.Assignee:
				return true;
			default:
				return false;
			}
		}
	}
}

