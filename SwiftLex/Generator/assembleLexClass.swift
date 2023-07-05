extension Generator {
    
    func assembleLexClass(_ stringOfSimulatorInitializers: String) -> String {
        
        return """
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
                    
                    if let token = nextToken() {
                        tokens.append(token)
                    }
                    
                }
                
                return tokens
                
            }
            
            private func nextToken() -> Token? {
                
                let maximalMunch = simulateDFAs()
                
                let attributes = maximalMunch.simulator.attributes
                let type = maximalMunch.simulator.type
                let content = sliceInput(with: index, maximalMunch.lastAccepting)
                
                adjustIndices(maximalMunch)
                
                if (attributes.contains(.discard)) {
                    return nil
                }
                
                if attributes.contains(.selfType) {
                    return Token(type: content, content: content)
                }
                
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
        """
        
    }
    
}
