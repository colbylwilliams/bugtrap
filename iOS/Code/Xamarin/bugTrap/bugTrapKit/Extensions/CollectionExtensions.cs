using System;
using System.Collections.Generic;

namespace bugTrapKit
{
	public static class CollectionExtensions
	{
		public static bool IsEmpty<T> (this List<T> list)
		{
			return list == null || list.Count <= 0;
		}

		public static T NIndexer<T> (this List<T> list, nint index)
		{
			return list[Convert.ToInt32(index)];
		}

		public static nint NCount<T> (this List<T> list)
		{
			return (nint)list.Count;
		}

	}
}