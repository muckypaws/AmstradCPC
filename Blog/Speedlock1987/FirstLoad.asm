         ORG  #a000
start
         ENT  $
         LD   bc,#7fc0
         OUT  (c),c                     ; Switch out Adam to main memory
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