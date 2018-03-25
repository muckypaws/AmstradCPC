;
         ORG  #a000                     ; Speedlock XOR routine
start
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
         LD   BC,#46
         ADD  IY,BC
         DEFB #fd,#5d
         DEFB #fd,#54
         LD   L,E
         LD   H,D
         LD   BC,#1D5
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
         LD   c,7
         LD   hl,#af00
         LD   de,#a600
         JP   #bcce
