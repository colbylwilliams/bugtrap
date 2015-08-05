using System;

namespace bugTrapKit
{
	public interface ITrackerDetailType<TDetail>
		where TDetail : struct, IConvertible, IFormattable
	{
		bool IsPersonDetail ();

		string SettingsKey ();
	}
}