//
//  AppNetworkReachability.swift
//  AppProject
//
//  Created by Chamira Fernando on 14/03/2017.
//  Copyright © 2017 Making Waves. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import CSNotificationView

//MARK: - App Network Reachability
typealias AppNetworkReachabilityStatus = NetworkReachabilityManager.NetworkReachabilityStatus

protocol AppNetworkReachabilitySubscriberProtocol : class {
	
	var lastReportedInternetReachabilityStatus:AppNetworkReachabilityStatus? { set get }
	var lastReportedHostReachabilityStatus:AppNetworkReachabilityStatus? { set get }
	var logNetworkReachabilityStatus:Bool { get }
	
	func deviceIsOffline()
	func deviceIsBackOnline()
	func hostIsNotReachable()
	func unknownErrorInNetwork()
	
}

fileprivate class AppNetworkReachabilitySubscriber {
	static var hostReachabilityManager:NetworkReachabilityManager? = {
		
		let host = AppConstants.NetworkService.host
		return NetworkReachabilityManager(host:host)
		
	}()
	
	static var internetReachabilityManager:NetworkReachabilityManager? = {
		
		let host = "google.com"
		return NetworkReachabilityManager(host:host)
		
	}()
	
	static let kPrintTag:String = {
		return "[NetworkReachabilitySubscriber]->"
	}()
	
}

extension AppNetworkReachabilitySubscriberProtocol where Self:UIViewController {
	
	@discardableResult
	func subscribeToNetworkReachabilityChange() -> Bool? {
		
		log("Subsribe to network monitoring")
		
		guard let net  = AppNetworkReachabilitySubscriber.internetReachabilityManager else {
			log("NetworkReachabilityManager failed to init(internet)")
			return false
		}
		
		guard let host = AppNetworkReachabilitySubscriber.hostReachabilityManager else {
			log("NetworkReachabilityManager failed to init(host)")
			return false
		}
		
		
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { [weak self] in
			if net.networkReachabilityStatus == .notReachable {
				self?.deviceIsOffline()
			}
		}
		
		net.listener = { [weak self] listener in
			self?.log("Net status change",listener)
			
			if let lastReported = self?.lastReportedInternetReachabilityStatus {
				if listener == .notReachable {
					self?.log("Internet is not available")
					self?.deviceIsOffline()
					
				} else if listener == .unknown {
					
					self?.log("Unknow error in network")
					self?.unknownErrorInNetwork()
					
				} else {
					if lastReported != listener {
						self?.log("Device is back online..")
						self?.deviceIsBackOnline()
					} else {
						self?.log("Network status did not change:",self?.lastReportedInternetReachabilityStatus ?? "nil",listener)
					}
				}
			} else {
				self?.log("Establishing connection..")
			}
			
			self?.lastReportedInternetReachabilityStatus = listener
			
		}
		
		host.listener = { [weak self] listener in
			
			self?.log("Host status",listener)
			if let _ = self?.lastReportedHostReachabilityStatus , let internet = self?.lastReportedInternetReachabilityStatus {
				
				self?.log("Host status change",listener)
				
				if internet == .notReachable {
					self?.deviceIsOffline()
				} else {
					if listener == .notReachable {
						
						self?.log("Network is reachable but host is not...")
						
						self?.hostIsNotReachable()
						
					} else if listener == .unknown {
						self?.unknownErrorInNetwork()
					}
				}
			}
			
			self?.lastReportedHostReachabilityStatus = listener
			
		}
		
		net.startListening()
		host.startListening()
		
		return true
		
	}
	
	func unsubscribeFromNetworkReachabilityChange(){
		AppNetworkReachabilitySubscriber.hostReachabilityManager?.stopListening()
		AppNetworkReachabilitySubscriber.internetReachabilityManager?.stopListening()
		log("Unsubsribe from network monitoring")
	}
	
	private func log(_ msg:String,_ obj:Any...){
		
		if !logNetworkReachabilityStatus {
			return
		}
		
		print(AppNetworkReachabilitySubscriber.kPrintTag,msg,obj)
		
	}
	
}


typealias AppNotificationView = CSNotificationView

//MARK: - NetworkStatusNotificationViewRendering
protocol AppNetworkStatusNotificationViewRenderingProtocol : class {
	var networkStatusNotificationView:AppNotificationView? { set get }
	var networkStatusNotificationViewHideOnTap:Bool { get }
}

fileprivate class AppNetworkStatusNotificationViewRenderingHelper {
	static var isNotificationIsShown:Bool = false
}

extension AppNetworkStatusNotificationViewRenderingProtocol where Self:UIViewController {
	
	func showOfflineNotificationView() {
		showNotificationView(color: UIColor.red, message:  "k_device_is_offline".localized)
	}
	
	func showHostNotReachableNotificatioView() {
		showNotificationView(color: UIColor.red, message: "k_could_not_connect_to_server".localized)
	}
	
	private func showNotificationView(color:UIColor,message:String) {
		
		if AppNetworkStatusNotificationViewRenderingHelper.isNotificationIsShown {
			return
		}
		
		if networkStatusNotificationView == nil {
			
			networkStatusNotificationView = CSNotificationView(parentViewController: self, tintColor: color, image: nil , message: message)
			let size :CGFloat = 16.0
			networkStatusNotificationView?.textLabel.font = UIFont.systemFont(ofSize: size)
			networkStatusNotificationView?.textLabel.adjustsFontSizeToFitWidth = true
			networkStatusNotificationView?.textLabel.minimumScaleFactor = 0.5
			
			networkStatusNotificationView?.setVisible(true, animated: true, completion: nil)
			
			if networkStatusNotificationViewHideOnTap {
				networkStatusNotificationView?.tapHandler = { [weak self] in
					self?.hideNetworkStatusNotificationView()
					
				}
			}
			
			AppNetworkStatusNotificationViewRenderingHelper.isNotificationIsShown = true
		}
		
	}
	
	func hideNetworkStatusNotificationView() {
		networkStatusNotificationView?.setVisible(false, animated: true, completion: nil)
		networkStatusNotificationView = nil
		AppNetworkStatusNotificationViewRenderingHelper.isNotificationIsShown = false
	}
	
}
