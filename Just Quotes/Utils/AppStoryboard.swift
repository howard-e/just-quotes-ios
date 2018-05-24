//
//  AppStoryboard.swift
//  Just Quotes
//
//  Created by Howard Edwards on 5/18/18.
//  Copyright © 2018 Heed. All rights reserved.
//

// USAGE:
// let greenScene = GreenVC.instantiate(fromAppStoryboard: .Main)
// let greenScene = AppStoryboard.Main.viewController(viewControllerClass: GreenVC.self)
// let greenScene = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: GreenVC.storyboardID)

// Reference: https://medium.com/@gurdeep060289/clean-code-for-multiple-storyboards-c64eb679dbf6 & https://gist.github.com/Gurdeep0602/4fc3892c1b2861d4cd2062ddfddf3262

import UIKit

enum AppStoryboard : String {
	
	case LaunchScreen, Main
	
	var instance : UIStoryboard {
		return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
	}
	
	func viewController<T : UIViewController>(viewControllerClass: T.Type, function: String = #function, line: Int = #line, file: String = #file) -> T {
		let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
		guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
			fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
		}
		return scene
	}
	
	func initialViewController() -> UIViewController? {
		return instance.instantiateInitialViewController()
	}
}

extension UIViewController {
	// Not using static as it wont be possible to override to provide custom storyboardID then
	class var storyboardID : String {
		return "\(self)"
	}
	
	static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
		return appStoryboard.viewController(viewControllerClass: self)
	}
}
