using System;
using UIKit;

namespace bugTrapKit
{
	public static class Annotate
	{
	
		public enum Tool
		{
			Callout,
			Marker,
			Arrow,
			Circle,
			Square,
			Color
		}


		public enum Color
		{
			Red,
			Orange,
			Green,
			Blue,
			White,
			Black
		}


		public static UIImage image (this Tool tool, Color color)
		{
			switch (tool) {
			case Tool.Callout:
				return UIImage.FromBundle("i_tool_annotation");
			case Tool.Marker:
				return UIImage.FromBundle("i_tool_marker");
			case Tool.Arrow:
				return UIImage.FromBundle("i_tool_arrow");
			case Tool.Circle:
				return UIImage.FromBundle("i_tool_circle");
			case Tool.Square:
				return UIImage.FromBundle("i_tool_square");
			case Tool.Color:
				return color.colorImage();
			default:
				return null;
			}
		}


		public static UIImage imageOn (this Tool tool, Color color)
		{
			switch (tool) {
			case Tool.Callout:
				return UIImage.FromBundle("i_tool_annotation_on");
			case Tool.Marker:
				return UIImage.FromBundle("i_tool_marker_on");
			case Tool.Arrow:
				return UIImage.FromBundle("i_tool_arrow_on");
			case Tool.Circle:
				return UIImage.FromBundle("i_tool_circle_on");
			case Tool.Square:
				return UIImage.FromBundle("i_tool_square_on");
			case Tool.Color:
				return color.colorImage();
			default:
				return null;
			}
		}


		static UIImage colorImage (this Color color)
		{
			switch (color) {
			case Color.Red:
				return UIImage.FromBundle("i_tool_color_red").ImageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal);
			case Color.Orange:
				return UIImage.FromBundle("i_tool_color_orange").ImageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal);
			case Color.Green:
				return UIImage.FromBundle("i_tool_color_green").ImageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal);
			case Color.Blue:
				return UIImage.FromBundle("i_tool_color_blue").ImageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal);
			case Color.White:
				return UIImage.FromBundle("i_tool_color_white").ImageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal);
			case Color.Black:
				return UIImage.FromBundle("i_tool_color_black").ImageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal);
			default:
				return null;
			}
		}


		public static UIColor color (this Color color)
		{
			switch (color) {
			case Color.Red:
				return UIColor.Red;
			case Color.Orange:
				return UIColor.Orange;
			case Color.Green:
				return UIColor.Green;
			case Color.Blue:
				return UIColor.Blue;
			case Color.White:
				return UIColor.White;
			case Color.Black:
				return UIColor.Black;
			default:
				return null;
			}
		}
	}
}

