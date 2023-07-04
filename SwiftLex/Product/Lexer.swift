
public class Lexer {
    
    private typealias SimulatorResult = (simulator: DFASimulator, lastAccepting: Int)
    
    private var index = 0
    private var currentStart = 0
    
    private var input: String = ""
    private var tokens: [Token] = []
    
    private var simulators: [DFASimulator] = [ /* Denne settes ved generering av filen, eller? */ ]
    
    init(_ tables: [Table]) {
        
        for table in tables {
            
            let simulator = DFASimulator(table)
            simulators.append(simulator)
            
        }
        
    }
    
    public func lex(_ input: String) -> [Token] {
        
        self.currentStart = 0
        self.index = 0
        
        self.input = input
        self.tokens = []
        
        print("\nIn lex\n")
        
        while (index < input.count) {
            
            print("In while loop: index = \(index), currentStart = \(currentStart)")
            
            let token = nextToken()
            tokens.append(token)
            
        }
        
        print("\nReturning \(tokens.count) tokens\n")
        
        return tokens
        
    }
    
    private func nextToken() -> Token {
        
        let maximalMunch = simulateDFAs()
        
        print("Max munch: \(maximalMunch.simulator.type) \(maximalMunch.lastAccepting)")
        
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
        
        print("DFA simulation: \(results)")
        
        let sortedResults = results.sorted { $0.lastAccepting > $1.lastAccepting }
        
        return sortedResults[0]
        
    }
    
    private func sliceInput(with index: Int, _ lastAccepting: Int) -> String {
        
        let startIndex = input.index(input.startIndex, offsetBy: index)
        let endIndex = input.index(input.startIndex, offsetBy: lastAccepting)
        
        print("Will slice with \(index) ..< \(lastAccepting)")
        
        let slice = input[startIndex ..< endIndex]
        
        return String(slice)
        
    }
    
    private func adjustIndices(_ result: SimulatorResult) {
        
        let lastAccepting = result.lastAccepting
        
        index = lastAccepting
        currentStart = lastAccepting
        
    }
    
}
