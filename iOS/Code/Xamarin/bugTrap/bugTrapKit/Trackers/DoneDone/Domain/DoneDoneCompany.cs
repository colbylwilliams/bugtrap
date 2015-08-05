using System.Collections.Generic;

namespace bugTrapKit.DoneDone
{

	public class DoneDoneCompany : DoneDoneSimpleItem
	{
		public int NumberOfActiveUsers { get; set; }

		public List<DoneDonePerson> People { get; set; }
	}
}