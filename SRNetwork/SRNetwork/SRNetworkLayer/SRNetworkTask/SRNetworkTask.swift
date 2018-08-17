//
//  SRNetworkTask.swift
//  SRNetwork
//
//  Created by Subhr Roy on 07/08/18.
//  Copyright © 2018 Subhr Roy. All rights reserved.
//

import Foundation

typealias CompletionBlock = (_ data : Any, _ status : Result<String>) -> Void

class SRNetworkTask: SRNetworkOperation,SRNetworkManagerProtocol {
	
	internal  var method : HTTPMethod = .get
	private  var requestURL : String?
	private  var headers : HTTPHeaders?
	private  var httpParam : HTTPParameter?
	private  var encodeType : ParameterEncoding = .url
	private var taskType : NetworkTaskType = NetworkTaskType.dataTask
	
	private  var completionHandler : CompletionBlock?
	
	convenience   init( method : HTTPMethod = .get, serviceURL : String , encoding : ParameterEncoding = .url, urlHeaders : HTTPHeaders? = nil , parameters : HTTPParameter? = nil, jobType : NetworkTaskType = .dataTask, closure : @escaping CompletionBlock) {
		
		self.init()
		
		let taskIdentifier : String = SRNetworkConstant.uniqueTaskIdentifier()
		
		self.taskIdentifier = taskIdentifier
		self.method = method
		self.requestURL = serviceURL
		self.headers = urlHeaders
		self.httpParam = parameters
		self.encodeType = encoding
		self.taskType = jobType
		
		self.completionHandler = closure
	}
	
	override private init() {
		super.init()
	}
	
	override  func start() {
		super.start()
		let shared : SRNetworkManager = SRNetworkManager.sharedManager
		shared.networkTaskDelegate = self
		shared.networkTaskType = self.taskType
		shared.dataTaskRequest =  self.createRequest()
		do{
			try shared.start()
		}catch {
			
			print("\(NetworkResponse.badRequest)")
			
		}
	}
	
	override func completeOpeartion() -> Void{
		
		super.completeOpeartion()
		let shared : SRNetworkManager = SRNetworkManager.sharedManager
		shared.cancelSession()
	}
	
	deinit {
		print("Network Dealloc")
	}
	
}

extension  SRNetworkTask : EndPointType{
	
	var serviceURL: String {
		return  self.requestURL!
	}
	
	var httpMethod: HTTPMethod {
		return  self.method
	}
	
	func createRequest() -> URLRequest?{
		
		let request = SRNetworkRequest().buildRequest(self.method, URLString: self.serviceURL, parameters: self.httpParam, encoding: self.encodeType, headers: self.headers)

		print("\(String(describing: request.url))")
		
		return  request
	}
	
}

//MARK:--------SRNetworkManagerProtocol functions-----------//
extension  SRNetworkTask {
	
	func taskDidStart(task : URLSessionTask, taskStatus : NetworkTaskStatus<Int64>, result : Result<String>){
		
		print("\(result)")
		
	}
	
	func taskDidFinish(task : URLSessionTask, taskStatus : NetworkTaskStatus<Int64>, data : Any, result : Result<String>){
		
			let  resultDict : [String : Any] = data as!  [String : Any]
			print("\(resultDict)")
		
			self.completeOpeartion()
			self.completionHandler?(resultDict, result)
	}
	
	func taskDidFail(task : URLSessionTask, taskStatus : NetworkTaskStatus<Int64>, error : Result<String>){
		
		print("\(error)")
		
		self.completeOpeartion()
		self.completionHandler?( [:] , error)
	}
	
	func taskDidWriteData(task : URLSessionTask, taskStatus : NetworkTaskStatus<Int64>,  progress : Float){
		
		
	}
	
}
