//
//  NetworkLog.swift
//  SRNetwork
//
//  Created by Subhr Roy on 04/08/18.
//  Copyright © 2018 Subhr Roy. All rights reserved.
//

import Foundation

enum NetworkResponse:String {
	case success
	case authenticationError = "You need to be authenticated first."
	case badRequest = "Bad request"
	case outdated = "The url you requested is outdated."
	case failed = "Network request failed."
	case noData = "Response returned with no data to decode."
	case unableToDecode = "We could not decode the response."
	case inValidJson = "JSON response is invalid"
}

enum Result<String> : Error{
	case success
	case failure(String)
}

enum DataErrorType  : Error {
	case inValidJSON
	case nullValue
	case invalidData
}

class NetworkLog {
	
    static func log(request: URLRequest) {
        
        print("\n - - - - - - - - - - OUTGOING - - - - - - - - - - \n")
        defer { print("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
        
        let urlAsString = request.url?.absoluteString ?? ""
        let urlComponents = NSURLComponents(string: urlAsString)
        
        let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"
        
        var logOutput = """
                        \(urlAsString) \n\n
                        \(method) \(path)?\(query) HTTP/1.1 \n
                        HOST: \(host)\n
                        """
        for (key,value) in request.allHTTPHeaderFields ?? [:] {
            logOutput += "\(key): \(value) \n"
        }
        if let body = request.httpBody {
            logOutput += "\n \(NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "")"
        }
        
        print(logOutput)
    }
	
	static func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
		
		switch response.statusCode {
			
			case 200...299: return .success
			case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
			case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
			case 600: return .failure(NetworkResponse.outdated.rawValue)
			default: return .failure(NetworkResponse.failed.rawValue)
			
		}
		
	}

}
