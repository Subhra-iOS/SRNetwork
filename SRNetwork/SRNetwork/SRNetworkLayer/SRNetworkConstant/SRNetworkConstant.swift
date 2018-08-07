//
//  SRNetworkConstant.swift
//  SRNetwork
//
//  Created by Subhr Roy on 07/08/18.
//  Copyright © 2018 Subhr Roy. All rights reserved.
//

import Foundation

enum NetworkEnvironment {
	case qa
	case production
	case staging
}

struct SRNetworkConstant {
	
	static  let  environment = NetworkEnvironment.staging
	
	var environmentBaseURL : String {
		switch SRNetworkConstant.environment {
			case .production: return "https://api.test.production/"
			case .qa: return "https://qa.test.qa/"
			case .staging: return "https://staging.test.staging/"
		}
	}
	
	var baseURL: URL {
		guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
		return url
	}
	
	static func uniqueTaskIdentifier() -> String {
		
		let timeIntervalToday: TimeInterval = Date().timeIntervalSince1970
		let taskIdentitfier : Int64 = Int64(timeIntervalToday * 100000)
		
		let  taskIdentitfierInString : String = String(taskIdentitfier)
		return  taskIdentitfierInString
		
	}
	
}
