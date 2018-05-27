;
         ORG  #9000
start    ENT  $
         DI   
         LD   sp,#bff8
         LD   bc,#7fc0
         OUT  (c),c
         CALL #bd37
         LD   a,#ff
         CALL #bc6b
         LD   de,#1000
         LD   b,0
         CALL #bc77
         JP   nc,0
         EX   de,hl
         LD   (filetype),a
         BIT  1,a
         JR   nz,next
         LD   hl,#170
next
         CALL #bc83
         JP   nc,0
         PUSH hl
         CALL #bc7a
         JP   nc,0
jason
         DI   
         LD   a,0
filetype EQU  $-1
         BIT  1,a
         JR   nz,oldv
         LD   C,#70
         LD   HL,#194
         LD   DE,#480
loop1
         LD   A,C
         XOR  (HL)
         LD   (HL),A
         INC  HL
         DEC  DE
         LD   A,D
         OR   E
         JR   NZ,loop1
         LD   hl,cheatc
         LD   de,#be80
         LD   (#230),de
         LD   bc,#30
         LDIR 
         JP   #195
;
;
oldv
         LD   hl,label1
         LD   de,#5000
         LD   bc,#100
         LDIR 
         JP   #5029
label1
         DI   
         LD   SP,#C000
         CALL #BD37
         LD   A,#FF
         CALL #BC6B
         LD   HL,#6000
         LD   DE,#6001
         LD   BC,#4A00
         LD   (HL),#00
         LDIR 
         LD   B,#00
         LD   DE,#1000
         CALL #BC77
         EX   DE,HL
         CALL #BC83
         PUSH HL
         CALL #BC7A
         LD   HL,#506D
         LD   DE,#BE80
         LD   BC,#100
         LDIR 
         LD   HL,#504D
         LD   DE,#BD16
         LD   BC,#03
         LDIR 
         LD   HL,#40
         LD   DE,#41
         LD   BC,#4FBF
         LD   (HL),#00
         LDIR 
         RET  
         JP   #BE80
         JR   Z,R8095
         ADD  HL,HL
         JR   NZ,R8086
         ADD  HL,SP
         JR   C,R8091
         JR   NZ,R808B
         LD   (HL),E
         LD   (HL),H
         JR   NZ,R80C1
         LD   L,B
         LD   L,A
         LD   L,C
         LD   H,E
         LD   H,L
         JR   NZ,R80B8
         LD   L,A
         LD   H,(HL)
         LD   (HL),H
         LD   (HL),A
         LD   H,C
         LD   (HL),D
         LD   H,L
         LD   L,#F3
         LD   DE,#100
         LD   IX,#A7B1
         CALL #A740
         LD   HL,#BE94
         LD   (#A85A),HL
         JP   #A7DB
cheatc
         LD   HL,#3766
         LD   (HL),#C3
R8086    JP   #400
