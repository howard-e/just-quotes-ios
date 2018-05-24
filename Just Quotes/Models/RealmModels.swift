//
//  RealmModels.swift
//  Just Quotes
//
//  Created by Howard Edwards on 5/24/18.
//  Copyright © 2018 Heed. All rights reserved.
//

import Foundation
import RealmSwift

class QuoteOfTheDay: Object {
	
	@objc dynamic var id = ""
	@objc dynamic var quote = ""
	@objc dynamic var author = ""
	@objc dynamic var imgUrl = ""
	@objc dynamic var lastUpdate = Date()
	
	override static func primaryKey() -> String? {
		return "id"
	}
}

class Quote: Object {
	
	@objc dynamic var quote = ""
	@objc dynamic var author = ""
	@objc dynamic var category = ""
	
	override static func primaryKey() -> String? {
		return "quote" // Using the same API will yield the same quotes
	}
}
