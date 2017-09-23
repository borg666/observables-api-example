import SwiftyJSON

public protocol BaseResource {

    var serverErrorMessage: String { get set }

    init(data: Data)

    init(json: JSON)

    func map(from json: JSON)
}

