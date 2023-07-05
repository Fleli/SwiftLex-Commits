
let input =
"""
integer                 :           [0-9]*
@2 @self keyword        :           if|else|while|func|var|let|try|catch
@1 identifier           :           [a-zA-Z][a-zA-Z0-9_]*
@self control           :           [{}();=]
@self equals            :           ==
@discard space          :           [ ]
"""

try Generator.generate(with: input, directory: "/Users/frederikedvardsen/Desktop", fileName: "lexfile")
