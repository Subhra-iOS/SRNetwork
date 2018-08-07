//
//  SRNetworkJsonParser.swift
//  SRNetwork
//
//  Created by Subhr Roy on 07/08/18.
//  Copyright © 2018 Subhr Roy. All rights reserved.
//

import Foundation
import UIKit


class SRNetworkJsonParser: JSONSerialization {
	
	static  func  validateJSON<T>(jsonData : T) -> Bool {
		
		var  isvalidJson : Bool = false
		
		isvalidJson = JSONSerialization.isValidJSONObject(jsonData)
		
		return  isvalidJson
		
	}
	
	static  func  fetchJSONData<T>(jsonResponse : T) throws -> Data? {
		
		var  jsonData : Data?
		do{
			
			jsonData = try JSONSerialization.data(withJSONObject: jsonResponse, options: JSONSerialization.WritingOptions.prettyPrinted)
			
		}catch {
			
			print("invalid JSON Data")
			
			throw  DataErrorType.inValidJSON
			
		}
		
		return  jsonData
		
	}
	
	static  func  jsonResponse(jsonResponse : Data,readingOption : JSONSerialization.ReadingOptions = []) throws  -> Any? {
		
		var jsonResult : Any?
		
		do{
			
			jsonResult = try JSONSerialization.jsonObject(with: jsonResponse, options: readingOption)
			
		}catch {
			
			print("invalid JSON Data")
			throw  DataErrorType.inValidJSON
		}
		
		return jsonResult
		
	}
	
	
}
