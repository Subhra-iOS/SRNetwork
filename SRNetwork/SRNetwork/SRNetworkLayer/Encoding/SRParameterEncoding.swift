//
//  SRParameterEncoding.swift
//  SRNetwork
//
//  Created by Subhr Roy on 11/08/18.
//  Copyright © 2018 Subhr Roy. All rights reserved.
//

import Foundation

//public enum MethodType: String {
//	case  GET, POST, PUT, DELETE
//}
// MARK: URLStringConvertible Protocol
public protocol URLStringConvertible {
	var URLString: String { get }
}

extension String: URLStringConvertible {
	public var URLString: String {
		return self
	}
}

extension URL: URLStringConvertible {
	public var URLString: String {
		return absoluteString
		
	}
}

extension URLComponents: URLStringConvertible {
	public var URLString: String {
		return url!.URLString
	}
}

public protocol URLRequestConvertible {
	/// The URL request.
	var URLRequest: URLRequest { get }
}

extension URLRequest: URLRequestConvertible {
	public var URLRequest: URLRequest {
		return self
	}
}
public enum ParameterEncoding {
	case url
	case urlEncodedInURL
	case json
	case propertyList(PropertyListSerialization.PropertyListFormat, PropertyListSerialization.WriteOptions)
	case custom((URLRequestConvertible, [String: AnyObject]?) -> (URLRequest, NSError?))
	
	
	public func encode(_ URLRequest: URLRequestConvertible, parameters: [String: AnyObject]?) -> (URLRequest, NSError?){
		
		var mutableURLRequest = URLRequest.URLRequest
		
		guard let parameters = parameters , !parameters.isEmpty else {
			return (mutableURLRequest, nil)
		}
		
		var encodingError: NSError? = nil
		
		switch self {
		case .url, .urlEncodedInURL:
			func query(_ parameters: [String: AnyObject]) -> String {
				
				var components: [(String, String)] = []
				
				for key in parameters.keys.sorted(by: <) {
					let value = parameters[key]!
					components += queryComponents(key, value)
				}
				
				return (components.map { "\($0)=\($1)" } as [String]).joined(separator: "&")
			}
			
			func encodesParametersInURL(_ method: HTTPMethod) -> Bool {
				switch self {
				case .urlEncodedInURL:
					return true
				default:
					break
				}
				
				switch method {
				case .get, .delete:
					return true
				default:
					return false
				}
			}
			
			if let method = HTTPMethod(rawValue: mutableURLRequest.httpMethod!) , encodesParametersInURL(method) {
				if var URLComponents = URLComponents(url: mutableURLRequest.url!, resolvingAgainstBaseURL: false) {
					let percentEncodedQuery = (URLComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + query(parameters)
					URLComponents.percentEncodedQuery = percentEncodedQuery
					mutableURLRequest.url = URLComponents.url
				}
			} else {
				if mutableURLRequest.value(forHTTPHeaderField: "Content-Type") == nil {
					mutableURLRequest.setValue(
						"application/x-www-form-urlencoded; charset=utf-8",
						forHTTPHeaderField: "Content-Type"
					)
				}
				
				
				mutableURLRequest.httpBody = query(parameters).data(
					using: String.Encoding.utf8,
					allowLossyConversion: false
				)
			}
		case .json:
			do {
				
				if  (parameters["Request Body"] != nil){
					
					//TO be modify
					let  requestBody = parameters["Request Body"] as? [[String: AnyObject]]
					
					if requestBody != nil{
						
						var postArray = [[String: AnyObject]]()
						
						for item  in requestBody! {
							let itemObject = item
							postArray.append(itemObject)
						}
						
						let options = JSONSerialization.WritingOptions()
						let data = try JSONSerialization.data(withJSONObject: postArray, options: options)
						
						let datastring = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
						print("\(String(describing: datastring))")
						
						mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
						mutableURLRequest.httpBody = data
						
					}else{
						
						let  body = parameters["Request Body"] as? [String]
						var postArray = [String]()
						for item  in body! {
							let itemObject = item
							postArray.append(itemObject)
						}
						
						let options = JSONSerialization.WritingOptions()
						let data = try JSONSerialization.data(withJSONObject: postArray, options: options)
						
						let datastring = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
						print("\(String(describing: datastring))")
						
						mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
						mutableURLRequest.httpBody = data
						
					}
					
				}else{
					
					let options = JSONSerialization.WritingOptions()
					let data = try JSONSerialization.data(withJSONObject: parameters, options: options)
					let datastring = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
					print("\(String(describing: datastring))")
					
					mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
					mutableURLRequest.httpBody = data
					
				}
			} catch {
				encodingError = error as NSError
			}
		case .propertyList(let format, let options):
			do {
				let data = try PropertyListSerialization.data(
					fromPropertyList: parameters,
					format: format,
					options: options
				)
				mutableURLRequest.setValue("application/x-plist", forHTTPHeaderField: "Content-Type")
				mutableURLRequest.httpBody = data
			} catch {
				encodingError = error as NSError
			}
		case .custom(let closure):
			(mutableURLRequest, encodingError) = closure(mutableURLRequest as URLRequestConvertible, parameters)
		}
		
		return (mutableURLRequest, encodingError)
	}
	
	/**
	Creates percent-escaped, URL encoded query string components from the given key-value pair using recursion.
	
	- parameter key:   The key of the query component.
	- parameter value: The value of the query component.
	
	- returns: The percent-escaped, URL encoded query string components.
	*/
	public func queryComponents(_ key: String, _ value: AnyObject) -> [(String, String)] {
		var components: [(String, String)] = []
		
		if let dictionary = value as? [String: AnyObject] {
			for (nestedKey, value) in dictionary {
				components += queryComponents("\(key)[\(nestedKey)]", value)
			}
		} else if let array = value as? [AnyObject] {
			for value in array {
				components += queryComponents("\(key)[]", value)
			}
		} else {
			components.append((escape(key), escape("\(value)")))
		}
		
		return components
	}
	
	/**
	Returns a percent-escaped string following RFC 3986 for a query string key or value.
	
	RFC 3986 states that the following characters are "reserved" characters.
	
	- General Delimiters: ":", "#", "[", "]", "@", "?", "/"
	- Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
	
	In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
	query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
	should be percent-escaped in the query string.
	
	- parameter string: The string to be percent-escaped.
	
	- returns: The percent-escaped string.
	*/
	
	public func escape(_ string: String) -> String {
		let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
		let subDelimitersToEncode = "!$&'()*+,;="
		
		var allowedCharacterSet = CharacterSet.urlQueryAllowed
		allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
		
		return string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
	}

}
