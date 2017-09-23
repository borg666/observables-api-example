import Alamofire
import SwiftyJSON

public class UsersRequest: ApiRequest {

    public var apiResponse: UsersResponse.Type {
        get {
            return UsersResponse.self
        }
    }

    public init() {
    }

    public func isAuthTokenRequired() -> Bool {
        return false
    }

    public func getHttpRequestBody() -> Data? {
        return nil
    }

    public func getHttpRequestUrl() -> String {
        return "https://google.com"
    }

    public func getHttpMethod() -> Alamofire.HTTPMethod {
        return Alamofire.HTTPMethod.get
    }

    public func createApiResponse(httpResponse: HttpResponse) -> ApiResponse {
        return UsersResponse(resourceType: UsersResource.self, httpResponse: httpResponse)
    }

    public func serializeToJsonData(with dictionary: Dictionary<String, AnyObject>) -> Data? {
        return nil
    }

}
