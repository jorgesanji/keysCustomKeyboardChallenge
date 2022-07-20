//
//  StyleSheet.swift
//  keyboard
//
//  Created by Jorge Sanmartin on 19/07/22.
//

import UIKit

enum StyleSheet {
	
	public enum Paddings {
		
		/// 2pt
		public static var xxs: CGFloat { 2 }
		
		/// 5.3pt
		public static var xs: CGFloat { 16.0 / 3.0 }
		
		/// 8pt
		public static var s: CGFloat { 16.0 / 2.0 }
		
		/// 16pt
		public static var n: CGFloat { 16.0 }
		
		/// 24pt
		public static var l: CGFloat { 16.0 * 1.5 }
		
		/// 32pt
		public static var xl: CGFloat { 16.0 * 2.0 }
		
		/// 48pt
		public static var xxl: CGFloat { 16.0 * 3.0 }
		
		/// 20pt
		public static var spacing: CGFloat { 20 }
	}
	
	public enum Styles {
		
		/// 6pt
		public static var cornerRadius: CGFloat { 6 }
		
		/// 10pt
		public static var blurRadius: CGFloat { 10 }

		/// 3pt
		public static var opacity: CGFloat { 0.3 }
		
	}
	
	public enum Measures {
	
		/// 200pf
		public static var minHeight: CGFloat { 200 }

	}

}
