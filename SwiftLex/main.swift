
let input =
"""
integer                 :           [0-9]*
integer                 :           0b[01][01]*|0x[0-9A-Fa-f][0-9A-Fa-f]*
@2 @self keyword        :           if|else|while|func|var|let|try|catch|for|in
@1 identifier           :           [a-zA-Z][a-zA-Z0-9_]*
@self control           :           [{}();:,.=!?@+*/%-\\[\\]]
@self ellipsis          :           ...
@self equals            :           ==
@discard space          :           [ \\n]
"""

// En av de neste prioriteringene bør være DFA minimization: Per nå vil hvert (62) tegn i [a-zA-Z0-9] ha egen state, med identiske
// transitions fra alle. Det betyr at space for n tegn i regex-range er O(n^2). Dersom hvert av de 62 tegnene merges til én
// state, vil det bare kreves 62 outputs fra én state, så da blir space-kompleksitet bare O(n), som drastisk vil redusere kompilerings-
// tid for produktet.

// I tillegg bør flere regex-operatorer legges til, spesielt '+' ("minst én") og [^...] ("hva som helst, utenom ...")
// Sistnevnte krever nok en smartere måte å gjøre NFA/DFA transitions på: Kanskje må det også være en transition for "ikke ..."?

try Generator.generate(with: input, directory: "/Users/frederikedvardsen/Desktop", fileName: "lexfile")
