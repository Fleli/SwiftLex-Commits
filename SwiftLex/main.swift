
/*
 
 String     ->      Regex               Parsing                         parse
 Regex      ->      NFA                 Thompson's construction         generateNFA
 NFA        ->      DFA                 Subset Construction             generateDFA
 
 */

let input = "a*&(b|c)"

print("Input:", input, "\n")

let regex = try input.parse()

print("Regex:", regex, "\n")

let nfa = regex.generateNFA()
nfa.tellEntryAndAccepting()

print("NFAEntryClosure:", nfa.entry.epsilonClosure(), "\n")
NFATransition.allTransitions.forEach { print($0) }

let dfa = nfa.generateDFA()

print("\nDFA Transitions:", dfa.allTransitions.count)
dfa.allTransitions.forEach { print($0) }

let table = Table(dfa)

print("")
table.print()
print("\n")
