         ORG  #a000
start
         ENT  $
         LD   (mbc),bc
         LD   (mde),de
         LD   (mhl),hl
         LD   (msp),sp
         PUSH af
         POP  af
         LD   (maf),hl
         PUSH bc
         LD   bc,#7fc4
         OUT  (c),c
         POP  bc
         JP   #4000
; regdata
mhl      DEFW 0
mde      DEFW 0
mbc      DEFW 0
maf      DEFW 0
msp      DEFW 

