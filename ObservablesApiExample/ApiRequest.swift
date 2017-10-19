import Alamofire
import SwiftyJSON

public protocol ApiRequest {

    func asURLRequest() throws -> URLRequest

    func createApiResponse(httpResponse: HttpResponse) -> ApiResponse

    func getHttpRequestBody() -> Data?

    func getHttpRequestUrl() -> String

    func getHttpMethod() -> Alamofire.HTTPMethod

    func serializeToJsonData(with dictionary: Dictionary<String, AnyObject>) -> Data?

    func isAuthTokenRequired() -> Bool

}

extension ApiRequest {

    public func asURLRequest() throws -> URLRequest {
        let url: URL? = URL(string: getHttpRequestUrl())!
        if url == nil {
            throw ClassError.invalidArgument
        }
        var urlRequest: URLRequest = URLRequest(url: url!)
        urlRequest.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
        urlRequest.timeoutInterval = 30.0
        urlRequest.httpMethod = getHttpMethod().rawValue
        if let httpRequestBody: Data = getHttpRequestBody() {
            urlRequest.httpBody = httpRequestBody
        }
        return urlRequest
    }
}
