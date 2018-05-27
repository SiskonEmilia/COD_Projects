1. addi: r1 = r0 + 1, r0 = 0, r1 = 1
1. add: r0 = r1 + r1, r1 = 1, r0 = 2
1. sub: r0 = r0 - r1, r1 = 1, r0 = 1
1. ori: r0 = r0 | b'1000000000000000, r0 = 1000000000000001
1. and: r0 = r0 & r1, r0 = 0000000000000001
1. or:  r0 = r0 | r2, r0 = 0000000000000000
1. sll: r1 = r1 << r1, r1 = 0000000000000010
1. slti: r1 = r1 < 3, r1 = 1
1. sw: memory[0] = r1
1. lw: r1 = memory[0]
1. beq: r0 == r2. immediate = 1
1. halt
1. bneq: r0 != r1, immediate = 1
1. halt
1. beq: r0 == r1, imeediate = 1
1. halt
1. add: r0 = r1 + r1, r1 = 1, r0 = 2