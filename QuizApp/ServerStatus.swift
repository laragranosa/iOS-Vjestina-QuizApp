enum ServerStatus: Int, CaseIterable {
    
    case UNAUTHORIZED = 401
    case FORBIDDEN = 403
    case NOT_FOUND = 404
    case BAD_REQUEST = 400
    case OK = 200
    var code: Int {
        return self.rawValue
    }
    
}
