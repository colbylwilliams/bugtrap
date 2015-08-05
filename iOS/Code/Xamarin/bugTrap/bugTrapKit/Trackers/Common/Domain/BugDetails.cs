using System;

namespace bugTrapKit
{
	public class BugDetails
	{
		public enum DetailType
		{
			Images,
			Selection,
			TextField,
			TextView,
			DateDisplay,
			DatePicker
		}
	}

	public static class BugDetailsExtensions
	{

		public static string CellId (this BugDetails.DetailType detailType)
		{
			switch (detailType) {
			case BugDetails.DetailType.Images:
				return "BtEmbeddedImageCollectionViewTableViewCell";
			case BugDetails.DetailType.Selection:
				return "BtTitlePlaceholderTableViewCell";
			case BugDetails.DetailType.TextField:
				return "BtTextFieldTableViewCell";
			case BugDetails.DetailType.TextView:
				return "BtTextViewTableViewCell";
			case BugDetails.DetailType.DateDisplay:
				return "BtDateDisplayTableViewCell";
			case BugDetails.DetailType.DatePicker:
				return "BtDatePickerTableViewCell";
			default:
				return null;
			}
		}

		public static nfloat CellHeight (this BugDetails.DetailType detailType)
		{
			switch (detailType) {
			case BugDetails.DetailType.Images:
				return 142;
			case BugDetails.DetailType.Selection:
				return 44;
			case BugDetails.DetailType.TextField:
				return 44;
			case BugDetails.DetailType.TextView:
				return 100;
			case BugDetails.DetailType.DateDisplay:
				return 44;
			case BugDetails.DetailType.DatePicker:
				return 163;
			default:
				return 44;
			}
		}

		public static bool IsDate (this BugDetails.DetailType detailType)
		{
			return detailType == BugDetails.DetailType.DateDisplay || detailType == BugDetails.DetailType.DatePicker;
		}
	}
}