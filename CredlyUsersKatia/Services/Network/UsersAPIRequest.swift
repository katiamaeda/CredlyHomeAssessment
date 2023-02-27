//
//  UsersAPIRequest.swift
//  CredlyProjectKatia
//
//  Created by Katia Maeda on 2023-02-25.
//

import Alamofire
import Foundation

public protocol APIConfiguration: URLRequestConvertible {
    var method: HTTPMethod { get }
    var baseURL: String { get }
    var path: String { get }
    
    func asURLRequest() throws -> URLRequest
}

public enum UsersAPIRequest: APIConfiguration {
    case getUsers
    
    public var method: HTTPMethod {
        .get
    }
    
    public var baseURL: String {
        return "https://jsonplaceholder.typicode.com"
    }
    
    public var path: String {
        switch self {
        case .getUsers:
            return "/users"
        }
    }
    
    public var url: String {
        baseURL + path
    }
    
    public func asURLRequest() throws -> URLRequest {
        let urlWithPathValue = url
        let url = try urlWithPathValue.asURL()
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = method.rawValue
        
        return urlRequest
    }
}
