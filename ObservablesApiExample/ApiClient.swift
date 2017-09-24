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
                return Observable<ApiResponse>.create { [weak self] observer  in
                    if httpResponse.error == nil {
                        var observerMutable: AnyObserver<ApiResponse> = observer
                        self?.mapResponse(
                            observer: &observerMutable,
                            httpResponse: httpResponse,
                            apiRequest: apiRequest)
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

    private func mapResponse(
        observer: inout AnyObserver<ApiResponse>,
        httpResponse: HttpResponse,
        apiRequest: ApiRequest) {
        let apiResponse: ApiResponse = apiRequest.createApiResponse(httpResponse: httpResponse)
        let httpStatusCode: Int = apiResponse.httpStatusCode?.rawValue ?? HttpStatusCode.undefined.rawValue

        if try! apiResponse.isSuccess() {
            observer.onNext(apiResponse)
            observer.onCompleted()
        } else if apiResponse.hasClientError() {
            observer.onError(ApiError.client(NetworkErrorDetail(
                statusCode: httpStatusCode,
                serverMessage: httpResponse.error.debugDescription)))
        } else if apiResponse.hasServerError() {
            observer.onError(ApiError.server(NetworkErrorDetail(
                statusCode: httpStatusCode,
                serverMessage: httpResponse.error.debugDescription)))
        } else {
            observer.onError(ApiError.unknown(NetworkErrorDetail(
                statusCode: httpStatusCode,
                serverMessage: httpResponse.error.debugDescription)))
        }
    }

}
