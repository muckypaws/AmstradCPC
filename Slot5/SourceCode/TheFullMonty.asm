;
         ORG  #814a                     ; Fruit Machine Simulator
start                                   ; Written By Jason Brooks
         ENT  start                     ; Started 27/06/90
         DI   
         IM   1
         LD   sp,#38
         CALL blackink
         CALL cleanscr
         CALL setinks
         CALL trans
         CALL jumble
newgame
         CALL ishscore
         CALL welcome
         CALL resetgc
         CALL resetwb
         CALL setwinb
         CALL resetspd
         LD   a,(functcnt)
         OR   a
         CALL nz,takeit1
         CALL funhfc
startr
         CALL game0
         CALL resetf
         CALL game0
         CALL getret
         CALL swichhld
         CALL resetgc
         LD   a,0
walkf    EQU  $-1
         OR   a
         JR   nz,newgame
         CALL getwin
         CALL gamble
         LD   a,(lastwin)
         OR   a
         PUSH af
         CALL nz,incmoney
         POP  af
         CALL nz,im2
         CALL getwin
         LD   a,(lastwin)
         OR   a
         JR   nz,startr3
         CALL getnum
         CALL nz,dispfunc
         LD   a,0
numbers  EQU  $-1
         OR   a
         CALL nz,modulec
         CALL gamblef
startr3
         CALL funhfc
;startr3
         CALL resetf
         CALL game0
         LD   a,r
         CP   56
         LD   a,#28
         JR   nc,setgt
         XOR  a
setgt
         LD   (gamblet),a
         LD   a,(lastwin)
         OR   a
         LD   a,0
         LD   c,a
         LD   (tsetg),a
         JR   nz,start1
;CALL getwin
         LD   a,(lastwin)
         OR   a
         LD   c,0
         JR   nz,start1
         CALL allnumb
         LD   c,0
         JR   c,start1
         LD   a,r
         CP   34
         LD   c,0
         JR   nc,start1
         LD   c,#18
start1
         LD   hl,getret+1
         LD   (hl),c
         CALL checkmon
         JP   nz,startr
         LD   a,4
         CALL losec1
         JP   newgame
welcome
         XOR  a
         LD   (walkf),a
         CALL dbest
         LD   hl,welcomem
         CALL setupms
newgame1
         LD   a,27
         CALL scrmess
         JR   c,newgame1
         CALL dspace
         CALL resetwb
         CALL setwinb
         LD   hl,hello
         CALL setupms
         LD   a,80
jason1
         CALL scrmess
         JP   dspace
allnumb
         CALL getwin
         CALL getnum
         LD   a,(number1)
         OR   a
         RET  z
         LD   a,(number2)
         OR   a
         RET  z
         LD   a,(number3)
         OR   a
         RET  z
         SCF  
         RET  
;
game0
         XOR  a
         JR   gamec
gameff
         LD   a,#ff
gamec
         OR   a
         JR   nz,fss
         LD   a,0
gamec1   EQU  $-1
         OR   a
         RET  z
         INC  a
         LD   (gamec1),a
         LD   a,0
funcheld EQU  $-1
         OR   a
         CALL nz,copyfunc
         CALL hrdrght
         CALL hrdrght
         CALL blitter
         LD   hl,#c026
         LD   c,19
mselect2
         PUSH bc
         CALL movsrght
         POP  bc
         DEC  c
         BIT  7,c
         JR   z,mselect2
         CALL hardlft
         JP   hardlft
fss
         LD   a,(gamec1)
         OR   a
         RET  nz
         DEC  a
         LD   (gamec1),a
fselect
         LD   c,0
         CALL getsaddr
         LD   c,20
         LD   hl,#c000
fselect1
         CALL strpstr
         DEC  c
         JR   nz,fselect1
         LD   hl,#c050
         LD   c,20
         JR   trans1
trans
         CALL resethrd
         LD   hl,#c000
         LD   c,0
transf
         CALL trans1
         LD   hl,sprload+#3a+40         ; Store Functions On 2nd 8K
         LD   b,20
sfp1
         PUSH bc
         PUSH hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         PUSH hl
         LD   hl,sprload
         ADD  hl,de
         EX   de,hl
         POP  hl
         PUSH de
         LD   de,79-40
         ADD  hl,de
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   hl,sprload
         ADD  hl,de
         EX   de,hl
         POP  hl
         LD   bc,#201
         LD   a,200
         CALL decomp
         POP  hl
         INC  hl
         INC  hl
         POP  bc
         DJNZ sfp1
         RET  
trans1
         PUSH bc
         CALL movsleft
         POP  bc
         INC  c
         LD   a,c
         CP   40
         JR   nz,trans1
         RET  
getsaddr                                ; Get Strip Addressess
         LD   hl,sprload
         PUSH hl
         LD   a,c                       ; C = Strip Number
         ADD  a,a
         ADD  a,#3a
         LD   e,a
         LD   d,0
         ADD  hl,de
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         POP  hl
         ADD  hl,de
         EX   de,hl                     ; EXIT DE=Location Of Strip
         RET  
strpstr
         LD   b,200
         PUSH hl
strpstr2
         LD   a,(hl)
         LD   (de),a
         INC  hl
         LD   a,h
         OR   #c0
         LD   h,a
         INC  de
         LD   a,(hl)
         LD   (de),a
         DEC  hl
         INC  de
         LD   a,h
         ADD  a,8
         JR   nc,strpstr3
         LD   a,#50
         ADD  a,l
         LD   l,a
         LD   a,#c8
         ADC  a,h
strpstr3
         OR   #c0
         LD   h,a
         DJNZ strpstr2
         POP  hl
         INC  hl
         INC  hl
         RET  
strips
         LD   b,200
         PUSH hl
trans2
         LD   a,(de)
         LD   (hl),a
         INC  hl
         LD   a,h
         OR   #c0
         LD   h,a
         INC  de
         LD   a,(de)
         LD   (hl),a
         DEC  hl
         INC  de
         LD   a,h
         ADD  a,8
         JR   nc,trans3
         LD   a,#50
         ADD  a,l
         LD   l,a
         LD   a,#c8
         ADC  a,h
trans3
         OR   #c0
         LD   h,a
         DJNZ trans2
         POP  hl
         INC  hl
         INC  hl
         RET  
movsleft
         CALL putstrip
         PUSH af
         PUSH bc
         PUSH de
         PUSH hl
         CALL hardlft
         POP  hl
         POP  de
         POP  bc
         POP  af
         RET  
copyfunc
         LD   c,20
         CALL getsaddr
         LD   hl,#c050
copyf1
         CALL strpstr
         DEC  c
         JR   nz,copyf1
         RET  
movsrght
         CALL putstrip
         PUSH af
         PUSH bc
         PUSH de
         PUSH hl
         CALL hrdrght
         POP  hl
         POP  de
         POP  bc
         POP  af
         DEC  hl
         DEC  hl
         DEC  hl
         DEC  hl
         RET  
putstrip
         PUSH hl
         CALL getsaddr
         POP  hl
         CALL blitter
         JR   strips
hardlft                                 ; HD6845 CRTC Controller Routines
         LD   hl,horiz
         INC  (hl)
         LD   a,(hl)
         OR   a
         RET  nz
         LD   hl,vert
         INC  (hl)
         RET  
hrdrght
         LD   a,(horiz)
         SUB  1
         LD   (horiz),a
         RET  nc
         LD   hl,vert
         DEC  (hl)
         RET  
resethrd                                ; 6845 CRT-C Controller Programs
         LD   b,#f5
         IN   a,(c)
         BIT  4,a
         JR   nz,reseth1
         LD   bc,#bc05
         OUT  (c),c
         INC  b
         DEC  c
         OUT  (c),c
reseth1
         LD   bc,#bc06
         OUT  (c),c
         LD   c,25
         INC  b
         OUT  (c),c
         DEC  b
         LD   c,0
         OUT  (c),c
         LD   a,63
         INC  b
         OUT  (c),a
         DEC  b
         INC  c
         OUT  (c),c
         INC  b
         LD   a,40
         OUT  (c),a
         DEC  b
         INC  c
         OUT  (c),c
         INC  b
         LD   a,46
         OUT  (c),a
         DEC  b
         INC  c
         LD   a,#8e
         OUT  (c),c
         INC  b
         OUT  (c),a
         XOR  a
         LD   a,217
         LD   (horiz),a
         LD   a,179
         LD   (vert),a
blitter
         PUSH af
         PUSH bc
         CALL framefly
         LD   bc,#bc0c
         LD   a,180
vert     EQU  $-1
         AND  #b7
         OR   #b0
         OUT  (c),c
         INC  b
         OUT  (c),a
         DEC  b
         INC  c
         LD   a,0
horiz    EQU  $-1
         OUT  (c),c
         INC  b
         OUT  (c),a
         POP  bc
         POP  af
         RET  
;
dropr1
         LD   hl,row1tot
         LD   a,0
number1  EQU  $-1
         LD   de,row1bf+8
         LD   bc,row1c
         JR   dropfba
dropr2
         LD   hl,row2tot
         LD   a,0
number2  EQU  $-1
         LD   de,row2bf+8
         LD   bc,row2c
         JR   dropfba
dropr3
         LD   hl,row3tot
         LD   a,0
number3  EQU  $-1
         LD   de,row3bf+8
         LD   bc,row3c
dropfba
         LD   (drops1),de
         LD   (drops5),bc
         LD   b,a
         ADD  a,(hl)
         LD   (hl),a
         LD   a,b
         OR   a
dropfbs
         RET  z
         LD   hl,row1bf+8
drops1   EQU  $-2
         LD   b,9
         EX   af,af
dropr1b
         LD   a,b
         LD   (bft),a
         LD   a,(hl)
         OR   a
         JR   nz,dropr1d
         LD   (hl),#ff
         PUSH hl
         PUSH bc
         CALL row1c
drops5   EQU  $-2
         CALL bf
         POP  bc
         POP  hl
         LD   (hl),0
         DEC  hl
         DJNZ dropr1b
dropr1d
         LD   a,b
         CP   9
         RET  z
         INC  hl
         LD   (hl),#ff
         EX   af,af
         DEC  a
         JR   dropfbs
row1c
         LD   hl,row1bf
         LD   de,row1bfo
         LD   bc,setrow1
rowc
         LD   (rowca),bc
         LD   b,9
         LD   c,0
row1cl
         LD   a,(de)
         CP   (hl)
         CALL nz,setrow1
rowca    EQU  $-2
         INC  hl
         INC  de
         INC  c
         DJNZ row1cl
         RET  
row2c
         LD   hl,row2bf
         LD   de,row2bfo
         LD   bc,setrow2
         JR   rowc
row3c
         LD   hl,row3bf
         LD   de,row3bfo
         LD   bc,setrow3
         JR   rowc
resetf
         LD   a,(funcheld)
         OR   a
         RET  nz
         CALL checkmon
         RET  z
         CALL dpause
resetag
         CALL isany
         RET  z
         CALL gameff
         LD   de,#3ccf
         CALL setcs
         LD   hl,#cee0+#50
         LD   bc,#e12
         LD   a,#3c
         CALL swichgwa
         CALL setfuncc
         LD   hl,row1bfo
         LD   de,row1bfo+1
         LD   bc,26
         LD   (hl),#ff
         LDIR 
         LD   hl,row1bf+8
         LD   de,row2bf+8
         LD   bc,row3bf+8
         LD   a,9
resetf1
         PUSH af
         PUSH bc
         PUSH de
         PUSH hl
         XOR  a
         LD   (hl),a
         LD   (de),a
         LD   (bc),a
         CALL setfun1
         LD   a,5
         CALL pause
         POP  hl
         POP  de
         POP  bc
         POP  af
         DEC  hl
         DEC  de
         DEC  bc
         DEC  a
         JR   nz,resetf1
         LD   (row1tot),a
         LD   (row2tot),a
         LD   (row3tot),a
         LD   (funcheld),a
         JP   copyfunc
setrow1
         PUSH af
         PUSH bc
         PUSH de
         PUSH hl
         CALL colsetf
         CALL calcfadd
         LD   b,row1len
         LD   c,18
         CALL swichgwa
         POP  hl
         POP  de
         POP  bc
         POP  af
         RET  
setrow2
         PUSH af
         PUSH bc
         PUSH de
         PUSH hl
         CALL colsetf
         CALL calcfadd
         LD   c,row2off
         ADD  hl,bc
         LD   b,row2len
         LD   c,18
         CALL swichgwa
         POP  hl
         POP  de
         POP  bc
         POP  af
         RET  
setrow3
         PUSH af
         PUSH bc
         PUSH de
         PUSH hl
         CALL colsetf
         CALL calcfadd
         LD   c,row3off
         ADD  hl,bc
         LD   b,row3len
         LD   c,18
         CALL swichgwa
         POP  hl
         POP  de
         POP  bc
         POP  af
         RET  
colsetf
         CALL framefly
         LD   a,(hl)
         LD   (de),a
         OR   a
         LD   a,#c0
         RET  nz
         LD   a,0
         RET  
calcfadd                                ; Calculate Function Screen Address
         SLA  c
         LD   b,0
         LD   hl,funcadtb
         ADD  hl,bc
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         EX   de,hl
         RET  
setfuncc                                ; Set Function Colours For Col. Swap
         LD   de,#c000
         JP   setcs
isany
         LD   hl,row1bfo
         LD   b,3*9
isany1
         LD   a,(hl)
         OR   a
         RET  nz
         INC  hl
         DJNZ isany1
         RET  
;
framefly                                ; Hardware Control Routines
         LD   b,#f5
framflya
         IN   a,(c)
         RRA  
         RET  c
         JR   framflya
scankey
         LD   b,a
         AND  7
         LD   c,a
         LD   a,1
         SRL  c
         JR   nc,scan1
         ADD  a,a
scan1
         SRL  c
         JR   nc,scan2
         ADD  a,a
         ADD  a,a
scan2
         SRL  c
         JR   nc,scan3
         ADD  a,a
         ADD  a,a
         ADD  a,a
         ADD  a,a
scan3
         LD   (bitmask+1),a
         LD   a,b
         SRL  a
         SRL  a
         SRL  a
         OR   #40
         LD   (rowsel+1),a
         LD   bc,#f792
         OUT  (c),c
         DEC  b
rowsel   LD   c,0
         IN   d,(c)
         OUT  (c),c
         LD   b,#f4
         IN   a,(c)
         LD   b,#f6
         OUT  (c),d
         LD   bc,#f782
         OUT  (c),c
bitmask  AND  0
         RET                            ; Quit Z If Pressed : NZ If Not Pressed
setmode
         AND  3
         OR   #8c
         EXX  
         LD   c,a
         LD   b,#7f
         OUT  (c),c
         EXX  
         RET  
setink                                  ; Entry A=Pen : B=Colour
         LD   c,a
         LD   l,b
         LD   h,0
         LD   de,hardinks
         ADD  hl,de
         LD   a,(hl)
         OR   #40
         LD   b,#7f
         OUT  (c),c
         OUT  (c),a
         RET  
putscr
         PUSH hl
         LD   hl,#771a
         LD   (csset),hl
         POP  hl
copyscr                                 ; Copy Section To REEL1BFD
         LD   de,reel1bfd
cs1
         PUSH bc
         PUSH hl
cs2
         SET  7,h
         SET  6,h
csset
         LD   a,(hl)
         LD   (de),a
         INC  hl
         INC  de
         DJNZ cs2
         POP  hl
         CALL addscr
         POP  bc
         DEC  c
         JR   nz,cs1
         LD   hl,#127e
         LD   (csset),hl
         RET  
cleanscr
         LD   hl,#c000
         LD   bc,#50d0
         XOR  a
wipeout                                 ; Entry HL=Address:A=Bck Col:B=Width:C=
         LD   (wp1),a
wip
         PUSH bc
         PUSH hl
wipeout1
         SET  7,h
         SET  6,h
         LD   (hl),0
wp1      EQU  $-1
         INC  hl
         DJNZ wipeout1
         POP  hl
         CALL addscr
         POP  bc
         DEC  c
         JR   nz,wip
         RET  
addscr
         LD   a,8
         ADD  a,h
         JR   nc,addscr1
         LD   a,#50
         ADD  a,l
         LD   l,a
         LD   a,#c8
         ADC  a,h
addscr1
         OR   #c0
         LD   h,a
         RET  
;
modulec                                 ; Module Control Unit
         LD   a,(functcnt)
         OR   a
         RET  nz
         LD   hl,functcnt               ; Point To Function Counter
         EXX  
         LD   hl,row1bfo
         LD   de,row2bfo
         LD   bc,row3bfo
         LD   a,9
funcav                                  ; Is There A Gaming Function Available
         EX   af,af
         LD   a,(hl)
         OR   a
         RET  z
         LD   a,(de)
         OR   a
         RET  z
         LD   a,(bc)
         OR   a
         RET  z
         EXX  
         INC  (hl)
         EXX  
         EX   af,af
         INC  hl
         INC  de
         INC  bc
         DEC  a
         JR   nz,funcav
         RET  
funhfc
         CALL cleartf
         XOR  a
         LD   (funcheld),a
         CALL isany
         RET  z
         LD   a,(lastwin)
         OR   a
         RET  nz
         CALL checkmon
         RET  z
         LD   a,r
         CP   34
         RET  c
         CALL getnum
         LD   a,0
row1tot  EQU  $-1
         CP   4
         RET  nc
         LD   a,0
row2tot  EQU  $-1
         CP   3
         RET  nc
         LD   a,0
row3tot  EQU  $-1
         CP   5
         RET  nc
         LD   a,#ff
         LD   (funcheld),a
         CALL gamec
         LD   a,20
oscil1
         PUSH af
         LD   de,#3ccf
         CALL setcs
         LD   hl,#cee0+#50
         LD   bc,#e12
         LD   a,#3c
         CALL swichgwa
         POP  af
         PUSH af
         ADD  a,a
         CALL pause
         LD   hl,#cee0+#50
         LD   bc,#e12
         LD   a,#cf
         CALL swichgwa
         POP  af
         PUSH af
         ADD  a,a
         CALL pause
         POP  af
         CALL sosc
         DEC  a
         JR   nz,oscil1
         CALL copyfunc
         JP   dpause
gamblef                                 ; Gamble Gaming Function
         CALL cleartf
         LD   de,#3ccf
         CALL setcs
         LD   hl,#cee0+#50
         LD   bc,#e12
         LD   a,#3c
         CALL swichgwa
         CALL setfuncc
         LD   a,(functcnt)
         OR   a
         RET  z
         XOR  a
         LD   (funcheld),a
         CALL gameff
         CALL clearxs
         CALL setfuncc
         CALL setfun1
         LD   hl,suppress
         LD   a,(hl)
         PUSH af
         LD   (hl),#ff
         PUSH hl
         CALL movenumb
         POP  hl
         POP  af
         LD   (hl),a
