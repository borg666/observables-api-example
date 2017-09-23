import UIKit
import RxSwift

class ViewController: UIViewController {

    var apiClient: ApiClient = ApiClient()
    let disposeBag: DisposeBag = DisposeBag()
    var userRemoteDao: UserRemoteDao = UserRemoteDao()

    override func viewDidLoad() {
        super.viewDidLoad()
        let users: Observable<UsersResponse> = userRemoteDao.findAllUsers(with: UsersRequest())
            .observeOn(MainScheduler.instance)

            users.subscribe(onNext: { (apiResponse) in
                print("onNext", apiResponse)
                print("isMainThread=\(Thread.current.isMainThread)")
            }, onError: { (error) in
                print("error", error)
            }, onCompleted: {
                print("onCompleted")
            }).addDisposableTo(disposeBag)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }




}

