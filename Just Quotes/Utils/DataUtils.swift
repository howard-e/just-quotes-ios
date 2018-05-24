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

// MARK :- Properties
let httpManager = HttpManager.shared


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
		
		if let responseData = response.result.value {
			print("\(#function): \(responseData)")
		} else {
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
