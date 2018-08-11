//
//  SRNetworkRequest.swift
//  SRNetwork
//
//  Created by Subhr Roy on 07/08/18.
//  Copyright © 2018 Subhr Roy. All rights reserved.
//

import Foundation

struct SRNetworkRequest {
	
	/*func buildRequest(baseURL : URL, path : String, httpMethod : HTTPMethod, task : HTTPTask) throws -> URLRequest {
		
		var url : URL?
		if path.count > 0{
			
			url = baseURL.appendingPathComponent(path)
		}else{
			
			url = baseURL
		}
		
		var request = URLRequest(url: url!,
								 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
								 timeoutInterval: 60.0)
		
		request.httpMethod = httpMethod.rawValue
		do {
			switch task {
				case .request:
					request.setValue("application/json", forHTTPHeaderField: "Content-Type")
				case .requestParameters(let bodyParameters,
										let bodyEncoding,
										let urlParameters):
					
					try self.configureParameters(bodyParameters: bodyParameters,
												 bodyEncoding: bodyEncoding,
												 urlParameters: urlParameters,
												 request: &request)
				
				case .requestParametersAndHeaders(let bodyParameters,
												  let bodyEncoding,
												  let urlParameters,
												  let additionalHeaders):
					
					self.addAdditionalHeaders(additionalHeaders, request: &request)
					try self.configureParameters(bodyParameters: bodyParameters,
												 bodyEncoding: bodyEncoding,
												 urlParameters: urlParameters,
												 request: &request)
			}
			return request
		} catch {
			throw error
		}
	}
	
	fileprivate func configureParameters(bodyParameters: Parameters?,
										 bodyEncoding: ParameterEncoding,
										 urlParameters: Parameters?,
										 request: inout URLRequest) throws {
		do {
			try bodyEncoding.encode(urlRequest: &request,
									bodyParameters: bodyParameters, urlParameters: urlParameters)
		} catch {
			throw error
		}
	}
	
	fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
		guard let headers = additionalHeaders else { return }
		for (key, value) in headers {
			request.setValue(value as? String, forHTTPHeaderField: key)
		}
	}*/
	
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
