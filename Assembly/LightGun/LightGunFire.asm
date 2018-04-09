
;
         ORG  #9000                     ; Read The Light Gun Fire Button
start    ENT  $                         ; Read Light Gun !
         LD   a,47                      ; Written By Jason Brooks
         CALL #bb1e
         RET  nz
;
         DI   
         LD   bc,#bc00
         LD   a,#11
         OUT  (c),a
         LD   bc,#bffe
         IN   e,(c)
         LD   bc,#fbfe
         LD   a,#7f
         OUT  (c),a
         INC  a
         OUT  (c),a
         LD   bc,#bffe
         IN   a,(c)
         CP   e
         JR   nz,start
fire
         LD   hl,mess
         CALL print
         JR   start
print
         LD   a,(hl)
         OR   a
         RET  z
         INC  hl
         CALL #bb5a
         JR   print
mess
         DEFB 13,10
         DEFM Fire !
         DEFB 13,10,0
;
