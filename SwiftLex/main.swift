
let input =
"""
@discard space          :           [ \\n\\t]
@self keyword           :           private|public|if|else|class|struct|var|let
@self control           :           [:;.,{}\\[\\]\\(\\)!?<>+/|*-]
identifier              :           [A-Za-z_][A-Za-z_0-9]*
integer                 :           [0-9]*
"""
/* LEX SPECIFICATION FOR SWIFTPARSE
@discard space          :           [ \\n\\t]
@self keyword           :           enum|nested|class|precedence|infix|prefix|postfix|case|var|private|protected|public
@self control           :           [:;.,{}\\[\\]\\(\\)!?<>+/|*-]
nonTerminal             :           [A-Z][a-zA-Z]*
terminal                :           #[^ \\n][^ \\n]*
identifier              :           [a-z][A-Za-z]*
arrow                   :           ->
@self main              :           @main
"""
*/
 
// En av de neste prioriteringene bør være DFA minimization: Per nå vil hvert (62) tegn i [a-zA-Z0-9] ha egen state, med identiske
// transitions fra alle. Det betyr at space for n tegn i regex-range er O(n^2). Dersom hvert av de 62 tegnene merges til én
// state, vil det bare kreves 62 outputs fra én state, så da blir space-kompleksitet bare O(n), som drastisk vil redusere kompilerings-
// tid for produktet.

// I tillegg bør flere regex-operatorer legges til, spesielt '+' ("minst én")

try Generator.generate(with: input, directory: "/Users/frederikedvardsen/Desktop/", fileName: "Lexer")

