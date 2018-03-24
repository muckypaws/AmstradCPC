;
GRIDX    EQU  3
GRIDY    EQU  #1c
GRIDW    EQU  20
GRIDH    EQU  20
BOMBS    EQU  10
BOMB     EQU  14
FLAG     EQU  13
MAXBOMBS EQU  4
FILLFLAG EQU  1+128
;
INTROM
         DEFM WELCOME@TO@MINE
         DEFB 0
TIMEM
         DEFM TIME
         DEFB 0
STARTUP
         DEFM @@@HELLO@AND@WELCOME@
         DEFM TO@MINE@@@PRESS@@S@@TO@ST
         DEFM ART@@@@
         DEFB 0
name
         DEFM MINE.SPR
len      EQU  $-name
name1    DEFM MINE.SCR
len1     EQU  $-name1
memflag  EQU  #100                      ; Flag Address For Loaded Data
sprites  EQU  #1000
mmx      DEFW 310                       ; Mouse Max X
mlx      DEFW 0                         ; Mouse X Min Boundary
mmy      DEFB 191                       ; Max Y Mouse Boundary
mly      DEFB 0                         ; Min Y Mouse Boundary
msex     DEFW 0
msey     DEFB 0
accel    DEFB 0
accelf   DEFB 0
mousew   EQU  17                        ; Mouse Width
mouseh   EQU  9                         ; Mouse Height
counter  DEFW 0
bitstate DEFW 0
rasterc  DEFB 0
fifty    DEFB 0
nobombs  DEFB BOMBS
maxgx    DEFB GRIDW-1
maxgy    DEFB GRIDH-1
time     DEFB 0,0,0,0
messpart DEFB 0
messbuff DEFS 18,0
messageb DEFW 0
messageo DEFW 0
;
;
mbuffer1 DEFS 10*4,0                    ; Screen Buffer 1
mbuffer2 DEFS 10*4,0                    ; Mouse Buffer 2
fblock   DEFS 10,0
list     DEFB #55,#56,#4a,#59,#47,#57
         DEFB #56
mouses                                  ; Data Address
;
         DEFB #0F,#08,#00,#7F
         DEFB #8C,#00,#7F,#08
         DEFB #00,#7F,#8C,#00
         DEFB #5F,#CE,#00,#05
         DEFB #EF,#00,#00,#7F
         DEFB #08,#00,#37,#08
         DEFB #00,#03,#00
random   DEFW #4a4b                     ; Random Numbers
lrandom  DEFW 0
maxlimit DEFB 0                         ; Maximum Limit In Random Numbers
randoffs DEFB 0
;
tablea   DEFW table
tableset DEFB 0
;
colours  DEFB 0,24,14,1
ftb      DEFS 10,0
FLAGS    DEFB BOMBS
MAXFLAGS DEFB BOMBS
gamegrid DEFS 20*20,0                   ; Maximum Size Grid
;
upflag   DEFB 0
downflag DEFB 0
STACKCNT DEFW 0                         ; Stack Counter
STACKMAX EQU  60
STACKPT  DEFW STACK
STACK    DEFS STACKMAX*2,0
;
maxbut   EQU  498                       ; Maximum Number Of Buttons Allowed
buttont  DEFW 0                         ; Current Number Of Buttons
buttons  DEFS 500*6,0                   ; Button Co-Ordinates
;
; Button Format X1 (Word), X2 (Word), Y1 (Byte), Y2 (Byte)
;
;
;
table    DEFS 512,0
;
