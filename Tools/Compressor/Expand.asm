
         ORG  #a000
         ENT  $
         LD   hl,#4000
         LD   de,0
ex2
         LD   a,(hl)
         INC  hl
         OR   a
         RET  z
         LD   c,a
         LD   b,a
         RES  7,b
ex3
         PUSH de
         PUSH hl
         LD   a,e
         AND  7
         ADD  a,a
         ADD  a,a
         ADD  a,a
         ADD  a,#c0
         LD   h,a
         LD   l,d
         PUSH hl
         LD   d,0
         SRL  e
         SRL  e
         SRL  e
         PUSH de
         POP  hl
         ADD  hl,hl
         ADD  hl,hl
         ADD  hl,de
         ADD  hl,hl
         ADD  hl,hl
         ADD  hl,hl
         ADD  hl,hl
         POP  de
         ADD  hl,de
         EX   de,hl
         POP  hl
         LD   a,(hl)
         LD   (de),a
         POP  de
         INC  d
         LD   a,d
         CP   80
         JR   nz,ex4
         LD   d,0
         INC  e
ex4
         BIT  7,c
         JR   nz,ex5
         INC  hl
ex5
         DJNZ ex3
         BIT  7,c
         JR   z,ex2
         INC  hl
         JR   ex2