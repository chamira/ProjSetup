//
//  UIFont+App.swift
//  AppProject
//
//  Created by Chamira Fernando on 14/03/2017.
//  Copyright © 2017 Making Waves. All rights reserved.
//

import UIKit

extension UIFont {
	
	fileprivate struct CacheEntry: Hashable {
		let name: String
		let size: Int
		
		fileprivate var hashValue: Int {
			return name.hashValue ^ Int(size)
		}
	}
	
	fileprivate static var cache = [CacheEntry: UIFont]() {
		didSet {
			assert(Thread.isMainThread)
		}
	}
	
	
	static func appFont(name:String, size:Int) -> UIFont {
		
		let key = CacheEntry(name: name, size: size)
		if let hit = cache[key] {
			return hit
		}
		
		let s = CGFloat(size)
		let f =  UIFont(name: name, size: s) ?? UIFont.systemFont(ofSize: s)
		cache[key] = f
		return f
		
	}
	
}

private func ==(lhs: UIFont.CacheEntry, rhs: UIFont.CacheEntry) -> Bool {
	return lhs.name == rhs.name && lhs.size == rhs.size
}
