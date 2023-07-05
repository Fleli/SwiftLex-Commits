extension Generator {
    
    func assembleTokenSpecificationStruct() -> String {
        
        return """
        private struct TokenSpecification {
            
            let type: String
            let regex: String
            let attributes: [TokenSpecificationAttribute]
            let specificationPrecedence: Int
            
            init(_ specificationPrecedence: Int, _ type: String, _ regex: String, _ attributes: [TokenSpecificationAttribute]) {
                
                self.specificationPrecedence = specificationPrecedence
                self.type = type
                self.regex = regex
                self.attributes = attributes
                
            }
            
        }


        """
        
    }
    
}
