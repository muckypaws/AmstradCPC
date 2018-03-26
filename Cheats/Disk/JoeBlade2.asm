         ORG  #a000
start
         ENT  $
         CALL #bd37
         LD   b,0
         LD   de,#4000
         LD   hl,0
         CALL #bc77
         RET  nc
         EX   de,hl
         CALL #bc83
         RET  nc
         CALL #bc7a
         RET  nc
         LD   a,#8f
         LD   (#417f),a
         LD   a,#b3
         LD   (#41cc),a
         LD   a,#f9
         LD   (#422c),a
         LD   a,2
         LD   (#422b),a
         LD   hl,cheat
         LD   de,#be00
         LD   bc,#30
         LDIR 
         JP   #4005
cheat
         LD   hl,#400
         LD   (#acb3),hl
         LD   hl,cheat1
         LD   (#acfb),hl
         JP   #ac00
cheat1
         XOR  a
cheat2
         LD   (#156a),a
cheat3
         LD   (#2319),a
         LD   (#24ad),a
         LD   (#26b4),a
         LD   (#28d3),a
exec
         JP   #ac14
