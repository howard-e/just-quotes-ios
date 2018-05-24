//
//  Extensions.swift
//  Just Quotes
//
//  Created by Howard Edwards on 5/24/18.
//  Copyright © 2018 Heed. All rights reserved.
//

import UIKit

extension UIViewController {
	// Show simple alert dialog with a title, description and OK button
	func alert(message: String, title: String? = nil, okActionTitle: String? = "OK", customHandler: ((UIAlertAction) -> Swift.Void)? = nil) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let okAction = UIAlertAction(title: okActionTitle, style: .default, handler: customHandler)
		alertController.addAction(okAction)
		self.present(alertController, animated: true, completion: nil)
	}
	
	func autoSizeTitle(largeTitle: Bool, title: String? = nil) {
		if #available(iOS 11.0, *) {
			if largeTitle {
				self.navigationController?.navigationBar.prefersLargeTitles = true
				self.navigationItem.largeTitleDisplayMode = .always
			} else {
				self.navigationController?.navigationBar.prefersLargeTitles = false
			}
		} else {
			// Fallback on earlier versions
		}
		
		if let title = title {
			self.navigationItem.title = title
		}
	}
	
	func setUpNavigationBar() {
		self.navigationController?.navigationBar.barTintColor = UIColor(hexString: Colors.colorPrimary)
		self.navigationController?.navigationBar.isTranslucent = false
		self.navigationController?.navigationBar.tintColor = .white
		
		self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
		if #available(iOS 11.0, *) {
			self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
		} else {
			// Fallback on earlier versions
		}
		
		self.navigationController?.navigationBar.barStyle = .black
	}
	
	func setStatusBarColour(statusBarColour: UIColor? = nil) {
		let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
		UIApplication.shared.statusBarStyle = .lightContent
		statusBar.backgroundColor = statusBarColour != nil ? statusBarColour : .clear
	}
}

extension UIColor {
	convenience init(red: Int, green: Int, blue: Int) {
		assert(red >= 0 && red <= 255, "Invalid red component")
		assert(green >= 0 && green <= 255, "Invalid green component")
		assert(blue >= 0 && blue <= 255, "Invalid blue component")
		
		self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
	}
	
	convenience init(hexString: String) {
		let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
		let scanner = Scanner(string: hexString)
		
		if (hexString.hasPrefix("#")) {
			scanner.scanLocation = 1
		}
		
		var color:UInt32 = 0
		scanner.scanHexInt32(&color)
		
		let mask = 0x000000FF
		let r = Int(color >> 16) & mask
		let g = Int(color >> 8) & mask
		let b = Int(color) & mask
		
		let red   = CGFloat(r) / 255.0
		let green = CGFloat(g) / 255.0
		let blue  = CGFloat(b) / 255.0
		
		self.init(red: red, green: green, blue: blue, alpha: 1)
	}
	
	func toHexString() -> String {
		var r: CGFloat = 0
		var g: CGFloat = 0
		var b: CGFloat = 0
		var a: CGFloat = 0
		
		getRed(&r, green: &g, blue: &b, alpha: &a)
		
		let rgb: Int = (Int)(r*255) << 16 | (Int)(g*255) << 8 | (Int)(b*255) << 0
		
		return String(format:"#%06x", rgb)
	}
}

extension UIView {
	func elevate(elevation: Double = 4.0) {
		self.layer.masksToBounds = false
		self.layer.shadowColor = UIColor.black.cgColor
		self.layer.shadowOffset = CGSize(width: 0, height: elevation)
		self.layer.shadowRadius = abs(CGFloat(elevation))
		self.layer.shadowOpacity = 0.24
	}
	
	func roundEdges(radius: CGFloat = 4.0) {
		self.layer.masksToBounds = true
		self.layer.cornerRadius = radius
	}
}

extension UITextField {
	func addDoneButtonToKeyboard(myAction: Selector?, showCancel: Bool = false, cancelTitle: String = "", cancelAction: Selector? = nil, actionTitle: String, target: Any) {
		let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
		doneToolbar.barStyle = UIBarStyle.default
		
		let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
		let done: UIBarButtonItem = UIBarButtonItem(title: actionTitle, style: UIBarButtonItemStyle.done, target: target, action: myAction)
		
		var items = [UIBarButtonItem]()
		if showCancel {
			let cancel: UIBarButtonItem = UIBarButtonItem(title: cancelTitle, style: UIBarButtonItemStyle.plain, target: target, action: cancelAction)
			items.append(cancel)
		}
		
		items.append(flexSpace)
		items.append(done)
		
		doneToolbar.items = items
		doneToolbar.sizeToFit()
		
		self.inputAccessoryView = doneToolbar
	}
}

