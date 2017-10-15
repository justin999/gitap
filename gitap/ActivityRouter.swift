//
//  ActivityRouter.swift
//  gitap
//
//  Created by Koichi Sato on 1/13/17.
//  Copyright © 2017 Koichi Sato. All rights reserved.
//

import Foundation
import Alamofire

enum ActivityRouter: URLRequestConvertible {
    case listFeeds()
    case listEvents()
    case listEventsUserReceived(String)
    
    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .listFeeds, .listEvents, .listEventsUserReceived:
                return .get
            }
        }
        
        let url: URL = {
            var url = URL(string: githubBaseURLString)!
            let relativePath: String
            switch self {
            case .listFeeds():
                relativePath = "/feeds"
            case .listEvents():
                relativePath = "/events"
            case .listEventsUserReceived(let userName):
                relativePath = "/users/\(userName)/received_events"
            }
            
            url.appendPathComponent(relativePath)
            return url
        }()
        
        let params: ([String: Any]?) = {
            switch self {
            case .listFeeds, .listEvents, .listEventsUserReceived:
                return nil
            }
        }()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        // Set Oauth token if we have one
        if let token = GitHubAPIManager.shared.OAuthToken {
            urlRequest.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let encoding = JSONEncoding.default
        return try encoding.encode(urlRequest, with: params)
    }
}
