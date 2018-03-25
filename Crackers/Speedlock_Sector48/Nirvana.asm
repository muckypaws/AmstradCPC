;
         ORG  #a000                     ; Speedlock XOR routine
start
         ENT  $
         CALL #bd37
         LD   b,0
         LD   de,#c000
         CALL #bc77
         LD   (#be80),bc
         EX   de,hl
         CALL #bc83
         CALL #bc7a
         LD   hl,#c900
         LD   (#ac00),hl
         LD   hl,switch
         PUSH hl
         LD   hl,NEXT_XOR
         PUSH hl
         LD   hl,#40
         PUSH hl
         LD   hl,#1000
         PUSH hl
         LD   hl,(#be80)
         PUSH hl
         DI   
         LD   a,2
         RRA  
         LD   R,A
         POP  BC
         POP  HL
         LD   D,H
         LD   E,L
         POP  hl
         LD   A,I
         CALL PO,#AC00
         LD   A,R
         XOR  (HL)
         LD   (HL),A
         LDI  
         RET  PO
         DEC  SP
         DEC  SP
         RET  PE                        ; First XOR taken From Header
NEXT_XOR
         LD   B,D                       ; Next XOR Taken from First XOR
         LD   D,L
         LD   B,A
         LD   A,(HL)
         LD   C,A
         LD   B,(HL)
         LD   B,(HL)
         DEC  SP
         DEC  SP
         DEFB #fd,#26,#10
         DEFB #fd,#2e,#00
         POP  hl
         NOP  
         LD   BC,#2e
         ADD  IY,BC
         DEFB #fd,#5d
         DEFB #fd,#54
         LD   L,E
         LD   H,D
         LD   BC,#400
         LD   A,I
         CALL PO,#AC00
         LD   A,R
         XOR  (HL)
         LD   (HL),A
         LDI  
         RET  PO
         DEC  SP
         DEC  SP
         RET  PE
switch
         LD   BC,(#1302)
         LD   B,#8A
         LD   DE,#1000
loopy1
         PUSH BC
         LD   A,(DE)
         PUSH DE
         LD   DE,#379
         SUB  C
         LD   HL,#108A
loopy
         XOR  (HL)
         LD   (HL),A
         INC  HL
         DEC  E
         JP   NZ,loopy
         DEC  D
         JP   NZ,loopy
         POP  DE
         INC  DE
         POP  BC
         LD   C,A
         DEC  B
         JP   nz,loopy1
jason
         LD   HL,#00
         LD   DE,#BBCB-#b900+#1000
         LD   B,#38
loopy2
         PUSH BC
         LD   A,(DE)
         INC  DE
         LD   B,#00
         LD   C,A
         ADD  HL,BC
         POP  BC
         DEC  B
         JP   NZ,loopy2
         LD   DE,#9B3
         AND  A
         SBC  HL,DE
         EX   AF,AF
         LD   HL,#102E
         LD   B,#3D
R1074    LD   (HL),#C9
         INC  HL
         DJNZ R1074
         EX   AF,AF
         RET  
switch1
         LD   c,7
         LD   de,#40
         LD   hl,#af00
         JP   #bcce
;
         ORG  #af00
isit
         LD   a,(#9845)
         OR   a
         JR   nz,no
         LD   a,(#8039)
         CP   #40
         JR   c,no
         JR   z,no
         CP   #4a
         JR   c,hello
no
         LD   a,0
hello
         LD   (flag),a
         LD   a,#45
         JP   #bb6f
dos48                                   ; Do I Do An S48 ?
         LD   a,(flag)
         OR   a
         CALL nz,s48
nos48
         XOR  a
         LD   (flag),a
         LD   (#9840),a
         RET  
deldata                                 ; Is Track 0 Got Deleted Data On It ?
         LD   a,(#9845)
         OR   a
         JR   nz,ndeldata
         LD   a,(flag)
         OR   a
         JR   z,ndeldata
         POP  hl
         POP  af
         XOR  a
         PUSH af
         PUSH hl
ndeldata
         LD   a,#34
         JP   #bb6f
s48                                     ; Sector 48
         LD   hl,#c666
         LD   (rw),hl
         LD   a,(#9844)
         LD   e,a
         LD   a,#41
         RST  #18
         DEFW select
         CALL readwrit
         LD   hl,(#be42)
         LD   d,0
         LD   a,(#9844)
         OR   a
         LD   e,0
         JR   z,patch1
         LD   e,64
patch1
         ADD  hl,de
         LD   (hl),40
         LD   e,15
         ADD  hl,de
         LD   (hl),#41
         INC  hl
         LD   (hl),10
         INC  hl
         LD   (hl),20
         INC  hl
         LD   (hl),32
         LD   e,6
         ADD  hl,de
         LD   (hl),#ff
         LD   hl,headbuff
         LD   d,0
         LD   a,(#9844)
         LD   e,a
         RST  #18
         DEFW format
         LD   hl,#c64e
         LD   (rw),hl
readwrit
         LD   hl,#3800
         LD   bc,#941
rw1
         PUSH bc
         PUSH hl
         LD   d,0
         LD   a,(#9844)
         LD   e,a
         RST  #18
         DEFW rw
         POP  hl
         INC  h
         INC  h
         POP  bc
         INC  c
         DJNZ rw1
         RET  
select
         DEFW #c581
         DEFB 7
format   DEFW #c652
         DEFB 7
rw       DEFW #c666
         DEFB 7
flag
         DEFB 0
headbuff
         DEFB 0,0,#41,2
         DEFB 0,0,#46,2
         DEFB 0,0,#42,2
         DEFB 0,0,#47,2
         DEFB 0,0,#43,2
         DEFB 0,0,#48,2
         DEFB 0,0,#44,2
         DEFB 0,0,#49,2
         DEFB 0,0,#45,2
         DEFB 0,0,#48,2
