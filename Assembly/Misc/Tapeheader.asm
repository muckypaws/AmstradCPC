;
         ORG  #1000                     ; Tape Header
start    ENT  $
         DI   
         LD   a,#10
         LD   hl,#8000
lp2
         DJNZ lp2
         LD   b,#f6
         OUT  (c),a
         XOR  #20
         PUSH af
         LD   bc,#7f10
         OUT  (c),c
         RRA  
         OR   #40
         OUT  (c),a
         POP  af
         LD   c,2
lp3
         LD   b,#32
         DEC  l
         JR   nz,lp2
;DEC  b
         DEC  h
         JP   p,lp2
lp1
         XOR  a
         LD   b,#f6
         OUT  (c),a
         RET  
;
jacelock
         LD   HL,#2000
         DI   
         LD   A,#10
         LD   B,#02
R8F3D
         DJNZ R8F3D
         LD   B,#F6
         OUT  (C),A
         XOR  #20
         LD   B,#32
         DEC  L
         JR   NZ,R8F3D
         DEC  B
         DEC  H
         JP   P,R8F3D
         LD   B,#2F
R8F51    DJNZ R8F51
         LD   B,#F6
         OUT  (C),A
         LD   A,#30
         LD   B,#37
R8F5B    DJNZ R8F5B
         LD   B,#F6
         OUT  (C),A
         LD   BC,#1a30
         LD   L,#00
R8F66    LD   A,D
         OR   E
         JR   Z,R8F75
         LD   L,(IX+#00)
R8F6D    LD   A,H
         XOR  L
         LD   H,A
         LD   A,#10
         SCF  
         JR   R8F8F
;
R8F75    LD   L,H
         JR   R8F6D
R8F78    LD   A,C
         BIT  7,B
R8F7B
         DJNZ R8F7B
         JR   NC,R8F83
         LD   B,#21
R8F81    DJNZ R8F81
R8F83    LD   B,#F6
         OUT  (C),A
         LD   B,#1a
         JR   NZ,R8F78
         DEC  B
         LD   A,#10
         AND  A
R8F8F    RL   L
         JR   NZ,R8F7B
         DEC  DE
         INC  IX
         AND  (IX+#00)
         LD   A,D
         INC  A
         JR   NZ,R8F66
         LD   B,#1a
R8F9F    DJNZ R8F9F
         XOR  A
         LD   B,#F6
         OUT  (C),A
         AND  A
         RET  
;
