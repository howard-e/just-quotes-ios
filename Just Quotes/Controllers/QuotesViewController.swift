//
//  QuotesViewController.swift
//  Just Quotes
//
//  Created by Howard Edwards on 5/18/18.
//  Copyright © 2018 Heed. All rights reserved.
//

import UIKit
import BTNavigationDropdownMenu

class QuotesViewController: UIViewController {
	
	@IBOutlet weak var quoteOfTheDayContainer: UIView!
	@IBOutlet weak var quoteOfTheDayQuote: UILabel!
	@IBOutlet weak var quoteOfTheDayAuthor: UILabel!
	
	let menuItems = ["Quote of the Day", "Famous", "Movies", "Random"]
	
	var categoryToSegueWith: QuoteCategory!
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setUpNavigationBar()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setUp()
	}
	
	func setUp() {
		// Menu Customizations
		let menuView = BTNavigationDropdownMenu(title: BTTitle.index(0), items: menuItems)
		self.navigationItem.titleView = menuView
		
		menuView.menuTitleColor = .white
		menuView.shouldChangeTitleText = false
		menuView.didSelectItemAtIndexHandler = { (indexPath: Int) -> () in
			print("Did select item at index: \(indexPath)")
			
			switch indexPath {
			case 1: // Famous
				self.categoryToSegueWith = .famous
				break
			case 2: // Movies
				self.categoryToSegueWith = .movies
				break
			case 3: // Random
				self.categoryToSegueWith = .random
				break
			default:
				break
			}
			
			if self.categoryToSegueWith != nil { // In case of default condition
				self.performSegue(withIdentifier: SegueIdentifiers.toQuoteCategory, sender: nil)
			}
		}
		
		// QOTD Customizations
		quoteOfTheDayContainer.roundEdges()
		quoteOfTheDayContainer.elevate()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let destination = segue.destination as? QuoteCategoryViewController {
			destination.category = self.categoryToSegueWith
		}
	}
}

