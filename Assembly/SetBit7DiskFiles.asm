;
         ORG  #a000                     ; Write Protect Option All Files
start
         ENT  $                         ; Created By Jason Brooks 1989
         LD   hl,comm
         CALL #bcd4
         LD   a,c
         LD   (read),hl
         LD   (read+2),a
         LD   (write+2),a
         LD   hl,comm1
         CALL #bcd4
         LD   (write),hl
         LD   b,4
         LD   hl,#9000
         LD   de,0
         LD   c,#c1
readsect
         PUSH de
         PUSH hl
         PUSH bc
         RST  #18
         DEFW read
         POP  bc
         INC  c
         POP  hl
         LD   de,512
         ADD  hl,de
         POP  de
         DJNZ readsect
;
         LD   hl,#9009
         LD   b,64
setbit7
         LD   a,(hl)
         SET  7,a
         LD   (hl),a
         LD   de,32
         ADD  hl,de
         DJNZ setbit7
         LD   b,4
         LD   hl,#9000
         LD   de,0
         LD   c,#c1
writsect
         PUSH de
         PUSH hl
         PUSH bc
         RST  #18
         DEFW write
         POP  bc
         INC  c
         POP  hl
         LD   de,512
         ADD  hl,de
         POP  de
         DJNZ writsect
         RET  
comm     DEFB #84
comm1    DEFB #85
read     DEFS 3,0
write    DEFS 3,0
