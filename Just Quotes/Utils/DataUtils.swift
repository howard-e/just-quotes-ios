//
//  DataUtils.swift
//  Just Quotes
//
//  Created by Howard Edwards on 5/18/18.
//  Copyright © 2018 Heed. All rights reserved.
//

import UIKit

import SwiftyJSON
import Alamofire
import RealmSwift
import SwiftEventBus

// MARK :- Properties
let httpManager = HttpManager.shared

var realm: Realm!


// MARK :- REST API Methods
func getQuoteOfTheDay(controller: UIViewController) {
	let resourceUrl = URLs.FORISMATIC_BASE_API
	let params: Parameters = [
		"method": "getQuote",
		"lang": "en",
		"format": "json"
	]
	logRequestInfo(#function, resourceUrl, requestParams: params)
	
	showActivityIndicator(true)
	httpManager.get(url: resourceUrl, parameters: params) { response in
		showActivityIndicator(false)
		print("\(#function) REQUEST URL: \(response.response?.url?.absoluteString ?? "")")
		
		if let responseData = response.result.value {
			print("\(#function) RESPONSE URL: \(responseData)")
			realm = try! Realm()
			
			let quote = JSON(responseData)["quoteText"].stringValue
			let author = JSON(responseData)["quoteAuthor"].stringValue
			
			let qotd = quoteOfTheDayInit(id: "qotd", quote: quote, author: author, imgUrl: "", lastUpdate: Date())
			try! realm.write {
				realm.add(qotd, update: true)
			}
			
			SwiftEventBus.post(EventBusParms.quoteOfTheDay)
		} else {
			SwiftEventBus.post(EventBusParms.quoteOfTheDay)
			
			if let error = (response.error as NSError?) {
				switch error.code {
				case -1009:
					controller.alert(message: "Unable to Continue. Please reconnect and try again.", title: "Internet Connection Required")
					break
				default:
					controller.alert(message: "Something went wrong. Please try again.", title: "Error")
					break
				}
			}
		}
	}
}

func getQuote(controller: UIViewController, category: QuoteCategory) {
	let resourceUrl = URLs.MASHABLE_BASE_API
	var params: Parameters = [
		"count": 8
	]
	
	if category == .random {
		// Do nothing
	} else {
		params["cat"] = category.rawValue.lowercased()
	}
	
	let headers = [
		"Accept": "application/json",
		"X-Mashape-Key": "kCrcMSEo6xmsh66rCsfWuFgZs6fJp1Oj52wjsnk8v5dmGa0FTH"
	]
	logRequestInfo(#function, resourceUrl, requestParams: params, headers: headers)
	
	showActivityIndicator(true)
	httpManager.get(url: resourceUrl, parameters: params, additionalHeaders: headers) { response in
		showActivityIndicator(false)
		print("\(#function) REQUEST URL: \(response.response?.url?.absoluteString ?? "")")
		
		if let responseData = response.result.value {
			print("\(#function) RESPONSE DATA: \(responseData)")
			realm = try! Realm()
			
			for qt in JSON(responseData).arrayValue {
				if let quote = qt.dictionary {
					let quoteString = quote["quote"]?.stringValue ?? ""
					let author = quote["author"]?.stringValue ?? ""
					let category = quote["category"]?.stringValue ?? ""
					
					let quoteItem = quoteInit(quote: quoteString, author: author, category: category)
					try! realm.write {
						realm.add(quoteItem, update: true)
					}
				}
			}
			
			SwiftEventBus.post(EventBusParms.quote)
		} else {
			SwiftEventBus.post(EventBusParms.quote)
			
			if let error = (response.error as NSError?) {
				switch error.code {
				case -1009:
					controller.alert(message: "Unable to Continue. Please reconnect and try again.", title: "Internet Connection Required")
					break
				default:
					controller.alert(message: "Something went wrong. Please try again.", title: "Error")
					break
				}
			}
		}
	}
}


func logRequestInfo(_ requestTitle: String, _ requestUrl: String, requestParams: [String: Any]? = nil, headers: HTTPHeaders? = nil) {
	print("======= \(requestTitle) =======")
	print("requestUrl: \(requestUrl)")
	if requestParams != nil {
		print("requestParams: \(requestParams ?? [:])")
	}
	if headers != nil {
		print("headers: \(headers ?? [:])")
	}
	print("==============")
}


// MARK :- Realm Model Initializers
func quoteOfTheDayInit(id: String, quote: String, author: String, imgUrl: String, lastUpdate: Date) -> QuoteOfTheDay {
	return QuoteOfTheDay(value: ["id": id, "quote": quote, "author": author, "imgUrl": imgUrl, "lastUpdate": lastUpdate])
}

func quoteInit(quote: String, author: String, category: String) -> Quote {
	return Quote(value: ["quote": quote, "author": author, "category": category])
}
