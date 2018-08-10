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
		
		let baseUrl = "http://77.104.169.151/~garmentexchange/index.php"
		let urlPath =   "r=api/Login"  //"%@?r=api/Login"
		
		let param : [String : Any] = ["login[username]" : "tedder1" , "login[password]" : "123456" , "os" : "ios", "token" : ""]
		
		guard let url : URL = URL(string: baseUrl) else { return }
		
		let  operationTask : SRNetworkTask = SRNetworkTask(method: .post, baseURL: url, urlPath: urlPath, encoding: ParameterEncoding.urlEncoding, urlHeaders: nil, parameters: param, urlParameter: param, _taskType: NetworkTaskType.dataTask) { (responseData, result) in
			
			let success = result.localizedDescription
			print("\(success)")
			
			let response : [String : Any]? = responseData as? [String : Any]
			print("\(String(describing: response))")
		}
		
		SRNetworkManager.sharedManager.operationQueue.addOperation(operationTask)
		
	}

}