gamblef1
         CALL clearix
         LD   a,(functcnt)
         LD   (lfunc),a
         CP   9
         JR   z,takeit
         CALL copyfunc
         CALL hilocont
         JR   nc,losthl
         OR   a
         JR   z,takeitb
         LD   a,(hilonum)
         DEC  a
         JR   z,mega
         CALL bardisp
         JR   gamblef1
takeitb
         LD   a,(functcnt)
         CP   2
         JR   nz,takeit
         CALL addmoney
         CALL addmoney
takeit
         CALL copyfunc
takeita
         LD   a,(functcnt)
         OR   a
         RET  z
         DEC  a
         ADD  a,a
         LD   e,a
         LD   d,0
         LD   hl,functab                ; HL=Address Table Of Gaming Functions
         ADD  hl,de
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         PUSH de
         RET  
takeit1
         CALL gameff
         CALL repeat
         PUSH af
         CALL dpause
         POP  af
         JR   nc,takeita
lostfunc
         CALL resetag
         CALL copyfunc
         CALL game0
         JP   losthl1
losthl
         LD   a,(hilonum)
         DEC  a
         JR   z,mega
         CALL resetag
losthl1
         CALL lostgame
         XOR  a
         LD   (winner),a
         LD   (functcnt),a
         LD   (funcheld),a
         RET  
bardisp
         CALL resethl
         CALL setfuncc
         CALL getfad
         LD   a,#ff
         CALL setfun
         CALL framefly
         CALL setfun1
         LD   hl,functcnt
         INC  (hl)
         RET  
mega                                    ; Mega Cash 4.80 Repeaters
         CALL clearix
         CALL bardisp
         LD   a,(hl)
         SUB  9
         JR   nz,mega
         CALL clearix
         DEC  a
         LD   (suppress),a
         CALL movenumb
         JP   takeit
lostgame
         CALL game0
         LD   a,0
lfunc    EQU  $-1
         DEC  a
         ADD  a,a
         LD   e,a
         LD   d,0
         LD   hl,gamelt
         ADD  hl,de
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         EX   de,hl
         CALL setupms
         LD   a,47
         CALL scrmess
         JP   dspace
clearix
         LD   a,(functcnt)
         DEC  a
         LD   hl,row1bf
         LD   de,row2bf
         LD   bc,row3bf
clearix1
         RET  z
         EX   af,af
         XOR  a
         LD   (hl),a
         LD   (de),a
         LD   (bc),a
         PUSH bc
         PUSH de
         PUSH hl
         CALL framefly
         CALL setfuncc
         CALL setfun1
         POP  hl
         POP  de
         POP  bc
         INC  hl
         INC  de
         INC  bc
         EX   af,af
         DEC  a
         JR   clearix1
clearxs                                 ; Clear Xcess Numbers
         LD   hl,row1bf+8
         LD   de,row2bf+8
         LD   bc,row3bf+8
         LD   a,8
clearx1
         EX   af,af
         LD   a,(de)
         OR   a
         JR   z,clearx2
         LD   a,(hl)
         OR   a
         JR   z,clearx2
         LD   a,(bc)
         OR   a
         JR   z,clearx2
         EX   af,af
         RET  
clearx2
         XOR  a
         LD   (hl),a
         LD   (de),a
         LD   (bc),a
         EX   af,af
         DEC  hl
         DEC  de
         DEC  bc
         DEC  a
         JR   nz,clearx1
         RET  
resfunt
         LD   a,(functcnt)
         OR   a
         RET  z
         XOR  a
         DEC  a
         LD   (flashrt),a
         LD   de,9
         JR   flashrt1
flashfnt                                ; Flash Current Function To Gamble
         LD   hl,count1
         INC  (hl)
         LD   a,(hl)
         SUB  18
         RET  c
         LD   (hl),a
flashrt1
         CALL setfuncc
         CALL getfad
         LD   a,0
flashrt  EQU  $-1
         XOR  #ff
         LD   (flashrt),a
         CALL setfun
         CALL framefly
setfun1
         CALL row1c
         CALL row2c
         JP   row3c
getfad
         LD   a,(functcnt)
         LD   e,a
         LD   d,0
         LD   hl,row1bf
         ADD  hl,de
         LD   e,9
         RET  
setfun
         LD   (hl),a
         ADD  hl,de
         LD   (hl),a
         ADD  hl,de
         LD   (hl),a
         RET  
;
retpres                                 ; Is return Still Pressed
         LD   a,18
         CALL scankey
         JR   z,retpres
         RET  
repeat                                  ; Draw Up Repeat Grid
         CALL gameff
         LD   hl,#e690+#50
         LD   bc,#281c
         PUSH hl
         PUSH bc
         PUSH hl
         PUSH bc
         CALL copyscr
         POP  bc
         POP  hl
         XOR  a
         LD   (rflglse),a
         CALL wipeout
         LD   a,(functcnt)
         CP   9
         JR   z,repeaten
         LD   hl,sprload
         PUSH hl
         LD   de,178
         ADD  hl,de
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         POP  hl
         ADD  hl,de
         EX   de,hl
         LD   hl,#ceee+#51
         LD   b,#c
         LD   c,5
         CALL gen
repeaten
         LD   b,5
         LD   a,1
         LD   hl,repeatlc
yesnod                                  ; Display Yes / No
         INC  a
         PUSH af
         PUSH bc
         PUSH hl
         AND  1
         ADD  a,a
         ADD  a,180
         LD   e,a
         LD   d,0
         LD   hl,sprload
         PUSH hl
         ADD  hl,de
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         POP  hl
         ADD  hl,de
         EX   de,hl
         POP  hl
         PUSH hl
         LD   b,4
         LD   c,13
         CALL gen
         POP  hl
         INC  hl
         INC  hl
         INC  hl
         INC  hl
         INC  hl
         POP  bc
         POP  af
         DJNZ yesnod
         LD   de,#c0cc
         CALL setcs
         CALL retpres
         LD   a,(functcnt)
         SUB  9
         JR   nz,repeatc
         LD   (repmean),a
repeatc                                 ; Repeat Control Loop
         LD   a,0
repeatf  EQU  $-1
         CALL calcrpad
         LD   a,#c0
         CALL swichrep
         CALL udrepm
         CALL calcrpad
         LD   a,#cc
         CALL swichrep
         CALL rpause
         LD   a,0
rflglse  EQU  $-1
         OR   a
         JR   nz,repeatk
         LD   a,18
         CALL scankey
         JR   nz,repeatc
         LD   a,#ff
         LD   (rflglse),a
         LD   a,0
repmean  EQU  $-1
         OR   a
         JR   z,repeatk
         LD   a,(repeatf)
         AND  1
         JR   z,repeatc
repeatk
         LD   a,(repeatf)
         EX   af,af
         CALL dpause
         POP  bc
         POP  hl
         CALL putscr
         LD   a,(repmean)
         XOR  1
         LD   (repmean),a
repnum1
         EX   af,af
         AND  1
         RET  z
         SCF  
         RET  
udrepm                                  ; Update Repeat Motion
         LD   hl,repeatf
         LD   de,backfrth
         LD   a,0
backfrth EQU  $-1
         OR   a
         JR   nz,back
         INC  (hl)
         LD   a,(hl)
         CP   5
         RET  nz
         LD   a,#ff
forth
         LD   (de),a
         LD   a,3
         LD   (hl),a
         RET  
back
         DEC  (hl)
         LD   a,(hl)
         CP   #ff
         LD   a,(hl)
         RET  nz
         XOR  a
         LD   (de),a
         INC  a
         LD   (hl),a
         RET  
rpause
         LD   a,(repeatf)
         AND  1
         CALL rnoise
         INC  a
         ADD  a,a
         JP   pause
calcrpad
         ADD  a,a
         LD   e,a
         LD   d,0
         LD   hl,repeatad
         ADD  hl,de
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         EX   de,hl
         RET  
swichrep
         PUSH af
         CALL framefly
         POP  af
         LD   bc,#40d
         JP   swichgwa
gen
         PUSH bc
         PUSH hl
gen1
         LD   a,(de)
         LD   (hl),a
         INC  hl
         LD   a,h
         OR   #c0
         LD   h,a
         INC  de
         DJNZ gen1
         POP  hl
         LD   a,8
         ADD  a,h
         JR   nc,gen2
         LD   a,#50
         ADD  a,l
         LD   l,a
         LD   a,#c8
         ADC  a,h
gen2
         OR   #c0
         LD   h,a
         POP  bc
         DEC  c
         JR   nz,gen
         RET  
;
Digital                                 ; Digital Display Routine
         LD   hl,DigitalN
DigitalJ
         LD   b,4
dig
         LD   a,(hl)
Digit1
         PUSH hl
         PUSH bc
         ADD  a,a
         LD   e,a
         LD   h,0
         LD   l,h
         LD   d,h
         LD   ix,sprload
         ADD  ix,de
         LD   l,(ix+0)
         LD   h,(ix+1)
         LD   de,sprload
         ADD  hl,de                     ; HL=Address Of Digital No. Data.
         PUSH hl
         LD   a,b
         DEC  a
         ADD  a,a
         LD   l,a
         LD   h,0
         LD   de,dig1
         ADD  hl,de
         LD   e,(hl)
         INC  hl
         LD   d,(hl)                    ; DE=Screen Address
         POP  hl
         LD   a,28
         EX   de,hl
         LD   c,0
         LD   b,6
         CALL decomp
         POP  bc
         POP  hl
         INC  hl
         DJNZ dig
         RET  
;
ingamefd
         LD   ix,sprload
         LD   (placefbd),hl
         LD   de,#e3
         ADD  hl,de
         LD   (placefd1),hl
placefb                                 ; Place Fruit Sprite Into Buffer
         CALL calcrspa
         PUSH hl
         EX   de,hl
         LD   de,reel1bfd
placefbd EQU  $-2
         LD   b,36
placefb1
         PUSH bc
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         POP  bc
         DJNZ placefb1
         POP  de
         LD   a,d
         OR   e
         RET  z
         LD   hl,reel1bfd+#e3
placefd1 EQU  $-2
         LD   c,12
         LD   b,3
placefb0
         PUSH bc
placefb2
         LD   a,(de)
         AND  #aa
         CP   #8a
         JR   z,placefb3
         LD   c,a
         LD   a,(hl)
         AND  #55
         OR   c
         LD   (hl),a
placefb3
         LD   a,(de)
         AND  #55
         CP   #45
         JR   z,placefb4
         LD   c,a
         LD   a,(hl)
         AND  #aa
         OR   c
         LD   (hl),a
placefb4
         INC  hl
         INC  de
         DJNZ placefb2
         INC  hl
         INC  hl
         INC  hl
         INC  hl
         INC  hl
         INC  hl
         INC  hl
         INC  hl
         POP  bc
         DEC  c
         JR   nz,placefb0
         RET  
calcrspa                                ; Calculate Reel Sprite Address
         LD   c,a
         SRL  a
         SRL  a
         SRL  a                         ; Shift Fruit Number
         LD   e,a
         LD   h,0
         ADD  a,a
         ADD  a,e
         ADD  a,a
         ADD  a,a
         LD   l,a
         LD   d,h
         ADD  hl,hl
         ADD  hl,hl
         ADD  hl,de
         ADD  hl,hl
         ADD  hl,de
         ADD  hl,hl
         ADD  hl,hl
         LD   e,(ix+26)
         LD   d,(ix+27)
         ADD  hl,de
         PUSH de
         LD   de,sprload
         ADD  hl,de
         POP  de
         LD   a,c
         PUSH hl
         AND  7
         LD   hl,0
         JR   z,calcra1
         DEC  a
         LD   e,a
         ADD  a,a
         ADD  a,a
         ADD  a,a
         ADD  a,e
         ADD  a,a
         ADD  a,a
         LD   l,a
         LD   e,(ix+28)
         LD   d,(ix+29)
         ADD  hl,de
         LD   de,sprload
         ADD  hl,de
calcra1
         POP  de
         RET  
setpoint                                ; Set Reel Pointers
         LD   ix,sprload
         CALL checkm0
         RET  nz
         LD   a,r
         AND  7
         LD   e,a
         LD   d,0
         LD   hl,reeldtb
         ADD  hl,de
         LD   a,(hl)
         LD   (state),a
         AND  a
setptbf                                 ; Set Buffer Pointers
         RRA  
         LD   de,rel5addd
         LD   hl,ree5adpf
         JR   nc,setbfr5
         LD   de,rel5addu
         LD   hl,ree5aupf
setbfr5
         LD   (reel5adp),hl
         PUSH af
         LD   a,(de)
         LD   hl,reel5bfd
         CALL ingamefd
         POP  af
         RRA  
         LD   de,rel4addd
         LD   hl,ree4adpf
         JR   nc,setbfr4
         LD   de,rel4addu
         LD   hl,ree4aupf
setbfr4
         LD   (reel4adp),hl
         PUSH af
         LD   a,(de)
         LD   hl,reel4bfd
         CALL ingamefd
         POP  af
         RRA  
         LD   de,rel3addd
         LD   hl,ree3adpf
         JR   nc,setbfr3
         LD   de,rel3addu
         LD   hl,ree3aupf
setbfr3
         LD   (reel3adp),hl
         PUSH af
         LD   a,(de)
         LD   hl,reel3bfd
         CALL ingamefd
         POP  af
         RRA  
         LD   de,rel2addd
         LD   hl,ree2adpf
         JR   nc,setbfr2
         LD   de,rel2addu
         LD   hl,ree2aupf
setbfr2
         LD   (reel2adp),hl
         PUSH af
         LD   a,(de)
         LD   hl,reel2bfd
         CALL ingamefd
         POP  af
         RRA  
         LD   de,rel1addd
         LD   hl,ree1adpf
         JR   nc,setbfr1
         LD   de,rel1addu
         LD   hl,ree1aupf
setbfr1
         LD   (reel1adp),hl
         PUSH af
         LD   a,(de)
         LD   hl,reel1bfd
         CALL ingamefd
         POP  af
setrc                                   ; Set Reel Counter
         LD   a,r
         XOR  #4a
xr       EQU  $-1
         LD   (xr),a
         AND  3
         ADD  a,5
         LD   (rscount),a
         RET  
;
swichhld
         LD   a,252
         LD   (colhl),a
         CALL holds2
         LD   a,#c0
         LD   (colhl),a
         RET  
setheldb
         CALL setrc
         CALL boing
         LD   hl,heldf
         BIT  4,(hl)
         SET  4,(hl)
         RET  z
shb1
         BIT  3,(hl)
         SET  3,(hl)
         RET  z
shb2
         BIT  2,(hl)
         SET  2,(hl)
         RET  z
shb3
         BIT  1,(hl)
         SET  1,(hl)
         RET  z
shb4
         SET  0,(hl)
         RET  
holdr
         LD   a,(count)
         CP   39
         CALL z,swichcan
holdrn
         LD   hl,count1
         INC  (hl)
         LD   a,(hl)
         SUB  15
         CALL nc,holds
         LD   a,(functcnt)
         OR   a
         JR   nz,holdrn1
         LD   a,64
         CALL scankey
         CALL z,holdr1
         LD   a,49
         CALL scankey
         CALL z,holdr5
holdrn1
         LD   a,65
         CALL scankey
         CALL z,holdr2
         LD   a,57
         CALL scankey
         CALL z,holdr3
         LD   a,56
         CALL scankey
         CALL z,holdr4
         LD   a,0
heldf    EQU  $-1
         OR   a
         RET  z
         LD   a,(functcnt)
         OR   a
         RET  nz
         LD   a,62
         CALL scankey
         RET  nz
         LD   a,252
         LD   (seth1+5),a
         CALL holdr1
         CALL holdr2
         CALL holdr3
         CALL holdr4
         CALL holdr5
         XOR  a
         LD   (heldf),a
         LD   a,#c0
         LD   (seth1+5),a
         RET  
holds                                   ; Swap Hold Colours
         LD   (hl),a
         LD   a,(colhl)
         XOR  #3c
         LD   (colhl),a
holds2
         LD   a,(heldf)
         BIT  4,a
         LD   hl,#ec12
         CALL z,flashhld
         BIT  3,a
         LD   hl,#cdaf
         CALL z,flashhld
         BIT  2,a
         LD   hl,#eefd
         CALL z,flashhld
         BIT  1,a
         LD   hl,#ef0a
         CALL z,flashhld
         BIT  0,a
         LD   hl,#ef17
         RET  nz
         JR   flashhld
holdr1
         LD   hl,heldf
         BIT  4,(hl)
         SET  4,(hl)
         CALL z,boing
         LD   hl,#ec12
         JR   seth1
holdr2
         LD   hl,heldf
         BIT  3,(hl)
         SET  3,(hl)
         CALL z,boing
         LD   hl,#cdaf
         JR   seth1
holdr3
         LD   hl,heldf
         BIT  2,(hl)
         SET  2,(hl)
         CALL z,boing
         LD   hl,#eefd
         JR   seth1
holdr4
         LD   hl,heldf
         BIT  1,(hl)
         SET  1,(hl)
         CALL z,boing
         LD   hl,#ef0a
         JR   seth1
holdr5
         LD   hl,heldf
         BIT  0,(hl)
         SET  0,(hl)
         CALL z,boing
         LD   hl,#ef17
seth1
         LD   a,(colhl)
         PUSH af
         LD   a,#c0
         LD   (colhl),a
         CALL flashhld
         POP  af
         LD   (colhl),a
         RET  
flashhld
         PUSH af
         LD   de,#fcc0
         CALL setcs
         LD   bc,#a0f
swap1
         LD   a,#c0
colhl    EQU  $-1
         CALL swichgwa
         POP  af
         RET  
;
reel1cd                                 ; Reel 1 Control
         LD   a,(reel1spd)
         OR   a
         JP   z,scrolr1
         LD   hl,reeloffs
         CALL shiftdwr
         LD   a,(moved1)
         ADD  a,e
         LD   (moved1),a
         CALL scrolr1                   ; Move Reel 1
         LD   hl,(reel1adp)
         CALL replaced
         LD   (reel1adp),hl
         LD   hl,moved1
         LD   a,(hl)
         SUB  36
         RET  nz
         LD   (hl),a
         CALL r1down
         LD   hl,ree1adpf
         LD   (reel1adp),hl
         LD   a,(reelt1+mid)
         LD   hl,reel1bfd
         JP   ingamefd
