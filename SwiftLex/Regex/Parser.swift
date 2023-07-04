extension String {
    
    func parse() throws -> Regex {
        
        let parser = Parser()
        
        return try parser.parse(self)
        
    }
    
}

class Parser {
    
    private var index = 0
    private var input = ""
    
    private var next: Character? { input[index] }
    
    func parse(_ input: String) throws -> Regex {
        
        self.input = input
        self.index = 0
        
        return try parse(3)
        
    }
    
    private func parse(_ depth: Int) throws -> Regex {
        
        if (depth == 0) {
            
            return try parseFactor()
            
        }
        
        var regex = try parse(depth - 1)
        
        while let operation = try getOperator(at: depth) {
            
            incrementIndex()
            
            if (operation == "*") {
                
                regex = RegexKleene(regex)
                
            } else {
                
                let arg2 = try parse(depth - 1)
                
                switch (operation) {
                    
                case "&":       regex = RegexConcatenation(regex, arg2)
                case "|":       regex = RegexAlternation(regex, arg2)
                default:        throw LexError.encounteredUnknown
                    
                }
                
            }
            
        }
        
        return regex
        
    }
    
    private func incrementIndex(_ number: Int = 1) {
        index += number
    }
    
    private func getOperator(at depth: Int) throws -> Character? {
        
        switch (depth, next) {
            
        case (1, "*"):      return "*"
        case (2, "&"):      return "&"
        case (3, "|"):      return "|"
        default:            return nil
            
        }
        
    }
    
    private func parseFactor() throws -> Regex {
        
        guard let next = next else {
            throw LexError.unexpectedEndOfInput
        }
        
        incrementIndex()
        
        if (next == "(") {
            
            let parenthesizedRegex = try parse(3)
            
            guard self.next == ")" else {
                throw LexError.unexpectedEndOfInput
            }
            
            incrementIndex()
            
            return parenthesizedRegex
            
        } else if (next == "[") {
            
            return try parseRangeDescription()
            
        }
        
        return RegexLiteral(literal: next)
        
    }
    
    private func parseRangeDescription() throws -> Regex {
        
        var chars: [Character] = []
        
        while let next = next, next != "]" {
            
            incrementIndex()
            
            chars.append(next)
            
        }
        
        if next == "]" {
            incrementIndex()
        } else {
            throw LexError.unexpectedEndOfInput
        }
        
        guard let first = chars.first else {
            throw LexError.wrongInputFormat
        }
        
        var regex: any Regex = RegexLiteral(literal: first)
        
        for (index) in (1 ..< chars.count) {
            let char = chars[index]
            let literal = RegexLiteral(literal: char)
            regex = RegexAlternation(regex, literal)
        }
        
        return regex
        
    }
    
    private func fillRange(_ range: inout [Character?]) {
        
        for (indexOffset) in (0 ... 2) {
            
            let index = self.index + indexOffset
            let character = self.input[index]
            
            range[indexOffset] = character
            
        }
        
    }
    
}
