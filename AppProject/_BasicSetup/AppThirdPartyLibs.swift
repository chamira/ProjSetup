//
//  AppThirdPartyLibs.swift
//  AppProject
//
//  Created by Chamira Fernando on 14/03/2017.
//  Copyright © 2017 Making Waves. All rights reserved.
//

import Foundation
//import HockeySDK

class AppThirdPartyLibs {

	static func integrateAll() {
		AppThirdPartyLibs.integrateHockeyApp()
		AppThirdPartyLibs.integrateGooleAnalytics()
	}
	
	static func integrateHockeyApp() {
		
		fatalError("Uncomment below code and add hockey App Id, make sure you import HockeySDK")
		
		/*let hockeyId = ""
		
		if hockeyId.characters.count == 0 {
			fatalError("Hockey app id must be set at above \(#file) \(#line)")
		}
		
		BITHockeyManager.shared().configure(withIdentifier: hockeyId)
		// Do some additional configuration if needed here
		BITHockeyManager.shared().start()
		BITHockeyManager.shared().authenticator.authenticateInstallation()
		*/
	}
	
	static func integrateGooleAnalytics() {
		
	}
}
	

	
	
