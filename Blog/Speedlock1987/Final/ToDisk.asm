         ORG  #a000
patch1   EQU  #3a76
patch2   EQU  patch1+1
start
         ENT  $
         LD   bc,#7fc0
         OUT  (c),c                     ; Switch out Adam to main memory
         LD   hl,rsxtape
         CALL rsxset
         CALL load
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
rsxset
         CALL #bcd4                     ; Request ROM and Address of RSX
         RET  nc                        ; command not found
         LD   (rsxwork),hl              ; Address of Command
         LD   a,c
         LD   (rsxwork+2),a             ; ROM where command located
         XOR  a                         ; No Parameters to Pass
         RST  #18
         DEFW rsxwork                   ; Point to work block
         RET  
back
         DI   
         LD   a,back2/256!#fb
         LD   (#4b),a
         LD   a,back2&255!#99
         LD   (#4e),a
         POP  af
         RET  
back2
         LD   ix,#bf00
         LD   de,#47
         CALL #bc4e
         LD   hl,savecode
         LD   (#bf44),hl
         JP   #bf00
rsxtape  DEFM TAP
         DEFB "E"+#80
rsxdisc  DEFM DIS
         DEFB "C"+#80
rsxwork  DEFS 3,0                       ; RSX Work Space
savecode
         LD   hl,rsxdisc
         CALL rsxset
         LD   ix,#c000
         LD   de,#4000
         LD   bc,#0
         CALL save
         LD   ix,#40
         LD   de,#64Ae+#3862+1
         LD   bc,#73b1
         CALL save
         JP   #73b1                     ; Start the Game
save
         LD   hl,fname+5
         INC  (hl)
         LD   hl,fname
         PUSH bc
         PUSH de
         PUSH ix
         LD   b,fnamel
         LD   de,#c000
         CALL #bc8c
         POP  hl
         POP  de
         POP  bc
         LD   a,2
         CALL #bc98
         JP   #bc8f
fname    DEFM DIZZY0.BIN
fnamel   EQU  $-fname