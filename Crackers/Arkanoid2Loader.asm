         ORG  #3649                     ; Loader For Within Arkanoid II
start    ENT  $
         DI   
         LD   (sp1+1),sp
         LD   sp,#c000
         LD   hl,0
         LD   de,#8000
         LD   bc,#40
         LDIR 
         LD   bc,#7f8e
         AND  a
         EX   af,af
         EXX  
         LD   hl,code
         LD   de,#be80
         LD   bc,#40
         LDIR 
         JP   #be80
ret
top
         DI   
         LD   bc,0
         CALL #bc38
         LD   a,(#347f)
         ADD  a,#31
         LD   (filename+4),a
         LD   hl,filename
         LD   b,5
         CALL #bc77
         LD   hl,#4000
         CALL #bc83
         CALL #bc7a
         DI   
sp1      LD   sp,0
         LD   hl,#8000
         LD   de,0
         LD   bc,#40
         LDIR 
         LD   a,9
         LD   (#36d1),a
         LD   hl,#26b9
         CALL #26a9
         XOR  a
         JP   #361f
filename
         DEFM ARKL0.
code
         LD   bc,#7f8b
         OUT  (c),c
         CALL #44
         CALL #8bd
         LD   bc,#7f8c
         OUT  (c),c
         LD   hl,next
         LD   c,#ff
         CALL #bd16
next
         CALL #bccb
         JP   ret
