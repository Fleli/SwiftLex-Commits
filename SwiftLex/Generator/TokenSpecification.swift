struct TokenSpecification {
    
    let type: String
    let regex: String
    let attributes: [TokenSpecificationAttribute]
    
    var initializerString: String { "TokenSpecification(\"\(type)\", \"\(regex)\", \(attributes))" }
    
    init(_ type: String, _ regex: String, _ attributes: [TokenSpecificationAttribute]) {
        
        self.type = type
        self.regex = regex
        self.attributes = attributes
        
    }
    
}
