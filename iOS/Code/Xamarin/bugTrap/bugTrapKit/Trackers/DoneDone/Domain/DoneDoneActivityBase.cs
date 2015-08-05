using System;
using System.Collections.Generic;

namespace bugTrapKit.DoneDone
{

	public class DoneDoneActivityBase
	{
		public DateTime CreatedOn { get; set; }

		public string Description { get; set; }

		public string Action { get; set; }

		public List<DoneDoneAttachment> Attachments { get; set; }
	}
}