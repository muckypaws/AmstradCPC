;
         ORG  #a000
start    ENT  $
         DI   
         LD   hl,cpm
         CALL #bcd4
         RET  nc
         LD   c,a
         CALL #b90f
         LD   hl,#c000
         LD   de,#4000
         PUSH de
         POP  bc
         LDIR 
         LD   hl,name1
         CALL save
         CALL #b906
         LD   hl,0
         LD   de,#4000
         PUSH de
         POP  bc
         LDIR 
         LD   hl,name2
         CALL save
         LD   c,0
         CALL #b90f
         LD   hl,#c000
         LD   de,#4000
         PUSH de
         POP  bc
         LDIR 
         LD   hl,name3
         CALL save
         LD   hl,name4
         LD   b,len
         LD   de,#c000
         CALL #bc8c
         LD   hl,#b900
         LD   de,#be80-#b900
         LD   bc,0
         LD   a,2
         CALL #bc98
         JP   #bc8f
save
         LD   b,len
         LD   de,#c000
         CALL #bc8c
         LD   hl,#4000
         LD   de,#4000
         LD   bc,#4000
         LD   a,2
         CALL #bc98
         JP   #bc8f
;
cpm      DEFM CP
         DEFB "M"+#80
name1    DEFM UPPER   .BIN
name2    DEFM LOWER   .BIN
name3    DEFM BASIC   .BIN
name4    DEFM FIRMWARE.BIN
len      EQU  $-name4
