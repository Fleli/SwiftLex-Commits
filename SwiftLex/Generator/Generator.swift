import Foundation

class Generator {
    
    private var tokenSpecifications: [TokenSpecification] = []
    private var tables: [Table] = []
    private let directory: String
    
    public static func generate(with lexSpecification: String, directory: String, fileName: String = "lexfile") throws {
        let _ = try Generator(lexSpecification, directory: directory, fileName)
    }
    
    private init(_ lexSpecification: String, directory: String, _ fileName: String) throws {
        
        self.directory = directory
        
        try parse(lexSpecification)
        try generateTables()
        
        let lexerFile = self.generateLexer(with: tables, fileName: fileName)
        
        createFiles((fileName, lexerFile))
        
    }
    
    private func parse(_ lexSpecification: String) throws {
        
        let lines = lexSpecification.split(separator: "\n")
        
        for line in lines {
            try parseLine(line)
        }
        
    }
    
    private func parseLine(_ line: Substring) throws {
        
        let split = try findTypeAndRegex(line)
        
        let specificationPrecedence = split.specificationPrecedence
        let attributes = split.attributes
        let type = split.type
        let regex = split.regex
        
        let specification = TokenSpecification(specificationPrecedence, type, regex, attributes)
        
        tokenSpecifications.append(specification)
        
    }
    
    private func findTypeAndRegex(_ line: Substring) throws -> (specificationPrecedence: Int, attributes: [TokenSpecificationAttribute], type: String, regex: String) {
        
        let split = line.split(separator: ":", maxSplits: 1, omittingEmptySubsequences: false)
        
        guard split.count == 2 else {
            throw LexError.wrongInputFormat
        }
        
        var specificationPrecedence = 0
        
        let lhsTrimmed = split[0].trimmingCharacters(in: .whitespaces)
        let lhsArray = try lhsArray(of: lhsTrimmed)
        
        let type = String(lhsArray.last!)
        
        var attributes: [TokenSpecificationAttribute] = []
        
        for (index) in (0 ..< lhsArray.count - 1) {
            
            let string = String(lhsArray[index])
            
            switch string {
                
            case "@discard":    attributes.append(.discard)
            case "@self":       attributes.append(.selfType)
            case var string:
                
                guard (string.count > 0), (string.removeFirst() == "@"), let precedence = Int(string) else {
                    throw LexError.wrongInputFormat
                }
                
                specificationPrecedence = precedence
                
            }
            
        }
        
        let regex = split[1].trimmingCharacters(in: .whitespaces)
        
        guard type.count > 0, regex.count > 0 else {
            throw LexError.tooShort
        }
        
        return (specificationPrecedence, attributes, type, regex)
        
    }
    
    private func lhsArray(of trimmed: String) throws -> [Substring] {
        
        let array = trimmed.split(separator: " ")
        
        guard (array.count > 0) else {
            throw LexError.wrongInputFormat
        }
        
        return array
        
    }
    
    private func generateTables() throws {
        
        for specification in tokenSpecifications {
            try generateTable(for: specification)
        }
        
    }
    
    private func generateTable(for specification: TokenSpecification) throws {
        
        let input = specification.regex
        
        let table = try input
            .parse()
            .generateNFA()
            .generateDFA()
            .generateTable(with: specification)
        
        tables.append(table)
        
    }
    
    private func createFiles(_ files: (name: String, content: String) ...) {
        
        let manager = FileManager()
        
        for file in files {
            
            let path = directory + "/\(file.name).swift"
            let result = manager.createFile(atPath: path, contents: file.content.data(using: .ascii))
            
            print("Created \(file.name): \(result)")
            
        }
        
    }
    
}
