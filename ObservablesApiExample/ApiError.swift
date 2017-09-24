public enum NetworkErrorDetailType: String {
    case network = "network"
    case server = "server"
    case client = "client"
    case invalidCredentials = "invalidCredentials"
    case unknown = "unknown"
}

public struct NetworkErrorDetail: Equatable {

    public private(set) var type: NetworkErrorDetailType!
    public private(set) var statusCode: Int!
    public private(set) var serverMessage: String!
    public private(set) var defaultMessage: String!

    private init() {
    }

    public init(statusCode: Int, serverMessage: String) {
        self.statusCode = statusCode
        self.serverMessage = serverMessage
    }

    fileprivate init(type: NetworkErrorDetailType, statusCode: Int, message: String, defaultMessage: String) {
        self.type = type
        self.statusCode = statusCode
        self.serverMessage = message
        self.defaultMessage = defaultMessage
    }

    public static func == (lhs: NetworkErrorDetail, rhs: NetworkErrorDetail) -> Bool {
        return lhs.type == rhs.type
    }
}


protocol NetworkErrorDetailable {
    var detail: NetworkErrorDetail { get }
}

public enum ApiError: NetworkErrorDetailable, Error {

    case network(NetworkErrorDetail)
    case server(NetworkErrorDetail)
    case client(NetworkErrorDetail)
    case invalidCredentials(NetworkErrorDetail)
    case unknown(NetworkErrorDetail)

    public var detail: NetworkErrorDetail {
        switch self {
        case .network(let errorDetail):
            return NetworkErrorDetail(
                type: NetworkErrorDetailType.network,
                statusCode: errorDetail.statusCode,
                message: errorDetail.serverMessage,
                defaultMessage: "No network connection!")
        case .server(let errorDetail):
            return NetworkErrorDetail(
                type: NetworkErrorDetailType.server,
                statusCode: errorDetail.statusCode,
                message: errorDetail.serverMessage,
                defaultMessage: "Something is not working, it is our fault!")
        case .client(let errorDetail):
            return NetworkErrorDetail(type: NetworkErrorDetailType.client,
                                      statusCode: errorDetail.statusCode,
                                      message: errorDetail.serverMessage,
                                      defaultMessage: "Request error")
        case .invalidCredentials(let errorDetail):
            return NetworkErrorDetail(type: NetworkErrorDetailType.invalidCredentials,
                                      statusCode: errorDetail.statusCode,
                                      message: errorDetail.serverMessage,
                                      defaultMessage: "Invalid email or password!")
        case .unknown(let errorDetail):
            return NetworkErrorDetail(type: NetworkErrorDetailType.unknown,
                                      statusCode: errorDetail.statusCode,
                                      message: errorDetail.serverMessage,
                                      defaultMessage: "Something went wrong, please try again!")
        }
    }
}

