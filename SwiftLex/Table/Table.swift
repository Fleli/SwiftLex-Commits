struct Table {
    
    private var simulatedDFA: [[Character : Int]] = []
    
    var entry = -1
    
    private var accepting: Set<Int> = []
    
    let specification: TokenSpecification
    
    var stringForTable: String {
        return "\(simulatedDFA)"
    }
    
    init(_ dfa: DFA, _ specification: TokenSpecification) {
        
        self.specification = specification
        
        var entry: Set<Int> = []
        var accepting: Set<Int> = []
        
        fillTable(dfa, &entry, &accepting)
        setEntryAndAccepting(entry, accepting)
        
    }
    
    func getStateAtTransition(for char: Character, in state: Int) -> Int {
        return simulatedDFA[state][char]  ??  0
    }
    
    func isAccepting(_ state: Int) -> Bool {
        return accepting.contains(state)
    }
    
    mutating
    private func fillTable(_ dfa: DFA, _ entry: inout Set<Int>, _ accepting: inout Set<Int>) {
        
        let transitions = dfa.allTransitions
        let count = dfa.stateCount + 1
        
        self.simulatedDFA = Array<[Character : Int]>(repeating: [:], count: count)
        
        transitions.forEach { transition in
            
            let oldState = transition.oldState.id
            let newState = transition.newState.id
            let character = transition.character
            
            simulatedDFA[oldState][character] = newState
            
            for (state) in [transition.oldState, transition.newState] {
                
                if (state.isEntry) {
                    entry.insert(state.id)
                }
                
                if (state.isAccepting) {
                    accepting.insert(state.id)
                }
                
            }
            
        }
        
    }
    
    mutating
    private func setEntryAndAccepting(_ entry: Set<Int>, _ accepting: Set<Int>) {
        
        guard entry.count == 1, let entry = entry.first else {
            fatalError("Something went wrong")
        }
        
        self.entry = entry
        self.accepting = accepting
        
    }
    
}
