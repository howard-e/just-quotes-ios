//
//  QuoteCategoryViewController.swift
//  Just Quotes
//
//  Created by Howard Edwards on 5/24/18.
//  Copyright © 2018 Heed. All rights reserved.
//

import UIKit

class QuoteCategoryViewController: UIViewController {

	@IBOutlet weak var quotesTableView: UITableView!
	
	var category: QuoteCategory!
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setUpNavigationBar()
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setUp()
    }
	
	func setUp() {
		if let category = category {
			// Trigger REST call to get quote categories
			switch category {
			case .famous:
				break
			case .movies:
				break
			case .random:
				break
			}
		}
	}
}
