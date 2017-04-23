final class GitHubAPI {
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
