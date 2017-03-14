//
//  AppStandardDefaults.swift
//  AppProject
//
//  Created by Chamira Fernando on 01/02/2017.
//  Copyright © 2017 Chamira Fernando. All rights reserved.
//

import Foundation

//TODO: define all your StandardDefaults here
//TODO: define all your StandardDefaults here
enum AppStandardDefaultKey:String {
	case notDefined="notdefined"
}

struct AppStandardDefault {
	
	@discardableResult
	static func save<Value>(_ key:AppStandardDefaultKey,value:Value) -> Bool {
		
		let data = NSKeyedArchiver.archivedData(withRootObject: value)
		UserDefaults.standard.set(data, forKey: key.rawValue)
		return UserDefaults.standard.synchronize()
		
	}
	
	static func get<Value>(_ key:AppStandardDefaultKey) -> Value? {
		guard let value =  UserDefaults.standard.value(forKey: key.rawValue) else {
			return nil
		}
		
		let v = NSKeyedUnarchiver.unarchiveObject(with: value as! Data)
		return v as? Value
	}
	
	@discardableResult
	static func remove(_ key:AppStandardDefaultKey) -> Bool {
		UserDefaults.standard.removeObject(forKey: key.rawValue)
		return UserDefaults.standard.synchronize()
	}
}
