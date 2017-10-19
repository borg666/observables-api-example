public class UsersResponse: ApiResponse {

    public required init<RESOURCE: BaseResource>(
        resourceType: RESOURCE.Type,
        httpResponse: HttpResponse) {
        super.init(resourceType: resourceType, httpResponse: httpResponse)
    }

    public override func isSuccess() -> Bool {
        if let _ = self.resource as? UsersResource, httpStatusCode == HttpStatusCode.ok {
            return true
        }
        return false
    }

}
