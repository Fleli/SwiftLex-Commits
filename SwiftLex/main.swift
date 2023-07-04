
/*
 
 String     ->      Regex               Parsing                         parse
 Regex      ->      NFA                 Thompson's construction         generateNFA
 NFA        ->      DFA                 Subset Construction             generateDFA
 
 */

let input = "(a|b)*"

print("Input:", input, "\n")

let regex = try input.parse()

print("Regex:", regex, "\n")

let nfa = regex.generateNFA()
nfa.tellEntryAndAccepting()

print("NFAEntryClosure:", nfa.entry.epsilonClosure(), "\n")
NFATransition.allTransitions.forEach { print($0) }

let dfa = nfa.generateDFA()

print("\nDFA Transitions:", DFATransition.allTransitions.count)
DFATransition.allTransitions.forEach { print($0) }


print("\n")
