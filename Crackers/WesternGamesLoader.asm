
.COPYRIGHT 1985 MICRO-APPLICATION.
.DAMS.

;
         ORG  #a000                     ; Load In Files To Banks
;
         DI   
         LD   hl,#a600
         LD   de,#8900
         LD   bc,#200
         LDIR 
         LD   hl,#ae00
         LD   de,#9100
         LD   bc,#200
         LDIR 
         LD   hl,#b600
         LD   de,#9800
         LD   bc,#200
         LDIR 
         LD   hl,#be00
         LD   de,#a100
         LD   bc,#200
         LDIR 
;
         LD   sp,#c000
         LD   bc,#7f8e
         AND  a
         EX   af,af
         EXX  
         LD   bc,#7f8b
         OUT  (c),c
         CALL #44
         CALL #8bd
         LD   bc,#7f8c
         OUT  (c),c
;
         LD   hl,#b0ff
         LD   de,#40
         LD   c,7
         CALL #bcce
         CALL load
         LD   bc,#7fc4
         OUT  (c),c
         CALL load
         LD   bc,#7fc5
         OUT  (c),c
         CALL load
         LD   bc,#7fc6
         OUT  (c),c
         CALL load
         LD   bc,#7fc7
         OUT  (c),c
         CALL load
         LD   bc,#7fc0
         OUT  (c),c
         DI   
         LD   sp,#a000
         LD   hl,#8900
         LD   de,#a600
         LD   bc,#200
         LDIR 
         LD   hl,#9100
         LD   de,#ae00
         LD   bc,#200
         LDIR 
         LD   hl,#9800
         LD   de,#b600
         LD   bc,#200
         LDIR 
         LD   hl,#a100
         LD   de,#be00
         LD   bc,#200
         LDIR 
         JP   #815d
load
         LD   hl,name+4
         INC  (hl)
         LD   hl,name
         LD   b,len
         CALL #bc77
         LD   hl,#4000
         CALL #bc83
         JP   #bc7a
name     DEFM PART0
len      EQU  $-name
