;
         ORG  #be80
start    ENT  $
         DI   
         LD   sp,#bff8
         LD   bc,#7fc0
         OUT  (c),c
         LD   hl,name
         LD   b,len
         CALL #bc77
         EX   de,hl
         LD   (load),hl
         LD   (leng),bc
         CALL #bc83
         CALL #bc7a
         CALL #bb18
         CALL #bb18
;
fix                                     ; Insert Code Into NIRVANA
         LD   hl,#f7
         LD   (#a58f),hl
         LD   hl,rtn2
         LD   (#a5df),hl
         LD   hl,rtn4
         LD   (#a5ae),hl
;
         LD   hl,name
         LD   b,len
         LD   de,#c000
         CALL #bc8c
         LD   hl,0
load     EQU  $-2
         LD   de,0
leng     EQU  $-2
         LD   bc,0
         LD   a,2
         CALL #bc98
         JP   #bc8f
;
name     DEFM NIRVANA3.BIN
len      EQU  $-name
;
rtn      EQU  #bf00                     ; ERASED FLAG CHECK
rtn2     EQU  #bf09                     ; DISPLAY 'E' AS FILE ATTRIBUTE
rtn4     EQU  #bf23                     ; DON'T DISPLAY USER 229
