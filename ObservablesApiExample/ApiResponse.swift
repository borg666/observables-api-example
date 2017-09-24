import SwiftyJSON

open class ApiResponse {

    public private(set) var resource: BaseResource?
    public private(set) var httpStatusCode: HttpStatusCode = HttpStatusCode.undefined

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
        if let data: Data = data, data.count > 0 {
            return true
        }
        return false
    }

    public func hasClientError() -> Bool {
        return HttpStatusCode.clientErrorsGroup.contains(httpStatusCode.rawValue)
    }

    public func hasServerError() -> Bool {
        return HttpStatusCode.serverErrorsGroup.contains(httpStatusCode.rawValue)
    }

    private func serverErrorMessage() -> String {
        return resource?.serverErrorMessage ?? ""
    }

    public func createApiErrorOnFail() -> ApiError {
        if hasClientError() {
            return ApiError.client(NetworkErrorDetail(
                statusCode: httpStatusCode.rawValue,
                serverMessage: serverErrorMessage()))
        } else if hasServerError() {
            return ApiError.server(NetworkErrorDetail(
                statusCode: httpStatusCode.rawValue,
                serverMessage: serverErrorMessage()))
        } else {
            return ApiError.unknown(NetworkErrorDetail(
                statusCode: httpStatusCode.rawValue,
                serverMessage: serverErrorMessage()))
        }
    }
}
