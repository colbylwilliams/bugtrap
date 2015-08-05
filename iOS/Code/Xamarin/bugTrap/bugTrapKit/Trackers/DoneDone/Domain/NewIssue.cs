namespace bugTrapKit.DoneDone
{

	public class NewIssue
	{
		public string Title { get; set; }

		public string Description { get; set; }

		public string DueDate { get; set; }

		public string Tags { get; set; }

		public string PriorityLevelId { get; set; }

		public string FixerId { get; set; }

		public string TesterId { get; set; }

		public string UserIdsToCc { get; set; }

		public string Attachment { get; set; }
	}
}