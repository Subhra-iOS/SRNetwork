//
//  EndPoint.swift
//  SRNetwork
//
//  Created by Subhr Roy on 04/08/18.
//  Copyright © 2018 Subhr Roy. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String : String]
public typealias HTTPParameter = [String : AnyObject]

protocol EndPointType {
    var serviceURL: String { get }
    var httpMethod: HTTPMethod { get }
}

