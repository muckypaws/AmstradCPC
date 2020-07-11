
;
         ORG  #a000                     ; GOLDMARKS 6128+ Update J.Brooks
start    ENT  $                         ; Search For Equiv Routines !
         LD   hl,#4000
loop
         INC  hl
         LD   a,h
         CP   #80
         RET  z
         LD   a,(hl)
         CP   #cd
         JR   nz,loop
         INC  hl
         INC  hl
         INC  hl
         LD   a,(hl)
         CP   #3e
         JR   nz,loop
         INC  (hl)
         LD   a,(hl)
         CP   #16
         JR   nz,loop
         INC  hl
         LD   a,(hl)
         CP   #cd
         JR   nz,loop
         INC  hl
         INC  hl
         INC  hl
         LD   a,(hl)
         CP   #57
         CALL z,printhl
         JR   loop
;
printhl
         LD   a,h
         CALL print
         LD   a,l
print
         PUSH af
         AND  #f0
         RRCA 
         RRCA 
         RRCA 
         RRCA 
         CALL print1
         POP  af
print1
         PUSH af
         AND  #f
         ADD  a,#30
         CP   #3a
         JR   c,print2
         ADD  a,7
print2
         CALL #bb5a
         POP  af
         RET  
