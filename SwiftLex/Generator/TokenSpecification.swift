struct TokenSpecification {
    
    let type: String
    let regex: String
    
    var initializerString: String { "TokenSpecification(\"\(type)\", \"\(regex)\")" }
    
    init(_ type: String, _ regex: String) {
        
        self.type = type
        self.regex = regex
        
    }
    
}
