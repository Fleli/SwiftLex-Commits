
let input =
"""
integer                 :           [0-9]*
integer                 :           (0x|0b)[0-9]*
@2 @self keyword        :           if|else|while|func|var|let|try|catch|for|in
@1 identifier           :           [a-zA-Z][a-zA-Z0-9_]*
@self control           :           [{}();:,.=!?@+*/%-]
@self ellipsis          :           ...
@self equals            :           ==
@discard space          :           [ ]
"""

// En av de neste prioriteringene bør være DFA minimization: Per nå vil hvert (62) tegn i [a-zA-Z0-9] ha egen state, med identiske
// transitions fra alle. Det betyr at space for n tegn i regex-range er O(n^2). Dersom hvert av de 62 tegnene merges til én
// state, vil det bare kreves 62 outputs fra én state, så da blir space-kompleksitet bare O(n), som drastisk vil redusere kompilerings-
// tid for produktet.

// Dessuten bør parsingen støtte escape sequences, f.eks. \]

try Generator.generate(with: input, directory: "/Users/frederikedvardsen/Desktop", fileName: "lexfile")
