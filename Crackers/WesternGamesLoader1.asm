;
         ORG  #be80
start    ENT  $
         DI   
         LD   (sp1+1),sp
         LD   sp,#c000
         LD   bc,#7f8b
         OUT  (c),c
         CALL #44
         CALL #8bd
         LD   bc,#7f8c
         OUT  (c),c
         LD   hl,#b0ff
         LD   de,#40
         LD   c,7
         CALL #bcce
         LD   hl,#ca8
         PUSH hl
         LD   de,filename
         LD   bc,8
         LDIR 
         LD   de,f1
         LD   bc,3
         LDIR 
         POP  hl
         LD   de,#cbd
         LD   bc,12
         LDIR 
         LD   a,#9d
         LD   (#cba),a
top
         LD   hl,filename
         LD   b,12
         CALL #bc77
         JR   nc,error
         EX   de,hl
         LD   (#ca6),hl
         LD   (#cba),bc
         CALL #bc83
         LD   (#cb6),hl
         LD   (#ca4),hl
         CALL #bc7a
         DI   
sp1      LD   sp,0
         RET  
error
         CALL #bc7a
         JR   top
filename
         DEFS 8,32
         DEFM .
f1
         DEFS 3,32
