//
//  SRNetworkRequest.swift
//  SRNetwork
//
//  Created by Subhr Roy on 07/08/18.
//  Copyright © 2018 Subhr Roy. All rights reserved.
//

import Foundation

struct SRNetworkRequest {
	
	func buildRequest(_ method: HTTPMethod, URLString: URLStringConvertible, parameters: [String: AnyObject]? = nil, encoding: ParameterEncoding = .url, headers: [String: String]? = nil) -> URLRequest{
		
		let mutableURLRequest = urlRequest(method, URLString: URLString, headers: headers)
		let encodedURLRequest = encoding.encode(mutableURLRequest as URLRequestConvertible, parameters: parameters).0
		return encodedURLRequest.URLRequest
	}
	
	private func urlRequest(_ method: HTTPMethod, URLString: URLStringConvertible, headers: [String: String]? = nil) -> URLRequest{
		
		var mutableURLRequest: URLRequest = URLRequest(url: URL(string: URLString.URLString)!)
		
		mutableURLRequest.httpMethod = method.rawValue
		
		if let headers = headers {
			for (headerField, headerValue) in headers {
				mutableURLRequest.setValue(headerValue, forHTTPHeaderField: headerField)
			}
		}
		return mutableURLRequest
	}
	
}
