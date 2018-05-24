//
//  ActivityIndicator.swift
//  Just Quotes
//
//  Created by Howard Edwards on 5/18/18.
//  Copyright © 2018 Heed. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ActivityIndicator: UIViewController, NVActivityIndicatorViewable {
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	func showActivityIndicator() {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		NVActivityIndicatorView.DEFAULT_TYPE = .ballSpinFadeLoader
		startAnimating()
	}
	
	func hideActivityIndicator() {
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
			UIApplication.shared.isNetworkActivityIndicatorVisible = false
			self.stopAnimating()
		}
	}
}
