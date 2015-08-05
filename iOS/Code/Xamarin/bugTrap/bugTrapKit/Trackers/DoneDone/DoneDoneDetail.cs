namespace bugTrapKit.DoneDone
{
	public enum DoneDoneDetail
	{
		Images,
		Project,
		Title,
		Description,
		Priority,
		Fixer,
		Tester,
		DueDate,
		Tags,
		Notify
	}

	public static class DoneDoneDetailExtensions
	{
		public static string SettingsKey (this DoneDoneDetail detail)
		{
			switch (detail) {
			case DoneDoneDetail.Images:
				return "DoneDoneDetailImages";
			case DoneDoneDetail.Project:
				return "DoneDoneDetailProject";
			case DoneDoneDetail.Title:
				return "DoneDoneDetailTitle";
			case DoneDoneDetail.Description:
				return "DoneDoneDetailDescription";
			case DoneDoneDetail.Priority:
				return "DoneDoneDetailPriority";
			case DoneDoneDetail.Fixer:
				return "DoneDoneDetailFixer";
			case DoneDoneDetail.Tester:
				return "DoneDoneDetailTester";
			case DoneDoneDetail.DueDate:
				return "DoneDoneDetailDueDate";
			case DoneDoneDetail.Tags:
				return "DoneDoneDetailTags";
			case DoneDoneDetail.Notify:
				return "DoneDoneDetailNotify";
			default:
				return null;
			}
		}

		public static bool IsPersonDetail (this DoneDoneDetail detail)
		{
			switch (detail) {
			case DoneDoneDetail.Fixer:
			case DoneDoneDetail.Tester:
			case DoneDoneDetail.Notify:
				return true;
			default:
				return false;
			}
		}
	}
}