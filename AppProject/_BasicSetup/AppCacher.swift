//
//  AppCacher.swift
//  AppProject
//
//  Created by Chamira Fernando on 14/03/2017.
//  Copyright © 2017 Making Waves. All rights reserved.
//

import Foundation

struct AppCacher: Hashable {
	
	let key: String
	let value: Any
	
	var hashValue: Int {
		return key.hashValue ^ Int("\(value)".hashValue)
	}
}

func ==(lhs: AppCacher, rhs:AppCacher) -> Bool {
	return lhs.hashValue == rhs.hashValue
}
