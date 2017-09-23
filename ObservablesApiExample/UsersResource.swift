import SwiftyJSON

public class UsersResource: BaseResource {

    public var serverErrorMessage: String = ""

    public private(set) var names: [String] = [String]()

    private init() {
    }

    required public init(data: Data) {
        let json = JSON(data: data)
        map(from: json)
    }

    required public init(json: JSON) {
        map(from: json)
    }

    public func map(from json: JSON) {
    }

}
