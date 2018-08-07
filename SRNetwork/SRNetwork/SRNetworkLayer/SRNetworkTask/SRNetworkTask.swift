//
//  SRNetworkTask.swift
//  SRNetwork
//
//  Created by Subhr Roy on 07/08/18.
//  Copyright © 2018 Subhr Roy. All rights reserved.
//

import Foundation

enum NetworkTaskStatus<T>{
	case start
	case inProgress
	case end
	case fail
}

class SRNetworkTask: SRNetworkOperation {
	
	convenience   init( _ taskIdentifier  : String , ) {
		
		self.init(taskIdentifier)
	}
	
	private init( _ taskIdentifier  : String) {
		
		super.init(_taskIdentifier: taskIdentifier)
	}

	
}

extension  SRNetworkTask : EndPointType{
	
	
}

