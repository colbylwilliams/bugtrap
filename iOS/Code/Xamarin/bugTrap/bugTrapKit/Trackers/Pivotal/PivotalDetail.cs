namespace bugTrapKit.Pivotal
{
	public enum PivotalDetail
	{
		Images,
		Project,
		Name,
		Description,
		StoryType,
		Deadline,
		Owners,
		Labels,
		Followers
	}

	public static class PivotalDetailExtensions
	{
		public static string SettingsKey (this PivotalDetail detail)
		{
			switch (detail) {
			case PivotalDetail.Images:
				return "PivotalDetailImages";
			case PivotalDetail.Project:
				return "PivotalDetailProject";
			case PivotalDetail.Name:
				return "PivotalDetailName";
			case PivotalDetail.Description:
				return "PivotalDetailDescription";
			case PivotalDetail.StoryType:
				return "PivotalDetailStoryType";
			case PivotalDetail.Deadline:
				return "PivotalDetailDeadline";
			case PivotalDetail.Owners:
				return "PivotalDetailOwners";
			case PivotalDetail.Labels:
				return "PivotalDetailLabels";
			case PivotalDetail.Followers:
				return "PivotalDetailFollowers";
			default:
				return null;
			}
		}

		public static bool IsPersonDetail (this PivotalDetail detail)
		{
			switch (detail) {
			case PivotalDetail.Owners:
			case PivotalDetail.Followers:
				return true;
			default:
				return false;
			}
		}
	}
}