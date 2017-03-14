//
//  NSError+Extension.swift
//  NOA book
//
//  Created by Chamira Fernando on 20/01/17.
//  Copyright © 2016 Making Waves. All rights reserved.
//

import Foundation

//TODO: App error domain anme
let kErrorDomain = "app.error.domain.name.must.be.set.here \(#file)"

//Real deal starts here
protocol AppErrorKind  {
	var code:Int { get }
}

//MARK: -  Protocols
protocol AppErrorMetaProtocol {
	var domain:String { get }
}

protocol AppErrorProtocol : AppErrorKind, Error, CustomNSError {
	var errorDescription:String { get }
	var localizedDescription: String? { get }
	func `is`(errorKind: AppErrorKind) ->Bool
}

protocol DebugErrorInfoProtocol : CustomStringConvertible, CustomDebugStringConvertible  {
	var file:String? { get }
	var line:Int? { get }
}

protocol AppErrorRecoveryProtocol {
	var recoveryOption:String? { get }
}

protocol DescriptiveErrorProtocol : AppErrorMetaProtocol, AppErrorProtocol, AppErrorRecoveryProtocol, DebugErrorInfoProtocol {}


//MARK: - Protocol default implementations
extension AppErrorMetaProtocol {
	var domain : String {
		return kErrorDomain
	}
}

extension DebugErrorInfoProtocol where Self:AppErrorProtocol, Self:AppErrorMetaProtocol {
	
	var description: String {
		return "domain:\(domain) code:\(code) description:\(errorDescription) file:\(file ?? "-") line:\(line ?? 0)"
	}
	
	var debugDescription: String {
		return "domain:\(domain) code:\(code) description:\(errorDescription) file:\(file ?? "-") line:\(line ?? 0)"
	}
	
}

extension AppErrorProtocol {
	func `is`(errorKind: AppErrorKind) -> Bool {
		return errorKind.code == code
	}
}


extension CustomNSError where Self:AppErrorMetaProtocol, Self:AppErrorProtocol {
	
	/// The domain of the error.
	static var errorDomain: String {
		return kErrorDomain
	}
	
	/// The error code within the given domain.
	var errorCode: Int {
		return code
	}
	
	/// The user-info dictionary.
	var errorUserInfo: [String : Any] {
		return [kCFErrorDescriptionKey as String : errorDescription ,
		        kCFErrorLocalizedDescriptionKey as String: localizedDescription ?? ""]
	}
	
}

extension AppErrorRecoveryProtocol {
	var recoveryOption:String? { return nil }
}

func ==(lhs: AppErrorProtocol, rhs: AppErrorProtocol) -> Bool {
	return lhs.code == rhs.code
}
