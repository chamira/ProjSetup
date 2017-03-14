//
//  String+Util.swift
//  AppProject
//
//  Created by Chamira Fernando on 23/01/2017.
//  Copyright © 2017 Chamira Fernando. All rights reserved.
//

import Foundation


//MARK: - Helper
extension String {
	
	var length:Int {
		return self.characters.count
	}
	
	func index(from: Int) -> Index {
		return self.index(startIndex, offsetBy: from)
	}
	
	func substring(from: Int) -> String {
		let fromIndex = index(from: from)
		return substring(from: fromIndex)
	}
	
	func substring(to: Int) -> String {
		let toIndex = index(from: to)
		return substring(to: toIndex)
	}
	
	func substring(with r: Range<Int>) -> String {
		let startIndex = index(from: r.lowerBound)
		let endIndex = index(from: r.upperBound)
		return substring(with: startIndex..<endIndex)
	}
	
	
	var localized:String {
		return NSLocalizedString(self, comment: "*not specified*")
	}
	
	var isEmailAddress:Bool {
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
		let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
		return emailTest.evaluate(with: self)
	}
	
}
