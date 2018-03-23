;
         ORG  #9300                     ; Load In A File And Check Pre-Compress
start    ENT  $
         LD   hl,0
         LD   (#3ff2),hl                ; Clear Length Of Data Flag
         LD   l,(ix+0)
         LD   h,(ix+1)
         LD   b,(hl)
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         EX   de,hl
loop
         LD   de,#c000
         CALL #bc77
         RET  nc
         EX   de,hl
         LD   a,h
         CP   #40
         JR   z,loadit1
         CP   #c0
         JP   nz,#bc7a
loadit
         LD   hl,#c000
         LD   (#3ff2),bc                ; Store File Length
         CALL #bc83
         JP   #bc7a
loadit1
         LD   (#3ff2),bc
         LD   a,b
         CP   #40
         JR   z,loadit
         CALL #bc83
         CALL #bc7a
         JP   #4012
;
cat                                     ; Catalogue Disk
         LD   de,#6000
         JP   #bc9b
