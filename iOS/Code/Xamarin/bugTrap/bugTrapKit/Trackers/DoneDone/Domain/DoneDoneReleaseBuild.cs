using System;
using System.Collections.Generic;

namespace bugTrapKit.DoneDone
{

	public class DoneDoneReleaseBuild : DoneDoneSimpleItem
	{
		public DateTime CreatedOn { get; set; }

		public string Description { get; set; }

		public string RelativeUrl { get; set; }

		public List<int> OrderNumbers { get; set; }
	}
}