reel2cd                                 ; Reel 2 Control
         LD   a,(reel2spd)
         OR   a
         JP   z,scrolr2
         LD   hl,reelofs1
         CALL shiftdwr
         LD   a,(moved2)
         ADD  a,e
         LD   (moved2),a
         CALL scrolr2
         LD   hl,(reel2adp)
         CALL replaced
         LD   (reel2adp),hl
         LD   hl,moved2
         LD   a,(hl)
         SUB  36
         RET  nz
         LD   (hl),a
         CALL r2down
         LD   hl,ree2adpf
         LD   (reel2adp),hl
         LD   a,(reelt2+mid)
         LD   hl,reel2bfd
         JP   ingamefd
reel3cd
         LD   a,(reel3spd)
         OR   a
         JP   z,scrolr3
         LD   hl,reelofs2
         CALL shiftdwr
         LD   a,(moved3)
         ADD  a,e
         LD   (moved3),a
         CALL scrolr3
         LD   hl,(reel3adp)
         CALL replaced
         LD   (reel3adp),hl
         LD   hl,moved3
         LD   a,(hl)
         SUB  36
         RET  nz
         LD   (hl),a
         CALL r3down
         LD   hl,ree3adpf
         LD   (reel3adp),hl
         LD   a,(reelt3+mid)
         LD   hl,reel3bfd
         JP   ingamefd
reel4cd
         LD   a,(reel4spd)
         OR   a
         JP   z,scrolr4
         LD   hl,reelofs1
         CALL shiftdwr
         LD   a,(moved4)
         ADD  a,e
         LD   (moved4),a
         CALL scrolr4
         LD   hl,(reel4adp)
         CALL replaced
         LD   (reel4adp),hl
         LD   hl,moved4
         LD   a,(hl)
         SUB  36
         RET  nz
         LD   (hl),a
         CALL r4down
         LD   hl,ree4adpf
         LD   (reel4adp),hl
         LD   a,(reelt4+mid+1)
         LD   hl,reel4bfd
         JP   ingamefd
reel5cd
         LD   a,(reel5spd)
         OR   a
         JP   z,scrolr5
         LD   hl,reeloffs
         CALL shiftdwr
         LD   a,(moved5)
         ADD  a,e
         LD   (moved5),a
         CALL scrolr5
         LD   hl,(reel5adp)
         CALL replaced
         LD   (reel5adp),hl
         LD   hl,moved5
         LD   a,(hl)
         SUB  36
         RET  nz
         LD   (hl),a
         CALL r5down
         LD   hl,ree5adpf
         LD   (reel5adp),hl
         LD   a,(reelt5+mid+2)
         LD   hl,reel5bfd
         JP   ingamefd
shiftdwr                                ; Shift Reel Down
         DEC  a
         LD   e,a
         LD   d,0
         ADD  hl,de
         LD   a,(hl)
         LD   (copyr1),a
         LD   (copyr3),a
         LD   e,6
         ADD  hl,de
         LD   a,(hl)
         LD   (scrolrm1),a
         LD   (scrolrm5),a
         LD   (scrolrm2),a
         LD   (scrolrm4),a
         LD   (scrolrm3),a
         LD   e,0
copyr1   EQU  $-1
         RET  
replaced                                ; Replace Sprite Down : HL=ReelADDP
         LD   b,0
copyr3   EQU  $-1
repr1
         PUSH bc
         PUSH de
         PUSH hl
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         POP  hl
         LD   de,11
         AND  a
         SBC  hl,de
         POP  de
         LD   a,d
         SUB  8
         LD   d,a
         CP   #c0
         JR   nc,repr1a
         EX   de,hl
         LD   bc,#3fb0
         ADD  hl,bc
         EX   de,hl
repr1a
         POP  bc
         DJNZ repr1
         RET  
scrolr1                                 ; Move Reel 1 Down
         LD   a,(reel1spd)
         LD   de,#dbc2
         LD   hl,reel1sad
         LD   b,35
scrolrm1 EQU  $-1
         JR   scroldr
scrolr2
         LD   a,(reel2spd)
         LD   de,#fd0f
         LD   hl,reel2sad
         LD   b,70
scrolrm2 EQU  $-1
         JR   scroldr
scrolr3
         LD   a,(reel3spd)
         LD   de,#deac
         LD   hl,reel3sad
         LD   b,105
scrolrm3 EQU  $-1
         JR   scroldr
scrolr4
         LD   a,(reel4spd)
         LD   de,#deb9
         LD   hl,reel4sad
         LD   b,71
scrolrm4 EQU  $-1
         JR   scroldr
scrolr5
         LD   a,(reel5spd)
         LD   de,#dec6
         LD   hl,reel5sad
         LD   b,35
scrolrm5 EQU  $-1
scroldr                                 ; Scroll Reel X
         PUSH de
         SLA  a
         LD   e,a
         LD   d,0
         ADD  hl,de
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         EX   de,hl
         POP  de
scroldr1
         PUSH bc
         PUSH de
         PUSH hl
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         POP  hl
         LD   a,h
         SUB  8
         LD   h,a
         CP   #c0
         JR   nc,scroldr2
         LD   de,#3fb0
         ADD  hl,de
scroldr2
         POP  de
         LD   a,d
         SUB  8
         LD   d,a
         CP   #c0
         JR   nc,scroldr3
         EX   de,hl
         LD   bc,#3fb0
         ADD  hl,bc
         EX   de,hl
scroldr3
         POP  bc
         DJNZ scroldr1
         RET  
reel1cu                                 ; Reel 1 Control
         LD   a,(reel1spd)
         OR   a
         JP   z,scrour1
         LD   hl,reeloffs
         CALL shiftupr
         LD   a,(moved1)
         ADD  a,e
         LD   (moved1),a
         CALL scrour1                   ; Move Reel 1
         LD   hl,(reel1adp)
         CALL replaceu
         LD   (reel1adp),hl
         LD   hl,moved1
         LD   a,(hl)
         SUB  36
         RET  nz
         LD   (hl),a
         CALL r1up
         LD   hl,ree1aupf
         LD   (reel1adp),hl
         LD   a,(reelt1+mid+2)
         LD   hl,reel1bfd
         JP   ingamefd
reel2cu
         LD   a,(reel2spd)
         OR   a
         JP   z,scrour2
         LD   hl,reelofs1
         CALL shiftupr
         LD   a,(moved2)
         ADD  a,e
         LD   (moved2),a
         CALL scrour2                   ; Move Reel 1
         LD   hl,(reel2adp)
         CALL replaceu
         LD   (reel2adp),hl
         LD   hl,moved2
         LD   a,(hl)
         SUB  36
         RET  nz
         LD   (hl),a
         CALL r2up
         LD   hl,ree2aupf
         LD   (reel2adp),hl
         LD   a,(reelt2+mid+3)
         LD   hl,reel2bfd
         JP   ingamefd
reel3cu
         LD   a,(reel3spd)
         OR   a
         JP   z,scrour3
         LD   hl,reelofs2
         CALL shiftupr
         LD   a,(moved3)
         ADD  a,e
         LD   (moved3),a
         CALL scrour3                   ; Move Reel 1
         LD   hl,(reel3adp)
         CALL replaceu
         LD   (reel3adp),hl
         LD   hl,moved3
         LD   a,(hl)
         SUB  36
         RET  nz
         LD   (hl),a
         CALL r3up
         LD   hl,ree3aupf
         LD   (reel3adp),hl
         LD   a,(reelt3+mid+4)
         LD   hl,reel3bfd
         JP   ingamefd
reel4cu
         LD   a,(reel4spd)
         OR   a
         JP   z,scrour4
         LD   hl,reelofs1
         CALL shiftupr
         LD   a,(moved4)
         ADD  a,e
         LD   (moved4),a
         CALL scrour4                   ; Move Reel 1
         LD   hl,(reel4adp)
         CALL replaceu
         LD   (reel4adp),hl
         LD   hl,moved4
         LD   a,(hl)
         SUB  36
         RET  nz
         LD   (hl),a
         CALL r4up
         LD   hl,ree4aupf
         LD   (reel4adp),hl
         LD   a,(reelt4+mid+4)
         LD   hl,reel4bfd
         JP   ingamefd
reel5cu
         LD   a,(reel5spd)
         OR   a
         JP   z,scrour5
         LD   hl,reeloffs
         CALL shiftupr
         LD   a,(moved5)
         ADD  a,e
         LD   (moved5),a
         CALL scrour5                   ; Move Reel 1
         LD   hl,(reel5adp)
         CALL replaceu
         LD   (reel5adp),hl
         LD   hl,moved5
         LD   a,(hl)
         SUB  36
         RET  nz
         LD   (hl),a
         CALL r5up
         LD   hl,ree5aupf
         LD   (reel5adp),hl
         LD   a,(reelt5+mid+4)
         LD   hl,reel5bfd
         JP   ingamefd
shiftupr                                ; Shift Reel Up
         DEC  a
         LD   e,a
         LD   d,0
         ADD  hl,de
         LD   a,(hl)
         LD   (copyru1),a
         LD   (copyru3),a
         LD   e,6
         ADD  hl,de
         LD   a,(hl)
         LD   (scrourm1),a
         LD   (scrourm5),a
         LD   (scrourm2),a
         LD   (scrourm4),a
         LD   (scrourm3),a
         LD   e,0
copyru1  EQU  $-1
         RET  
replaceu                                ; Replace Sprite Up : HL=ReelADDP
         LD   b,0
copyru3  EQU  $-1
repru1
         PUSH bc
         PUSH de
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         POP  de
         EX   de,hl
         LD   a,h
         ADD  a,8
         JR   nc,repru1a
         LD   a,l
         ADD  a,#50
         LD   l,a
         LD   a,h
         ADC  a,#c8
repru1a
         LD   h,a
         EX   de,hl
         POP  bc
         DJNZ repru1
         RET  
scrour1                                 ; Move Reel 1 Up
         LD   a,(reel1spd)
         LD   de,#c282
         LD   hl,reel1sau
         LD   b,35
scrourm1 EQU  $-1
         JR   scrolur
scrour2
         LD   a,(reel2spd)
         LD   de,#c28f
         LD   hl,reel2sau
         LD   b,70
scrourm2 EQU  $-1
         JR   scrolur
scrour3
         LD   a,(reel3spd)
         LD   de,#c29c
         LD   hl,reel3sau
         LD   b,105
scrourm3 EQU  $-1
         JR   scrolur
scrour4
         LD   a,(reel4spd)
         LD   de,#e3e9
         LD   hl,reel4sau
         LD   b,71
scrourm4 EQU  $-1
         JR   scrolur
scrour5
         LD   a,(reel5spd)
         LD   de,#c586
         LD   hl,reel5sau
         LD   b,35
scrourm5 EQU  $-1
scrolur                                 ; Scroll Reel X
         OR   a
         JR   nz,scrolurx
         PUSH de
         POP  hl
         JR   scrolur1
scrolurx
         DEC  a
         PUSH de
         SLA  a
         LD   e,a
         LD   d,0
         ADD  hl,de
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         POP  hl
         EX   de,hl
         LD   a,h
         ADD  a,8
         JR   nc,scrolurj
         LD   a,l
         ADD  a,#50
         LD   l,a
         LD   a,h
         ADC  a,#c8
scrolurj
         LD   h,a
scrolur1
         PUSH bc
         PUSH de
         PUSH hl
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         POP  hl
         LD   a,h
         ADD  a,8
         JR   nc,scrolur2
         LD   a,l
         ADD  a,#50
         LD   l,a
         LD   a,h
         ADC  a,#c8
scrolur2
         LD   h,a
         POP  de
         LD   a,d
         ADD  a,8
         JR   nc,scrolur3
         LD   a,e
         ADD  a,#50
         LD   e,a
         LD   a,d
         ADC  a,#c8
scrolur3
         LD   d,a
         POP  bc
         DJNZ scrolur1
         RET  
;
hilocont                                ; Hi \ Lo Control
         CALL togglehl
         LD   b,150
kpause
         PUSH bc
         LD   a,44
         CALL scankey
         JR   z,higher
         LD   a,36
         CALL scankey
         JR   z,lower
         CALL collect
         JR   c,take
         LD   a,0
functcnt EQU  $-1
         OR   a
         CALL nz,flashfnt               ; Flash Current Function To Gamble
         LD   a,0
coinflsh EQU  $-1
         OR   a
         CALL nz,flshcoin
         POP  bc
         DJNZ kpause
         JR   hilocont
higher
         CALL resfunt
         POP  hl
         CALL resethl
         CALL sethi
         LD   a,#ff
         CALL movenumb
         JR   z,higher1
         CCF  
         RET  
lower
         CALL resfunt
         POP  hl
         CALL resethl
         CALL setlo
         XOR  a
         CALL movenumb
         RET  
take
         CALL resfunt
         POP  hl
         CALL resethl
higher1
         XOR  a
         SCF  
         RET  
movenumb
         LD   (hilop),a
         LD   a,8
hilonum  EQU  $-1
         DEC  a
         JR   nz,mov2
         LD   a,13
mov2
         LD   (hilocomp),a
         CALL accelnms
         CALL resethl
         LD   a,(hilonum)
         DEC  a
         JR   nz,movenum1
         LD   a,13
movenum1
         CP   0
hilocomp EQU  $-1
         LD   a,#ff
         RET  
togglehl
         LD   de,#c0cc
         CALL setcs
         CALL framefly
         LD   hl,#800
framel
         DEC  hl
         LD   a,l
         OR   h
         JR   nz,framel
         CALL swichhi
         CALL framefly
swichlo
         LD   a,#cc
         XOR  #c
         LD   (swichlo+1),a
swichlo1
         LD   hl,#db04
         LD   bc,#d0e
         JP   swichgwa
swichhi                                 ; Switch HI Colours
         LD   a,#c0
         XOR  #c
         LD   (swichhi+1),a
swichhi1
         LD   hl,#c884
         LD   bc,#d0e
         JP   swichgwa
sethi
         CALL framefly
         LD   a,#cc
         JR   swichhi1
setlo
         CALL framefly
         LD   a,#cc
         JR   swichlo1
resethl
         LD   de,#c0cc
         CALL setcs
         LD   a,#c0
         CALL swichhi1
         LD   a,#c0
         JR   swichlo1
accelnms                                ; Accelerate Number Reels On Start Up
         LD   a,0
suppress EQU  $-1
         LD   a,r
         XOR  %101010
acelnmr  EQU  $-1
         LD   (acelnmr),a
         AND  15
         ADD  a,5
         CP   15
         JR   z,accelnms
         LD   c,a
         LD   a,(mean)
         OR   a
         JR   z,accelnmc
accelnmd
         LD   a,2
counthi  EQU  $-1
         DEC  a
         LD   (counthi),a
         JR   nz,accelnmc
         LD   a,r
         AND  3
         INC  a
         LD   (counthi),a
         LD   a,0
hilop    EQU  $-1
         OR   a
         LD   c,16
         JR   z,accelnmc
         DEC  c
         DEC  c
accelnmc
         LD   a,c
         DEC  a
accelnme
         LD   (amount2),a
         XOR  a
         LD   (movedhi),a
         CALL sethilob
         LD   hl,accelsqn
         LD   b,11
accelnm1
         PUSH bc
         PUSH hl
         LD   a,(hl)
         LD   (hilospd),a
         CALL framefly
         CALL scrlhilo
         POP  hl
         LD   b,(hl)
         LD   a,6
         SUB  b
         ADD  a,a
accelnm2
         PUSH af
         CALL framefly
         POP  af
         DEC  a
         JR   nz,accelnm2
         POP  bc
         INC  hl
         DJNZ accelnm1
movnumb
         LD   a,12
amount2  EQU  $-1
         DEC  a
         LD   (amount2),a
         JR   z,movnumb3
         XOR  a
         LD   (movedhi),a
movnumb2
         CALL framefly
         CALL scrlhilo
         LD   a,(movedhi)
         OR   a
         JR   nz,movnumb2
         JR   movnumb
movnumb3
         LD   a,(suppress)
         OR   a
         JP   z,boing
         LD   a,(hilonum)
         DEC  a
         JP   nz,boing
         LD   a,r
         AND  3
         ADD  a,2
         LD   (amount2),a
         JR   movnumb
;
sethilob                                ; Set Hi Lo Buffer
         LD   a,(hilonum)
         ADD  a,a
         ADD  a,30
         LD   e,a
         LD   d,0
         LD   hl,sprload
         PUSH hl
         ADD  hl,de
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         POP  hl
         ADD  hl,de
         EX   de,hl
         LD   hl,reel1bfd
         LD   (hilobufa),hl
         LD   b,14
         LD   a,36
         LD   c,1
         JP   decomp
scrlhilo                                ; Scroll Hi Lo Grid UP
         LD   a,0
movedhi  EQU  $-1
         OR   a
         CALL z,sethilob
         LD   a,0
hilospd  EQU  $-1
         OR   a
         RET  z
         DEC  a
         LD   c,a
         LD   hl,hilofs
         LD   e,a
         LD   d,0
         ADD  hl,de
         LD   a,(hl)
         LD   (hilrep),a
         LD   e,7
         ADD  hl,de
         LD   a,(hl)
         LD   (hiloscam),a
         LD   a,c
         ADD  a,a
         LD   e,a
         LD   hl,hiloscad
         ADD  hl,de
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         EX   de,hl
         LD   de,#f923
         LD   b,0
hiloscam EQU  $-1
hilosc
         PUSH bc
         PUSH de
         PUSH hl
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         POP  hl
         LD   a,8
         ADD  a,h
         JR   nc,hilosc1
         LD   a,#50
         ADD  a,l
         LD   l,a
         LD   a,#c8
         ADC  a,h
hilosc1
         OR   #c0
         LD   h,a
         POP  de
         LD   a,8
         ADD  a,d
         JR   nc,hilosc2
         LD   a,#50
         ADD  a,e
         LD   e,a
         LD   a,#c8
         ADC  a,d
hilosc2
         OR   #c0
         LD   d,a
         POP  bc
         DJNZ hilosc
         LD   hl,reel1bfd
hilobufa EQU  $-2
         LD   b,0
hilrep   EQU  $-1
hreploop
         PUSH bc
         PUSH de
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         POP  de
         LD   a,8
         ADD  a,d
         JR   nc,hrepl1
         LD   a,#50
         ADD  a,e
         LD   e,a
         LD   a,d
         ADC  a,#c8
