extension Generator {
    
    func assembleLexError() -> String {
        
        return """
        enum LexError: Error {
        
            case invalidCharacter
            
        }
        """
        
    }
    
}
