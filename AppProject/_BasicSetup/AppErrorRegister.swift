//
//  ErrorRegister.swift
//  AppProject
//
//  Created by Chamira Fernando on 14/03/2017.
//  Copyright © 2017 Making Waves. All rights reserved.
//

import Foundation

//MARK: - Networking Error
struct NetworkingError {
	
	enum Kind: Int, AppErrorKind {
		case emptyResponse = 10001,
		notExpectedResultType = 10002,
		unknownError = 10000
		var code: Int {
			return rawValue
		}
	}
	
	struct EmptyResponse : DescriptiveErrorProtocol {
		
		var file: String?
		var line: Int?
		
		var code: Int {
			return Kind.emptyResponse.rawValue
		}
		
		var errorDescription: String {
			return "Response is empty"
		}
		
		var localizedDescription: String? {
			return "k.network.response_is_empty".localized
		}
		
	}
	
	struct NotExpectedResultType : DescriptiveErrorProtocol {
		
		var file: String?
		var line: Int?
		var expected:Any.Type
		var got:Any.Type
		
		var code: Int {
			return Kind.notExpectedResultType.rawValue
		}
		
		var errorDescription: String {
			return "Not Expected result type expected \(expected) got \(got)"
		}
		
		var localizedDescription: String? {
			return "".localized
		}
		
	}
	
	struct UnknownNetworkError : DescriptiveErrorProtocol {
		
		var file: String?
		var line: Int?
		
		let statusCode:Int?
		let message:String?
		
		var code: Int {
			return statusCode ?? Kind.unknownError.rawValue
		}
		
		var errorDescription: String {
			return message ?? "Unknown error"
		}
		
		var localizedDescription: String? {
			return "".localized
		}
		
	}
}