hrepl1
         OR   #c0
         LD   d,a
         POP  bc
         DJNZ hreploop
         LD   (hilobufa),hl
         LD   a,(hilrep)
         LD   hl,movedhi
         ADD  a,(hl)
         LD   (hl),a
         SUB  36
         RET  nz
         LD   (hl),a
         LD   hl,hilonum
         INC  (hl)
         LD   a,(hl)
         SUB  14
         RET  nz
         LD   (hl),1
         RET  
;
meancont                                ; Control Mean Streak Of Computer
         ENT  $
         LD   de,200                    ; How Much Paid Out
paidout  EQU  $-2
         LD   hl,0
         ADD  hl,de
         ADD  hl,hl
         ADD  hl,de
         ADD  hl,hl
         ADD  hl,hl
         ADD  hl,hl
         ADD  hl,de
         ADD  hl,hl
         ADD  hl,hl                     ; HL=Winnings * 100
division                                ; 16 Bit Division Routine
         PUSH hl
         POP  bc
         LD   hl,0
         LD   de,400                    ; Computers Takings !
takings  EQU  $-2
         LD   a,b
         LD   b,16
divshift
         SLA  c
         RLA  
         ADC  hl,hl
         SBC  hl,de
         JR   c,divskip
         INC  c
         JR   divover
divskip
         ADD  hl,de
divover
         DJNZ divshift
         LD   a,c                       ; C = Roughly % Payout
         LD   (percent),a
         CP   40                        ; Is Payout < Legal Minimum ?
         JR   c,notmean                 ; If < Than Increase Chances
         CP   84
         RET  c
notmean
         CCF  
         SBC  a,a
         LD   (mean),a
         LD   (suppress),a
         RET  
submoney                                ; Money Handling Routines
         CALL submon2
         JR   meancont
submon2
         LD   hl,DigitalN+1
         LD   b,3
submon1
         DEC  (hl)
         LD   a,(hl)
         CP   #ff
         JR   nz,submon3
         LD   (hl),9
         INC  hl
         DJNZ submon1
submon3
         LD   hl,(takings)
         INC  hl
         LD   (takings),hl
         BIT  1,h
         RET  z
intake1                                 ; Divide Takings & Winnings By 2
         LD   hl,(takings)
         SRL  h
         RR   l
         LD   (takings),hl
         LD   hl,(paidout)
         SRL  h
         RR   l
         LD   (paidout),hl
         RET  
addmoney
         CALL admon2
         JR   meancont
admon2
         LD   hl,DigitalN+1
         LD   b,3
addmony1
         INC  (hl)
         LD   a,(hl)
         CP   #a
         JR   nz,addmony2
         LD   (hl),0
         INC  hl
         DJNZ addmony1
addmony2
         LD   hl,(paidout)
         INC  hl
         LD   (paidout),hl
         BIT  1,h
         RET  z
         JR   intake1
checkmon
         LD   de,(DigitalN)
         LD   hl,(DigitalN+2)
         XOR  a
         OR   l
         OR   h
         ADD  a,a
         OR   e
         OR   d
         RET  z
         DEC  a
         RET  nz
         DEC  d
         RET  
resetwb
         LD   hl,#00
         LD   (DigitalN),hl
         INC  l
         LD   (DigitalN+2),hl
         RET  
getnum
         LD   a,(lastwin)
         OR   a
         RET  nz
         LD   hl,winlbuff+1
         LD   e,0
         LD   c,e
         PUSH hl
         CALL addnum
         CALL addnum
         LD   a,e
         LD   (number1),a
         POP  hl
         INC  hl
         LD   e,0
         CALL addnum
         CALL addnum
         CALL addnum
         LD   a,e
         LD   (number2),a
         LD   hl,winlbuff+5
         LD   e,0
         CALL addnum
         CALL addnum
         LD   a,e
         LD   (number3),a
         LD   a,c
         LD   (numbers),a
         OR   a
         RET  
dispfunc
         LD   a,(functcnt)
         OR   a
         RET  nz
         LD   a,(lastwin)
         OR   a
         RET  nz
         CALL gameff
         CALL setfuncc
         CALL dcash
         CALL dropr1
         CALL dropr2
         CALL dropr3
         JP   copyfunc
addnum
         LD   a,(hl)
         AND  7
         CP   4
         CALL z,addnum1
         ADD  a,e
         LD   e,a
         ADD  a,c
         LD   c,a
         INC  hl
         INC  hl
         RET  
addnum1
         LD   a,r
         AND  3
         RET  
getwin
         CALL getwinl
getwiner
         XOR  a
         LD   (lastwin),a
         LD   hl,winlbuff
         CALL checkw2
         CALL checkw2
checkw2
         LD   a,(hl)
         AND  %11111000
         LD   e,a
         INC  hl
         LD   a,(hl)
         AND  %11111000
         LD   d,a
         INC  hl
         LD   a,(hl)
         AND  %11111000
         LD   b,e
         LD   c,a
         LD   a,d
         INC  hl
         SUB  b
         RET  nz
         LD   a,b
         SUB  c
         LD   b,4
         LD   a,c
         JR   nz,gw1
         CALL calcwin
gw1
         LD   a,(lastwin)
         ADD  a,b
         LD   (lastwin),a
         RET  
incmoney
         CALL convert
         LD   a,255
lastwin  EQU  $-1
         OR   a
         RET  z
         LD   b,a
im1
         PUSH bc
         PUSH hl
         CALL addmoney
         CALL framefly
         CALL Digital
         CALL ping
         LD   a,20
         CALL pause
         POP  hl
         POP  bc
         DJNZ im1
         JP   cleartf
im2
         XOR  a
         LD   (funcheld),a
         JP   resetf
getwinl                                 ; Get Winning Lines Out In To Table
         LD   de,winlbuff
         LD   hl,reelt1+mid+1
         CALL getwinla
         LD   hl,reelt2+mid+2
         CALL getwinla
         LD   hl,reelt3+mid+3
getwinla
         CALL getwinlb
         CALL getwinlb
getwinlb
         LD   a,(hl)
         LD   (de),a
         INC  de
         LD   bc,nfrtpr
         ADD  hl,bc
         RET  
calcwin
         PUSH hl
         SRL  c
         SRL  c
         SRL  c
         LD   e,c
         LD   d,0
         LD   hl,wintable
         ADD  hl,de
         LD   b,(hl)
         POP  hl
         RET  
multiple                                ; Multiple Key Presses
         PUSH hl
         PUSH bc
         LD   a,(hl)
         CALL scankey
         POP  bc
         POP  hl
         JR   nz,multkey2
         INC  hl
         DJNZ multiple
         SCF  
         RET  
multkey2
         OR   a
         RET  
regs                                    ; Display Machines Status
         LD   hl,regstr
         LD   b,4
         CALL multiple
         RET  nc
         LD   a,0
percent  EQU  $-1
         LD   d,10
         CALL subtract
         ADD  a,#30
         LD   (ppc+1),a
         LD   a,#30
         ADD  a,c
         CP   #30
         JR   nz,regs1
         ADD  a,#f
regs1
         LD   (ppc),a
         LD   hl,pms
         LD   a,(mean)
         CALL onoroff
         LD   a,(suppress)
         LD   hl,pms1
         CALL onoroff
         LD   hl,info
scrmessj
         CALL setupms
         LD   a,47
scrmessk
         CALL scrmess
         JP   dspace
onoroff
         OR   a
         JR   nz,onset
         CALL onoroff1
onoroff1
         LD   (hl),"F"
         INC  hl
         RET  
onset
         LD   (hl),"N"
         INC  hl
         LD   (hl),"?"
         RET  
convert
         XOR  a
         LD   (plus),a
         LD   a,(lastwin)               ; A=Amount Won
         OR   a
         RET  z
         LD   d,10                      ; Pounds
         CALL subtract
         LD   hl,pounds
         LD   (hl),c
         LD   (pence),a
         LD   d,5
         CALL subtract
         LD   hl,fifty
         LD   (hl),c
         LD   d,2
         CALL subtract
         LD   hl,twenty
         LD   (hl),c
         LD   d,1
         CALL subtract
         LD   hl,tens
         LD   (hl),c
         LD   hl,wunm
         LD   a,(pounds)
         OR   a
         JR   z,verbalm1
         LD   (hl),">"
         ADD  a,#30
         INC  hl
         LD   (hl),a
         INC  hl
         LD   (hl),"."
         INC  hl
verbalm1
         LD   a,0
pence    EQU  $-1
         ADD  a,#30
         LD   (hl),a
         INC  hl
         LD   (hl),#30
         INC  hl
         LD   a,(pounds)
         OR   a
         JR   nz,verbalm2
         LD   (hl),"P"
         INC  hl
verbalm2
         LD   (hl),"?"
         INC  hl
         LD   (hl),";"
         INC  hl
         LD   (hl),"?"
         INC  hl
         LD   a,0
pounds   EQU  $-1
         OR   a
         CALL nz,pounds1
         LD   a,0
fifty    EQU  $-1
         LD   d,5
         OR   a
         CALL nz,pence1
         LD   a,0
twenty   EQU  $-1
         LD   d,2
         OR   a
         CALL nz,pence1
         LD   a,0
tens     EQU  $-1
         SRL  d
         OR   a
         CALL nz,pence1
         LD   (hl),#ff
         LD   hl,youvewun
         CALL setupms
         LD   a,79
         CALL scrmess
         JP   dspace
pounds1
         LD   a,(pounds)
         CALL timesX
         LD   (hl),">"
         INC  hl
         LD   (hl),#31
         INC  hl
         LD   (hl),"?"
         INC  hl
         RET  
pence1
         EX   af,af
         LD   a,0
plus     EQU  $-1
         OR   a
         CALL nz,plus1
         EX   af,af
         CALL timesX
         LD   a,#30
         ADD  a,d
         LD   (hl),a
         INC  hl
         LD   (hl),#30
         INC  hl
         LD   (hl),"P"
         INC  hl
         LD   (hl),"?"
         INC  hl
         LD   (hl),"?"
         RET  
timesX
         LD   (hl),"?"
         INC  hl
         ADD  a,#30
         LD   (hl),a
         INC  hl
         LD   (hl),"?"
         INC  hl
         LD   (hl),"X"
         INC  hl
         LD   (hl),"?"
         INC  hl
         LD   a,#ff
         LD   (plus),a
         RET  
plus1
         LD   (hl),"?"
         INC  hl
         LD   (hl),"+"
         INC  hl
         LD   (hl),"?"
         INC  hl
         RET  
subtract
         LD   c,0
subt1
         SUB  d
         INC  c
         JR   nc,subt1
         ADD  a,d
         DEC  c
         RET  
updatemb                                ; Update Cash Pot Money Box
         LD   hl,nudges                 ; Update Nudges As Well
         LD   a,(hl)
         OR   a
         JR   nz,udnb1
         LD   (hl),1
udnb1
         CP   9
         JR   z,updatem1
         LD   a,15
udnb     EQU  $-1
         DEC  a
         LD   (udnb),a
         BIT  7,a
         JR   z,updatem1
         LD   a,r
         AND  7
         ADD  a,8
         LD   (udnb),a
         INC  (hl)
         CALL boing
updatem1
         LD   hl,cashpotm
         LD   a,(hl)
         CP   24
         RET  z
         LD   a,7
udmb     EQU  $-1
         DEC  a
         LD   (udmb),a
         BIT  7,a
         RET  z
         LD   a,r
         AND  7
         INC  a
         LD   (udmb),a
         INC  (hl)
         JP   ping
;
decomp                                  ; HL=Addr - DECMP DATA : DE = CMP DATA
         PUSH af
         LD   a,c
         OR   a
         LD   a,#38
         JR   nz,dec
         XOR  a
dec
         LD   (decompv2+4),a
         POP  af
         CALL setdcmpv
         LD   a,b
         LD   (decmwid1),a
         LD   (decomps4),a
         LD   (decwid),a
decompv1
         LD   a,(de)
         OR   a
         RET  z
         PUSH af
         AND  #80
         JR   nz,decr
         POP  af
         AND  #7f
         LD   b,a
         INC  de
decompv3
         LD   a,(de)
         INC  de
         CALL decompv2
         RET  nc
         DJNZ decompv3
         JR   decompv1
decr
         POP  af
         AND  #7f
         LD   b,a
         INC  de
decrv1
         LD   a,(de)
         CALL decompv2
         RET  nc
         DJNZ decrv1
         INC  de
         JR   decompv1
decompv2                                ; Update HL
         LD   hl,#c000
         JR   decmem
decompvs
         LD   (hl),a
         LD   a,8
         ADD  a,h
         JR   nc,decomps1
         LD   a,#50
         ADD  a,l
         LD   l,a
         LD   a,h
         ADC  a,#c8
decomps1
         OR   #c0
         LD   h,a
         LD   (decompv2+1),hl
         INC  c
         LD   a,c
         CP   200
decomps2 EQU  $-1
         SCF  
         RET  nz
         LD   c,0
         LD   hl,(decmpvo)
         INC  hl
         LD   a,h
         OR   #c0
         LD   h,a
         LD   (decmpvo),hl
         LD   (decompv2+1),hl
         LD   a,0
decomps3 EQU  $-1
         INC  a
         LD   (decomps3),a
         CP   2
decomps4 EQU  $-1
         SCF  
         RET  nz
         XOR  a
         LD   (decomps3),a
         RET  
decmem
         LD   (hl),a
         LD   a,0
decwid   EQU  $-1
         ADD  a,l
         LD   l,a
         ADC  a,h
         SUB  l
         LD   h,a
         LD   (decompv2+1),hl
         INC  c
         LD   a,c
         CP   0
decompof EQU  $-1
         SCF  
         RET  nz
         LD   c,0
         LD   hl,#c000
decmpvo  EQU  $-2
         INC  hl
         LD   a,0
decmwid  EQU  $-1
         INC  a
         LD   (decmwid),a
         CP   0
decmwid1 EQU  $-1
         JR   nz,setd
         OR   a
         RET  
setd     LD   a,(decompof)
setdcmpv
         LD   (decmpvo),hl
         LD   (decompv2+1),hl
         LD   (decompof),a
         LD   (decomps2),a
         XOR  a
         LD   (decmwid),a
         LD   (decomps3),a
         LD   c,0
         SCF  
         RET  
;
calcgwsa                                ; Calculate Gamble Win Screen Address
         LD   l,a                       ; Entry A=Height In Table
         LD   h,0
         LD   de,gwsat
         ADD  hl,de
         LD   a,(hl)
         LD   c,a
         AND  15
         OR   #e0
         LD   h,a
         LD   a,c
         AND  #f0
         OR   3
         LD   l,a
         RET  
cleartf                                 ; Clear Trail Flags
         LD   hl,trailfc
         LD   b,12
         XOR  a
ctf
         LD   (hl),a
         INC  hl
         DJNZ ctf
         CALL framefly
trailc                                  ; Trail Control Routine
         LD   de,#cc3c
         CALL setcs
         CALL framefly
         LD   de,trailfc
         LD   hl,trailfo
         LD   c,0
trailc1
         LD   a,(de)
         CP   (hl)
         LD   (hl),a
         CALL nz,trailc2
         INC  hl
         INC  de
         INC  c
         LD   a,c
         CP   11
         JR   NZ,trailc1
         CALL framefly
         LD   de,#c0cc
         CALL setcs
         LD   hl,#ef23
         LD   a,(lose)
         OR   a
         LD   a,#cc
         JR   nz,l3
         LD   a,#c0
l3
         AND  #55
         LD   d,a
         RLCA 
         LD   e,a
         LD   bc,#d12
         JR   swichgw1
trailc2
         PUSH bc
         PUSH de
         PUSH hl
         LD   b,(hl)
         LD   a,c
         CALL calcgwsa
         XOR  a
         OR   b
         LD   a,#cc
         CALL nz,gtable
         JR   nz,trailc3
         LD   a,#3c
trailc3
         CALL swichgw
         POP  hl
         POP  de
         POP  bc
         RET  
setcs                                   ; Set Colours To Switch
         LD   a,d
         AND  #55
         LD   (sgw2a),a
         RLCA 
         LD   (sgw1a),a
         LD   a,e
         AND  #55
         LD   (sgw2b),a
         RLCA 
         LD   (sgw1b),a
         RET  
swichgw                                 ; Switch Money Counters
         LD   bc,#d0f
swichgwa
         AND  #55
         LD   d,a
         RLCA 
         LD   e,a
swichgw1
         PUSH bc
         PUSH hl
swichgw2
         LD   a,(hl)
         AND  #aa
         CP   #28
sgw1a    EQU  $-1
         JR   z,swichgw3
         CP   #88
sgw1b    EQU  $-1
         JR   nz,swichgw4
swichgw3
         LD   a,(hl)
         AND  #55
         OR   e
         LD   (hl),a
swichgw4
         LD   a,(hl)
         AND  #55
         CP   #14
sgw2a    EQU  $-1
         JR   z,swichgw5
         CP   #44
sgw2b    EQU  $-1
         JR   nz,swichgw6
swichgw5
         LD   a,(hl)
         AND  #aa
         OR   d
         LD   (hl),a
swichgw6
         INC  hl
         LD   a,h
         OR   #c0
         LD   h,a
         DJNZ swichgw2
         POP  hl
         LD   a,h
         ADD  a,8
         JR   nc,swichgw7
         LD   a,#50
         ADD  a,l
         LD   l,a
         LD   a,#c8
         ADC  a,h
swichgw7
         OR   #c0
         LD   h,a
         POP  bc
         DEC  c
         JR   nz,swichgw1
         RET  
bags                                    ; Player Won 4.80 Spin To Bags
         CALL setpoint
         LD   a,%10001
         LD   (heldf),a
         CALL acellrls
bags1
         CALL getwin
         LD   de,winlbuff+3
         LD   hl,reel2spd
         CALL bags5
         LD   hl,reel3spd
         CALL bags5
         LD   hl,reel4spd
         CALL bags5
         CALL bags4
         JR   z,bags3
bags2
         CALL moveallr
         CALL checkm0
         JR   nz,bags2
         JR   bags1
bags3
         SUB  a
         LD   (heldf),a
         RET  
bags4
         EX   de,hl
         LD   a,#40
         DEC  hl
         CP   (hl)
         RET  nz
         DEC  hl
         CP   (hl)
         RET  nz
         DEC  hl
         CP   (hl)
         RET  
bags5
         LD   a,(de)
         AND  #f8
         LD   (de),a
         INC  de
         CP   #40
         RET  nz
         LD   (hl),0
         JP   boing
gamble
         CALL sdisable
         XOR  a
         LD   (flaglse),a
         LD   a,3
