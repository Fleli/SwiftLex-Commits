
let input =
"""
@discard space          :       [ \\n]
@self keyword           :       let|var
identifier              :       [a-zA-Z_][a-zA-Z0-9_]*
@self special           :       [=:;,.{}\\[\\]()+*/%-]
integer                 :       [0-9]*
integer                 :       0b[01][01]*
integer                 :       0x[0-9A-Fa-f][0-9A-Fa-f]*
"""

// En av de neste prioriteringene bør være DFA minimization: Per nå vil hvert (62) tegn i [a-zA-Z0-9] ha egen state, med identiske
// transitions fra alle. Det betyr at space for n tegn i regex-range er O(n^2). Dersom hvert av de 62 tegnene merges til én
// state, vil det bare kreves 62 outputs fra én state, så da blir space-kompleksitet bare O(n), som drastisk vil redusere kompilerings-
// tid for produktet.

// I tillegg bør flere regex-operatorer legges til, spesielt '+' ("minst én")
try Generator.generate(with: input, directory: "/Users/frederikedvardsen/Desktop/", fileName: "Lexer")

