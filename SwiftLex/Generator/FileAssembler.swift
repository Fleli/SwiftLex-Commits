extension Generator {
    
    func generateLexer(with tables: [Table]) -> String {
        
        var stringOfSimulatorInitializers = ""
        
        for table in tables {
            
            let initializerString = table.tableInitializerString
            
            let simulatorInitializer = "\t\tDFASimulator(\(initializerString)),\n"
            stringOfSimulatorInitializers += simulatorInitializer
            
        }
        
        stringOfSimulatorInitializers.removeLast(2)
        stringOfSimulatorInitializers.append("\n")
        
        let lexerClassString =
        
            """
            // Auto-generated lexer file.
            
            public class Lexer {
                
                private typealias SimulatorResult = (simulator: DFASimulator, lastAccepting: Int)
                
                private var index = 0
                private var currentStart = 0
                
                private var input: String = ""
                private var tokens: [Token] = []
                
                private var simulators: [DFASimulator] =
                [
            \(stringOfSimulatorInitializers)
                ]
                
                public func lex(_ input: String) -> [Token] {
                    
                    self.currentStart = 0
                    self.index = 0
                    
                    self.input = input
                    self.tokens = []
                    
                    while (index < input.count) {
                        
                        let token = nextToken()
                        tokens.append(token)
                        
                    }
                    
                    return tokens
                    
                }
                
                private func nextToken() -> Token {
                    
                    let maximalMunch = simulateDFAs()
                    
                    let type = maximalMunch.simulator.type
                    let content = sliceInput(with: index, maximalMunch.lastAccepting)
                    
                    adjustIndices(maximalMunch)
                    
                    return Token(type: type, content: content)
                    
                }
                
                private func simulateDFAs() -> SimulatorResult {
                    
                    var results: [SimulatorResult] = []
                    
                    for (simulator) in (simulators) {
                        let lastAccepting = simulator.simulateUntilDead(input, index)
                        results.append((simulator, lastAccepting))
                    }
                    
                    let sortedResults = results.sorted { $0.lastAccepting > $1.lastAccepting }
                    
                    return sortedResults[0]
                    
                }
                
                private func sliceInput(with index: Int, _ lastAccepting: Int) -> String {
                    
                    let startIndex = input.index(input.startIndex, offsetBy: index)
                    let endIndex = input.index(input.startIndex, offsetBy: lastAccepting)
                    
                    let slice = input[startIndex ..< endIndex]
                    
                    return String(slice)
                    
                }
                
                private func adjustIndices(_ result: SimulatorResult) {
                    
                    let lastAccepting = result.lastAccepting
                    
                    index = lastAccepting
                    currentStart = lastAccepting
                    
                }
                
            }
            
            private class DFASimulator {
                
                private let table: Table
                private var state: Int
                
                private var input: String = ""
                
                var type: String { table.specification.type }
                
                init(_ table: Table) {
                    self.table = table
                    self.state = table.entry
                }
                
                /// Returns the last accepting length
                func simulateUntilDead(_ input: String, _ index: Int) -> Int {
                    
                    reset()
                    
                    var index = index
                    var lastAccepting = 0
                    
                    self.input = input
                    
                    while (state > 0) {
                        
                        guard let char = self[index] else {
                            return lastAccepting
                        }
                        
                        state = table.getStateAtTransition(for: char, in: state)
                        
                        index += 1
                        
                        if table.isAccepting(state) {
                            lastAccepting = index
                        }
                        
                    }
                    
                    return lastAccepting
                    
                }
                
                private func reset() {
                    
                    state = table.entry
                    
                }
                
                private subscript(index: Int) -> Character? {
                    
                    guard index < input.count else { return nil }
                    
                    let stringIndex = input.index(input.startIndex, offsetBy: index)
                    return input[stringIndex]
                    
                }
                
            }
            
            public struct Token {
                
                public var type: String
                public var content: String
                
            }
            
            private struct Table {
                
                var simulatedDFA: [[Character : Int]] = []
                
                var entry = -1
                
                var accepting: Set<Int> = []
                
                let specification: TokenSpecification
                
                init(_ specification: TokenSpecification) {
                    
                    self.specification = specification
                    
                }
                
                init(_ simulatedDFA: [[Character : Int]], _ entry: Int, _ accepting: Set<Int>, _ specification: TokenSpecification) {
                    
                    self.simulatedDFA = simulatedDFA
                    self.entry = entry
                    self.accepting = accepting
                    self.specification = specification
                    
                }
                
                func getStateAtTransition(for char: Character, in state: Int) -> Int {
                    return simulatedDFA[state][char]  ??  0
                }
                
                func isAccepting(_ state: Int) -> Bool {
                    return accepting.contains(state)
                }
                
            }
            
            private struct TokenSpecification {
                
                let type: String
                let regex: String
                
                init(_ type: String, _ regex: String) {
                    
                    self.type = type
                    self.regex = regex
                    
                }
                
            }
            
            """
        
        return lexerClassString
        
    }
    
}
