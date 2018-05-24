//
//  QuoteCategoryTableViewCell.swift
//  Just Quotes
//
//  Created by Howard Edwards on 5/24/18.
//  Copyright © 2018 Heed. All rights reserved.
//

import UIKit

class QuoteCategoryTableViewCell: UITableViewCell {

	@IBOutlet weak var cellBackgroundView: UIView!
	@IBOutlet weak var backgroundImageView: UIImageView!
	@IBOutlet weak var dividerView: UIView!
	
	@IBOutlet weak var quoteTextLabel: UILabel!
	@IBOutlet weak var quoteAuthorLabel: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
		
		cellBackgroundView.backgroundColor = .random()
	}
}
