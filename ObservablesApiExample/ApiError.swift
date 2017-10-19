public enum ApiErrorType: String {

    case network = "network"

    case server = "server"

    case client = "client"

    case invalidCredentials = "invalidCredentials"

    case unknown = "unknown"

}

public struct ApiErrorDetail: Equatable {

    public private(set) var type: ApiErrorType!
    public private(set) var statusCode: Int!
    public private(set) var serverMessage: String!
    public private(set) var defaultMessage: String!

    private init() {
    }

    public init(statusCode: Int, serverMessage: String) {
        self.statusCode = statusCode
        self.serverMessage = serverMessage
    }

    fileprivate init(type: ApiErrorType, statusCode: Int, message: String, defaultMessage: String) {
        self.type = type
        self.statusCode = statusCode
        self.serverMessage = message
        self.defaultMessage = defaultMessage
    }

    public static func == (lhs: ApiErrorDetail, rhs: ApiErrorDetail) -> Bool {
        return lhs.type == rhs.type
    }
}

public enum ApiError: Error {

    case network(ApiErrorDetail)

    case server(ApiErrorDetail)

    case client(ApiErrorDetail)

    case invalidCredentials(ApiErrorDetail)

    case unknown(ApiErrorDetail)

    public var detail: ApiErrorDetail {
        switch self {
        case .network(let errorDetail):
            return ApiErrorDetail(
                type: ApiErrorType.network,
                statusCode: errorDetail.statusCode,
                message: errorDetail.serverMessage,
                defaultMessage: "No network connection!")
        case .server(let errorDetail):
            return ApiErrorDetail(
                type: ApiErrorType.server,
                statusCode: errorDetail.statusCode,
                message: errorDetail.serverMessage,
                defaultMessage: "Something is not working, it is our fault!")
        case .client(let errorDetail):
            return ApiErrorDetail(
                type: ApiErrorType.client,
                statusCode: errorDetail.statusCode,
                message: errorDetail.serverMessage,
                defaultMessage: "Request error")
        case .invalidCredentials(let errorDetail):
            return ApiErrorDetail(
                type: ApiErrorType.invalidCredentials,
                statusCode: errorDetail.statusCode,
                message: errorDetail.serverMessage,
                defaultMessage: "Invalid email or password!")
        case .unknown(let errorDetail):
            return ApiErrorDetail(
                type: ApiErrorType.unknown,
                statusCode: errorDetail.statusCode,
                message: errorDetail.serverMessage,
                defaultMessage: "Something went wrong, please try again!")
        }
    }
}

