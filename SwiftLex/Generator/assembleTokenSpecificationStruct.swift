extension Generator {
    
    func assembleTokenSpecificationStruct() -> String {
        
        return """
        private struct TokenSpecification {
            
            let type: String
            let regex: String
            
            init(_ type: String, _ regex: String) {
                
                self.type = type
                self.regex = regex
                
            }
            
        }
        """
        
    }
    
}