gt       EQU  $-1
         CALL pause
         CALL addnum1
         INC  a
         LD   (gt),a
         CALL retpres
gambleaz
         LD   a,(lastwin)
         OR   a
         RET  z
         SUB  48
         JR   nc,bags
         LD   hl,gwin-1
         ADD  a,48
         LD   b,11
gamble1
         CP   (hl)
         JR   z,gamble2
         JR   c,gamble2
         DEC  hl
         DJNZ gamble1
         RET  
gamble2
         LD   a,(hl)
         LD   (lastwin),a
         CALL settrail
         CALL settf
         CALL framefly
         LD   a,7                       ; Get Computer Timings
computg  EQU  $-1
         CALL ploseg
         JR   c,finalm
         CALL collect
         LD   a,(gwun)
         JR   c,finalm1
         LD   a,7
playertg EQU  $-1
         CALL pwing
         JR   nc,gambleaz
wungamb
         LD   a,(gwin)
finalm1
         LD   (gwun),a
         LD   e,a
         LD   d,0
         LD   hl,gmoney
         ADD  hl,de
         LD   a,(hl)
         LD   (lastwin),a
         CALL cleartf
         LD   hl,gwun
         CALL settf2
         CALL trailc
         LD   a,(lastwin)
         OR   a
         CALL z,losecont
         CALL sdisable                  ; Switch Off Sound
resetgc
         CALL rswich
         CALL nz,switchst
         CALL cs
         RET  z
         JP   swichcan
finalm
         LD   a,(glose)
         JR   finalm1
ploseg
         EX   af,af
         LD   hl,glose
         CALL settf2
         CALL trailc
         EX   af,af
plosega
         EX   af,af
         CALL framefly
         CALL gcancel
         CALL collect
         CCF  
         RET  nc
         LD   a,0
flaglse  EQU  $-1
         OR   a
         SCF  
         RET  nz
         LD   a,18
         CALL scankey
         SCF  
         RET  z
         EX   af,af
         DEC  a
         JR   nz,plosega
         LD   hl,glose
         CALL cleft2
         OR   a
         RET  
collect
         LD   a,51
         CALL scankey
         SCF  
         RET  z
         LD   a,62
         CALL scankey
         SCF  
         RET  z
         CCF  
         RET  
gcancel
         CALL delay
         RET  c
         CALL switchst
         JP   swichcan
pwing
         EX   af,af
         LD   hl,gwin
         CALL settf2
         CALL trailc
         EX   af,af
pwinga
         EX   af,af
         CALL framefly
         CALL gcancel
         CALL collect
         CCF  
         RET  nc
         LD   a,18
         CALL scankey
         JR   z,pwing1
pwing1l
         EX   af,af
         DEC  a
         JR   nz,pwinga
         LD   hl,gwin
         CALL cleft2
         OR   a
         RET  
pwing1
         LD   hl,flaglse
         LD   a,(mean)
         OR   a
         LD   (hl),a
         JR   nz,pwing1l
         CALL cleartf
         CALL trailc
         CALL wungamb
         OR   a
         RET  
losecont
         CALL addnum1
losec1
         ADD  a,a
         LD   c,a
         LD   b,0
         LD   hl,losttble
         ADD  hl,bc
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         EX   de,hl
         JP   scrmessj
settrail LD   c,a
         LD   a,0
tsetg    EQU  $-1
         OR   a
         LD   a,c
         RET  nz
         LD   hl,#503
         SUB  14
         JR   z,cgt2
         SUB  4
         JR   z,cgt2
         INC  h
         INC  l
cgt2
         LD   (gtrailo),hl
         LD   a,c
         LD   (tsetg),a
         RET  
settf                                   ; Set Trail Flags
         LD   hl,gtrail
         LD   a,b
         LD   bc,20
settf1
         CPIR 
         DEC  hl
         LD   a,(hl)
         LD   (gwun),a
         CALL settf2
         DEC  hl
         LD   a,(hl)
         LD   (gwin),a
         CALL cleft2
         INC  hl
         INC  hl
         LD   a,(hl)
         LD   (glose),a
         LD   a,0
gamblet  EQU  $-1
         OR   a
         JR   z,settf2
         LD   a,11
         LD   (glose),a
         LD   hl,gtrail+10
settf2
         PUSH hl
         LD   e,(hl)
         LD   d,0
         LD   hl,trailfc
         ADD  hl,de
         LD   (hl),#ff
settf3   EQU  $-1
         POP  hl
         RET  
cleft2
         XOR  a
         LD   (settf3),a
         CALL settf2
         DEC  a
         LD   (settf3),a
         RET  
delay1
         LD   hl,count1
         INC  (hl)
         LD   a,(hl)
         SUB  15
         RET  c
         LD   (hl),a
         RET  
;
insert
         CALL submoney
         CALL submoney
         CALL framefly
         JP   Digital
swichp
         LD   de,#cf
         CALL setcs
         CALL framefly
         LD   hl,#c000
         LD   bc,#91d
         JR   swich1
swichcan                                ; Switch Cancel/Take
         LD   de,#c
         CALL setcs
         CALL framefly
         LD   hl,#ee41
         LD   bc,#c24
colcn
         LD   a,0
         XOR  #c
         LD   (colcn+1),a
         JP   swichgwa
switchst                                ; Switch start/gamble Colours
         LD   de,#cf
         CALL setcs
         CALL framefly
         LD   hl,#fcb1
         LD   bc,#c24
swich1
         LD   a,0
colst    EQU  $-1
         XOR  #cf
         LD   (colst),a
         JP   swichgwa
delay
         CALL framefly
         LD   hl,count
         INC  (hl)
         LD   a,(hl)
         SUB  40
         RET  c
         LD   (hl),a
         RET  
rswich
         LD   a,(colst)
         OR   a
         RET  
cs
         LD   a,(colcn+1)
         OR   a
         RET  
getret
         LD   a,0
         OR   a
         CALL nz,holdr
         CALL regs
         XOR  a
         LD   (lastwin),a
         CALL delay
         CALL z,switchst
getret0
         LD   a,47
         CALL scankey
         RET  z
         LD   a,59
         CALL scankey
         JR   nz,nowalk
         LD   a,#ff
         LD   (walkf),a
         LD   hl,byebye
         CALL setupms
         LD   a,80
         JP   scrmess
nowalk
         LD   a,18
         CALL scankey
         JR   nz,getret
         CALL resetgc
spinrls                                 ; Spin The Reels
         CALL swichhld
         CALL insert
         CALL whichnum
         CALL setpoint                  ; Set Pointers
         CALL updatemb                  ; Update Money Box
         CALL acellrls
spinrls1
         CALL moveallr                  ; Move all reels
         CALL checkm0
         JR   nz,spinrls1
         LD   a,0
rscount  EQU  $-1
         DEC  a
         LD   (rscount),a
         LD   (lastwin),a
         CALL z,stopok
         LD   hl,heldf
         LD   a,(hl)
         CP   %11111
         JR   nz,spinrls1
         XOR  a
         LD   (hl),a
         LD   (lastwin),a
         RET  
stopok
         LD   a,0
winner   EQU  $-1
         OR   a
         JR   nz,winspin
         LD   a,0
mean     EQU  $-1
         OR   a
         JR   z,nxtpnt2
         CALL getwin
         LD   a,(lastwin)
         OR   a
         JR   nz,nxtpnt
         CALL getnum
         LD   hl,number2
numreel  EQU  $-2
         LD   a,(hl)
         OR   a
         JR   z,nxtpnt2
nxtpnt
         LD   a,2
         LD   (rscount),a
         LD   a,0
nxtpnt1  EQU  $-1
         INC  a
         LD   (nxtpnt1),a
         SUB  5
         RET  nz
         LD   (nxtpnt1),a
nxtpnt2
         JP   setheldb
winspin
         LD   a,(heldf)
         OR   a
         JR   z,nxtpnt2
         CALL getwin
         LD   a,(lastwin)
         OR   a
         JR   nz,nxtpnt2
         LD   a,2
         LD   (rscount),a
         RET  
whichnum                                ; Find Out Which Reel Number Is Needed
         LD   hl,number1
         LD   a,(row1tot)
         OR   a
         JR   z,whichn1
         LD   hl,number2
         LD   a,(row2tot)
         OR   a
         JR   z,whichn1
         LD   hl,number3
whichn1
         LD   (numreel),hl
         RET  
acellrls                                ; Accelerate Reels On Start Up
         LD   hl,accelsqn
nmac
         LD   b,11
accelrl1
         PUSH hl
         PUSH bc
         LD   a,(hl)
         CALL set5rspd
         CALL framefly
         CALL moveallr
         CALL framefly
         POP  bc
         POP  hl
         INC  hl
         DJNZ accelrl1
         RET  
checkm0                                 ; Check If MOVED = 0
         PUSH hl
         LD   hl,moved1
         XOR  a
         OR   (hl)
         INC  hl
         OR   (hl)
         INC  hl
         OR   (hl)
         INC  hl
         OR   (hl)
         INC  hl
         OR   (hl)
         POP  hl
         RET  
moveallr
         CALL mover1
         CALL mover2
         CALL mover3
         CALL mover4
         JP   mover5
mover1
         LD   a,(moved1)
         OR   a
         JR   nz,mover1a
         LD   a,(heldf)
         BIT  4,a
         JR   z,mover1a
         XOR  a
         LD   (reel1spd),a
mover1a
         LD   a,0
state    EQU  $-1
         BIT  4,a
         JP   z,reel1cd
         JP   reel1cu
mover2
         LD   a,(moved2)
         OR   a
         JR   nz,mover2a
         LD   a,(heldf)
         BIT  3,a
         JR   z,mover2a
         XOR  a
         LD   (reel2spd),a
         LD   hl,reel2bfd
         CALL ingamefd
mover2a
         LD   a,(state)
         BIT  3,a
         JP   z,reel2cd
         JP   reel2cu
mover3
         LD   a,(moved3)
         OR   a
         JR   nz,mover3a
         LD   a,(heldf)
         BIT  2,a
         JR   z,mover3a
         XOR  a
         LD   (reel3spd),a
mover3a
         LD   a,(state)
         BIT  2,a
         JP   z,reel3cd
         JP   reel3cu
mover4
         LD   a,(moved4)
         OR   a
         JR   nz,mover4a
         LD   a,(heldf)
         BIT  1,a
         JR   z,mover4a
         XOR  a
         LD   (reel4spd),a
         LD   hl,reel4bfd
         CALL ingamefd
mover4a
         LD   a,(state)
         BIT  1,a
         JP   z,reel4cd
         JP   reel4cu
mover5
         LD   a,(moved5)
         OR   a
         JR   nz,mover5a
         LD   a,(heldf)
         BIT  0,a
         JR   z,mover5a
         XOR  a
         LD   (reel5spd),a
mover5a
         LD   a,(state)
         BIT  0,a
         JP   z,reel5cd
         JP   reel5cu
set5rspd
         LD   de,reel1spd
         LD   b,5
set5rsp1
         LD   (de),a
         INC  de
         DJNZ set5rsp1
         RET  
rinchl
         INC  (hl)
         LD   a,(hl)
         CP   nfrtpr+1
         RET  nz
         LD   (hl),1
         RET  
rdechl
         DEC  (hl)
         RET  nz
         LD   (hl),nfrtpr
         RET  
resetspd
         LD   hl,reel1spd
         XOR  a
         LD   b,5
resetspa
         LD   (hl),a
         INC  hl
         DJNZ resetspa
         RET  
;
dbest                                   ; Display Best Win Of Today !
         LD   hl,hscore
         CALL DigitalJ
         LD   hl,sprload+24
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         JR   setwinbw
ishscore                                ; Is There A Higher Win ?
         LD   hl,dspace
         PUSH hl
         LD   de,hscore+3
         LD   hl,DigitalN+3
         LD   b,4
ishs1
         LD   a,(de)
         CP   (hl)
         JR   c,ishs2
         RET  nz
         DEC  hl
         DEC  de
         DJNZ ishs1
         RET  
ishs2
         LD   hl,DigitalN
         LD   de,hscore
         LD   bc,4
         LDIR 
         LD   hl,hicon
         CALL setupms
         LD   a,80
         JP   scrmess
setwinb
         CALL Digital
         LD   ix,sprload
         LD   e,(ix+20)
         LD   d,(ix+21)
         LD   hl,sprload
         ADD  hl,de
         EX   de,hl
         LD   hl,#d800
         LD   c,0
         LD   b,9
         LD   a,23
         CALL decomp
         LD   ix,sprload
         LD   e,(ix+22)
         LD   d,(ix+23)
setwinbw
         LD   hl,sprload
         ADD  hl,de
         LD   bc,#1608
         LD   de,3*#50+#e808
Generals                                ; General Sprite Routine
         PUSH bc
         PUSH de                        ; HL = Scr Addr : DE = SPRITE ADDR
         LD   c,b
         LD   b,0
Genspr1
         LDIR 
         POP  de
         LD   a,d
         ADD  a,8
         JR   nc,Genspr2
         LD   a,#50
         ADD  a,e
         LD   e,a
         LD   a,d
         ADC  a,#c8
Genspr2
         LD   d,a
         POP  bc
         DEC  c
         JR   nz,Generals
         RET  
dpause
         XOR  a
         CALL pause
pause                                   ; Entry A=Pause Length In 1/50th S
         PUSH af
         CALL framefly
         POP  af
         DEC  a
         RET  z
         JR   pause
blackink
         XOR  a
blakink1
         PUSH af
         LD   b,0
         CALL setink
         POP  af
         INC  a
         BIT  4,a
         JR   z,blakink1
         RET  
setinks
         XOR  a
         CALL setmode
         LD   b,0
         LD   a,16
         CALL setink
         LD   ix,inks
         XOR  a
setinks1
         PUSH af
         LD   b,(ix+0)
         CALL setink
         INC  ix
         POP  af
         INC  a
         CP   16
         JR   nz,setinks1
         RET  
jumble
         CALL spinrls
         CALL resetwb
         JP   spinrls
;
setupms                                 ; Set Up Message Scroll
         XOR  a
         LD   (messagep),a
         LD   (messagec),hl
         LD   (messageo),hl
         RET  
scrmess
         LD   (exitkey),a
scrmess1
         CALL framefly
         CALL scrolmb
         LD   a,0
exitmes  EQU  $-1
         BIT  7,a
         JR   nz,exitkey1
         LD   a,27
exitkey  EQU  $-1
         CALL scankey
         JR   nz,scrmess1
         LD   a,(messagep)
         OR   a
         JR   nz,scrmess1
         RET  
exitkey1
         SCF  
         RET  
dspace
         LD   hl,spaces
         CALL setupms
         LD   a,37*2+4
dspace1
         PUSH af
         CALL framefly
         CALL scrolmb
         POP  af
         DEC  a
         JR   nz,dspace1
         RET  
scrolmb
         LD   hl,#f992
         LD   d,5
scrolmb1
         PUSH hl
         LD   b,37
scrolmb2
         LD   a,(hl)
         AND  #55
         RLCA 
         LD   (hl),a
         INC  hl
         LD   a,(hl)
         AND  #aa
         RRCA 
         DEC  hl
         OR   (hl)
         LD   (hl),a
         INC  hl
         DJNZ scrolmb2
         POP  hl
         LD   a,8
         ADD  a,h
         JR   nc,scrolmb3
         LD   a,#50
         ADD  a,l
         LD   l,a
         LD   a,#c8
         ADC  a,h
scrolmb3
         OR   #c0
         LD   h,a
         DEC  d
         JR   nz,scrolmb1
dmess
         LD   hl,welcome
messagec EQU  $-2
         LD   a,(hl)
         LD   (exitmes),a
         BIT  7,a
         JR   z,dmess1
         LD   hl,welcome
messageo EQU  $-2
         LD   (messagec),hl
         LD   a,"?"
         CALL dmess1
         XOR  a
         LD   (messagep),a
         RET  
@
colour
         ADD  a,17
         LD   e,a
         XOR  a
         LD   (messagep),a
         LD   d,0
         LD   hl,einktble
         ADD  hl,de
         LD   a,(hl)
         LD   (lcolmask),a
         CALL dmess9
         JR   dmess
dmess1
         SUB  17
         JR   c,colour
         SUB  #16
         LD   d,0
         LD   h,d
         ADD  a,a
         LD   e,a
         ADD  a,a
         LD   l,a
         ADD  hl,hl
         ADD  hl,de
         LD   a,(messagep)
         BIT  1,a
         JR   z,dmess2
         LD   e,5
         ADD  hl,de
dmess2
         LD   ix,sprload
         LD   e,(ix+30)
         LD   d,(ix+31)
         ADD  hl,de
         LD   de,sprload
         ADD  hl,de
         EX   de,hl
         LD   hl,#f9b6
dmessad  EQU  $-2
         LD   b,5
dmess3
         LD   a,0
messagep EQU  $-1
         AND  1
         LD   a,(de)
         JR   nz,dmess4
         AND  #aa
         RRCA 
dmess4
         AND  #55
         LD   c,a
         LD   a,(hl)
         AND  #aa
         OR   c
         AND  #ff
lcolmask EQU  $-1
         LD   (hl),a
         LD   a,8
         ADD  a,h
         JR   nc,dmess5
         LD   a,#50
         ADD  a,l
         LD   l,a
         LD   a,#c8
         ADC  a,h
dmess5
         OR   #c0
         LD   h,a
         INC  de
         DJNZ dmess3
         LD   hl,messagep
         INC  (hl)
         LD   a,(hl)
         SUB  4
         RET  nz
         LD   (hl),a
dmess9
         LD   hl,(messagec)
         INC  hl
         LD   (messagec),hl
         RET  
;
mystery                                 ; Mystery Gaming Function
         LD   a,(mean)
         OR   a
         JR   z,mystery1
         LD   a,r
         AND  1
         ADD  a,17
         JR   mysteryc
mystery1                                ; Totally Random Mystery Function
         LD   a,r
         AND  15
         ADD  a,3
mysteryc
         LD   b,a
         DEC  a
         LD   (mystc1),a
         XOR  a
         DEC  a
         CALL myst1
         LD   a,b
         OR   a
         LD   a,#ff
         CALL nz,myst2
myst3                                   ; Clear Up All Unwanted Flags
         LD   b,0
mystc1   EQU  $-1
         XOR  a
         CALL myst1
         LD   a,b
         OR   a
         LD   a,0
         LD   (tsetg),a
         CALL nz,myst2
         LD   a,(mystc1)                ; Get Mystery Function Money/Game
         SUB  7
         JR   nc,myst4m                 ; Mystery Money !
         ADD  a,9
         LD   (functcnt),a
         SUB  a
         LD   (row1bf),a
         LD   (row2bf),a
         LD   (row3bf),a
         CALL setfuncc
         CALL setfun1
         JP   takeit
