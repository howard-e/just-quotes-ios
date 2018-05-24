//
//  QuoteCategoryViewController.swift
//  Just Quotes
//
//  Created by Howard Edwards on 5/24/18.
//  Copyright © 2018 Heed. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftEventBus

class QuoteCategoryViewController: UIViewController {

	@IBOutlet weak var quotesTableView: UITableView!
	
	let refreshControl = UIRefreshControl()
	
	var quotesData = [Quote?]()
	
	var category: QuoteCategory!
	var realm: Realm!
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setUpNavigationBar()
		
		if let category = category {
			autoSizeTitle(largeTitle: false, title: category.rawValue)
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setUp()
    }
	
	func setUp() {
		realm = try! Realm()
		
		// Refresh Control Setup
		let attributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.foregroundColor: UIColor.white]
		self.refreshControl.attributedTitle = NSAttributedString(string: "Getting the latest quotes", attributes: attributes)
		self.refreshControl.addTarget(self, action: #selector(reloadInformation), for: .valueChanged)
		self.quotesTableView.refreshControl = refreshControl
		
		// Category Setup
		if let category = category {
			// Trigger REST call to get quote categories
			self.refreshControl.beginRefreshing()
			getQuote(controller: self, category: category)
		}
		
		// Setup TableView
		let nib = UINib(nibName: XibCells.quoteCategoryCell, bundle: nil)
		quotesTableView.register(nib, forCellReuseIdentifier: CellIdentifiers.quoteCategoryCell)
		
		self.quotesTableView.delegate = self
		self.quotesTableView.dataSource = self
		self.quotesTableView.rowHeight = 200
		self.quotesTableView.estimatedRowHeight = 200
		
		// Data Loading
		SwiftEventBus.onMainThread(self, name: EventBusParms.quote) { result in
			self.quotesData.removeAll()
			self.quotesTableView.reloadData()
			
			let realmQuotesData = self.category == .random ? self.realm.objects(Quote.self).shuffled() : self.realm.objects(Quote.self).filter("category == '\(self.category.rawValue)'").shuffled()
			if realmQuotesData.count > 0 {
				for i in 0..<8 { // No built-in realm query limiter; why dataset has to be [Quote?]
					self.quotesData.append(realmQuotesData[i])
				}
			}
			
			self.quotesTableView.reloadData()
			self.refreshControl.endRefreshing()
			
			if self.quotesData.count == 0 {
				// TODO: Show empty collection view error
			}
		}
	}
	
	@objc func reloadInformation() {
		getQuote(controller: self, category: category)
	}
}


// MARK :- UITableViewDataSource Methods

extension QuoteCategoryViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return quotesData.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let row = indexPath.row
		let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.quoteCategoryCell, for: indexPath) as! QuoteCategoryTableViewCell
		
		let quote = quotesData[row]
		
		if let quote = quote {
			cell.quoteTextLabel.text = quote.quote
			cell.quoteAuthorLabel.text = "- \(quote.author)"
		}
		
		return cell
	}
}


// MARK :- UITableViewDelegate Methods

extension QuoteCategoryViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
}
