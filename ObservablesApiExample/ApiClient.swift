import Foundation
import Alamofire
import RxSwift

public class ApiClient {
    
    internal var httpClient: HttpClient = HttpClient()
    
    public init() {
    }
    
    public func request(with apiRequest: ApiRequest) -> Observable<ApiResponse> {
        return httpClient.request(urlRequest: apiRequest)
            .flatMap { httpResponse in
                return Observable<ApiResponse>.create { observer  in
                    if httpResponse.error == nil {
                        let apiResponse: ApiResponse = apiRequest.createApiResponse(httpResponse: httpResponse)
                        if try! apiResponse.isSuccess() {
                            observer.onNext(apiResponse)
                            observer.onCompleted()
                        } else {
                            observer.onError(apiResponse.createApiErrorOnFail())
                        }
                    } else {
                        let errorDetail: NetworkErrorDetail = NetworkErrorDetail(
                            statusCode: HttpStatusCode.undefined.rawValue,
                            serverMessage: httpResponse.error.debugDescription)
                        observer.onError(ApiError.network(errorDetail))
                    }
                    return Disposables.create()
                }
        }
    }
}
