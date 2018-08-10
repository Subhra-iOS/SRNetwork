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

typealias CompletionBlock = (_ data : Any, _ status : Result<String>) -> Void

class SRNetworkTask: SRNetworkOperation,SRNetworkManagerProtocol {
	
	internal  var method : HTTPMethod = .get
	private  var environmentBaseUrl : URL?
	private  var urlpath : String?
	private  var headers : [String : Any]?
	private  var httpBodyParam : [String : Any]?
	private  var encodeType : ParameterEncoding = .urlEncoding
	private var  urlParam : [String : Any]?
	private var taskType : NetworkTaskType = NetworkTaskType.dataTask
	
	private  var completionHandler : CompletionBlock?
	
	convenience   init( method : HTTPMethod, baseURL : URL , urlPath : String, encoding : ParameterEncoding, urlHeaders : HTTPHeaders? = nil , parameters : [String : Any]? = nil,urlParameter : [String : Any]? = nil, _taskType : NetworkTaskType = .dataTask, closure : @escaping CompletionBlock) {
		
		self.init()
		
		let taskIdentifier : String = SRNetworkConstant.uniqueTaskIdentifier()
		
		self.taskIdentifier = taskIdentifier
		self.method = method
		self.environmentBaseUrl = baseURL
		self.urlpath = urlPath
		self.headers = urlHeaders
		self.httpBodyParam = parameters
		self.encodeType = encoding
		self.urlParam = urlParameter
		self.taskType = _taskType
		
		self.completionHandler = closure
	}
	
	override  init() {
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
	
}

extension  SRNetworkTask : EndPointType{
	
	var baseURL: URL {
		return  self.environmentBaseUrl!
	}
	
	var path: String {
		return  self.urlpath!
	}
	
	var httpMethod: HTTPMethod {
		return  self.method
	}
	
	
	var task: HTTPTask {
		
		switch encodeType {
			case .urlEncoding:
				
				if let header = self.headers {
					
					return .requestParametersAndHeaders(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: self.urlParam, additionHeaders: header)
				}else{
					
					return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: self.urlParam)
				}
				
			case .jsonEncoding:
				
				if let header = self.headers {
					
					return .requestParametersAndHeaders(bodyParameters: self.httpBodyParam, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: header)
					
				}else{
					
				   return .requestParameters(bodyParameters: self.httpBodyParam, bodyEncoding: .jsonEncoding, urlParameters: nil)
			    }
			
			default:
				if let header = self.headers {
					
					return .requestParametersAndHeaders(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: self.urlParam, additionHeaders: header )
				}else{
					
					return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: self.urlParam)
			}
			
		}
		
	}
	
	func createRequest() -> URLRequest?{
		
		do{
			
			let request =  try SRNetworkRequest().buildRequest(baseURL: self.baseURL, path: self.path, httpMethod: self.httpMethod, task: task)

				return  request
		}catch{
			return nil
		}
	}
	
}

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
