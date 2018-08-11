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

	/*
	URL : http://77.104.169.151/~garmentexchange/index.php?r=api/Login
	header: {
	"Accept-Language" = "en;q=1";
	"Content-Type" = "application/x-www-form-urlencoded; charset=utf-8";
	"User-Agent" = "GarmentXchange BETA/1.0 (iPhone; iOS 11.4; Scale/2.00)";
	}
	Body : login[password]=123456&login[username]=tedder1&os=ios
	*/
	
	func  login() -> Void{
		
		let baseUrl = "http://77.104.169.151/~garmentexchange/index.php?r=api/Login"
		
		let param : [String : AnyObject] = ["login[username]" : "tedder1" , "login[password]" : "123456" , "os" : "ios"]  as [String : AnyObject]
		
		let  operationTask : SRNetworkTask = SRNetworkTask(method: .post, serviceURL: baseUrl, encoding: .url, urlHeaders: nil, parameters: param, _taskType: NetworkTaskType.dataTask, closure: { (responseData, result) in
			
			let success = result.localizedDescription
			print("\(success)")
			
			let response : [String : Any]? = responseData as? [String : Any]
			print("\(String(describing: response))")
			
		})
		
		SRNetworkManager.sharedManager.operationQueue.addOperation(operationTask)
		
	}

}