myst4m                                  ; How Much Have You Won ?
         LD   hl,gmoney
         OR   a
         JR   z,mystl1
mystl
         INC  hl
         DEC  a
         JR   nz,mystl
mystl1
         LD   a,(hl)
         LD   (lastwin),a
         CALL game0
         CALL gamble
         CALL incmoney
         JP   takeit1
myst1
         LD   hl,row1bf+1
         LD   c,0
myst1a
         PUSH hl
         PUSH bc
         PUSH af
         LD   de,9
         LD   (hl),a
         ADD  hl,de
         LD   (hl),a
         ADD  hl,de
         LD   (hl),a
         CALL framefly
         CALL setfuncc
         CALL setfun1
         CALL bf
         POP  af
         POP  bc
         POP  hl
         INC  hl
         INC  c
         LD   d,a
         LD   a,c
         LD   (bft),a
         CP   8
         LD   a,d
         RET  z
         DJNZ myst1a
         RET  
myst2                                   ; Money Control
         LD   hl,trailfc
         LD   c,0
myst2a
         PUSH hl
         PUSH bc
         PUSH af
         LD   (hl),a
         CALL framefly
         CALL trailc
         POP  af
         POP  bc
         POP  hl
         INC  hl
         INC  c
         EX   af,af
         LD   a,c
         CP   11
         RET  z
         EX   af,af
         DJNZ myst2a
         RET  
;
spinawin                                ; Spin A Win Gaming Function
         LD   a,#ff
         LD   (winner),a
         LD   (gamblet),a
         INC  a
         LD   (getret+1),a
         CALL gamec
         LD   hl,spinawm
         CALL setupms
         LD   a,80
         CALL scrmess
         CALL dspace
spinwg1
         LD   a,r
         AND  3
         INC  a
         CP   4
         JR   z,spinwg1
         LD   (spinwc),a
         LD   a,0
spinwc   EQU  $-1
spinw1
         CALL getret
         CALL resetgc
         CALL getwin
         CALL gamble
         CALL incmoney
         CALL cleartf
         CALL checkmon
         RET  z
         LD   hl,spinwc
         DEC  (hl)
         JR   nz,spinw1
spinw2
         JP   takeit1
;
skilcash                                ; Skill Cash Gaming Function
         CALL cashfals
         CALL resetwl
         LD   a,3
         LD   (functcnt),a
         SUB  a
         LD   (count1),a
         LD   (skcount),a
skla
         LD   b,240
skl0
         PUSH bc
         CALL flshcoin
         POP  bc
         DJNZ skl0
skl1
         LD   hl,trailfc+11
         LD   a,0
skcount  EQU  $-1
         CALL skupcont
         JR   c,skwin
         CALL skd
         JR   nc,skl1
skwin
         LD   a,(trailfc)
         OR   a
         JR   z,sklose
         LD   hl,skcount
         INC  (hl)
         CALL sklose1
         CALL updatewl
         JR   nz,skla
sklose
         CALL sklose1
         JP   cashfal8
sklose1
         CALL dpause
         JP   cleartf
skupcont
         RRCA 
         AND  3
         JR   z,scupx1
         DEC  a
         JR   z,scupx2
scupx3
         LD   b,4
         LD   a,3
         JR   skupd
scupx1
         LD   b,13
         LD   a,1
         JR   skupd
scupx2                                  ; Move Skill Climb Up !
         LD   b,7
         LD   a,2
skupd
         LD   (skupk),a
skup1
         LD   c,2
skupk    EQU  $-1
         CALL scupx
         CALL skret
         SCF  
         RET  z
         DJNZ skup1
         OR   a
         RET  
scupx
         RET  z
         LD   (hl),#ff
         DEC  c
         DEC  hl
         JR   scupx
skd
         LD   b,12
skd1
         LD   (hl),0
         INC  hl
         CALL skret
         SCF  
         RET  z
         DJNZ skd1
         OR   a
         RET  
skret
         PUSH bc
         PUSH hl
         CALL trailc
         POP  hl
         LD   a,18
         CALL scankey
         POP  bc
         RET  
;
cashfall                                ; Cashfalls Gaming Function
         CALL cashfals
         CALL coings
         CALL winlines
cashfal2
         CALL boing1
         CALL shiftc
         CALL coincont
         LD   a,200
time     EQU  $-1
         CALL cashfal4
         CALL framefly
         LD   hl,count
         DEC  (hl)
         JR   nz,cashfal2
         LD   (hl),15
         LD   hl,time
         DEC  (hl)
         JR   nz,cashfal2
         PUSH bc
cashfal5
         POP  de
cashfal8
         CALL bitmon
cf1jb
         CALL dpause
         CALL dpause
         CALL game0
         LD   hl,nowin
         CALL setupms
         LD   a,(lastwin)
         OR   a
         JR   nz,cf1fbc
         LD   a,80
         CALL scrmess
         CALL dspace
cf1fbc
         CALL incmoney
         CALL gameff
cf1fba
         JP   takeit1
cashfals
         LD   a,(mean)
         XOR  255
         LD   (coinc2),a
         LD   a,15
         LD   (count),a
         LD   a,29
         LD   (time),a
         LD   hl,#c050
         LD   bc,#28c8
         SUB  a
         JP   wipeout
cashfal4
         DEC  a
         RET  z
         EX   af,af
         LD   a,18
         CALL scankey
         JR   z,cashfal5
         CALL framefly
         EX   af,af
         JR   cashfal4
;
shiftc                                  ; Shift Coins Down
         LD   hl,coingrid+4
         LD   b,5
shiftc1
         LD   a,(hl)
         INC  hl
         LD   (hl),a
         DEC  hl
         DEC  hl
         DJNZ shiftc1
         INC  hl
shiftc2
         CALL random
         AND  7
         JR   z,shiftc2
         CP   7
         JR   z,shiftc2
         LD   b,(hl)
         CP   b
         JR   z,shiftc2
         LD   r,a
         LD   (hl),a
         RET  
coings                                  ; Set Up Coin Grid !
         LD   hl,coingrid
         LD   b,6
coings1
         PUSH bc
         CALL shiftc
         POP  bc
         DJNZ coings1
         RET  
random
         LD   a,r
         XOR  12
random1  EQU  $-1
         RRCA 
         XOR  7
         RLCA 
         XOR  l
         RRCA 
         XOR  b
         RRCA 
         RRCA 
         LD   (random1),a
         CCF  
         RET  nz
         INC  a
         RET  
winlines                                ; Get Winning Lines On Cash Falls
         LD   a,(mean)
         OR   a
         LD   b,3
         JR   z,winlna
         LD   b,1
winlna
         CALL random
         AND  1
         ADD  a,b
         AND  7
         LD   (winl3),a
         LD   hl,winlgrid
         LD   a,r
         INC  a
         LD   b,6
         LD   c,0
winln1
         LD   d,0
         RRCA 
         LD   (hl),d
         JR   nc,winl2
         DEC  d
         LD   (hl),d
         INC  c
winl2
         INC  hl
         DJNZ winln1
         LD   a,c
         CP   3
winl3    EQU  $-1
         JR   nz,winlines
wingrid                                 ; Draw Up WIN Graphics
         CALL framefly
         LD   de,#c0fc
         CALL setcs
         LD   hl,winlgrid
         LD   de,#500                   ; Start Adrress
         LD   b,6                       ; 6 Winning Lines
wingrid1
         PUSH bc
         PUSH de
         PUSH hl
         CALL bc1d
         PUSH hl
         LD   de,wing
         CALL getspad
         POP  hl
         PUSH hl
         LD   bc,#c00
         LD   a,15
         CALL decomp
         POP  de
         POP  hl
         PUSH hl
         LD   a,(hl)
         OR   a
         JR   z,wingrid2
         EX   de,hl
         LD   bc,#c0f
         LD   a,#c0
         CALL swichgwa
wingrid2
         POP  hl
         POP  de
         CALL updatecd
         POP  bc
         INC  hl
         DJNZ wingrid1
coincont                                ; Coin Control Program
         CALL framefly
         LD   hl,coingrid               ; Point To Coin Grid
         LD   de,14                     ; DE = X Y Scr Co-ords
         LD   b,6
coinc1                                  ; Coin Control 1
         PUSH de
         PUSH bc
         CALL poundc
         POP  bc
         POP  de
         CALL updatecd
         INC  hl
         DJNZ coinc1
         RET  
tenps64                                 ; Display 4 * 6 Rows Of 10 Ps
         CALL framefly
         LD   hl,potcash                ; Point To Cash Pot Flags
         LD   de,2
         LD   c,6
tenps64a
         PUSH de
         LD   b,4
tenps64b
         PUSH bc
         CALL tensc
         INC  hl
         POP  bc
         DJNZ tenps64b
         POP  de
         CALL updatecd
         DEC  c
         JR   nz,tenps64a
         RET  
poundc
         PUSH hl
         LD   a,1
coinc2   EQU  $-1
         OR   a
         JR   z,fiftyc
         LD   hl,p1l
         LD   (coi1),hl
         LD   hl,p1
         LD   (coi2),hl
         LD   a,2
         LD   (coia),a
         POP  hl
         CALL coinpnd
         JR   twentyc
fiftyc
         LD   hl,p50l
         LD   (coi1),hl
         LD   hl,p50
         LD   (coi2),hl
         LD   a,2
         LD   (coia),a
         POP  hl
         CALL coinpnd
twentyc
         PUSH hl
         LD   hl,p20l
         LD   (coi1),hl
         LD   hl,p20
         LD   (coi2),hl
         LD   a,4
         LD   (coia),a
         POP  hl
         CALL coinpnd
tensc
         PUSH hl
         LD   hl,p10l
         LD   (coi1),hl
         LD   hl,p10
         LD   (coi2),hl
         LD   a,1
         LD   (coia),a
         POP  hl
coinpnd
         PUSH de
         PUSH hl
         CALL bc1d
         POP  de
         PUSH de
         PUSH hl
         LD   a,(de)
         AND  4
coia     EQU  $-1
         LD   de,p1l
coi1     EQU  $-2
         JR   nz,coinpnd1
         LD   de,p1
coi2     EQU  $-2
coinpnd1
         CALL getspad
         POP  hl
         CALL coinprnt
         POP  hl
         POP  de
updatecn                                ; Update Coin Address
         LD   a,9
         ADD  a,e
         LD   e,a
         RET  
updatecd
         LD   a,#21
         ADD  a,d
         LD   d,a
         RET  
coinprnt                                ; Display Coin
         EX   de,hl
         LD   b,8
         LD   c,27
         JP   Generals
getspad                                 ; Get Sprite Address From Table
         LD   hl,sprload
         PUSH hl
         ADD  hl,de
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         POP  hl
         ADD  hl,de
         EX   de,hl
         RET                            ; Exit DE=Sprite Address
bc1d
         PUSH de
         LD   a,d
         AND  7
         ADD  a,a
         ADD  a,a
         ADD  a,a
         LD   c,a
         LD   a,d
         LD   h,0
         AND  #f8
         RRCA 
         RRCA 
         RRCA 
         LD   e,a
         ADD  a,a
         ADD  a,a
         ADD  a,e
         ADD  a,a
         LD   l,a
         ADD  hl,hl
         ADD  hl,hl
         ADD  hl,hl
         LD   a,h
         ADD  a,c
         LD   h,a
         POP  de
         PUSH de
         LD   d,0
         ADD  hl,de
         LD   a,#50                     ;#50
         ADD  a,l
         LD   l,a
         ADC  a,h
         SUB  l
         OR   #c0
         LD   h,a
         POP  de
         RET  
bitmon                                  ; Calculate Winnings From BIT Map Table
         XOR  a
         LD   (lastwin),a
         LD   de,winlgrid
         LD   hl,coingrid
         LD   b,6
bitmon1
         LD   a,(de)
         OR   a
         CALL nz,bitmon2
         INC  de
         INC  hl
         DJNZ bitmon1
         RET  
bitmon2
         LD   a,(lastwin)
         LD   c,a
         LD   a,(hl)
         BIT  0,a
         CALL nz,bitm10p
         LD   a,(hl)
         BIT  1,a
         CALL nz,bitm501p
         LD   a,(hl)
         BIT  2,a
         RET  z
         INC  c
bitm10p
         INC  c
         LD   a,c
bitm10pb
         LD   (lastwin),a
         RET  
bitm501p
         LD   a,(coinc2)
         OR   a
         LD   a,10
         JR   nz,bm501pa
         RRA  
bm501pa
         ADD  a,c
         LD   c,a
         JR   bitm10pb
;
numberun                                ; Mystery Gaming Function
         LD   hl,numbr1
         CALL setupms
         CALL game0
         LD   a,47
         CALL scrmess
         CALL dspace
         CALL setpoint
         CALL random
         AND  7
         ADD  a,8                       ; At least 4 Reel Drops
         LD   b,a
num1
         PUSH bc
         CALL numsr
         CALL getwinl
         LD   hl,winlbuff+3
         LD   c,7
         LD   a,(hl)
         AND  c
         LD   (keyna1),a
         INC  hl
         LD   a,(hl)
         AND  c
         LD   (keyna2),a
         INC  hl
         LD   a,(hl)
         AND  c
         LD   (keyna3),a
         LD   b,90
numd
         PUSH bc
         CALL numbk
         POP  bc
         DJNZ numd
         POP  bc
         DJNZ num1
         XOR  a
         LD   (heldf),a
         CALL swichhld
         JP   takeit1
numsr                                   ; Spin Reels For Numbers
         LD   a,7
         LD   (numbk1),a
         SUB  a
         BIT  0,b
         JR   nz,numsr1
         LD   a,(heldf)
numsr1
         OR   #11
         LD   (heldf),a
         LD   a,(state)
         CALL setptbf
nreel                                   ; Nudge Reel
         SUB  a
         LD   (lastwin),a
         LD   hl,nudgesac
         LD   b,18
         CALL accelrl1
         JP   boing
numbk
         CALL holdrn
         LD   a,7
numbk1   EQU  $-1
         BIT  2,a
         CALL nz,keyn2
         BIT  1,a
         CALL nz,keyn3
         BIT  0,a
         CALL nz,keyn4
         LD   (numbk1),a
         RET  
keyn2                                   ; Is Key 2 Pressed ?
         EX   af,af
         LD   a,(heldf)
         BIT  3,a
         LD   b,3
         LD   a,0
keyna1   EQU  $-1
         JR   nz,keyadd
         EX   af,af
         RET  
keyadd                                  ; Add Dosh !
         PUSH bc
         OR   a
         JR   z,kkkk
         LD   b,a
         CALL im1
;JR   kkkk
;LD   hl,numbwun
;ADD  a,(hl)
;LD   (hl),a
kkkk
         POP  bc
         EX   af,af
         AND  b
         RET  
keyn3                                   ; Is Key 2 Pressed ?
         EX   af,af
         LD   a,(heldf)
         BIT  2,a
         LD   b,%101
         LD   a,0
keyna2   EQU  $-1
         JR   nz,keyadd
         EX   af,af
         RET  
keyn4                                   ; Is Key 2 Pressed ?
         EX   af,af
         LD   a,(heldf)
         BIT  1,a
         LD   b,%110
         LD   a,0
keyna3   EQU  $-1
         JR   nz,keyadd
         EX   af,af
         RET  
;
hilocash                                ; Hi Lo Cash Gaming Function
         CALL cashfals
         CALL resetwl
hilocsh1
         CALL hilocont
         JR   nc,losthlc
         OR   a
         JR   z,hilocsh1
         CALL updatewl
         JR   nz,hilocsh1
losthlc
         LD   a,6
         LD   (functcnt),a
         SUB  a
         LD   (coinflsh),a
         JP   cashfal8
flshcoin                                ; Flash Current Coin Win Line
         LD   hl,count1
         INC  (hl)
         LD   a,(hl)
         SUB  20
         RET  c
         LD   (hl),a
         LD   hl,coingrid+5
coinsw1  EQU  $-2
         LD   a,(hl)
         LD   b,0
coinswap EQU  $-1
         LD   (coinswap),a
         LD   (hl),b
         JP   coincont
swapcn1
         LD   hl,(coinsw1)
         DEC  hl
         LD   (coinsw1),hl
         LD   a,(coinswap)
         OR   a
         RET  z
         INC  hl
         LD   (hl),a
         RET  
;
updatewl
         CALL swapcn1
         XOR  a
         LD   (coinswap),a
         DEC  a
         LD   hl,winlgrid+5
hilocsh2 EQU  $-2
         DEC  hl
         LD   (hl),a
         LD   (hilocsh2),hl
         PUSH hl
         CALL wingrid
         POP  hl
         LD   de,winlgrid
         AND  a
         SBC  hl,de
         RET  
resetwl
         LD   hl,winlgrid
         LD   b,6
         XOR  a
hilolp
         LD   (hl),a
         INC  hl
         DJNZ hilolp
         LD   (functcnt),a
         LD   (mean),a
         LD   (coinswap),a
         DEC  a
         LD   (suppress),a
         LD   (coinflsh),a
         LD   (hilocsh2),hl
         LD   hl,coingrid+5
         LD   (coinsw1),hl
         CALL coings
         JP   wingrid
;
cashpot                                 ; Mystery Gaming Function
         LD   a,24
cashpotm EQU  $-1
         LD   (lastwin),a
         OR   a
         JP   z,cashfal8
         XOR  a
         LD   (functcnt),a
         CALL dcasha
         CALL resetag
         CALL cashfals
         LD   hl,potcash
         LD   de,potcash+1
         LD   bc,23
         LD   (hl),b
         LDIR 
         LD   a,(cashpotm)
cashpot1
         LD   (hl),#ff
         DEC  hl
         DEC  a
         JR   nz,cashpot1
cashpot2
         LD   (cashpotm),a
         CALL tenps64
         LD   hl,potcash
         LD   b,24
cashpota
         LD   a,(hl)
         OR   a
         JR   nz,cashpot3
         INC  hl
         DEC  b
         JR   cashpota
cashpot3
         PUSH bc
         PUSH hl
         CALL flashpot
         LD   (hl),0
         CALL tenps64
         POP  hl
         INC  hl
         POP  bc
         DJNZ cashpot3
         CALL game0
         JP   incmoney
flashpot
         XOR  a
         LD   (functcnt),a
         CALL flshpt1
         LD   a,1
