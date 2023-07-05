
let input =
"""
integer         :       [0-9]*
identifier      :       [a-zA-Z][a-zA-Z0-9_]*
keyword         :       if|else|while|func|var|let|try|catch
control         :       [{}();=]
equals          :       ==
space           :       [ ]
"""

try Generator.generate(with: input, directory: "/Users/frederikedvardsen/Desktop", fileName: "Lex")
