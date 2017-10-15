import Foundation

protocol GitHubRequest {
    associatedtype Response: JSONDecodable

    var baseURL: URL { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Any? { get }
}

extension GitHubRequest {
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }

    func buildURLRequest() -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var jsonData: Data? = nil
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)

        switch method {
        case .get:
            let dictionary = parameters as? [String : Any]
            let queryItems = dictionary?.map { key, value in
                return URLQueryItem(
                    name: key,
                    value: String(describing: value))
            }
            components?.queryItems = queryItems
        case .post:
            if let dictionary = parameters as? [String: Any] {
                jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            }
        default:
            fatalError("Unsupported method \(method)")
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.url = components?.url
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = jsonData
        
        if let token = GitHubAPIManager.shared.OAuthToken {
            urlRequest.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        }

        return urlRequest
    }

    func response(from data: Data, urlResponse: URLResponse) throws -> Response {
        // 取得したデータをJSONに変換
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        
        if case (200..<300)? = (urlResponse as? HTTPURLResponse)?.statusCode {
            // JSONからモデルをインスタンス化
            return try Response(json: json)
        } else {
            // JSONからAPIエラーをインスタンス化
            throw try GitHubAPIError(json: json)
        }
    }
}
