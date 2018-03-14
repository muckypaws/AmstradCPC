         ORG  #9000                     ; Decide disk Format.
buffer   EQU  #2000
start
         ENT  $
         LD   hl,disc
         CALL #bcd4                     ; Test to see if Drive is present
         JR   nc,error                  ; Exit if Drive not present.
         LD   hl,setmess
         CALL #bcd4
         LD   (setmess1),hl
         LD   a,c
         LD   (setmess2),a
         LD   hl,readsec
         CALL #bcd4
         LD   (readsec1),hl
         LD   a,c
         LD   (readsec2),a
         LD   a,#ff
         RST  #18
         DEFW setmess1
         LD   hl,buffer
         LD   de,0
         LD   c,1
         RST  #18
         DEFW readsec1
         JP   nc,next
         LD   a,1
         LD   (which),a                 ; It's IBM format !
         CALL onmess
         LD   hl,IBM
         JP   print
next
         LD   hl,buffer
         LD   de,0
         LD   c,#41
         RST  #18
         DEFW readsec1
         JP   nc,next1
         LD   a,#41
         LD   (which),a                 ; It's CP/M format !
         CALL onmess
         LD   hl,CPM
         JP   print
next1
         LD   hl,buffer
         LD   de,0
         LD   c,#c1
         RST  #18
         DEFW readsec1
         JP   nc,next2
         LD   a,#c1
         LD   (which),a                 ; It's DATA format
         CALL onmess
         LD   hl,DATA
         JP   print
next2
         LD   a,#ff                     ; Non standard format !
         LD   (which),a
onmess
         LD   a,0
         RST  #18
         DEFW setmess1
         RET  
error
         LD   a,2
         CALL #bc0e
         CALL #bc02
         LD   hl,errormsg
         CALL print
warning
         LD   bc,#0006
         CALL #bc38
         LD   a,47
         CALL #bb1e
         RET  nz
         JR   warning
print
         LD   a,(hl)
         INC  hl
         OR   a
         RET  z
         CALL #bb5a
         JR   print
setmess  DEFB #81
setmess1 DEFW 0
setmess2 DEFB 0
readsec  DEFB #84
readsec1 DEFW 0
readsec2 DEFB 0
which    DEFB 0
disc     DEFM DIS
         DEFB "C"+#80
errormsg DEFB 7,31,26,5
         DEFM Disk drive is not connect
         DEFM ed !
         DEFB 31,27,7
         DEFM Press SPACE to exit prog
         DEFM ram.
         DEFB 7,0
IBM      DEFB 31,1,3,32
         DEFM Disk is IBM format.
         DEFB 0
CPM      DEFB 31,1,3,32
         DEFM Disk is CPM format.
         DEFB 0
DATA     DEFB 31,1,3
         DEFM Disk is DATA format.
         DEFB 0
