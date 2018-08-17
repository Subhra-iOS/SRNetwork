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
		
		let networkManager : SRNetworkManager = SRNetworkManager.sharedManager
		networkManager.serviceDataTaskManagerWith(httpMethodType: .post, url: baseUrl, headers: nil, encoding: .url, urlParameter: param, networkJobType: .dataTask) { (responseData, result) in
			
			let success = result.localizedDescription
			print("\(success)")
			
			switch result{
				case Result.success: break
				case Result.failure(let error) : print("\(error)")
			}
			
			let response : [String : Any]? = responseData as? [String : Any]
			print("\(String(describing: response))")
		}
		
	}
	

}

