using System;
using System.Collections.Generic;

namespace bugTrapKit
{
	public interface ITrackerState
	{
		void Reset ();

		void SortActiveBugDetailValues ();

		string ActiveBugDetailTitle { get; }

		int ActiveBugDetail { get; set; }

		bool IsActiveTopLevelDetail { get; }

		// Dictionary<int, BugDetails.DetailType> TrackerDetails { get; }

		// int TrackerSections { get; }

		bool HasProject { get; }

		string BugTitle { get; set; }

		string BugDescription { get; set; }

		DateTime? BugDueDate { get; set; }

		bool IsValid { get; }

		string GetValueForDetail (int detailIndex);

		List<CellData> TrackerDetailCells { get; }

		CellData GetTrackerDetailCell (int detailIndex, bool populateValue);

		BugCellTypes GetActiveCellType ();

		int GetCountForActiveBugDetail ();

		Dictionary<DataKeys, string> GetActiveTitleDetail ();

		CellData GetActiveCellDetails (int selectedIndex);
	}
}