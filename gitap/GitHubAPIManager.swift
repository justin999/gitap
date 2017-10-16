//
//  GitHubAPIManager.swift
//  gitap
//
//  Created by Koichi Sato on 1/4/17.
//  Copyright © 2017 Koichi Sato. All rights reserved.
//

import Foundation
import Alamofire
import Locksmith

let githubBaseURLString = "https://api.github.com"

enum GitHubAPIManagerError: Error {
    case network(error: Error)
    case apiProvidedError(reason: String)
    case authCouldNot(reason: String)
    case authLost(reason: String)
    case objectSerialization(reason: String)
}

protocol ResultProtocol {
    init?(json: [String: Any])
}

let kKeyChainGitHub = "github"
let kMessageFailToObtainToken: String = "Could not obtain an OAuth token"

class GitHubAPIManager {
    static let shared = GitHubAPIManager()
    
    var isLoadingOAuthToken: Bool = false
    var OAuthTokenCompletionHandler:((Error?) -> Void)?
    var OAuthToken: String? {
        set {
            guard let newValue = newValue else {
                let _ = try? Locksmith.deleteDataForUserAccount(userAccount: kKeyChainGitHub)
                Utils.setDefaultsValue(value: nil, key: "githubAuthToken")
                return
            }
            Utils.setDefaultsValue(value: newValue, key: "githubAuthToken")
            guard let _ = try? Locksmith.updateData(data: ["token": newValue], forUserAccount: kKeyChainGitHub) else {
                let _ = try? Locksmith.deleteDataForUserAccount(userAccount: kKeyChainGitHub)
                return
            }
            
        }
        get {
            // try to load from keychain
            let dictionary = Locksmith.loadDataForUserAccount(userAccount: kKeyChainGitHub)
            return dictionary?["token"] as? String
        }
    }
    
    let clientID: String = Configs.github.clientId
    let clientSecret: String = Configs.github.clientSecret
    
    func clearCache() -> Void {
        let cache = URLCache.shared
        cache.removeAllCachedResponses()
    }
    
    func hasOAuthToken() -> Bool {
        if let token = self.OAuthToken {
            return !token.isEmpty
        }
        return false
    }
    
    func clearOAuthToken() {
        if let _ = self.OAuthToken {
            self.OAuthToken = nil
        }
    }
    
    // MARK: - OAuth flow
    func URLToStartOAuth2Login() -> URL? {
        // TODO: change the state for production
        let authPath: String = "https://github.com/login/oauth/authorize" +
        "?client_id=\(clientID)&scope=user%20repo%20gist"
        return URL(string: authPath)
    }
    
    func processOAuthStep1Response(_ url: URL) {
        // extract the code from the URL
        guard let code = extrctCodeFromOauthStep1Response(url) else {
            self.isLoadingOAuthToken = false
            let error = GitHubAPIManagerError.authCouldNot(reason: kMessageFailToObtainToken)
            self.OAuthTokenCompletionHandler?(error)
            return
        }
        
        swapAuthCodeForToken(code: code)
    }
    
    func swapAuthCodeForToken(code: String) {
        let getTokenPath: String = "https://github.com/login/oauth/access_token"
        let tokenParams = ["client_id": clientID, "client_secret": clientSecret, "code": code]
        let jsonHeader = ["Accept": "application/json"]
        
        Alamofire.request(getTokenPath, method: .post, parameters: tokenParams, encoding: URLEncoding.default, headers: jsonHeader)
            .responseJSON { response in
                guard response.result.error == nil else {
                    print(response.result.error!)
                    self.isLoadingOAuthToken = false
                    let errorMessage = response.result.error?.localizedDescription ?? kMessageFailToObtainToken
                    let error = GitHubAPIManagerError.authCouldNot(reason: errorMessage)
                    self.OAuthTokenCompletionHandler?(error)
                    return
                }
                guard let value = response.result.value else {
                    print("no string received in response when swapping oauth code for token")
                    self.isLoadingOAuthToken = false
                    let error = GitHubAPIManagerError.authCouldNot(reason: kMessageFailToObtainToken)
                    self.OAuthTokenCompletionHandler?(error)
                    return
                }
                guard let jsonResult = value as? [String: String] else {
                    print("no data received or data not JSON")
                    self.isLoadingOAuthToken = false
                    let error = GitHubAPIManagerError.authCouldNot(reason: kMessageFailToObtainToken)
                    self.OAuthTokenCompletionHandler?(error)
                    return
                }
                
                self.OAuthToken = self.parseOAuthTokenResponse(jsonResult)
                self.isLoadingOAuthToken = false
                if (self.hasOAuthToken()) {
                    self.OAuthTokenCompletionHandler?(nil)
                } else {
                    let error = GitHubAPIManagerError.authCouldNot(reason: kMessageFailToObtainToken)
                    self.OAuthTokenCompletionHandler?(error)
                }
        }
    }
    
