;
framefly                                ; Hardware Control Routines
         LD   b,#f5
framflya
         IN   a,(c)
         RRA  
         RET  c
         JR   framflya
scankey
         LD   b,a
         AND  7
         LD   c,a
         LD   a,1
         SRL  c
         JR   nc,scan1
         ADD  a,a
scan1
         SRL  c
         JR   nc,scan2
         ADD  a,a
         ADD  a,a
scan2
         SRL  c
         JR   nc,scan3
         ADD  a,a
         ADD  a,a
         ADD  a,a
         ADD  a,a
scan3
         LD   (bitmask+1),a
         LD   a,b
         SRL  a
         SRL  a
         SRL  a
         OR   #40
         LD   (rowsel+1),a
         LD   bc,#f792
         OUT  (c),c
         DEC  b
rowsel   LD   c,0
         IN   d,(c)
         OUT  (c),c
         LD   b,#f4
         IN   a,(c)
         LD   b,#f6
         OUT  (c),d
         LD   bc,#f782
         OUT  (c),c
bitmask  AND  0
         RET                            ; Quit Z If Pressed : NZ If Not Pressed
setmode
         AND  3
         OR   #8c
         EXX  
         LD   c,a
         LD   b,#7f
         OUT  (c),c
         EXX  
         RET  
setink                                  ; Entry A=Pen : B=Colour
         LD   c,a
         LD   l,b
         LD   h,0
         LD   de,hardinks
         ADD  hl,de
         LD   a,(hl)
         OR   #40
         LD   b,#7f
         OUT  (c),c
         OUT  (c),a
         RET  
putscr
         PUSH hl
         LD   hl,#771a
         LD   (csset),hl
         POP  hl
copyscr                                 ; Copy Section To REEL1BFD
         LD   de,reel1bfd
cs1
         PUSH bc
         PUSH hl
cs2
         SET  7,h
         SET  6,h
csset
         LD   a,(hl)
         LD   (de),a
         INC  hl
         INC  de
         DJNZ cs2
         POP  hl
         CALL addscr
         POP  bc
         DEC  c
         JR   nz,cs1
         LD   hl,#127e
         LD   (csset),hl
         RET  
cleanscr
         LD   hl,#c000
         LD   bc,#50d0
         XOR  a
wipeout                                 ; Entry HL=Address:A=Bck Col:B=Width:C=
         LD   (wp1),a
wip
         PUSH bc
         PUSH hl
wipeout1
         SET  7,h
         SET  6,h
         LD   (hl),0
wp1      EQU  $-1
         INC  hl
         DJNZ wipeout1
         POP  hl
         CALL addscr
         POP  bc
         DEC  c
         JR   nz,wip
         RET  
addscr
         LD   a,8
         ADD  a,h
         JR   nc,addscr1
         LD   a,#50
         ADD  a,l
         LD   l,a
         LD   a,#c8
         ADC  a,h
addscr1
         OR   #c0
         LD   h,a
         RET  
*f,modulecn.adm
