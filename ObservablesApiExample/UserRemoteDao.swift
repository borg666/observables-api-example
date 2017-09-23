import RxSwift

public class UserRemoteDao {

    private var apiClient: ApiClient = ApiClient()

    public func findAllUsers(with usersRequest: UsersRequest) -> Observable<UsersResponse> {
        return apiClient.request(with: usersRequest)
            .map { apiResponse in
                return apiResponse as! UsersResponse
        }
    }
}