flshpt1
         PUSH hl
         LD   (hl),a
         CALL ping
         CALL tenps64
         POP  hl
         RET  
dcash
         LD   a,(cashpotm)
dcasha
         LD   hl,wunm
         PUSH hl
         LD   (hl),12
         INC  hl
         LD   d,10
         CALL subtract
         OR   #30
         PUSH hl
         INC  hl
         LD   (hl),"."
         INC  hl
         LD   (hl),a
         INC  hl
         LD   (hl),#30
         INC  hl
         LD   (hl),#ff
         POP  hl
         LD   a,c
         OR   #30
         LD   (hl),a
         POP  hl
         CALL setupms
         LD   hl,#cf92
         LD   b,8
         CALL dcash1
dnudge
         LD   a,(nudges)
         LD   hl,wunm
         PUSH hl
         DEC  (hl)
         INC  hl
         OR   #30
         LD   (hl),a
         INC  hl
         LD   (hl),#ff
         POP  hl
         CALL setupms
         LD   hl,#ff51
         LD   b,2
dcash1
         PUSH bc
         PUSH hl
         LD   (dmessad),hl
         CALL dmess
         POP  hl
         PUSH hl
         LD   b,5
dcash2
         LD   a,(hl)
         AND  #55
         ADD  a,a
         LD   (hl),a
         LD   a,8
         ADD  a,h
         JR   nc,dcash3
         LD   a,#50
         ADD  a,l
         LD   l,a
         LD   a,#c8
         ADC  a,h
dcash3
         OR   #c0
         LD   h,a
         DJNZ dcash2
         CALL dmess
         POP  hl
         POP  bc
         INC  hl
         DJNZ dcash1
         LD   hl,#f9b6
         LD   (dmessad),hl
         RET  
;
nudge                                   ; **** NUDGES.ADM ****
         XOR  a
         LD   (functcnt),a
         CALL resetag
         CALL game0
         CALL resetcom
;LD   a,(nudges)
;CP   5
;JR   c,nudgeok
         LD   hl,think
         CALL setupms
         LD   a,80
         CALL scrmess
nudgeok
         LD   de,reel1bfd
         LD   hl,reelt1
         LD   bc,nfrtpr*5+20
         PUSH hl
         PUSH de
         PUSH bc
         LDIR                           ; Copy Reels Into Buffer
         CALL forn1                     ; Get Nudges
         POP  bc
         POP  hl
         POP  de
         LDIR 
         LD   hl,nowin
         CALL setupms
         LD   a,(currcomb)
         OR   a
         CALL z,scrmess
         CALL dspace
         LD   hl,currcomb
         LD   a,(hl)
         OR   a
         RET  z                         ; Quit If No Win Available
         INC  hl                        ; Point To Nudge Sequence
         LD   a,(hl)
         LD   (state),a
         AND  a
         CALL setptbf
         LD   hl,currcomb+3
         LD   b,5                       ; 5 Reels
         LD   c,%11111110
nudgem
         PUSH hl
         PUSH bc
         LD   a,(hl)
         AND  31
         JR   z,nudgem2
         LD   b,a
         LD   a,c
         LD   (heldf),a
nudgem1
         PUSH bc
         LD   a,(state)
         AND  a
         CALL setptbf
         CALL nreel
         LD   hl,nudges
         DEC  (hl)
         POP  bc
         DJNZ nudgem1
nudgem2
         POP  bc
         LD   a,c
         RLCA 
         LD   c,a
         POP  hl
         INC  hl
         DJNZ nudgem
         XOR  a
         LD   (heldf),a
         CALL getwin
         CALL gamble
         JP   incmoney
;
forn1                                   ; Routine To Generate Combinations For
         LD   a,(nudges)
         OR   a
         RET  z
         LD   a,%1111                   ; Nudges !
         CALL maskdbit                  ; This Was A BASTARD To Write
         CALL rp1
forn1l
         CALL forn2
         LD   a,(n1)
         CP   4
nudges   EQU  $-1
         JR   z,ud1b
         CALL r1ud
         JR   forn1l
ud1b
         LD   c,16
         CALL xordbit
         RET  z
         CALL rp1
         CALL r1ud
         JR   forn1l
forn2
         LD   c,%10111
         CALL maskdbit
         CALL rp2
forn2b
         XOR  a
         LD   hl,n2
         CALL addsub3
         LD   (to2),a
forn2l
         CALL forn3
         LD   a,(to2)
         OR   a
         RET  z
         LD   a,(n2)
         CP   10
to2      EQU  $-1
         JR   z,ud2b
         CALL r2ud
         JR   forn2l
ud2b
         LD   c,8
         CALL xordbit
         RET  z
         CALL rp2
         CALL r2ud
         JR   forn2l
forn3
         LD   c,%11011
         CALL maskdbit
         CALL rp3
forn3b
         LD   hl,n2
         LD   a,(hl)
         CALL addsub3
         LD   (to3),a
forn3l
         CALL forn4
         LD   a,(to3)
         OR   a
         RET  z
         LD   a,(n3)
         CP   10
to3      EQU  $-1
         JR   z,ud3b
         CALL r3ud
         JR   forn3l
ud3b
         LD   c,4
         CALL xordbit
         RET  z
         CALL rp3
         CALL r3ud
         JR   forn3l
forn4                                   ; Next
         LD   c,%11101
         CALL maskdbit
         CALL rp4
forn4b
         LD   hl,n3
         LD   a,(hl)
         CALL addsub2
         LD   (to4),a
forn4l
         CALL forn5
         LD   a,(to4)
         OR   a
         RET  z
         LD   a,(n4)
         CP   0
to4      EQU  $-1
         JR   z,ud4b
         CALL r4ud
         JR   forn4l
ud4b
         LD   c,2
         CALL xordbit
         RET  z
         CALL rp4
         CALL r4ud
         JR   forn4l
forn5                                   ; Call For Loop
         LD   c,%11110
         CALL maskdbit
         CALL rp5
forn5b
         CALL addsub
         LD   (to5),a
forn5l
         CALL checkwin
         LD   a,(to5)
         OR   a
         RET  z
         LD   a,(n5)
         CP   0
to5      EQU  $-1
         JR   z,ud5b
         CALL r5ud
         JR   forn5l
ud5b
         LD   c,1
         CALL xordbit
         RET  z
         CALL rp5
         CALL r5ud
         JR   forn5l
rp1                                     ; Replace Reel One
         XOR  a
         LD   (n1),a
         LD   hl,reel1bfd
         LD   de,reelt1
rcop
         LD   bc,nfrtpr
         LDIR 
         RET  
rp2
         XOR  a
         LD   (n2),a
         LD   hl,reel1bfd+nfrtpr
rs2      EQU  $-2
         LD   de,reelt2
         JR   rcop
rp3
         XOR  a
         LD   (n3),a
         LD   hl,nfrtpr*2+reel1bfd
         LD   de,reelt3
         JR   rcop
rp4
         XOR  a
         LD   (n4),a
         LD   hl,nfrtpr*3+reel1bfd
         LD   de,reelt4
         JR   rcop
rp5
         XOR  a
         LD   (n5),a
         LD   hl,nfrtpr*4+reel1bfd
         LD   de,reelt5
         JR   rcop
xordbit
         LD   a,(state)
         XOR  c
         LD   (state),a
         AND  c
         LD   a,1
         RET  
maskdbit
         LD   a,(state)
         AND  c
         LD   (state),a
         RET  
addsub
         LD   hl,n4
         LD   a,(hl)
addsub1
         INC  hl
         ADD  a,(hl)
addsub2
         INC  hl
         ADD  a,(hl)
addsub3
         INC  hl
         ADD  a,(hl)
         LD   b,a
         LD   a,(nudges)
         SUB  b
         RET  
resetcom
         LD   hl,currcomb               ; Reset Winning Combination
resetcm1
         LD   b,8
         XOR  a
resetcm2
         LD   (hl),a
         INC  hl
         DJNZ resetcm2
         LD   (to2),a
         LD   (to3),a
         LD   (to4),a
         LD   (to5),a
         RET  
r1ud                                    ; Reel 1 Up Or Down ?
         LD   hl,n1
         INC  (hl)
         LD   a,(state)
         AND  16
         JR   z,r1down
r1up
         LD   hl,reelt1+1
         JR   shiftu
r2ud                                    ; Reel 1 Up Or Down ?
         LD   hl,n2
         INC  (hl)
         LD   a,(state)
         AND  8
         JR   z,r2down
r2up
         LD   hl,reelt2+1
         JR   shiftu
r3ud                                    ; Reel 1 Up Or Down ?
         LD   hl,n3
         INC  (hl)
         LD   a,(state)
         AND  4
         JR   z,r3down
r3up
         LD   hl,reelt3+1
         JR   shiftu
r4ud                                    ; Reel 1 Up Or Down ?
         LD   hl,n4
         INC  (hl)
         LD   a,(state)
         AND  2
         JR   z,r4down
r4up
         LD   hl,reelt4+1
         JR   shiftu
r5ud                                    ; Reel 1 Up Or Down ?
         LD   hl,n5
         INC  (hl)
         LD   a,(state)
         AND  1
         JR   z,r5down
r5up
         LD   hl,reelt5+1
shiftu
         PUSH hl
         POP  de
         DEC  de
         LD   bc,nfrtpr-1
         LD   a,(de)
         LDIR 
         LD   (de),a
         RET  
r1down
         LD   hl,reelt1+nfrtpr-2
         JR   shiftd
r2down
         LD   hl,reelt2+nfrtpr-2
         JR   shiftd
r3down
         LD   hl,reelt3+nfrtpr-2
         JR   shiftd
r4down
         LD   hl,reelt4+nfrtpr-2
         JR   shiftd
r5down
         LD   hl,reelt5+nfrtpr-2
shiftd
         PUSH hl
         POP  de
         INC  de
         LD   bc,nfrtpr-1
         LD   a,(de)
         LDDR 
         LD   (de),a
         RET  
checkwin
         CALL getwin                    ; See If Win Available
         LD   a,(lastwin)
         OR   a
         RET  z                         ; If Not Exit
         LD   b,a
         LD   a,(currcomb)              ; Get Stored Win
         SUB  b
         JR   z,equalw                  ; If Equal Win The See If Less Nudges !
         RET  nc                        ; Quit If Lesser Win
         JR   nputwin                   ; Put Bigger Win In
equalw                                  ; If Equal Winnings Is It Fewer Nudges 
         LD   hl,n5
         XOR  a
         LD   b,5
equalw1
         ADD  a,(hl)
         INC  hl
         DJNZ equalw1
         LD   b,a
         LD   a,(currcomb+2)
         SUB  b
         RET  c                         ; If More Nudges Then Exit
nputwin
         LD   hl,currcomb               ; Point HL To Current Combination
         LD   a,(lastwin)               ; Get Winnings
         LD   (hl),a                    ; And Store
         INC  hl
         LD   a,(state)
         LD   (hl),a                    ; Poke Direction BIT
         INC  hl
         INC  hl
         LD   de,n5                     ; Poke Nudge Sequence
         LD   b,5
         LD   c,0
nputwin1
         LD   a,(de)
         LD   (hl),a
         ADD  a,c                       ; Add Nudges
         LD   c,a
         INC  hl
         INC  de
         DJNZ nputwin1
         LD   a,c
         LD   (currcomb+2),a            ; Store Number Of Nudges
         RET  
;
repeater                                ; Mystery Gaming Function
         LD   hl,rept1
         CALL setupms
         XOR  a
         CALL gamec
         LD   a,47
         CALL scrmess
         CALL dspace
         LD   a,#ff
         CALL gamec
;LD   hl,#e690+#50
;LD   bc,#281c
;XOR  a
;CALL wipeout
         CALL repeat
         LD   a,48
         JR   c,bigm1
         RRCA 
bigm1
         LD   (lastwin),a
         CALL game0
         CALL incmoney
         JP   takeit1
;
boing1
         LD   hl,boingt1
         JR   msound
boing
         LD   hl,boingt
         JR   msound
sosc
         LD   c,a
         JR   gtable
rnoise                                  ; For Repeaters
         PUSH af
         LD   a,40
         JR   z,rnoise1
         RRCA 
rnoise1
         LD   (ntone1),a
         LD   hl,noiset
         CALL msound
         POP  af
         RET  
bf
         LD   c,0
bft      EQU  $-1
         CALL bf1
         INC  c
bf1
gtable                                  ; Cash Table (GAMBLE MONEY GRID) Sound
         PUSH af
         PUSH bc
         PUSH hl
         LD   a,c
         INC  a
         INC  a
         ADD  a,a
         ADD  a,a                       ; Entry A = Grid Part
         ADD  a,a
         ADD  a,a
         LD   (gstable1),a
         LD   hl,gstable
         CALL msound
         POP  hl
         POP  bc
         POP  af
         RET  
sdisable                                ; Sound Disable
         LD   hl,disablet
         JR   msound
ping
         LD   hl,pingt
msound
         LD   a,(hl)
         CP   #ff
         JR   z,msounde
         INC  hl
         LD   c,(hl)
         INC  hl
         CALL sound
         JR   msound
msounde                                 ; If Not Exited Writing To reg. 14 The 
         LD   a,14                      ; Keyboard Hangs
         LD   c,0
sound                                   ; Control AY-3-8192 CHIP
         DI   
         LD   b,#f4
         OUT  (c),a
         INC  b
         INC  b
         IN   a,(c)
         OR   #c0
         OUT  (c),a
         AND  #3f
         OUT  (c),a
         DEC  b
         DEC  b
         OUT  (c),c
         INC  b
         INC  b
         LD   c,a
         OR   #80
         OUT  (c),a
         OUT  (c),c
         RET  
;
pingt                                   ; Ping Table
         DEFB 8,16                      ; Envelope Enable Voluem
         DEFB 1,0
         DEFB 0,37                      ; Set Up CHANNEL A
         DEFB 11,255
         DEFB 12,18                     ; Set Envelope Duration
         DEFB 13,1                      ; Select Envelope 1
         DEFB 7,62                      ; Enable Tone
         DEFB #ff
disablet                                ; Disable Sound Table
         DEFB 8,0                       ; Volume 0
         DEFB 0,0
         DEFB 1,0                       ; CHANNEL A SOUND 0
         DEFB 2,0
         DEFB 3,0                       ; CHANNEL B SOUND 0
         DEFB 4,0
         DEFB 5,0                       ; CHANNEL C SOUND 0
         DEFB 7,63                      ; Disable All Channels
         DEFB #ff                       ; End
gstable                                 ; Gamble Sound Table
         DEFB 8,16
         DEFB 1,0
         DEFB 0,20
gstable1 EQU  $-1
         DEFB 11,50
         DEFB 12,6
         DEFB 13,2
         DEFB 7,60
         DEFB #ff
noiset                                  ; NOISE TABLE
         DEFB 8,16
         DEFB 1,0
         DEFB 0,100
ntone    EQU  $-1
         DEFB 6,12
ntone1   EQU  $-1
         DEFB 11,180
         DEFB 12,0
         DEFB 13,9
         DEFB 7,%110110
         DEFB #ff
boingt                                  ; Boing Table
         DEFB 8,16
         DEFB 9,16
         DEFB 10,16
         DEFB 11,200
         DEFB 12,2
         DEFB 13,9
         DEFB 1,3
         DEFB 3,3
         DEFB 5,3
         DEFB 7,%111000
         DEFB #ff
boingt1                                 ; Boing Table
         DEFB 8,16
         DEFB 9,16
         DEFB 10,16
         DEFB 11,200
         DEFB 12,1
         DEFB 13,9
         DEFB 0,50
         DEFB 1,2
         DEFB 2,50
         DEFB 3,2
         DEFB 4,50
         DEFB 5,2
         DEFB 7,%111010
         DEFB #ff
;end
currcomb DEFS 8,0                       ; Nudge Win Combination
n5       DEFB 0
n4       DEFB 0
n3       DEFB 0
n2       DEFB 0
n1       DEFB 0
mid      EQU  15
coingrid                                ; Coin Matrix
         DEFB 1,2,3,4,5,6
winlgrid
         DEFS 6,0
potcash  DEFS 24,255
wing     EQU  184
p10      EQU  186
p20      EQU  188
p50      EQU  190
p1       EQU  192
ptoken   EQU  194
p10l     EQU  196
p20l     EQU  198
p50l     EQU  200
p1l      EQU  202
ptokenl  EQU  204
einktble
         DEFB 0,#c0,#c,#cc,#30,#f0,#3c
         DEFB #fc,3,#c3,15,#cf,#33,#f3
         DEFB #3f,#ff
functab                                 ; Gaming Functions Table
         DEFW mystery
         DEFW spinawin
         DEFW skilcash
         DEFW cashfall
         DEFW numberun
         DEFW hilocash
         DEFW cashpot
         DEFW nudge
         DEFW repeater
repeatlc EQU  #df38+#51
repeatad                                ; Repeat Address Table
         DEFW repeatlc,repeatlc+5
         DEFW repeatlc+10,repeatlc+15
         DEFW repeatlc+20
nowin                                   ; If No NUDGES WIN
         DEFB 3
         DEFM ?SORRY?NO?WIN...?
         DEFB #ff
youvewun                                ; Message For Amount Won.
         DEFB 3
         DEFM ??CONGRATULATIONS?YOU'VE?
         DEFM WON??-??
         DEFB 11
wunm
         DEFS 80,"?"
         DEFB #ff
spaces   EQU  $-2
think                                   ; For Nudges When > 5
         DEFB 11
         DEFM ?THINKING...???
         DEFB #ff
spinawm
         DEFB 11
         DEFM ??HIT?START?TO?WIN?THE?SP
         DEFM IN..
         DEFB #ff
rept1
         DEFB 11
         DEFM ??HIT?RETURN?FOR?>2.40?OR
         DEFM ?
         DEFM >4.80?REPEATERS?N?FOR?BIG
         DEFM ?MONEY
         DEFB #ff
numbr1
         DEFB 11
         DEFM ?HIT?THE?HOLD?BUTTONS?
         DEFB 2
         DEFM 2?-?4
         DEFB 11
         DEFM ?TO?GET?THE?NUMBERS?FOR?X
         DEFM TRA?CASH?@@@
         DEFB #ff
game1
         DEFB 2
         DEFM ??MYSTERY?LOST.
         DEFB #ff
game2
         DEFB 2
         DEFM ??SPIN-A-WIN?LOST.
         DEFB #ff
game3
         DEFB 2
         DEFM ??SKILL?CASH?LOST.
         DEFB #ff
game4
         DEFB 5
         DEFM ??CASH-FALLS?LOST.
         DEFB #ff
