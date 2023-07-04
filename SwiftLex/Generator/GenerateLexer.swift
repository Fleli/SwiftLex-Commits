extension Generator {
    
    func generateLexer(_ tables: [Table]) -> String {
        
        var initialValueOfTables: String = "[\n"
        
        for table in tables {
            initialValueOfTables += "\t\t" + table.stringForTable + ",\n"
        }
        
        initialValueOfTables.removeLast(2)
        initialValueOfTables += "\n\t]"
        
        return """
        
        public class Lexer {
            
            private let tables: [[[Character : Int]]] = \(initialValueOfTables)
            
            public init() {
                
            }
            
        }
        
        """
        
    }
    
}
