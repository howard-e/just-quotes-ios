//
//  QuotesViewController.swift
//  Just Quotes
//
//  Created by Howard Edwards on 5/18/18.
//  Copyright © 2018 Heed. All rights reserved.
//

import UIKit
import BTNavigationDropdownMenu
import SwiftEventBus
import RealmSwift

class QuotesViewController: UIViewController {
	
	@IBOutlet weak var containerScrollView: UIScrollView!
	@IBOutlet weak var quoteOfTheDayContainer: UIView!
	@IBOutlet weak var quoteOfTheDayQuoteLabel: UILabel!
	@IBOutlet weak var quoteOfTheDayAuthorLabel: UILabel!
	
	let refreshControl = UIRefreshControl()
	let menuItems = ["Quote Of The Day", "Famous", "Movies", "Random"]
	
	var categoryToSegueWith: QuoteCategory!
	var realm: Realm!
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setUpNavigationBar()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setUp()
	}
	
	func setUp() {
		realm = try! Realm()
		
		// Refresh Control Setup
		let attributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.foregroundColor: UIColor.white]
		self.refreshControl.attributedTitle = NSAttributedString(string: "Getting the latest Quote Of The Day", attributes: attributes)
		self.refreshControl.addTarget(self, action: #selector(reloadInformation), for: .valueChanged)
		self.containerScrollView.refreshControl = refreshControl
		
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
		
		// Data Loading
		SwiftEventBus.onMainThread(self, name: EventBusParms.stopRefresh) { result in
			self.refreshControl.stopRefresh()
		}
		
		SwiftEventBus.onMainThread(self, name: EventBusParms.quoteOfTheDay) { result in
			self.setQuoteOfTheDay()
			self.refreshControl.stopRefresh()
		}
		
		setQuoteOfTheDay()
	}
	
	func setQuoteOfTheDay() {
		let qotdCollection = realm.objects(QuoteOfTheDay.self)
		if qotdCollection.count > 0 { // If QOTD exists, inflate it in the container
			let qotd = qotdCollection[0]
			self.quoteOfTheDayQuoteLabel.text = qotd.quote
			self.quoteOfTheDayAuthorLabel.text = "- \(qotd.author)"
			
			// Also check if it's a new day since quote was last saved; pull a new quote if it is
			let originalQuoteDate = qotd.lastUpdate
			let currentDate = Date()
			
			let calendar = Calendar(identifier: .gregorian)
			let dateCheck = calendar.compare(originalQuoteDate, to: currentDate, toGranularity: .day)
			switch dateCheck {
			case .orderedAscending: // Get new QOTD
				print("ascending (current quote date is in the past)")
				self.refreshControl.startRefresh()
				getQuoteOfTheDay(controller: self)
				break
			case .orderedDescending: // Get new QOTD
				print("descending (current quote date is in the future .. somehow 🤔)")
				self.refreshControl.startRefresh()
				getQuoteOfTheDay(controller: self)
				break
			case .orderedSame: // Leave current QOTD
				print("same")
				self.refreshControl.stopRefresh()
				break
			}
		} else { // Get first QOTD
			self.refreshControl.startRefresh()
			getQuoteOfTheDay(controller: self)
		}
		
		self.refreshControl.stopRefresh()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let destination = segue.destination as? QuoteCategoryViewController {
			destination.category = self.categoryToSegueWith 
		}
	}
	
	@objc func reloadInformation() {
		setQuoteOfTheDay()
	}
}

