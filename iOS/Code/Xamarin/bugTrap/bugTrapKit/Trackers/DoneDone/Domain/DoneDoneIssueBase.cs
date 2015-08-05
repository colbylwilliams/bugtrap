using System;

namespace bugTrapKit.DoneDone
{

	public class DoneDoneIssueBase : DoneDoneSimpleItem
	{
		public int OrderNumber { get; set; }

		// public SimpleItem Project { get; set; }

		public DoneDoneProject Project { get; set; }

		public DateTime? DueDate { get; set; }

		public DateTime CreatedOn { get; set; }

		public DoneDoneSimpleItem Status { get; set; }

		public DoneDoneSimpleItem Tester { get; set; }

		public DoneDoneSimpleItem Fixer { get; set; }

		public DoneDoneSimpleItem Priority { get; set; }

		#region Helper

		public bool HasProject {
			get {
				return Project != null && Project.Id > 0;
			}
		}

		public bool HasStatus {
			get {
				return Status != null && Status.Id > 0;
			}
		}

		public bool HasTester {
			get {
				return Tester != null && Tester.Id > 0;
			}
		}

		public bool HasFixer {
			get {
				return Fixer != null && Fixer.Id > 0;
			}
		}

		public bool HasPriority {
			get {
				return Priority != null && Priority.Id > 0;
			}
		}

		public bool HasDueDate {
			get {
				return DueDate.HasValue;
			}
		}

		#endregion
	}
}