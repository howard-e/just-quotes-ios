//
//  Constants.swift
//  Just Quotes
//
//  Created by Howard Edwards on 5/18/18.
//  Copyright © 2018 Heed. All rights reserved.
//

import Foundation

struct URLs {
	static let FORISMATIC_BASE_API = "http://api.forismatic.com/api/1.0/"
	static let MASHABLE_BASE_API = "https://andruxnet-random-famous-quotes.p.mashape.com/"
}

struct Constants {
	static let mashapeTestKey = "kCrcMSEo6xmsh66rCsfWuFgZs6fJp1Oj52wjsnk8v5dmGa0FTH"
	static let serverTimeout = 15.0
}

struct ControllerIdentifiers {
}

struct CellIdentifiers {
	static let quoteCategoryCell = "QuoteCategoryTableViewCell"
}

struct XibCells {
	static let quoteCategoryCell = "QuoteCategoryTableViewCell"
}

struct SegueIdentifiers {
	static let toQuoteCategory = "goToQuoteCategory"
}

struct UserDefaultsKeys {
}

struct EventBusParms {
	static let quoteOfTheDay = "quote_of_the_day"
	static let quote = "quote"
}

struct Colors {
	static let colorPrimary = "#000000"
	static let colorAccent = "#9E9E9E"
	static let colorSecondary = "#3b3b3b"
	
	static let darkBackground = "#565651"
	static let bordersGrey = "#ADADAC"
	static let backgroundGrey = "#DFE3E6"
	static let lightGrey = "#9A9A9A"
	
	static let formBackgroundColor = "#F0EFF5"
}
