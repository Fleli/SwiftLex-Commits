extension Generator {
    
    func assembleTokenSpecificationStruct() -> String {
        
        return """
        private struct TokenSpecification {
            
            let type: String
            let regex: String
            let attributes: [TokenSpecificationAttribute]
            
            init(_ type: String, _ regex: String, _ attributes: [TokenSpecificationAttribute]) {
                
                self.type = type
                self.regex = regex
                self.attributes = attributes
                
            }
            
        }

        """
        
    }
    
}
