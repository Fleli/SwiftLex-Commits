let input =
"""
    identifier      :       [a-z]*
    number          :       [0-9]*
    space           :       [ ]
    control         :       [(){}=;:]
    equals          :       =&=
"""

try Generator.generate(with: input, directory: "/Users/frederikedvardsen/Desktop")
