;
dropr1
         LD   hl,row1tot
         LD   a,0
number1  EQU  $-1
         LD   de,row1bf+8
         LD   bc,row1c
         JR   dropfba
dropr2
         LD   hl,row2tot
         LD   a,0
number2  EQU  $-1
         LD   de,row2bf+8
         LD   bc,row2c
         JR   dropfba
dropr3
         LD   hl,row3tot
         LD   a,0
number3  EQU  $-1
         LD   de,row3bf+8
         LD   bc,row3c
dropfba
         LD   (drops1),de
         LD   (drops5),bc
         LD   b,a
         ADD  a,(hl)
         LD   (hl),a
         LD   a,b
         OR   a
dropfbs
         RET  z
         LD   hl,row1bf+8
drops1   EQU  $-2
         LD   b,9
         EX   af,af
dropr1b
         LD   a,b
         LD   (bft),a
         LD   a,(hl)
         OR   a
         JR   nz,dropr1d
         LD   (hl),#ff
         PUSH hl
         PUSH bc
         CALL row1c
drops5   EQU  $-2
         CALL bf
         POP  bc
         POP  hl
         LD   (hl),0
         DEC  hl
         DJNZ dropr1b
dropr1d
         LD   a,b
         CP   9
         RET  z
         INC  hl
         LD   (hl),#ff
         EX   af,af
         DEC  a
         JR   dropfbs
row1c
         LD   hl,row1bf
         LD   de,row1bfo
         LD   bc,setrow1
rowc
         LD   (rowca),bc
         LD   b,9
         LD   c,0
row1cl
         LD   a,(de)
         CP   (hl)
         CALL nz,setrow1
rowca    EQU  $-2
         INC  hl
         INC  de
         INC  c
         DJNZ row1cl
         RET  
row2c
         LD   hl,row2bf
         LD   de,row2bfo
         LD   bc,setrow2
         JR   rowc
row3c
         LD   hl,row3bf
         LD   de,row3bfo
         LD   bc,setrow3
         JR   rowc
resetf
         LD   a,(funcheld)
         OR   a
         RET  nz
         CALL checkmon
         RET  z
         CALL dpause
resetag
         CALL isany
         RET  z
         CALL gameff
         LD   de,#3ccf
         CALL setcs
         LD   hl,#cee0+#50
         LD   bc,#e12
         LD   a,#3c
         CALL swichgwa
         CALL setfuncc
         LD   hl,row1bfo
         LD   de,row1bfo+1
         LD   bc,26
         LD   (hl),#ff
         LDIR 
         LD   hl,row1bf+8
         LD   de,row2bf+8
         LD   bc,row3bf+8
         LD   a,9
resetf1
         PUSH af
         PUSH bc
         PUSH de
         PUSH hl
         XOR  a
         LD   (hl),a
         LD   (de),a
         LD   (bc),a
         CALL setfun1
         LD   a,5
         CALL pause
         POP  hl
         POP  de
         POP  bc
         POP  af
         DEC  hl
         DEC  de
         DEC  bc
         DEC  a
         JR   nz,resetf1
         LD   (row1tot),a
         LD   (row2tot),a
         LD   (row3tot),a
         LD   (funcheld),a
         JP   copyfunc
setrow1
         PUSH af
         PUSH bc
         PUSH de
         PUSH hl
         CALL colsetf
         CALL calcfadd
         LD   b,row1len
         LD   c,18
         CALL swichgwa
         POP  hl
         POP  de
         POP  bc
         POP  af
         RET  
setrow2
         PUSH af
         PUSH bc
         PUSH de
         PUSH hl
         CALL colsetf
         CALL calcfadd
         LD   c,row2off
         ADD  hl,bc
         LD   b,row2len
         LD   c,18
         CALL swichgwa
         POP  hl
         POP  de
         POP  bc
         POP  af
         RET  
setrow3
         PUSH af
         PUSH bc
         PUSH de
         PUSH hl
         CALL colsetf
         CALL calcfadd
         LD   c,row3off
         ADD  hl,bc
         LD   b,row3len
         LD   c,18
         CALL swichgwa
         POP  hl
         POP  de
         POP  bc
         POP  af
         RET  
colsetf
         CALL framefly
         LD   a,(hl)
         LD   (de),a
         OR   a
         LD   a,#c0
         RET  nz
         LD   a,0
         RET  
calcfadd                                ; Calculate Function Screen Address
         SLA  c
         LD   b,0
         LD   hl,funcadtb
         ADD  hl,bc
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         EX   de,hl
         RET  
setfuncc                                ; Set Function Colours For Col. Swap
         LD   de,#c000
         JP   setcs
isany
         LD   hl,row1bfo
         LD   b,3*9
isany1
         LD   a,(hl)
         OR   a
         RET  nz
         INC  hl
         DJNZ isany1
         RET  
*f,firmware.adm
