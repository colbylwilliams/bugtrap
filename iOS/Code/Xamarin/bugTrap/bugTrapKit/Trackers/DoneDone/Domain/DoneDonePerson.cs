namespace bugTrapKit.DoneDone
{

	public class DoneDonePerson : DoneDoneSimpleItem
	{
		public int CompanyId { get; set; }

		public string CompanyName { get; set; }

		public string FirstName { get; set; }

		public string LastName { get; set; }

		public string ProfileEmail { get; set; }

		public string AccountEmail { get; set; }

		public string MobilePhone { get; set; }

		public string OfficePhone { get; set; }

		public string Fax { get; set; }

		public string AvatarUrl { get; set; }

		public string FullName {
			get {
				Value = string.Format ("{0} {1}", FirstName ?? string.Empty, LastName ?? string.Empty);
				return Value;
			}
		}

		public string Initials {
			get {
				return string.Format ("{0}{1}", !string.IsNullOrEmpty (FirstName) ? char.ToLower (FirstName [0]) : ' ', !string.IsNullOrEmpty (LastName) ? char.ToLower (LastName [0]) : ' ');
			}
		}
	}
}