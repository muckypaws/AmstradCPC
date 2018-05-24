;
         ORG  #b000                     ; Arkanoid Xor Routine For Speedlocks
;
speedlck ENT  $
         DI   
         LD   bc,#7fc0
         OUT  (c),c
         LD   de,#321c
         LD   hl,#500
         LD   bc,#500
         LDIR 
;
xor1
         LD   HL,#3245
R3239    LD   D,(HL)
         INC  HL
         LD   E,(HL)
         DEC  HL
         LD   (HL),E
         INC  HL
         LD   (HL),D
         INC  HL
         BIT  6,H
         JR   Z,R3239
xor2
         LD   D,D
         LD   H,L
         LD   H,H
         LD   C,B
         LD   H,L
         LD   (HL),D
         LD   (HL),D
         LD   L,C
         LD   L,(HL)
         LD   H,A
         LD   L,#2E
         LD   A,#15
         LD   R,A
         LD   E,#32
         LD   A,R
         LD   D,A
         PUSH DE
         DEC  SP
         POP  HL
         INC  SP
         LD   B,L
         LD   L,#77
         PUSH HL
R3262    INC  (HL)
         LD   A,R
         XOR  B
         LD   A,B
         INC  HL
         RES  0,B
         BIT  7,H
         JR   Z,R3262
xor3
         LD   HL,#3286
         LD   BC,#471
loop3
         LD   A,(HL)
         XOR  B
         XOR  L
         LD   (HL),A
         INC  HL
         DEC  BC
         LD   A,B
         OR   C
         JR   NZ,loop3
         JR   qq
xor4
         LD   B,#BC
         INC  C
         OUT  (C),C
         INC  B
         OUT  (C),A
qq
         LD   HL,#C000
         CALL W32D4
         LD   H,#70
         LD   L,B
         CALL W32D4
         LD   HL,#4000
         LD   DE,#4001
         LD   BC,#2FFF
         LD   (HL),#E5
         LDIR 
         LD   IY,#7000
         LD   IX,#C000
         LD   HL,#4000
         LD   BC,#3D5
         LD   DE,#3322
R32B9    LD   A,(DE)
         XOR  (IY+#01)
         XOR  (IX+#00)
         XOR  (HL)
         LD   (DE),A
         INC  HL
         INC  IY
         INC  IX
         INC  DE
         DEC  BC
         LD   A,B
         OR   C
         JP   Z,xor5
         JR   R32B9
addr1
         RST  #38
         XOR  A
addr
         NOP  
         OR   B
;
W32D4
         LD   (addr),HL
         LD   BC,#2000
         CCF  
         SBC  HL,HL
;
W32DD
         LD   (addr1),HL
         PUSH BC
         LD   D,H
         LD   E,L
         ADD  HL,HL
         ADD  HL,HL
         ADD  HL,HL
         ADD  HL,HL
         PUSH HL
         ADD  HL,HL
         EX   (SP),HL
         OR   A
         SBC  HL,DE
         POP  BC
         ADD  HL,BC
         ADD  HL,HL
         ADD  HL,HL
         ADD  HL,HL
         ADD  HL,DE
         ADD  HL,HL
         ADD  HL,HL
         ADD  HL,DE
         LD   DE,#29
         ADD  HL,DE
         POP  BC
         LD   DE,(addr)
         EX   DE,HL
         LD   (HL),E
         INC  HL
         LD   (HL),D
         INC  HL
         LD   (addr),HL
         DEC  BC
         PUSH BC
         LD   A,#10
         LD   B,#7F
         OUT  (C),A
         LD   A,R
         AND  #3F
         ADD  A,#40
         OUT  (C),A
         POP  BC
         LD   A,B
         OR   C
         RET  Z
         LD   A,(addr1)
         INC  HL
         JP   W32DD
xor5
         LD   B,#21
         LD   A,#C9
         LD   (#BDEE),A
         LD   HL,#333A
loop5
         LD   A,(HL)
         XOR  B
         LD   B,A
         LD   (HL),A
         INC  HL
         BIT  6,H
         LD   A,#EF
         LD   R,A
         JR   NZ,xor6
         JR   loop5
xor6
         LD   HL,#100
         LD   BC,#323B
R3341    LD   A,R
         LD   (HL),A
         INC  HL
         DEC  BC
         LD   A,B
         OR   C
         JR   NZ,R3341
         LD   HL,#337D
         LD   BC,#335C
R3350    LD   A,(BC)
         XOR  B
         SUB  C
         XOR  C
         ADD  A,B
         LD   (BC),A
         INC  BC
         LD   A,B
         CP   #B0
         JR   NZ,R3350
xor7
         DI   
         PUSH HL
         LD   HL,#C000
         LD   DE,#C001
         LD   BC,#4000
         LD   (HL),#00
         LDIR 
         POP  HL
         LD   A,#9C
         LD   R,A
         LD   BC,#37A
R3373    LD   A,R
         XOR  (HL)
         LD   (HL),A
         INC  HL
         DEC  BC
         LD   A,B
         OR   C
         JR   NZ,R3373
;
;
         LD   bc,#7fc4
         OUT  (c),c
         JP   #48b1
;
         ORG  #be80
start    ENT  $
         DI   
         LD   sp,#c000
         LD   bc,#7fc0
         OUT  (c),c
         LD   hl,#abff
         LD   de,#40
         LD   c,7
         CALL #bcce
         LD   a,1
         CALL #bc0e
         LD   bc,0
         CALL #bc38
         XOR  a
         LD   b,a
         LD   c,b
         CALL #bc32
         LD   a,1
         LD   bc,#1a1a
         CALL #bc32
         LD   a,2
         LD   bc,#606
         CALL #bc32
         LD   a,3
         LD   bc,#1212
         CALL #bc32
;
         CALL load
         CALL #4000
         CALL load
         LD   bc,#7fc4
         OUT  (c),c
         CALL load
         DI   
         LD   hl,#4000
         LD   de,#a000
         LD   bc,#1000
         LDIR 
         LD   bc,#7fc0
         OUT  (c),c
         JP   #40
load
         LD   hl,name+5
         INC  (hl)
         LD   hl,name
         LD   b,6
         CALL #bc77
         EX   de,hl
         CALL #bc83
         JP   #bc7a
name     DEFM DIZZY0
