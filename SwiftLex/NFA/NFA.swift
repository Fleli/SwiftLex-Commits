class NFA {
    
    var entry: NFAState
    var accepting: NFAState
    
    init(entry: NFAState, accepting: NFAState) {
        
        self.entry = entry
        self.accepting = accepting
        
    }
    
}
