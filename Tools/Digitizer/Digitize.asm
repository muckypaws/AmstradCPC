         ORG  #a000                     ; Digitize Sounds
start    ENT  $
         DI   
         CALL motoron
         LD   ix,#c000
         LD   de,#4000
         CALL DIGITIZE
         CALL replay
         RET  
DIGITIZE
         LD   b,8
         XOR  a
digitz1
         CALL getbyte
         CALL pause
         RLA  
         DJNZ digitz1
         LD   (ix+0),a
         INC  ix
         DEC  de
         LD   a,d
         OR   e
         JR   nz,DIGITIZE
         LD   b,#f6
         OUT  (c),a
         RET  
pause
         LD   l,25
pause1
         DEC  l
         JR   nz,pause1
         RET  
getbyte
         PUSH bc
         LD   b,#f5
         IN   h,(c)
         RL   h
         CALL c,sc1
         CALL nc,sc2
         POP  bc
         RET  
sc1
         PUSH af
         PUSH bc
         LD   bc,#7f10
         LD   a,#44
         OUT  (c),c
         OUT  (c),a
         POP  bc
         POP  af
         RET  
sc2
         PUSH af
         PUSH bc
         LD   bc,#7f10
         LD   a,#54
         OUT  (c),c
         OUT  (c),a
         POP  bc
         POP  af
         RET  
replay
         CALL #bca7
         DI   
         LD   a,2
         LD   c,0
         CALL bd34
         LD   a,3
         LD   c,0
         CALL bd34
         LD   c,%111101
         LD   a,7
         CALL bd34
         DI   
         LD   hl,#c000
         LD   de,#4000
replay1
         LD   b,8
replay2
         PUSH bc
         RLC  (hl)
         CALL nc,sound1
         CALL c,sound0
         POP  bc
         DJNZ replay2
         INC  hl
         DEC  de
         LD   a,d
         OR   e
         JR   nz,replay1
         CALL #bca7
         RET  
sound1
         PUSH af
         LD   c,15
         LD   a,9
         CALL bd34
         LD   bc,#7f10
         LD   a,#44
         OUT  (c),c
         OUT  (c),a
         POP  af
         RET  
sound0
         PUSH af
         LD   c,0
         LD   a,9
         CALL bd34
         LD   bc,#7f10
         LD   a,#54
         OUT  (c),c
         OUT  (c),a
         POP  af
         RET  
bd34
         PUSH af
         LD   A,#C0
         LD   B,#F6
         OUT  (C),A
         LD   B,#F4
         POP  AF
         OUT  (C),A
         LD   B,#F6
         LD   A,#80
         OUT  (C),A
         LD   B,#F4
         OUT  (C),C
         RET  
         LD   B,#F6
         XOR  A
         OUT  (C),A
         RET  
motoron
         LD   bc,#f610
         OUT  (c),c
         LD   de,#800
motoron1
         CALL framefly
         DEC  de
         LD   a,d
         OR   e
         JR   nz,motoron1
         RET  
framefly
         LD   b,#f5
         IN   a,(c)
         RRA  
         RET  c
         JR   framefly