extension UIPageViewController {
	func goToNextPage() {
		guard let currentViewController = self.viewControllers?.first else { return }
		guard let nextViewController = dataSource?.pageViewController( self, viewControllerAfter: currentViewController ) else { return }
		setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
	}
	
	func goToPreviousPage() {
		guard let currentViewController = self.viewControllers?.first else { return }
		guard let previousViewController = dataSource?.pageViewController( self, viewControllerBefore: currentViewController ) else { return }
		setViewControllers([previousViewController], direction: .reverse, animated: true, completion: nil)
	}
}

extension Double {
	// Rounds the double to the number of decimal places
	func rounded(toPlaces places: Int) -> Double {
		let divisor = pow(10.0, Double(places))
		return (self * divisor).rounded() / divisor
	}
	
	func getDateStringFromUTC() -> String {
		let date = Date(timeIntervalSince1970: self)
		
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "en_US")
		dateFormatter.dateStyle = .medium
		
		return dateFormatter.string(from: date)
	}
}

extension Date {
	func timeAgoDisplay() -> String {
		let calendar = Calendar.current
		let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
		let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
		let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
		let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
		
		if minuteAgo < self {
			let diff = Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
			return "\(diff) sec\(diff > 1 ? "s" : "") ago"
		} else if hourAgo < self {
			let diff = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
			return "\(diff) min\(diff > 1 ? "s" : "") ago"
		} else if dayAgo < self {
			let diff = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
			return "\(diff) hr\(diff > 1 ? "s" : "") ago"
		} else if weekAgo < self {
			let diff = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
			return "\(diff) day\(diff > 1 ? "s" : "") ago"
		}
		let diff = Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear ?? 0
		return "\(diff) week\(diff > 1 ? "s" : "") ago"
	}
}

extension MutableCollection {
	/// Shuffles the contents of this collection.
	mutating func shuffle() {
		let c = count
		guard c > 1 else { return }
		
		for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
			let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
			let i = index(firstUnshuffled, offsetBy: d)
			swapAt(firstUnshuffled, i)
		}
	}
}

extension Sequence {
	/// Returns an array with the contents of this sequence, shuffled.
	func shuffled() -> [Element] {
		var result = Array(self)
		result.shuffle()
		return result
	}
}

extension UIImage {
	/// Represents a scaling mode
	enum ScalingMode {
		case aspectFill
		case aspectFit
		
		/// Calculates the aspect ratio between two sizes
		///
		/// - parameters:
		///     - size:      the first size used to calculate the ratio
		///     - otherSize: the second size used to calculate the ratio
		///
		/// - returns: the aspect ratio between the two sizes
		func aspectRatio(between size: CGSize, and otherSize: CGSize) -> CGFloat {
			let aspectWidth  = size.width/otherSize.width
			let aspectHeight = size.height/otherSize.height
			
			switch self {
			case .aspectFill:
				return max(aspectWidth, aspectHeight)
			case .aspectFit:
				return min(aspectWidth, aspectHeight)
			}
		}
	}
	
	/// Scales an image to fit within a bounds with a size governed by the passed size. Also keeps the aspect ratio.
	///
	/// - parameters:
	///     - newSize:     the size of the bounds the image must fit within.
	///     - scalingMode: the desired scaling mode
	///
	/// - returns: a new scaled image.
	func scaled(to newSize: CGSize, scalingMode: UIImage.ScalingMode = .aspectFill) -> UIImage {
		
		let aspectRatio = scalingMode.aspectRatio(between: newSize, and: size)
		
		/* Build the rectangle representing the area to be drawn */
		var scaledImageRect = CGRect.zero
		
		scaledImageRect.size.width  = size.width * aspectRatio
		scaledImageRect.size.height = size.height * aspectRatio
		scaledImageRect.origin.x    = (newSize.width - size.width * aspectRatio) / 2.0
		scaledImageRect.origin.y    = (newSize.height - size.height * aspectRatio) / 2.0
		
		/* Draw and retrieve the scaled image */
		UIGraphicsBeginImageContext(newSize)
		
		draw(in: scaledImageRect)
		let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
		
		UIGraphicsEndImageContext()
		
		return scaledImage!
	}
}
