//
//  ViewController.swift
//  SRNetwork
//
//  Created by Subhr Roy on 04/08/18.
//  Copyright © 2018 Subhr Roy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		self.login()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func  login() -> Void{
		
		let baseUrl = "https://api/Login"
		
		let param : [String : AnyObject] = ["login[username]" : "xyz" , "login[password]" : "123456" , "os" : "ios"]  as [String : AnyObject]
		
		let  operationTask : SRNetworkTask = SRNetworkTask(method: .post, serviceURL: baseUrl, encoding: .url, urlHeaders: nil, parameters: param, _taskType: NetworkTaskType.dataTask, closure: { (responseData, result) in
			
			let success = result.localizedDescription
			print("\(success)")
			
			let response : [String : Any]? = responseData as? [String : Any]
			print("\(String(describing: response))")
			
		})
		
		operationTask.enqueueOperation()
	}
	

}

