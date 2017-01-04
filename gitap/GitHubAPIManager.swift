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

enum GitHubAPIManagerError: Error {
    case network(error: Error)
    case apiProvidedError(reason: String)
    case authCouldNot(reason: String)
    case authLost(reason: String)
    case objectSerialization(reason: String)
}

let kKeyChainGitHub = "github"
let kMessageFailToObtainToken: String = "Could not obtain an OAuth token"

class GitHubAPIManager {
    static let sharedInstance = GitHubAPIManager()
    
    var isLoadingOAuthToken: Bool = false
    var OAuthTokenCompletionHandler:((Error?) -> Void)?
    var OAuthToken: String? {
        set {
            guard let newValue = newValue else {
                let _ = try? Locksmith.deleteDataForUserAccount(userAccount: kKeyChainGitHub)
                return
            }
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
    
    // MARK: - OAuth flow
    func URLToStartOAuth2Login() -> URL? {
        // TODO: change the state for production
        let authPath: String = "https://github.com/login/oauth/authorize" +
        "?client_id=\(clientID)&scope=gist&state=TEST_STATE"
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
        
//        Alamofire.request(getTokenPath, method: .post, parameters: tokenParams, encoding)
        Alamofire.request(getTokenPath, method: .post, parameters: tokenParams, encoding: URLEncoding.default, headers: jsonHeader)
            .responseJSON { response in
                guard response.result.error == nil else {
                    print(response.result.error!)
                    self.isLoadingOAuthToken = false
                    let errorMessage = response.result.error?.localizedDescription ?? self.kMessageFailToObtainToken
                    let error = GitHubAPIManagerError.authCouldNot(reason: errorMessage)
                    self.OAuthTokenCompletionHandler?(error)
                    return
                }
                guard let value = response.result.value else {
                    print("no string received in response when swapping oauth code for token")
                    self.isLoadingOAuthToken = false
                    let error = GitHubAPIManagerError.authCouldNot(reason: self.kMessageFailToObtainToken)
                    self.OAuthTokenCompletionHandler?(error)
                    return
                }
                guard let jsonResult = value as? [String: String] else {
                    print("no data received or data not JSON")
                    self.isLoadingOAuthToken = false
                    let error = GitHubAPIManagerError.authCouldNot(reason: self.kMessageFailToObtainToken)
                    self.OAuthTokenCompletionHandler?(error)
                    return
                }
                
                self.OAuthToken = self.parseOAuthTokenResponse(jsonResult)
                self.isLoadingOAuthToken = false
                if (self.hasOAuthToken()) {
                    self.OAuthTokenCompletionHandler?(nil)
                } else {
                    let error = GitHubAPIManagerError.authCouldNot(reason: self.kMessageFailToObtainToken)
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
                print("Got Token: \(token)")
            case "scope":
                // TODO: verify scope
                print("SET SCOPE")
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
    
    // MARK: - Helpers
}
