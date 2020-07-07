;
         ORG  #40
         ENT  $
start
         LD   a,1
         CALL #bc0e
top
         LD   bc,#7fc0
         OUT  (c),c
loop
         CALL #C64
         CALL #C0C
         LD   HL,(#CA4)
         LD   (#CB6),HL
         LD   DE,#0E
         LD   IX,#CBC
         CALL #BB9
         LD   HL,#CBC
         LD   A,(HL)
         CP   #9D
         JP   NZ,loop
         INC  HL
         LD   DE,#CA8
         LD   B,#0B
RAE8     LD   A,(DE)
         CP   (HL)
         INC  HL
         INC  DE
         DJNZ RAE8
         LD   E,(HL)
         INC  HL
         LD   D,(HL)
         LD   (#CBA),DE
         CALL #C0C
         LD   IX,(#CA6)
         LD   DE,(#CBA)
         LD   HL,(#CB6)
         LD   (#CA4),HL
         LD   (codes+1),ix
         LD   (codel+1),de
         LD   (exec+1),hl
         CALL #BB9
         LD   a,d
         OR   e
         CALL nz,#b94
         LD   hl,#b0ff
         LD   de,#40
         LD   c,7
         CALL #bcce
         LD   hl,#cbd
         LD   de,filename
         LD   bc,8
         LDIR 
         LD   de,f1
         LD   bc,3
         LDIR 
         LD   bc,#f600
         OUT  (c),c
save
         LD   hl,co
         CALL print
         LD   hl,filename
         CALL print
         LD   hl,filename
         LD   b,12
         CALL #bc8c
         JR   nc,eror
codes    LD   hl,0
codel    LD   de,0
exec     LD   bc,0
         LD   a,2
         CALL #bc98
         CALL #bc8f
         LD   c,2
         LD   b,0
pause
         CALL #bd19
         DJNZ pause
         DEC  c
         LD   a,c
         OR   a
         JR   nz,pause
         JP   top
filename
         DEFS 8,32
         DEFM .
f1
         DEFS 3,32
         DEFB 0
print
         LD   a,(hl)
         INC  hl
         OR   a
         RET  z
         CALL #bb5a
         JR   print
co       DEFB 13,10,10
         DEFM Transfering :- 
         DEFB 0
error    DEFM Turn Disk Over.
         DEFB 0
eror
         CALL #bc8f
         LD   hl,error
         JR   save
