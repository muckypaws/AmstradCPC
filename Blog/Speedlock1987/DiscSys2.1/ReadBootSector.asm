         ORG  #a000
start
         ENT  $
         LD   hl,readcomm
         CALL #bcd4
         RET  nc
         LD   a,c
         LD   (readsect),hl
         LD   (readsect+2),a
         LD   de,0
         LD   c,#41
         LD   hl,#100
readit
         RST  #18
         DEFW readsect
         RET  
readcomm DEFB #84
readsect DEFS 3,0
