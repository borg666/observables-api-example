import RxSwift

class UserService {

    var userRemoteDao: UserRemoteDao = UserRemoteDao()

    func findAllUsers(with usersRequest: UsersRequest) -> Observable<[String]> {
        return userRemoteDao
            .findAllUsers(with: usersRequest)
            .map { ($0.resource as! UsersResource).names }
    }

}
