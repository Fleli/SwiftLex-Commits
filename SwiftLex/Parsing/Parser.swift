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
        
        let char: Character?
        
        switch (depth, next) {
            
        case (_ , nil):                                                                                 char = nil
        case (1, "*"):                                                                                  char = "*"
        case (2, "&"):                                                                                  char = "&"
        case (3, "|"):                                                                                  char = "|"
        case (2 , let operation) where operation != "*" && operation != "&" && operation != "*":        char = "&"; index -= 1
        default:                                                                                        char = nil
            
        }
        
        return char
        
    }
    
    private func parseFactor() throws -> Regex {
        
        guard let next = next else {
            throw LexError.unexpectedEndOfInput("factor")
        }
        
        incrementIndex()
        
        if (next == "(") {
            
            let parenthesizedRegex = try parse(3)
            
            guard self.next == ")" else {
                throw LexError.unexpectedEndOfInput(")")
            }
            
            incrementIndex()
            
            return parenthesizedRegex
            
        } else if (next == "[") {
            
            let rangeDescribedRegex = try parseRangeDescription()
            
            guard self.next == "]" else {
                throw LexError.unexpectedEndOfInput("]")
            }
            
            incrementIndex()
            
            return rangeDescribedRegex
            
        }
        
        return RegexLiteral(literal: next)
        
    }
    
    private func parseRangeDescription() throws -> Regex {
        
        // På dette punktet er ikke next = [, men etter det igjen.
        
        var charsInRangeDescription: [Character] = []
        
        var buffer: [Character?] = [nil, nil, nil]
        
        fillBuffer(&buffer)
        
        while buffer[0] != "]" {
            
            switch ( buffer[0], buffer[1], buffer[2] ) {
                
            case (nil, nil, nil):
                
                throw LexError.unexpectedEndOfInput("] or chars")
                
            case (let start , "-" , let end) where (end != "]"):
                
                let chars = try getCharsInClosedRange(from: start!, to: end!)
                charsInRangeDescription += chars
                
                incrementIndex(3)
                
            case (let start , _ , _):
                
                guard let start = start else {
                    fatalError("")
                }
                
                charsInRangeDescription.append(start)
                incrementIndex()
                
            }
            
            fillBuffer(&buffer)
            
        }
        
        guard (charsInRangeDescription.count > 0) else {
            throw LexError.wrongInputFormat
        }
        
        let regex = produceRegexFrom(chars: charsInRangeDescription)
        
        return regex
        
    }
    
    private func fillBuffer(_ buffer: inout [Character?]) {
        
        for (offset) in (0 ... 2) {
            let char = input[index + offset]
            buffer[offset] = char
        }
        
    }
    
    private func getCharsInClosedRange(from start: Character, to end: Character) throws -> [Character] {
        
        guard let asciiStart = start.asciiValue, let asciiEnd = end.asciiValue, asciiStart <= asciiEnd else {
            throw LexError.wrongInputFormat
        }
        
        var chars: [Character] = []
        
        for (ascii) in (asciiStart ... asciiEnd) {
            
            let unicodeScalar = UnicodeScalar(ascii)
            let character = Character(unicodeScalar)
            
            chars.append(character)
            
        }
        
        return chars
        
    }
    
    private func produceRegexFrom(chars: [Character]) -> Regex {
        
        let first = chars[0]
        
        var regex: any Regex = RegexLiteral(literal: first)
        
        for (charIndex) in (1 ..< chars.count) {
            
            let char = chars[charIndex]
            let literal = RegexLiteral(literal: char)
            
            regex = RegexAlternation(regex, literal)
            
        }
        
        return regex
        
    }
    
}
