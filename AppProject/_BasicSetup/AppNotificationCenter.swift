//
//  AppNotificationCenter.swift
//  NOA book
//
//  Created by Chamira Fernando on 13/12/2016.
//  Copyright © 2016 Making Waves. All rights reserved.
//

import Foundation

///Use AppNotificationCenter instead of NotificationCenter.default to post, add observer and removeObserver

/// This class keeps the track on all fired/Posted notifications and observers
enum AppPostNotification : String {
	case notDefined = "kDefineNotificationsHere"
}

struct AppNotificationObserver : Hashable, CustomStringConvertible {
	var observer:AnyHashable
	let selector:Selector
	let object:Any?
	private let _hash:Int!
	
	init(observer:AnyHashable, selector:Selector, object:Any?) {
		self.observer = observer
		self.selector = selector
		self.object = object
		_hash = "\(observer)\(selector)".hashValue
	}
	
	var hashValue: Int {
		return _hash
	}
	
	var description: String {
		return "Observer:\(observer) selector:\(selector) hash:\(hashValue)"
	}
}

func ==(lhs:AppNotificationObserver,rhs:AppNotificationObserver)->Bool {
	return lhs.hashValue == rhs.hashValue
}

class AppNotification : Hashable, CustomStringConvertible {
	
	let name:Notification.Name
	var observers:[AppNotificationObserver] =  [AppNotificationObserver]()
	var description: String {
		return "AppNotification: \(name) observers:\(observers)"
	}

	init(name:Notification.Name, observer:AppNotificationObserver) {
		self.name = name
		self.observers.append(observer)
	}
	
	func addObserver(_ observer:AppNotificationObserver) {
		if !observers.contains(observer) {
			observers.append(observer)
		}
	}
	
	func removeObserver(_ observer:AppNotificationObserver) {
		let ob = observers.filter { $0.hashValue == observer.hashValue }.first
		
		guard let o = ob else {
			return
		}
		
		guard let index = observers.index(of: o) else {
			return
		}
		
		observers.remove(at: index)
		
	}
	
	func removeAllObservers() {
		observers.removeAll()
	}
	
	var hashValue: Int {
		return "\(name)".hashValue
	}
	
}

func ==(lhs:AppNotification,rhs:AppNotification)->Bool {
	return lhs.hashValue == rhs.hashValue
}

struct AppPostNotificationItem {
	let postNotiifcation:AppPostNotification
	let object:Any?
	let userInfo:[AnyHashable:Any]?
}

class AppNotificationCenter {
	
	static var registedObservers:[AppNotification] {
		return _registedObservers
	}
	
	static var postedNotifications:[AppPostNotificationItem] {
		return _postedNotifications
	}
	
	static private var _registedObservers:[AppNotification] = { [AppNotification]() }()
	
	static private var _postedNotifications:[AppPostNotificationItem] = { [AppPostNotificationItem]() }()
	
	static func post (_ postNotification:AppPostNotification, object:Any? = nil , userInfo: [AnyHashable : Any]? = nil) {
        print("object passed: \(object)")
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: postNotification.rawValue), object: object, userInfo: userInfo)
        _postedNotifications.append(AppPostNotificationItem(postNotiifcation: postNotification, object: object, userInfo: userInfo))
	}
	
	@discardableResult
	static func observePost (_ postNotification:AppPostNotification, observer:AppNotificationObserver) -> AppNotification {
        let notification = Notification.Name(rawValue: postNotification.rawValue)
		NotificationCenter.default.addObserver(observer.observer, selector: observer.selector , name: notification , object: observer.object)
		
		var appNotificationObj = _registedObservers.filter { $0.name.rawValue == notification.rawValue }.first
		
		if (appNotificationObj == nil) {
			
			appNotificationObj = AppNotification(name: notification, observer: observer)
			_registedObservers.append(appNotificationObj!)
			
		} else {
			appNotificationObj!.addObserver(observer)
		}
		
		return appNotificationObj!
		
	}
	
	static func removePost(_ postNotification:AppPostNotification, observer anObserver:AppNotificationObserver? = nil) {
		let removeObserverFromNotificationCenter:(AppPostNotification,AppNotificationObserver)->() = {name,observer in
			NotificationCenter.default.removeObserver(observer.observer, name: Notification.Name(rawValue: name.rawValue), object: observer.object)
		}
		
		let registedNotification = _registedObservers.filter { $0.name.rawValue == postNotification.rawValue }.first
		
		guard let notification = registedNotification else {
			if (anObserver != nil) {
				removeObserverFromNotificationCenter(postNotification,anObserver!)
			}
			return
		}
		
		if (anObserver == nil) {
			let _ = notification.observers.map { removeObserverFromNotificationCenter(postNotification,$0) }
			
			notification.removeAllObservers()
			guard let index = _registedObservers.index(of: notification) else {
				return
			}
			_registedObservers.remove(at: index)
			
		} else {
			
			notification.removeObserver(anObserver!)
			
			if notification.observers.count == 0 {
				guard let index = _registedObservers.index(of: notification) else {
					return
				}
				_registedObservers.remove(at: index)
			}
		}
		
	}
	
	static func removeObservers(for observer:AnyHashable) {
		
		for notification in _registedObservers {
			
			let objects = notification.observers.filter { $0.observer == observer }
		
			for object in objects {
				notification.removeObserver(object)
			}
			
		}
		
		NotificationCenter.default.removeObserver(observer)
		
	}
	
}
