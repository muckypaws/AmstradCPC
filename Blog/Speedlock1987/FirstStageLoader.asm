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
         LDIR                           ; Patch the Stack - Saves 1 Byte
         LD   a,#c3
         LD   hl,back
         LD   (patch1),a
         LD   (patch2),hl
         LD   hl,#abff
         LD   de,#40
         LD   bc,#b0ff
         LD   sp,#bffa
         JP   #3a43                     ; Execute the loader..
load
         LD   b,0
         LD   de,#1000
         CALL #bc77                     ; load the header
         EX   de,hl                     ; HL = Load Address
         CALL #bc83                     ; Complete the load
         CALL #bc7a                     ; close the cassette buffer
         PUSH bc
         LD   bc,#7fc4
         OUT  (c),c                     ; Switch back in extended memory
         POP  bc
         RET                            ; return  
buffer   DEFS 3,0
stakdata DEFW #B9A2,#7f89,#98
tocopy
         ORG  #be80
back
         NOP  
         PUSH bc
         LD   bc,#7fc4
         OUT  (c),c
         POP  bc
         POP  af
         JP   #4000                     ; Back to ADAM