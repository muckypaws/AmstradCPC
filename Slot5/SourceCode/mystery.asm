;
mystery                                 ; Mystery Gaming Function
         LD   a,(mean)
         OR   a
         JR   z,mystery1
         LD   a,r
         AND  1
         ADD  a,17
         JR   mysteryc
mystery1                                ; Totally Random Mystery Function
         LD   a,r
         AND  15
         ADD  a,3
mysteryc
         LD   b,a
         DEC  a
         LD   (mystc1),a
         XOR  a
         DEC  a
         CALL myst1
         LD   a,b
         OR   a
         LD   a,#ff
         CALL nz,myst2
myst3                                   ; Clear Up All Unwanted Flags
         LD   b,0
mystc1   EQU  $-1
         XOR  a
         CALL myst1
         LD   a,b
         OR   a
         LD   a,0
         LD   (tsetg),a
         CALL nz,myst2
         LD   a,(mystc1)                ; Get Mystery Function Money/Game
         SUB  7
         JR   nc,myst4m                 ; Mystery Money !
         ADD  a,9
         LD   (functcnt),a
         SUB  a
         LD   (row1bf),a
         LD   (row2bf),a
         LD   (row3bf),a
         CALL setfuncc
         CALL setfun1
         JP   takeit
myst4m                                  ; How Much Have You Won ?
         LD   hl,gmoney
         OR   a
         JR   z,mystl1
mystl
         INC  hl
         DEC  a
         JR   nz,mystl
mystl1
         LD   a,(hl)
         LD   (lastwin),a
         CALL game0
         CALL gamble
         CALL incmoney
         JP   takeit1
myst1
         LD   hl,row1bf+1
         LD   c,0
myst1a
         PUSH hl
         PUSH bc
         PUSH af
         LD   de,9
         LD   (hl),a
         ADD  hl,de
         LD   (hl),a
         ADD  hl,de
         LD   (hl),a
         CALL framefly
         CALL setfuncc
         CALL setfun1
         CALL bf
         POP  af
         POP  bc
         POP  hl
         INC  hl
         INC  c
         LD   d,a
         LD   a,c
         LD   (bft),a
         CP   8
         LD   a,d
         RET  z
         DJNZ myst1a
         RET  
myst2                                   ; Money Control
         LD   hl,trailfc
         LD   c,0
myst2a
         PUSH hl
         PUSH bc
         PUSH af
         LD   (hl),a
         CALL framefly
         CALL trailc
         POP  af
         POP  bc
         POP  hl
         INC  hl
         INC  c
         EX   af,af
         LD   a,c
         CP   11
         RET  z
         EX   af,af
         DJNZ myst2a
         RET  
;
*f,spinawin.adm
