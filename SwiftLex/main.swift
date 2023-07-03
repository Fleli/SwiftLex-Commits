
/*
 
 String     ->      Regex               Parsing                         parse
 Regex      ->      NFA                 Thompson's construction         generateNFA
 NFA        ->      DFA                 Subset Construction             generateDFA
 
 */


let input = "a|b"

print("Input:", input, "\n")

let regex = try input.parse()

print("Regex:", regex, "\n")

let nfa = regex.generateNFA()

print(nfa.entry.epsilonClosure())
