class DFA {
    
    private var entry: DFAState
    private var allStates: Set<DFAState> = []
    
    init(_ entry: DFAState) {
        
        self.entry = entry
        addState(entry)
        
        entry.dfa = self
        
    }
    
    func getDFAState(with nfaStates: Set<NFAState>) -> DFAState {
        
        for dfaState in allStates {
            
            if dfaState.nfaStates == nfaStates {
                return dfaState
            }
            
        }
        
        let newState = DFAState(nfaStates)
        addState(newState)
        newState.dfa = self
        
        return newState
        
    }
    
    func addState(_ dfaState: DFAState) {
        
        allStates.insert(dfaState)
        
    }
    
}
