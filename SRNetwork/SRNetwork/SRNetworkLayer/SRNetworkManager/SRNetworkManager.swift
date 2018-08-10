//
//  SRNetworkManager.swift
//  SRNetwork
//
//  Created by Subhr Roy on 06/08/18.
//  Copyright © 2018 Subhr Roy. All rights reserved.
//

import Foundation

protocol SRNetworkManagerProtocol {
	func taskDidStart(task : URLSessionTask, taskStatus : NetworkTaskStatus<Int64>, result : Result<String>)
	func taskDidFinish(task : URLSessionTask, taskStatus : NetworkTaskStatus<Int64>, data : Any, result : Result<String>)
	func taskDidFail(task : URLSessionTask, taskStatus : NetworkTaskStatus<Int64>, error : Result<String>)
	func taskDidWriteData(task : URLSessionTask, taskStatus : NetworkTaskStatus<Int64>,  progress : Float)
}

enum  NetworkTaskType{
	case dataTask
	case downloadTask
	
}

final class SRNetworkManager : NSObject,URLSessionDelegate{
	
	static  let  sharedManager : SRNetworkManager = SRNetworkManager()
	var sharedSessionTask : URLSessionTask?
	var networkTaskDelegate : SRNetworkManagerProtocol?
	
	var dataTaskRequest : URLRequest?
	var  networkTaskType : NetworkTaskType = .dataTask
	
	private  var  responseData : Data?
	
	var  operationQueue : OperationQueue = OperationQueue()
	
	override private init(){
		
		self.operationQueue.maxConcurrentOperationCount = SRNetworkConstant.maxConcurrentOperation
		self.operationQueue.name = "SRNetworkOperation"
	}
	
	lazy  var sharedSession : URLSession? = {
		
		let session : URLSession = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
		return session
		
	}()
	
	func start() throws -> Void{
		
		if let currentSession : URLSession = self.sharedSession, let request = dataTaskRequest {
			
			print("\(String(describing: request.url))")
			print("\(String(describing: request.allHTTPHeaderFields))")
			
			self.responseData = Data()
			self.sharedSessionTask = currentSession.dataTask(with: request)
			self.sharedSessionTask?.resume()
			
		}else{
			
			throw  Result.failure(NetworkResponse.badRequest)
		}
		
	}
	
	func cancelSession() -> Void{
		
		if let session  : URLSessionTask = self.sharedSessionTask{
			
			session.cancel()
		}
		
		if let sharedSession : URLSession = self.sharedSession{
			
			sharedSession.invalidateAndCancel()
		}
		
	}
	
	private func finishTask() -> Void{
		
		if let session  : URLSessionTask = self.sharedSessionTask{
			
			session.cancel()
		}
		
	}
	
	deinit {
		print("Service Manager Dealloc")
	}
	
}


extension  SRNetworkManager: URLSessionDataDelegate,URLSessionDownloadDelegate{
	
	public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Swift.Void){
		
		if(dataTask.state == URLSessionTask.State.canceling) {
			
			self.finishTask()
			completionHandler(.cancel)
			return
			
		}else{
			
			if response is HTTPURLResponse {
				
				if let urlResponse : HTTPURLResponse = response as? HTTPURLResponse{
					
					let httpsResponse : HTTPURLResponse = urlResponse
					let statusCode = httpsResponse.statusCode
					let responseHeader = httpsResponse.allHeaderFields
					
					print("\(responseHeader)")
					
					if statusCode == 200 || statusCode == 206 {
						
						self.networkTaskDelegate?.taskDidStart(task: dataTask, taskStatus : .start, result: NetworkLog.handleNetworkResponse(urlResponse))
						
						switch networkTaskType{
							
							case .dataTask : completionHandler(.allow)
							case .downloadTask : completionHandler(.becomeDownload)
							
						}
						
						
					}else if statusCode >= 400{
						
						self.finishTask()
						self.networkTaskDelegate?.taskDidFail(task: dataTask, taskStatus: .fail, error: NetworkLog.handleNetworkResponse(urlResponse))
						
						completionHandler(.cancel)
					}
					
				}
				
			}else{
				self.finishTask()
				completionHandler(.cancel)
			}
			
		}
		
	}
	
	func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask){
		
	}
	
	func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data){
		
		if(dataTask.state == URLSessionTask.State.canceling) {
			
			return
			
		}else{
		
			self.responseData?.append(data)
		
		}
		
	}
	
	public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64){
	
		let downLoadProgress = Float(bytesWritten) / Float(totalBytesExpectedToWrite)
		print("didGetData : \(downLoadProgress)")
		
		self.networkTaskDelegate?.taskDidWriteData(task: downloadTask, taskStatus: .inProgress, progress: downLoadProgress)
		
	}
	
	public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL){
		
		// Check if the operation has been cancelled
		if(downloadTask.state == URLSessionTask.State.canceling) {
			
			return
		}else  if(downloadTask.state == URLSessionTask.State.suspended) { // Check if the operation has been Suspended
			
			return
		}
		
			self.finishTask()
		do{
			let data : Data = try Data(contentsOf: location)
			self.networkTaskDelegate?.taskDidFinish(task: downloadTask, taskStatus: .end, data: data, result: .success)
			
		}catch{
			
		}
		
	}
	
	public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64){
		
		
	}
	
	public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?){
		
		// Check if the operation has been cancelled
		if(task.state == URLSessionTask.State.canceling){
			
			return
		}
			// Check if the operation has been Suspended
		else if(task.state == URLSessionTask.State.suspended) {
			
			return
		}
		
		if let errorInfo = error{
			print("Session error: \(errorInfo.localizedDescription)")
			self.finishTask()
			self.networkTaskDelegate?.taskDidFail(task: task, taskStatus: .fail, error: .failure(NetworkResponse.failed.rawValue))
			
		}
		else{
			
			self.finishTask()
			
			if let data : Data = self.responseData{
				
				do{
					
					let  result : Any = try SRNetworkJsonParser.jsonResponse(jsonResponse: data) as Any
					self.networkTaskDelegate?.taskDidFinish(task: task, taskStatus: .end, data: result, result: .success)
					
				}catch DataErrorType.inValidJSON{
					
					self.networkTaskDelegate?.taskDidFail(task: task, taskStatus: .fail, error: .failure(NetworkResponse.failed.rawValue))
				}catch{
					
					self.networkTaskDelegate?.taskDidFail(task: task, taskStatus: .fail, error: .failure(NetworkResponse.failed.rawValue))
				}
				
			}
			
		}
		
	}
		
}

