class DFA {
    
    private var entry: DFAState
    private var allStates: Set<DFAState> = []
    
    var stateCounter = 2
    
    var allTransitions: Set<DFATransition> = []
    
    init(_ entry: DFAState) {
        
        self.entry = entry
        addState(entry)
        
        entry.id = 1
        entry.dfa = self
        
    }
    
    func getDFAState(with nfaStates: Set<NFAState>) -> DFAState {
        
        for dfaState in allStates {
            
            if dfaState.nfaStates == nfaStates {
                return dfaState
            }
            
        }
        
        let newState = DFAState(nfaStates, dfa: self)
        addState(newState)
        
        return newState
        
    }
    
    func addState(_ dfaState: DFAState) {
        allStates.insert(dfaState)
    }
    
}
