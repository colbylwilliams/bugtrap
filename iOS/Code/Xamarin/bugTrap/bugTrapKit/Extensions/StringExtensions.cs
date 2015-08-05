using System;

namespace bugTrapKit
{
	public static class StringExtensions
	{
		const string dFormat = "{0}{1}";

		public static string doubleString (this string str)
		{
			return string.Format(dFormat, str, str);
		}
	}
}