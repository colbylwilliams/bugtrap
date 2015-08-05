using System.Collections.Generic;

namespace bugTrapKit.DoneDone
{

	public class DoneDoneReleaseBuildInfo : DoneDoneSimpleItem
	{
		public List<int> OrderNumbersReadyForNextRelease { get; set; }
	}
}