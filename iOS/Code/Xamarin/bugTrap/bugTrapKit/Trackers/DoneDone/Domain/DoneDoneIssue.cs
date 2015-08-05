using System.Collections.Generic;
using System;
using System.Linq;

namespace bugTrapKit.DoneDone
{

	public class DoneDoneIssue : DoneDoneIssueBase
	{
		public DoneDoneIssue ()
		{
			CCdUsers = new List<DoneDoneSimpleItem> ();
			// CCdUsers = new List<Person>();
			Attachments = new List<DoneDoneAttachment> ();
			Histories = new List<DoneDoneHistory> ();
			Tags = new List<DoneDoneTag> ();
		}

		public string Description { get; set; }

		public DoneDoneSimpleItem Creator { get; set; }

		public List<DoneDoneSimpleItem> CCdUsers { get; set; }

		// public List<Person> CCdUsers { get; set; }

		public List<DoneDoneAttachment> Attachments { get; set; }

		public List<DoneDoneHistory> Histories { get; set; }

		public List<DoneDoneTag> Tags { get; set; }

		// Ignore
		public bool Valid {
			get {
				return HasValue && HasPriority && HasFixer && HasTester;
			}
		}

		#region Helper

		public string DueDateString {
			get {
				return HasDueDate ? DueDate.Value.ToString ("MMMM d, yyyy") : string.Empty;
			}
		}

		public string DaysUntilDue {
			get {

				if (!HasDueDate)
					return "No Due Date";

				var span = DueDate.Value.Date.Subtract (DateTime.Now.Date).Days;

				return span < 2 ? span == 0 ? "Today" : "Tomorrow" : string.Format ("({0} days)", span);
			}
		}

		public bool HasDescription {
			get {
				return !string.IsNullOrEmpty (Description);
			}
		}

		public bool HasCreator {
			get {
				return Creator != null && Creator.Id > 0;
			}
		}

		public bool HasCCdUsers {
			get {
				return CCdUsers != null && CCdUsers.Count > 0;
			}
		}

		public string CCdUsersString {
			get {
				return HasCCdUsers ? string.Join (", ", CCdUsers.Select (t => t.Value)) : string.Empty;
			}
		}


		public bool HasAttachments {
			get {
				return Attachments != null && Attachments.Count > 0;
			}
		}

		public bool HasHistories {
			get {
				return Histories != null && Histories.Count > 0;
			}
		}

		public bool HasTags {
			get {
				return Tags != null && Tags.Count > 0;
			}
		}

		public string TagsString {
			get {
				return HasTags ? string.Join (", ", Tags.Select (t => t.Value)) : string.Empty;
			}
		}

		#endregion
	}
}