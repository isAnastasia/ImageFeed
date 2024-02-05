import Foundation

extension URLRequest {
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL = ApiConstants.defaultBaseURL
    ) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL) ?? ApiConstants.defaultBaseURL)
        request.httpMethod = httpMethod
        return request
    }
}
