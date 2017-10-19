import Alamofire
import RxSwift

public class HttpClient {

    public init() {
    }

    public func request2(urlRequest: URLRequestConvertible) -> Observable<HttpResponse> {
        let startTime: Date = Date()
        return Observable.create { observer in
            let queue: DispatchQueue = DispatchQueue(label: "http.client.queue", qos: DispatchQoS.background)
            let request = Alamofire.request(urlRequest)
                .response(queue: queue, completionHandler: { defaultDataResponse in
                    let httpResponse: HttpResponse = HttpResponse(
                        response: defaultDataResponse.response,
                        data: defaultDataResponse.data,
                        error: defaultDataResponse.error)
                     print("startTime.timeIntervalSinceNow=\(startTime.timeIntervalSinceNow)")
                    observer.onNext(httpResponse)
                    observer.onCompleted()
                })

            return Disposables.create(with: request.cancel)
        }
    }

    public func request(urlRequest: URLRequest) -> Observable<HttpResponse> {
        let startTime: Date = Date()
        return Observable.create { observer in
            let session: Foundation.URLSession = URLSession.shared
            let task: URLSessionDataTask = session.dataTask(
                with: urlRequest,
                completionHandler: { data, response, error in
                print( "++++++ describing response=\(data?.count)\n"
                    + "response=\(response as? HTTPURLResponse) error=\(error)")
                    print("thread=\(Thread.current.isMainThread)")

                    let httpResponse: HttpResponse = HttpResponse(
                    response: response as? HTTPURLResponse,
                    data: data,
                    error: error)

                     print("startTime.timeIntervalSinceNow=\(startTime.timeIntervalSinceNow)")
                observer.onNext(httpResponse)
                observer.onCompleted()
            })
            task.resume()
            return Disposables.create(with: task.cancel)
        }
    }




}
