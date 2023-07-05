enum TokenSpecificationAttribute: CustomStringConvertible {
    
    case discard
    
    var description: String {
        switch self {
        case .discard:
            return ".discard"
        }
    }
    
}