    func extrctCodeFromOauthStep1Response(_ url: URL) -> String? {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        var code: String?
        guard let queryItems = components?.queryItems else {
            return nil
        }
        for queryItem in queryItems {
            if (queryItem.name.lowercased() == "code") {
                code = queryItem.value
                break
            }
        }
        return code
    }
    
    func parseOAuthTokenResponse(_ json: [String: String]) -> String? {
        var token: String?
        for (key, value) in json {
            switch key {
            case "access_token":
                token = value
                print("Got Token: \(token ?? "no token")")
            case "scope":
                // TODO: verify scope
                print("SET SCOPE")
                print("key: \(key), scope: \(value)")
            case "token_type":
                // TODO: verify is bearer
                print("CHECK IF BEARER")
            default:
                print("got more than I expected from the OAuth token exchange")
                print(key)
            }
        }
        return token
    }
    
    // MARK: - API Calls
    // MARK: fundamental
    
    func fetch<T: ResultProtocol>(_ urlRequest: URLRequestConvertible, completionHandler: @escaping (Result<[T]>, String?) -> Void) {
        Alamofire.request(urlRequest)
            .responseJSON { response in
                
                if let urlResponse = response.response,
                    let authError = self.checkUnauthorized(urlResponse: urlResponse) {
                    completionHandler(.failure(authError), nil)
                    return
                }
                let result: Result<[T]> = self.arrayFromResponse(response: response)
                let next = self.parseNextPageFromHeaders(response: response.response)
                completionHandler(result, next)
        }
    }
    
    private func arrayFromResponse<T: ResultProtocol>(response: DataResponse<Any>) -> Result<[T]> {
        guard response.result.error == nil else {
            return .failure(GitHubAPIManagerError.network(error: response.result.error!))
        }
        
        // make sure we got JSON and it's an array
        if let jsonArray = response.result.value as? [[String: Any]] {
            var datas = [T]()
            for item in jsonArray {
                if let data = T(json: item) {
                    datas.append(data)
                }
            }
            return .success(datas)
        } else if let jsonData = response.result.value as? [String: Any], let data: T = T(json: jsonData) {
            return .success([data])
        } else if let jsonDictionary = response.result.value as? [String: Any],
            let errorMessage = jsonDictionary["message"] as? String { return .failure(GitHubAPIManagerError.apiProvidedError(reason: errorMessage))
        } else {
            return .failure(GitHubAPIManagerError.apiProvidedError(reason: "something went wrong"))
        }
    }
    
    // MARK: - Helpers
//    func isAPIOnline(completionHandler: @escaping (Bool) -> Void) {
//        Alamofire.request(GistRouter.baseURLString)
//            .validate(statusCode: 200 ..< 300)
//            .response { response in
//                guard response.error == nil else {
//                    // no internet connection or GitHub API is down
//                    completionHandler(false)
//                    return
//                }
//                completionHandler(true)
//        }
//    }
    
    func checkUnauthorized(urlResponse: HTTPURLResponse) -> (Error?) {
        if (urlResponse.statusCode == 401) {
            self.OAuthToken = nil
            return GitHubAPIManagerError.authLost(reason: "Not Logged In")
        } else if (urlResponse.statusCode == 404) {
            return GitHubAPIManagerError.authLost(reason: "Not Found")
        } else if (urlResponse.statusCode >= 400 && urlResponse.statusCode < 500) { // TODO: describe this reason more kindly
            return GitHubAPIManagerError.apiProvidedError(reason: "400 error")
        }
        return nil
    }
    
    // MARK: - Pagination
    private func parseNextPageFromHeaders(response: HTTPURLResponse?) -> String? {
        guard let linkHeader = response?.allHeaderFields["Link"] as? String else {
            return nil
        }
        /* looks like: <https://...?page=2>; rel="next", <https://...?page=6>; rel="last" */
        // so split on ","
        let components = linkHeader.characters.split { $0 == "," }.map { String($0) }
        // now we have 2 lines like '<https://...?page=2>; rel="next"'
        for item in components {
            // see if it's "next"
            let rangeOfNext = item.range(of: "rel=\"next\"", options: [])
            guard rangeOfNext != nil else {
                continue
            }
            // this is the "next" item, extract the URL
            let rangeOfPaddedURL = item.range(of: "<(.*)>;",
                                              options: .regularExpression,
                                              range: nil,
                                              locale: nil)
            guard let range = rangeOfPaddedURL else {
                return nil
            }
            let nextURL = item.substring(with: range)
            // strip off the < and >;
            let start = nextURL.index(range.lowerBound, offsetBy: 1)
            let end = nextURL.index(range.upperBound, offsetBy: -2)
            let trimmedRange = start ..< end
            return nextURL.substring(with: trimmedRange)
        }
        return nil
    }
    
}
