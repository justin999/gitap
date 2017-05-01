final class GitHubAPI {
    // MARK: - Repos
    struct SearchRepositories : GitHubRequest {
        let keyword: String
        
        // GitHubRequestが要求する連想型
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
        let params: [String: Any]
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
            return nil
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
//
//    struct SearchUsers : GitHubRequest {
//        let keyword: String
//        
//        typealias Response = SearchResponse<User>
//        
//        var method: HTTPMethod {
//            return .get
//        }
//        
//        var path: String {
//            return "/search/users"
//        }
//        
//        var parameters: Any? {
//            return ["q": keyword]
//        }
//    }
}
