//
//  HTTPTask.swift
//  SRNetwork
//
//  Created by Subhr Roy on 04/08/18.
//  Copyright © 2018 Subhr Roy. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String : Any]

public enum HTTPTask {
    case request
    
    case requestParameters(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?)
    
    case requestParametersAndHeaders(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?,
        additionHeaders: HTTPHeaders?)
    
}


