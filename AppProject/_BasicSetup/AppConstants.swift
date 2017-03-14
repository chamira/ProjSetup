//
//  Config.swift
//  AppProject
//
//  Created by Chamira Fernando on 23/01/2017.
//  Copyright © 2017 Chamira Fernando. All rights reserved.
//

import Foundation

struct AppConstants {

	struct NetworkService {
		
		static let kProtocol = "https://"
		static let host		 = "facebook.com" //TODO: change this to your host url
		static let kBaseUrl  = NetworkService.kProtocol + NetworkService.host
		static let kAPIPath  = "/api"
		
		static func uri(path:String)->URL {
			var uri = path
			if (!path.hasPrefix("/")) {
				uri = "/"+path
			}
			
			return URL(string: NetworkService.kBaseUrl+kAPIPath+uri)!
			
		}
	}
	
	struct Undefined {
		static let kInt = -1
		static let kString = ""
	}
	
	
}


