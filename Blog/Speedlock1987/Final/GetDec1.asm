         ORG  #a000
patch1   EQU  #3a76
patch2   EQU  patch1+1
start
         ENT  $
         LD   bc,#7fc0
         OUT  (c),c                     ; Switch out Adam to main memory
         CALL load
         LD   hl,stakdata
         LD   de,#bffa
         LD   bc,6
         LDIR 
         LD   a,#c3
         LD   hl,back
         LD   (patch1),a
         LD   (patch2),hl
         LD   hl,#abff
         LD   de,#40
         LD   bc,#b0ff
         LD   sp,#bffa
         JP   #3a43
load
         LD   b,0
         LD   de,#1000
         CALL #bc77                     ; load the header
         EX   de,hl                     ; HL = Load Address
         CALL #bc83                     ; Complete the load
         JP   #bc7a                     ; close the cassette buffer
buffer   DEFS 3,0
stakdata DEFW #b9a2,#7f89,#98
back
         PUSH bc
         LD   bc,#7fc4
         OUT  (c),c
         POP  bc
         POP  af
         JP   #4000						; ADAM Load Location
         