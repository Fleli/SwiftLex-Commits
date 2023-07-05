extension Generator {
    
    func assembleTokenStruct() -> String {
        
        return """
        public struct Token {
            
            public var type: String
            public var content: String
            
        }
        """
        
    }
    
}
