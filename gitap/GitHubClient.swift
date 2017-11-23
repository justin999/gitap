import Foundation

class GitHubClient {
    private let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        return session
    }()

    func send<Request : GitHubRequest>(
        request: Request,
        completion: @escaping (Results<Request.Response, GitHubClientError>) -> Void)
    {
        let urlRequest = request.buildURLRequest()
        
        let task = session.dataTask(with: urlRequest) {
            data, response, error in
            
            switch (data, response, error) {
            case (_, _, let error?):
                completion(Results(error: .connectionError(error)))
            case (let data?, let response?, _):
                do {
                    let response = try request.response(from: data, urlResponse: response)
                    completion(Results(value: response))
                } catch let error as GitHubAPIError {
                    completion(Results(error: .apiError(error)))
                } catch {
                    completion(Results(error: .responseParseError(error)))
                }
            default:
                fatalError("invalid response combination \(data), \(response), \(error).")
            }
        }

        task.resume()
    }
}
