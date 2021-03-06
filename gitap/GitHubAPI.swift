final class GitHubAPI {
    // MARK: - Repos
    struct SearchRepositories : GitHubRequest {
        let keyword: String
        
        typealias Response = SearchResponse<Repo>
        
        var method: HTTPMethod {
            return .get
        }
        
        var path: String {
            return "/search/repositories"
        }
        
        var parameters: Any? {
            return ["q": keyword]
        }
    }
    
    struct ListUserRepositories: GitHubRequest {
        typealias Response = RootUserResponse<Repo>
        var method: HTTPMethod {
            return .get
        }
        var path: String {
            return "/user/repos"
        }
        var parameters: Any? {
            return nil
        }
        
    }
    
    // MARK: - Issues
    struct CreateIssue: GitHubRequest {
        let params: [String: Any?]
        typealias Response = Issue
        var path: String {
            if let owner = params["owner"] as? String, let repo = params["repo"] as? String {
                return "/repos/\(owner)/\(repo)/issues"
            } else {
                return ""
            }
        }
        var method: HTTPMethod {
            return .post
        }
        var parameters: Any? {
            return params
        }
    }
    
    // MARK: - User
    struct FetchAuthenticatedUser: GitHubRequest {
//        typealias Response = SearchResponse<User>
        typealias Response = User
        var method: HTTPMethod {
            return .get
        }
        var path: String {
            return "/user"
        }
        var parameters: Any? {
            return nil
        }
    }
    
    // https://developer.github.com/v3/oauth_authorizations/#revoke-a-grant-for-an-application
    struct DeleteAuthorization: GitHubRequest {
        typealias Response = ApiResponseData
        var method: HTTPMethod {
            return .delete
        }
        var path: String {
            let clientId    = Configs.github.clientId
            let accessToken = GitHubAPIManager.shared.OAuthToken!
            return "/applications/\(clientId)/grants/\(accessToken)"
        }
        var parameters: Any? {
            return nil
        }
    }
}
