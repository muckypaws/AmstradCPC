;
         ORG  #be80
start    ENT  $
         LD   hl,#abff
         LD   de,#40
         LD   c,7
         CALL #bcce
         XOR  a
         CALL #bc0e
         LD   bc,0
         CALL #bc38
         LD   ix,inks
         XOR  a
setem
         PUSH af
         LD   b,(ix+0)
         LD   c,b
         CALL #bc32
         POP  af
         INC  ix
         INC  a
         CP   #10
         JR   nz,setem
         LD   hl,#4000
         CALL load
         CALL #4000
         LD   hl,#100
         CALL load
         LD   hl,#3649
         CALL load
         JP   #30fd
load
         PUSH hl
         LD   hl,name+3
         INC  (hl)
         LD   hl,name
         LD   b,4
         CALL #bc77
         POP  hl
         CALL #bc83
         JP   #bc7a
name     DEFM ARK0
inks     DEFB 0,#D,#1a,#15,#19,9,#18
         DEFB #a,#14,1,2,#b,#10,#f,3,6
