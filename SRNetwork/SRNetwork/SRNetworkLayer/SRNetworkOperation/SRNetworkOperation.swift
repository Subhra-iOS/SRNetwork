//
//  SROperationTask.swift
//  SRNetwork
//
//  Created by Subhr Roy on 06/08/18.
//  Copyright © 2018 Subhr Roy. All rights reserved.
//

import Foundation

class SRNetworkOperation : Operation {
	
	public var taskIdentifier : String?
	
	
	override  init() {
		
	}
	
	override var isAsynchronous: Bool  {return true}
	
	fileprivate var _executing = false
	override var isExecuting: Bool{
		get{
			return _executing
		}
		set{
			if _executing != newValue{
				self.willChangeValue(forKey: "isExecuting")
				_executing = newValue
				self.didChangeValue(forKey: "isExecuting")
			}
		}
	}
	
	fileprivate var _finished : Bool = false
	override var isFinished: Bool{
		get{
			return _finished
		}
		set{
			if _finished != newValue{
				self.willChangeValue(forKey: "isFinished")
				_finished = newValue
				self.didChangeValue(forKey: "isFinished")
			}
		}
	}
	
	func cancelOperation() -> Void{
	
		self.isExecuting = false
		self.isFinished = true
	}
	
	func suspendOperation() -> Void{
		
		self.isExecuting = false
		self.isFinished = true
	}
	
	func completeOpeartion() -> Void{
		if self.isExecuting{
			self.isExecuting = false
			self.isFinished = true
		}
	}
	
	func resumeOperation() -> Void {
		self.isExecuting = true;
		
	}
	
	override func start() {
		if isCancelled{
			self.isFinished = true
			return
		}
		self.isExecuting = true
		main()
	}
	
	override func main() {
		self.resumeOperation()
	}
	
	
}
