;
skilcash                                ; Skill Cash Gaming Function
         CALL cashfals
         CALL resetwl
         LD   a,3
         LD   (functcnt),a
         SUB  a
         LD   (count1),a
         LD   (skcount),a
skla
         LD   b,240
skl0
         PUSH bc
         CALL flshcoin
         POP  bc
         DJNZ skl0
skl1
         LD   hl,trailfc+11
         LD   a,0
skcount  EQU  $-1
         CALL skupcont
         JR   c,skwin
         CALL skd
         JR   nc,skl1
skwin
         LD   a,(trailfc)
         OR   a
         JR   z,sklose
         LD   hl,skcount
         INC  (hl)
         CALL sklose1
         CALL updatewl
         JR   nz,skla
sklose
         CALL sklose1
         JP   cashfal8
sklose1
         CALL dpause
         JP   cleartf
skupcont
         RRCA 
         AND  3
         JR   z,scupx1
         DEC  a
         JR   z,scupx2
scupx3
         LD   b,4
         LD   a,3
         JR   skupd
scupx1
         LD   b,13
         LD   a,1
         JR   skupd
scupx2                                  ; Move Skill Climb Up !
         LD   b,7
         LD   a,2
skupd
         LD   (skupk),a
skup1
         LD   c,2
skupk    EQU  $-1
         CALL scupx
         CALL skret
         SCF  
         RET  z
         DJNZ skup1
         OR   a
         RET  
scupx
         RET  z
         LD   (hl),#ff
         DEC  c
         DEC  hl
         JR   scupx
skd
         LD   b,12
skd1
         LD   (hl),0
         INC  hl
         CALL skret
         SCF  
         RET  z
         DJNZ skd1
         OR   a
         RET  
skret
         PUSH bc
         PUSH hl
         CALL trailc
         POP  hl
         LD   a,18
         CALL scankey
         POP  bc
         RET  
;
*f,cashfall.adm
