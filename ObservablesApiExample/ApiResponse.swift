import SwiftyJSON

open class ApiResponse {

    public private(set) var resource: BaseResource?
    public private(set) var httpStatusCode: HttpStatusCode?

    private init() {
    }

    public required init<RESOURCE: BaseResource>(resourceType: RESOURCE.Type, httpResponse: HttpResponse) {
        self.resource = createResourceOrReturnNil(resourceType: resourceType, data: httpResponse.data)
        self.httpStatusCode = HttpStatusCode.findOrReturnUndefined(statusCode:httpResponse.response?.statusCode)
    }

    open func isSuccess() throws -> Bool {
        throw ClassError.overrideMethodRequired
    }

    private func createResourceOrReturnNil<RESOURCE: BaseResource>(
        resourceType: RESOURCE.Type,
        data: Data?) -> BaseResource? {
        if hasData(withData: data) {
            return RESOURCE(data: data!)
        }
        return nil
    }

    private func hasData(withData data: Data?) -> Bool  {
        if let data = data, data.count > 0 {
            return true
        }
        return false
    }

    public func hasClientError() -> Bool {
        if let httpStatusCode: HttpStatusCode = self.httpStatusCode {
            return HttpStatusCode.clientErrorsGroup.contains(httpStatusCode.rawValue)
        }
        return false
    }

    public func hasServerError() -> Bool {
        if let httpStatusCode: HttpStatusCode = self.httpStatusCode {
            return HttpStatusCode.serverErrorsGroup.contains(httpStatusCode.rawValue)
        }
        return false
    }
}
