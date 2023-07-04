struct Table {
    
    var simulatedDFA: [[Character : Int]] = []
    
    var entry = -1
    var accepting: Set<Int> = []
    
    init(_ dfa: DFA) {
        
        var entry: Set<Int> = []
        var accepting: Set<Int> = []
        
        fillTable(dfa, &entry, &accepting)
        setEntryAndAccepting(entry, accepting)
        
    }
    
    mutating
    private func fillTable(_ dfa: DFA, _ entry: inout Set<Int>, _ accepting: inout Set<Int>) {
        
        let transitions = dfa.allTransitions
        
        self.simulatedDFA = Array<[Character : Int]>(repeating: [:], count: transitions.count)
        
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
    
    func print() {
        
        Swift.print(simulatedDFA)
        
        Swift.print("Simulated DFA (Table)")
        Swift.print("Entry is \(entry)")
        Swift.print("Accepting is \(accepting)")
        Swift.print("\nStates {")
        
        for (index) in (0 ..< table.simulatedDFA.count) {
            
            let state = table.simulatedDFA[index]
            
            Swift.print("\tState", index, "has transitions", state)
            
        }
        
        Swift.print("}")

    }
    
}
