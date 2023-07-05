
let input =
"""
integer             :       [0-9]*
@self keyword       :       if|else|while|func|var|let|try|catch
identifier          :       [a-zA-Z][a-zA-Z0-9_]*
@self control       :       [{}();=]
@self equals        :       ==
@discard space      :       [ ]
"""

// Bør lage en attributt for precedence slik at try (keyword) utkonkurrerer try (identifier)

try Generator.generate(with: input, directory: "/Users/frederikedvardsen/Desktop", fileName: "lexfile")
