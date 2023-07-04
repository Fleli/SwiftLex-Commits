let input =
"""
    keyword         :       i&f|e&l&s&e
    identifier      :       (a|b|c|d|e|f|i|u)*
    integer         :       (0|1|2)*
    space           :       [ ]
"""

// MERK: Ved 'if' vil keyword matches (i stedet for identifier) fordi keyword kommer først. Bør se på muligheter for å fine-tune dette.

let generator = try Generator(input, directory: "/Users/frederikedvardsen/Desktop")

let program = "du0111b1  if"

let tokens = generator.lex(program)

print("Tokens:\n")
tokens.forEach { print("\t" + $0.type + "\t\t" + $0.content) }
print("")
