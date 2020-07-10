
;
         ORG  #be80
start    ENT  $
         DI   
         LD   sp,#bff8
         LD   hl,name
         LD   b,len
         CALL #bc77
         EX   de,hl
         CALL #bc83
         LD   (exec),hl
         CALL #bc7a
         DI   
         LD   bc,#7fc4
         OUT  (c),c
         JP   #4000
name     DEFM appleby2
len      EQU  $-name
exec     DEFW 0
