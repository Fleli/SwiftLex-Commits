class NFAState: CustomStringConvertible, Hashable {
    
    static func == (lhs: NFAState, rhs: NFAState) -> Bool {
        return lhs === rhs
    }
    
    var description: String { "\(id)" }
    
    let id = Int.random(in: 10_000 ..< 100_000)
    
    var transitions: [NFATransition] = []
    
    func addTransition(to newState: NFAState, at character: Character?) {
        
        let transition = NFATransition(character: character, newState: newState, fromState: self)
        transitions.append(transition)
        
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
