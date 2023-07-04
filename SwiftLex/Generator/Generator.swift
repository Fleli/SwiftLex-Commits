import Foundation

class Generator {
    
    var tokenSpecifications: [TokenSpecification] = []
    var tables: [Table] = []
    
    let directory: String
    
    var lexer: Lexer? = nil
    
    init(_ lexSpecification: String, directory: String) throws {
        
        self.directory = directory
        
        try parse(lexSpecification)
        try generateTables()
        
        self.lexer = Lexer(tables)
        
    }
    
    func lex(_ input: String) -> [Token] {
        return lexer!.lex(input)
    }
    
    private func parse(_ lexSpecification: String) throws {
        
        let lines = lexSpecification.split(separator: "\n")
        
        for line in lines {
            
            let typeAndRegex = try findTypeAndRegex(line)
            
            let type = typeAndRegex.type
            let regex = typeAndRegex.regex
            
            let specification = TokenSpecification(type, regex)
            
            tokenSpecifications.append(specification)
            
        }
        
        print("Specs {\n")
        
        tokenSpecifications.forEach { spec in
            print("\t" + spec.regex)
        }
        
        print("\n}")
        
    }
    
    private func findTypeAndRegex(_ line: Substring) throws -> (type: String, regex: String) {
        
        let split = line.split(separator: ":", maxSplits: 1, omittingEmptySubsequences: false)
        
        guard split.count == 2 else {
            throw LexError.wrongInputFormat
        }
        
        let type = split[0].trimmingCharacters(in: .whitespaces)
        let regex = split[1].trimmingCharacters(in: .whitespaces)
        
        guard type.count > 0, regex.count > 0 else {
            throw LexError.tooShort
        }
        
        return (type, regex)
        
    }
    
    private func generateTables() throws {
        
        for specification in tokenSpecifications {
            try generateTable(for: specification)
        }
        
    }
    
    private func generateTable(for specification: TokenSpecification) throws {
        
        let input = specification.regex
        
        let dfa = try input.parse().generateNFA().generateDFA()
        
        let table = Table(dfa, specification)
        
        tables.append(table)
        
    }
    
    private func createFiles(_ files: (name: String, content: String) ...) {
        
        for file in files {
            
            let manager = FileManager()
            
            let path = directory + "/\(file.name).swift"
            
            let result = manager.createFile(atPath: path, contents: file.content.data(using: .ascii))
            
        }
        
    }
    
}
