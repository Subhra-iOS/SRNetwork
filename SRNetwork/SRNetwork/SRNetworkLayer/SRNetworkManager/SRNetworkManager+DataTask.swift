//
//  SRNetworkManager+DataTask.swift
//  SRNetwork
//
//  Created by Subhr Roy on 17/08/18.
//  Copyright © 2018 Subhr Roy. All rights reserved.
//

import Foundation

extension SRNetworkManager{
	
	public func serviceDataTaskManagerWith(httpMethodType : HTTPMethod, url : String, headers : HTTPHeaders? = nil, encoding : ParameterEncoding = .url, urlParameter : HTTPParameter? = nil, networkJobType : NetworkTaskType = .dataTask, completionHandler : @escaping CompletionBlock) -> Void{
		
		let  operationTask : SRNetworkTask = SRNetworkTask(method: httpMethodType, serviceURL: url, encoding: encoding, urlHeaders: headers, parameters: urlParameter, jobType : networkJobType, closure: { (responseData, result) in
			
			completionHandler(responseData,result)
			
		})
		
		self.operationQueue.addOperation(operationTask)
		
	}
	
}
