//
//  EndPoint.swift
//  NetworkLayer
//
//  Created by Subhr Roy on 04/08/18.
//  Copyright © 2018 Subhr Roy. All rights reserved.
//

import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}