game5
         DEFB 11
         DEFM ??NUMBERS?RUN?LOST.
         DEFB #ff
game6
         DEFB 11
         DEFM ??HI/LO?CASH?LOST.
         DEFB #ff
regstr                                  ; Register Display Key String
         DEFB 50,58,52,60
game7
         DEFB 11
         DEFM ??CASH?POT?LOST.
         DEFB #ff
game8
         DEFB 11
         DEFM ??NUDGES?LOST.
         DEFB #ff
game9
         DEFB 15
         DEFM ??REPEATERS?LOST.
         DEFB #ff
lost1    DEFB 2
         DEFM ??HE?HE?HE?YOU'VE?LOST?TH
         DEFM E?GAMBLE??FOOLS?AND?THERE
         DEFM ?MONEY?@@@
         DEFB #ff
lost2
         DEFB 2
         DEFM ??HA?HA?HA?THAT?WILL?TEAC
         DEFM H?YOU?TO?GAMBLE
         DEFB #ff
lost3
         DEFB 3
         DEFM ??THERE'S?ONLY?ONE?WINNER
         DEFM ,?
         DEFM ?AND?THAT?JUST?HAPPENS?TO
         DEFM ?BE?ME...
         DEFB #ff
lost4
         DEFB 3
         DEFM ??ONCE?AGAIN?YOU?LOSE?TO?
         DEFM ME,?
         DEFM HAVE?YOU?CONSIDERED?GA
         DEFM MBLERS?ANONYMOUS?@@@
         DEFB #ff
lost5
         DEFB 3
         DEFM ??YOU?ARE?BROKE
         DEFM ??AND?YOU?ARE?IN?DEBT?
         DEFM TO?THE?BANK.
         DEFB #FF
hicon                                   ; Hi-Score Congratulations
         DEFB 11
         DEFM BY?THE?WAY
         DEFM ?YOU?WALK?AWAY
         DEFM ?WITH?TODAY'S?HIGHEST?WIN
         DEFM ?@@@
         DEFB #ff
byebye                                  ; Ta For Playing Sucker !
         DEFB 11
         DEFM ?THANK?YOU?FOR?PLAYING?
         DEFB 2
         DEFM SLOT?5?
         DEFB 11
         DEFM I?HOPE?TO?SEE?YOU?AGAIN?S
         DEFM OON?...???
         DEFB #FF
hello
         DEFB 11
         DEFM ?EXCELLENT?TO?SEE?YOU?...
         DEFB #ff
info     DEFB 3
         DEFM ??MACHINE?CURRENTLY?ON?
         DEFB 5
ppc      DEFM ??
         DEFB 3
         DEFM ?PERCENT?PAYOUT.?MACH
         DEFM INES?MEAN?STATUS?IS?
         DEFB 5,"O"
pms      DEFM ???
         DEFB 3
         DEFM MEGA?CASH?SUPRESSION?IS?
         DEFB 5,"O"
pms1     DEFM ???
         DEFB 3
         DEFM ...
         DEFB #ff
gamelt   DEFW game1,game2,game3,game4
         DEFW game5,game6,game7,game8
         DEFW game9
funcadtb                                ; Function Screen Address Table
         DEFW #ce40,#f550,#dcb0,#c410
         DEFW #eb20,#d280,#f990,#e0f0
         DEFW #c850
row1off  EQU  0
row2off  EQU  #e
row3off  EQU  #1c
row1len  EQU  #e
row2len  EQU  #1c-#e
row3len  EQU  #28-#1c
row1bf   DEFS 9,0
row2bf   DEFS 9,0
row3bf   DEFS 9,0
row1bfo  DEFS 9,0
row2bfo  DEFS 9,0
row3bfo  DEFS 9,0
hilofs                                  ; Hilo Offsets
         DEFB 1,2,4,6,9,12,18
         DEFB 35,34,32,30,27,24,18
hiloscad                                ; HI / LO Screen Address Table
         DEFW #c173,#c973,#d973,#e973
         DEFW #c1c3,#d9c3,#ca13
gwsat    DEFB #48,#e8,#89,#2a,#ca,#6b
         DEFB #c,#ac,#4d,#ed,#8e,#2f
gtrail   DEFB 0,1,2
gtrailo  DEFW 0
         DEFB 7,8,9,10,11
gmoney   DEFB 48,24,20,18,16,14,12,10
         DEFB 8,6,4,0
gwin     DEFB 0                         ; Gamble High Screen Addre
gwun     DEFB 0
glose    DEFB 0                         ; Gamble Low ScrADD
trailfo  DEFS 12,0                      ; Original Trail Flags
trailfc  DEFS 12,0                      ; Trail Flag Control
lose     EQU  $-1
gtimings
         DEFB 0,1,3,5,7,9,11,12,13,14
         DEFB 15,15
wintable
         DEFB 6,8,6,6,16,10,18,10,48
         DEFB 24,8,20,10,12
winlbuff DEFS 9,0                       ; 3*3 Win Line Buffers
reeldtb                                 ; Reel Directions Table
         DEFB 0,%11111,%10101,%1010
         DEFB %10001,%100,%1110,0
count    DEFB 6
count1   DEFB 6
count2   DEFW 0
losttble                                ; Table For LOST MESSAGES
         DEFW lost1,lost2,lost3
         DEFW lost4,lost5
reel1spd DEFB 1                         ; Reel Speeds
reel2spd DEFB 2                         ; Reel 2 Speed
reel3spd DEFB 3                         ; Reel 3 Speed
reel4spd DEFB 4                         ; Reel 4 Speed
reel5spd DEFB 5                         ; Reel 5 Spd
holdt    DEFW #ec12,#cdaf,#eefd
         DEFW #ef0a,#ef17
reeloffs                                ; Reel Speed Offsets
         DEFB 1,2,4,6,12,18
         DEFB 35,34,32,30,24,18
nudgesac                                ; Reel Nudge accelleration Sequence
         DEFB 1,1,1,1,1,1,1,1,2,2,2,2
         DEFB 3,3,4,3,1,1
reelofs1
         DEFB 1,2,4,6,12,18
         DEFB 71,70,68,66,60,54
reelofs2
         DEFB 1,2,4,6,12,18
         DEFB 107,106,104,102,96,90
DigitalN DEFW #70,0
hscore   DEFB 0,5,1,1
hardinks DEFB 20,4,21,28,24,29,12,5
         DEFB 13,22,6,23,30,0,31
         DEFB 14,7,15,18,2,19,26,25
         DEFB 27,10,3,11
inks     DEFB 0,6,15,25,22,18,12,1,2
         DEFB 5,11,26,24,4,3,7
sprload  EQU  #40
dig1     DEFW #c00a,#c011,#c01a,#c021
accelsqn                                ; Acceleration Sequence
         DEFB 1,1,1,1,2,2,2,3,3,4,5
reel1sad                                ; Reel 1 Screen Address Table For Scrol
         DEFW #dbc2
         DEFW #d3c2,#cbc2,#fb72
         DEFW #eb72,#fb22,#cb22
reel1sau
         DEFW #c282
         DEFW #ca82,#da82,#ea82
         DEFW #dad2,#cb22
reel2sad
         DEFW #fd0f
         DEFW #f50f,#ed0f,#dd0f
         DEFW #cd0f,#dcbf,#ec6f
reel2sau
         DEFW #c28f,#ca8f,#da8f
         DEFW #ea8f,#dadf,#cb2f
reel3sad
         DEFW #deac
         DEFW #d6ac,#ceac,#fe5c
         DEFW #ee5c,#fe0c,#ce0c
reel3sau
         DEFW #c29c,#ca9c,#da9c
         DEFW #ea9c,#daec,#cb3c
reel4sad
         DEFW #deb9
         DEFW #d6b9,#ceb9,#fe69
         DEFW #ee69,#fe19,#ce19
reel4sau
         DEFW #e3e9,#ebe9,#fbe9
         DEFW #cc39,#fc39,#ec89
reel5sad
         DEFW #dec6
         DEFW #d6c6,#cec6,#fe76
         DEFW #ee76,#fe26,#ce26
reel5sau
         DEFW #c586,#cd86,#dd86
         DEFW #ed86,#ddd6,#ce26
reel1bfd DEFS 11*36,0
reel2bfd DEFS 11*36,0
reel3bfd DEFS 11*36,0
reel4bfd DEFS 11*36,0
reel5bfd DEFS 11*36,0
moved1   DEFB 0
moved2   DEFB 0
moved3   DEFB 0
moved4   DEFB 0
moved5   DEFB 0
reel1adp DEFW 0
reel2adp DEFW 0
reel3adp DEFW 0
reel4adp DEFW 0
reel5adp DEFW 0
roff     EQU  35*11
nfrtpr   EQU  29                        ; Number Of Fruits Per Reel
ree1adpf EQU  roff+reel1bfd
ree2adpf EQU  roff+reel2bfd
ree3adpf EQU  roff+reel3bfd
ree4adpf EQU  roff+reel4bfd
ree5adpf EQU  roff+reel5bfd
ree1aupf EQU  reel1bfd
ree2aupf EQU  reel2bfd
ree3aupf EQU  reel3bfd
ree4aupf EQU  reel4bfd
ree5aupf EQU  reel5bfd
reelt1
         DEFB 104,24,16,8,80,96,16,24
         DEFB 88,40,0,16,32,72,104,16
         DEFB 8,16,56,24,80,32,8,0,16
         DEFB 48,24,80,40
reelt2
         DEFB 16,68,8,88,107,18,96,8,25
         DEFB 16,32,1,24,56,74,16,56
         DEFB 97,0,16,11,48,83,0,89,16
         DEFB 80,42,24
reelt3
         DEFB 41,16,24,9,72,56,91,96,16
         DEFB 0,8,16,40,2,80,48,16,4
         DEFB 56,64,16,24,104,88,24,81
         DEFB 16,48,32
reelt4
         DEFB 64,80,3,24,16,96,28,16,74
         DEFB 105,80,0,91,16,49,24,32
         DEFB 16,67,16,8,82,32,28,72
         DEFB 104,17,56,40
reelt5
         DEFB 72,32,16,24,8,96,88,56,16
         DEFB 24,40,0,8,16,32,80,104,24
         DEFB 16,0,8,40,96,56,16,24
         DEFB 80,48,88
rel1addd EQU  reelt1+mid
rel2addd EQU  reelt2+mid
rel3addd EQU  reelt3+mid
rel4addd EQU  reelt4+mid+1
rel5addd EQU  reelt5+mid+2
rel1addu EQU  reelt1+mid+2
rel2addu EQU  reelt2+mid+3
rel3addu EQU  reelt3+mid+4
rel4addu EQU  reelt4+mid+4
rel5addu EQU  reelt5+mid+4
welcomem                                ; Welcome Message
         DEFB 1
         DEFM ????WELCOME?TO?
         DEFB 11
         DEFM SLOT?
         DEFB 3
         DEFM 5
         DEFB 1
         DEFM ?
         DEFM FRUIT?MACHINE?SIMULATOR??
         DEFB 11
         DEFM WRITTEN?BY?-?
         DEFB 3
         DEFM THE?ARGONAUT?
         DEFB 11
         DEFM -?
         DEFB 2
         DEFM (C)?1990?JACESOFT?SOFTWAR
         DEFM E?LTD,??
         DEFB 5
         DEFM WELL?AS?YOU?CAN?SEE?THIS?
         DEFM FRUIT?MACHINE?SIMULATOR?IS
         DEFM ?SLIGHTLY?DIFFERENT?TO?TH
         DEFM E?CONVENTIONAL?ONES?C
         DEFM URRENTLY?SEEN?ON?THE?MARK
         DEFM ET?
         DEFB 4
         DEFM THIS?HAS?5?REELS?STAGGERE
         DEFM D?IN?3?SETS?OF?THREE?
         DEFB 1
         DEFM THEREFORE?WITH?3?WINLINES
         DEFM ?YOU?SHOULD?NOT?LOSE?@@@??
         DEFB 10
         DEFM TO?PLAY?THE?GAME?SIMPLY?P
         DEFM RESS?THE?=
         DEFB 5
         DEFM P
         DEFB 10
         DEFM <?KEY???
         DEFB 2
         DEFM TO?SPIN?THE?REELS?PRESS?=
         DEFB 5
         DEFM RETURN
         DEFB 2
         DEFM <?
         DEFB 4
         DEFM TO?HOLD?THE?REELS?PRESS?K
         DEFM EYS?=
         DEFB 10
         DEFM 1?-?5?
         DEFB 4
         DEFM <?
         DEFB 12
         DEFM SHOULD?YOU?FIND?THAT?YOU?
         DEFM HAVE?WON?THEN?YOU?HAVE?THE
         DEFM ?OPTION?OF?GAMBLING?YOUR?W
         DEFM INNINGS?FOR?A?LARGER?AMOUN
         DEFM T,?THE?CONSEQUENCE?OF?THE
         DEFM ?GAMBLE?IS?THAT?THERE?IS?T
         DEFM HE?POSSIBILITY?YOU?COULD?L
         DEFM OSE?ALL?OF?YOUR?WINNINGS?O
         DEFM R?ONLY?A?SMALL?PORTION.??
         DEFB 11
         DEFM NO?MORE?THAN?>4.80?MAY?BE
         DEFM ?WON?FROM?THIS?MACHINE?IN?
         DEFM ANY?ONE?GAME?@??
         DEFB 1
         DEFM TO?GAMBLE?YOUR?WINNINGS?P
         DEFM RESS?=
         DEFB 3
         DEFM RETURN
         DEFB 1
         DEFM <?TO?COLLECT?PRESS?=
         DEFB 3
         DEFM C?OR?T
         DEFB 1
         DEFM <
         DEFB 12
         DEFM ?WELL?NOW?THE?INTRODUCTIO
         DEFM N?IS?OVER?TIME?FOR?ANOTHER
         DEFM ?ONE?OF?THOSE?LONG?BORING
         DEFM ?SCROLLING?MESSAGES?FULL?
         DEFM OF?USELESS?INFORMATION,?
         DEFB 1
         DEFM DID?YOU?KNOW?
         DEFB 2
         DEFM THAT?THERE?IS?A?SYSTEM?TO
         DEFM ?BEAT?FRUIT?MACHINES?FOUN
         DEFM D?IN?AMUSEMENT?ARCADES?,
         DEFM PUBS,?AND?CLUBS?ETC.,??
         DEFB 11
         DEFM ONE?THING?YOU?MUST?ALWAYS
         DEFM ?REMEMBER?IS?THAT?A?MACHI
         DEFM NE?WILL?ONLY?GIVE?YOU?AS?M
         DEFM UCH?AS?IT?WANTS?:?
         DEFB 3
         DEFM THE?BEST?TIME?TO?GO?ON?A?
         DEFM MACHINE?IS?AFTER?SOME?UNFO
         DEFM RTUNATE?SOLE?HAS?PUT?>5?TO
         DEFM ?>10?INTO?IT?AND?WALKED?AW
         DEFM AY?WITH?NOTHING?THIS?MEANS
         DEFM ?THAT?THE?MACHINE?HAS?BEEN
         DEFM ?PRIMED?AND?THE?POSSIBILIT
         DEFM Y?OF?YOU?WINNING?IS?GREAT
         DEFM ER?
         DEFB 5
         DEFM ALSO?ALMOST?ALWAYS?GAMBLE
         DEFM ?YOUR?WINNINGS?DON'T?BOTH
         DEFM ER?TIMING?SEQUENCES?BECAU
         DEFM SE?NO?MATTER?WHEN?YOU?PRE
         DEFM SS?THE?GAMBLE?BUTTON?THE?
         DEFM MACHINE?WILL?GIVE?YOU?WHA
         DEFM T?
         DEFB 1
         DEFM IT
         DEFB 5
         DEFM ?WANTS?TO?GIVE?NOT?WHAT?Y
         DEFM OU?WANT?IT?TO?STOP?ON
         DEFB 3
         DEFM ?ALSO?TRY?AND?HOLD?NUMBER
         DEFM S?-?IF?THE?MACHINE?HAS?THE
         DEFM M?-?AS?EVERY?ONE?COUNTS
         DEFB 4
         DEFM ?TRY?AND?TAKE?YOUR?MYSTE
         DEFM RY?PRIZES?AS?SOMETIMES?IT?
         DEFM WILL?GIVE?YOU?AS?MUCH?AS?>
         DEFM 2?ALTHOUGH?MORE?OFTEN?THAN
         DEFM ?NOT?IT?WILL?GIVE?YOU?40P?
         DEFB 1
         DEFM ANY?WAY?ENOUGH?OF?THAT?.?
         DEFM IF?YOU?LIKE?THIS?GAME?THEN
         DEFM ?PLEASE?LET?US?KNOW,?IF?YO
         DEFM U?HAVE?WRITTEN?A?GOOD?QUAL
         DEFM ITY?ARCADE?GAME?THEN?SEND?
         DEFM IT?TO?US?FOR?EVALUATION,?O
         DEFM THER?PROGRAMS?IN?OUR?TITL
         DEFM ES?INCLUDE?
         DEFB 2
         DEFM CHOICE?CHEATS?1-5?
         DEFB 11
         DEFM THESE?ARE?SMALL?PROGRAMS?
         DEFM TO?ENABLE?YOU?TO?COMPLETE?
         DEFM MANY?OF?THE?COMMERCIAL?GAM
         DEFM ES?ON?THE?MARKET?AND?ARE?A
         DEFM N?ESSENTIAL?PIECE?OF?GEAR.
         DEFM ??ALSO?I?MAKE?NO?APOLOGIES
         DEFM ?FOR?THE?PATHETIC?SOUND?TH
         DEFM AT?ACCOMPANIES?THIS?GAME?B
         DEFM ECAUSE?I?CAN?NOT?WRITE?SOU
         DEFM ND?ROUTINES?AND?AM?NOT?MUS
         DEFM ICALLY?MINDED?HOWEVER?I?AM
         DEFM ?LOOKING?FOR?SOMEONE?THAT?
         DEFM CAN?WRITE?SOUND?IN?MACHIN
         DEFM E?CODE?PREFERABLY?NOT?USIN
         DEFM G?FIRMWARE,?IF?YOU?CAN?THE
         DEFM N?PLEASE?CONTACT?ME??C/O
         DEFM ?1ST?CHOICE?SOFTWARE?LTD.?
         DEFM 4?PAUL?ROW?TEMPLE?LANE?,?
         DEFM LITTLEBOROUGH,?LANCS,?OL15
         DEFM ?9QG???
         DEFB #ff
;
