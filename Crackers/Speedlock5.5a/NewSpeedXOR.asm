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
