//
//  IssueRouter.swift
//  gitap
//
//  Created by Koichi Sato on 1/4/17.
//  Copyright © 2017 Koichi Sato. All rights reserved.
//

import Foundation
import Alamofire

enum IssueRouter: URLRequestConvertible {
    case listIssues()
    
    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .listIssues:
                return .get
            }
        }
        
        let url: URL = {
            let relativePath: String
            switch self {
            case .listIssues():
                relativePath = "issues"
            }
            
            var url = URL(string: baseURLString)!
            url.appendPathComponent(relativePath)
            return url
        }()
        
        let params: ([String: Any]?) = {
            switch self {
            case .listIssues:
                return nil
            }
        }()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        // Set Oauth token if we have one
        if let token = GitHubAPIManager.sharedInstance.OAuthToken {
            urlRequest.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let encoding = JSONEncoding.default
        return try encoding.encode(urlRequest, with: params)
    }
}

