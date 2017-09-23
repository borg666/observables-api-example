import Foundation

public class HttpResponse {

    public let response: HTTPURLResponse?
    public let data: Data?
    public let error: Error?

    public init(response: HTTPURLResponse?, data: Data?, error: Error?) {
        self.response = response
        self.data = data
        self.error = error
    }
}
