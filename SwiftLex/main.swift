let input =
"""
    identifier      :       [a-z]*
    number          :       [0-9]*
    space           :       [ ]
    control         :       [(){}=;:]
    equals          :       =&=
"""

// MERK: Ved 'if' vil keyword matches (i stedet for identifier) fordi keyword kommer først. Bør se på muligheter for å fine-tune dette.

let generator = try Generator(input, directory: "/Users/frederikedvardsen/Desktop")

let program = "if (x==6) { y=72; }"

let tokens = generator.lex(program)

print("Tokens:\n")
tokens.forEach { print("\t" + $0.type + "\t\t" + $0.content) }
print("")
