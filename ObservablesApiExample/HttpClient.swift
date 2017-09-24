import Alamofire
import RxSwift

public class HttpClient {

    public init() {
    }

    public func request(urlRequest: URLRequestConvertible) -> Observable<HttpResponse> {
        return Observable.create { observer in
            let queue: DispatchQueue = DispatchQueue(label: "http.client.queue", qos: DispatchQoS.background)
            let request = Alamofire.request(urlRequest)
                .response(queue: queue,completionHandler: { defaultDataResponse in
                    let httpResponse: HttpResponse = HttpResponse(
                        response: defaultDataResponse.response,
                        data: defaultDataResponse.data,
                        error: defaultDataResponse.error)
                    observer.onNext(httpResponse)
                    observer.onCompleted()
                })
            return Disposables.create(with: request.cancel)
        }
    }

}
