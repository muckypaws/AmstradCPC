;
         ORG  #100
sprites  EQU  #1000
scankey  EQU  #bb1e
setmode  EQU  #bc0e
setink   EQU  #bc32
setbord  EQU  #bc38
framefly EQU  #bd19
ptime    EQU  100
xoff     EQU  10                        ; X Offset Of Playing Board
yoff     EQU  2                         ; Y Offset Of Playing Board
mboxw    EQU  10
start    ENT  $
         DI   
         LD   sp,#bff8
         LD   bc,#7fc0
         OUT  (c),c
         CALL load
         CALL setscrd
         CALL setplay                   ; Set Playing Screen Colours And Mode
         LD   hl,sprites+20
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   hl,sprites+#100
         ADD  hl,de
         LD   (txtchar),hl
         LD   (textch1),hl
         LD   b,10
start1
         LD   (hl),0
         INC  hl
         DJNZ start1
         LD   hl,welcome
         CALL setupms
         LD   a,47
         CALL scrmess
test
         LD   hl,#101
         CALL locate
         LD   hl,welcome
         CALL print
newgame
         CALL setplay
         LD   h,0
         LD   l,0
         LD   b,38
         LD   c,23
         CALL pbox
         LD   h,xoff-2
         LD   l,yoff-1*8
         LD   b,10
         LD   c,20
         CALL pbox
         LD   hl,0
         LD   (nfulline),hl
         XOR  a
         LD   (shownf),a
         CALL cleargrd
         CALL newpc
         CALL newpc
         LD   h,24+xoff
         LD   l,8
         LD   a,9
         LD   b,22
         LD   c,33
         CALL pspr
         LD   h,xoff+28
         LD   l,yoff-1+4*8+2
         LD   b,6
         LD   c,3
         CALL pbox
gloop1
         CALL chkline
         LD   hl,(resett)
         LD   (gtimer),hl
         XOR  a
         LD   (play1y),a
         LD   (rot),a
         CALL newpc
         CALL addpiece
         LD   a,(shapehw+1)             ; Get Width
         RRA  
         LD   c,a
         LD   a,5
         SUB  c
         LD   (play1x),a
         CALL chkpce
         JP   c,adam
         CALL putpce
         CALL dblok
         CALL shownext
gameloop
         CALL #bd19
         LD   a,6
         CALL #bb1e
         JP   nz,adam
;
         CALL cdown
         JR   c,gloop1
         CALL #bb09
         JR   nc,gameloop
         AND  #df
         CALL left
         CALL right
         CALL rotate
         CALL snext
;
         OR   a
         JR   nz,gameloop
         CALL alldown
         JR   gloop1
;
cdown
         LD   hl,(gtimer)
         DEC  hl
         LD   (gtimer),hl
         LD   a,h
         OR   l
         RET  nz
RESET
         LD   hl,(resett)
         LD   (gtimer),hl
         JR   down
dblok
         PUSH af
         LD   a,1
         CALL drawblok
         POP  af
         RET  
delblok
         CALL #bd19
         PUSH af
         XOR  a
         CALL drawblok
         POP  af
         RET  
rrot
         LD   a,ptime
         LD   (keyc1),a
         RET  
snext
         CP   "N"
         RET  nz
         LD   a,(shownf)
         OR   a
         RET  nz
         DEC  a
         LD   (shownf),a
         PUSH af
         CALL shownext
         POP  af
         RET  
rotate
         CP   13
         RET  nz
         PUSH af
         CALL rotate1
         POP  af
         RET  
         JR   rotate1
         LD   a,21
         CALL #bb1e
         JR   z,rrot
         LD   hl,keyc1
         LD   a,(hl)
         DEC  (hl)
         JR   z,rrot
         CP   ptime
         RET  nz
rotate1
         CALL delpce
         LD   hl,rot
         INC  (hl)
         CALL newrot
         CALL chkpce
         LD   hl,rot
         DEC  (hl)
         JR   nc,canrot
         CALL newrot
         JP   putpce
canrot                                  ; Can Rotate
         CALL newrot
         CALL delblok
         LD   hl,rot
         INC  (hl)
         CALL newrot
         CALL putpce
         JP   dblok
alldown
         OR   a
         RET  nz
alldown1
         CALL down
         JR   nc,alldown1
         RET  
down
         CALL delpce
         LD   hl,play1y
         INC  (hl)
         CALL chkpce
         LD   hl,play1y
         DEC  (hl)
         JR   nc,downok
         CALL putpce
         SCF  
         RET                            ; Carry Set If Can Not Go Down
downok
         CALL delblok
         LD   hl,play1y
         INC  (hl)
         CALL putpce
         CALL dblok
         AND  a
         RET  
rleft
         LD   (hl),ptime
         RET  
addpiece                                ; Add Piece To List
         LD   a,(piece)
         ADD  a,a
         LD   e,a
         LD   d,0
         LD   hl,npieces
         ADD  hl,de
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         INC  de
         LD   (hl),d
         DEC  hl
         LD   (hl),e
         RET  
resetpl                                 ; Reset Piece List
         LD   hl,npieces
         LD   b,7*2
rpl1
         LD   (hl),0
         INC  hl
         DJNZ rpl1
         RET  
left
         CP   "Z"
         RET  nz
         PUSH af
         CALL left1
         POP  af
         RET  
left1
;
         CALL delpce
         LD   hl,play1x
         DEC  (hl)
         CALL chkpce
         PUSH af
         LD   hl,play1x
         INC  (hl)
         POP  af
         JR   nc,leftok
         CALL putpce
         SCF  
         RET                            ; Carry Set If Can Not Go Down
leftok
         CALL delblok
         LD   hl,play1x
         DEC  (hl)
         CALL putpce
         CALL dblok
         AND  a
         RET  
right
         CP   "X"
         RET  nz
         PUSH af
         CALL right1
         POP  af
         RET  
right1
;
         CALL delpce
         LD   hl,play1x
         INC  (hl)
         CALL chkpce
         LD   hl,play1x
         DEC  (hl)
         JR   nc,rightok
         CALL putpce
         SCF  
         RET                            ; Carry Set If Can Not Go Down
rightok
         CALL delblok
         LD   hl,play1x
         INC  (hl)
         CALL putpce
         CALL dblok
         AND  a
         RET  
;
adam
         CALL #bb09
         JR   c,adam
         DI   
         LD   bc,#7fc4
         OUT  (c),c
         LD   sp,#bff8
         JP   #4000
delpce
         LD   a,#af
         LD   (delete),a
         CALL putpce
         XOR  a
         LD   (delete),a
         RET  
putpce                                  ; Put Piece Into Play Grid
         CALL calcgad                   ; HL = Location To Place Piece
         LD   de,(shapead)
         LD   bc,(shapehw)
putpce1
         PUSH bc
         PUSH hl
putpce2
         LD   a,(de)                    ; Get Piece
         OR   a
         JR   z,putpce3
         NOP                            ; Spare When Deleteing Piece
delete   EQU  $-1                       ; Will Contain XOR A : #AF
         LD   (hl),a
putpce3
         INC  de
         INC  hl
         DJNZ putpce2
         POP  hl
         LD   bc,12
         ADD  hl,bc
         POP  bc
         DEC  c
         JR   nz,putpce1
         RET  
chkline                                 ; Check If There Is A Full Line
         XOR  a
         LD   (blast),a                 ; How Many Blocks Destroyed This Time
chkline1
         CALL findline
         RET  nc
         LD   hl,blast
         INC  (hl)
         LD   hl,(nfulline)             ; Get Full Lines
         INC  hl
         LD   (nfulline),hl
         CALL dropline
         PUSH bc
         CALL topline
         LD   a,c
         LD   (TOP),a
         POP  bc
         CALL scrlined
         LD   hl,20*12+playgrid
         LD   de,20*12+playgrid+1
         LD   bc,11
         LD   (hl),#ff
         LDIR 
         JR   chkline
topline                                 ; Find Top Line
         LD   hl,playgrid+1
         LD   c,0
topline1
         LD   b,10
topline2
         LD   a,(hl)
         OR   a
         RET  nz
         INC  hl
         DJNZ topline2
topline3
         INC  hl
         INC  hl
         INC  c
         JR   topline1
findline
         LD   hl,12*19+playgrid+1
         LD   c,20                      ; Check 20 Lines
fndline1
         LD   e,0                       ; Counter
         LD   b,10
         PUSH hl
fndline2
         LD   a,(hl)
         OR   a
         JR   z,fndline3
         INC  e
         INC  hl
         DJNZ fndline2
         LD   a,e
         CP   10
         JR   nz,fndline3
         SCF  
         POP  hl
         DEC  c
         RET  
fndline3
         POP  hl
         LD   de,12
         AND  a
         SBC  hl,de
         DEC  c
         JR   nz,fndline1
         AND  a
         RET  
dropline
         PUSH bc
         DEC  c
         LD   a,c
         ADD  a,a
         ADD  a,c
         ADD  a,a
         ADD  a,a
         LD   e,a
         LD   d,0
         LD   hl,playgrid+11
         ADD  hl,de                     ; HL = Line
;
         PUSH hl
         LD   de,playgrid
         AND  a
         SBC  hl,de                     ; HL = Distance to copy
         PUSH hl
         POP  bc
         POP  de
         LD   hl,12
         ADD  hl,de
         EX   de,hl
;
         LDDR 
         LD   hl,playgrid+1
         LD   de,playgrid+2
         LD   bc,9
         LD   (hl),0
         LDIR 
         POP  bc
         RET  
scrlined                                ; Drop Screen Line Down By One.
         CALL #bd19
         PUSH bc
         LD   a,c
         DEC  a
         ADD  a,yoff
         ADD  a,a
         ADD  a,a
         ADD  a,a
         LD   l,a
         LD   h,xoff
         CALL calcaddr                  ; HL = Physical Address
         EX   de,hl
         LD   hl,#50
         ADD  hl,de
         EX   de,hl                     ; DE = Next Line Down
         POP  bc
         LD   a,c
         SUB  0
TOP      EQU  $-1
         INC  a
         JR   z,scrd3
         LD   c,a
scrd2
         PUSH bc
         PUSH hl
         PUSH de
         LD   c,8
scrd1
         PUSH bc
         PUSH hl
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
;
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
         POP  hl
         CALL addline
         CALL addlnde
         POP  bc
         DEC  c
         JR   nz,scrd1
         POP  hl
         LD   bc,#50
         AND  a
         SBC  hl,bc
         EX   de,hl
         POP  hl
         AND  a
         SBC  hl,bc
         POP  bc
         DEC  c
         JR   nz,scrd2
scrd3
         LD   bc,#50
         ADD  hl,bc
         LD   b,8
scrd4
         PUSH bc
         PUSH hl
         PUSH hl
         POP  de
         INC  de
         LD   (hl),0
         LD   bc,19
         LDIR 
         POP  hl
         CALL addline
         POP  bc
         DJNZ scrd4
         RET  
chkpce                                  ; Check If Piece Can Move Here
         CALL calcgad                   ; HL = Location To Place Piece
         LD   de,(shapead)
         LD   bc,(shapehw)
chkpce1
         PUSH bc
         PUSH hl
chkpce2
         LD   a,(de)                    ; Get Piece
         OR   a
         JR   z,chkpce3
         LD   a,(hl)
         OR   a
         JR   nz,collis                 ; There Is a collision
chkpce3
         INC  de
         INC  hl
         DJNZ chkpce2
         POP  hl
         LD   bc,12
         ADD  hl,bc
         POP  bc
         DEC  c
         JR   nz,chkpce1
         AND  a
         RET                            ; NC if Piece Is Clear  
collis
         POP  hl
         POP  de
         SCF  
         RET                            ; Carry Set If Not Clear 
calcgad                                 ; Calculate Grid Address
         LD   d,0
         LD   a,(play1y)
         OR   a
         JR   nz,calcgad2
         LD   a,(play1x)
         INC  a
         BIT  7,a
         JR   z,calcgad1
         DEC  d
         JR   calcgad1
calcgad2
         LD   c,a
         ADD  a,a
         ADD  a,c                       ; * 3
         ADD  a,a                       ; * 6
         ADD  a,a                       ; * 12
         LD   c,a
;
         LD   a,(play1x)
         ADD  a,c
         INC  a
calcgad1
         LD   e,a
         LD   hl,playgrid
         ADD  hl,de
         RET  
newpc                                   ; Calculate Game Pieces A = Piece No.
         LD   a,(next)
         LD   (piece),a
         ADD  a,a
         ADD  a,a
         ADD  a,a                       ; Multiply By 8
         LD   c,a                       ; Store In C
         ADD  a,a
         LD   e,a
         LD   d,0
         LD   hl,sprites+#100
         ADD  hl,de
         LD   (spradr),hl               ; Store Address
newpc2
         LD   a,r
         AND  7
         CP   7
         JR   nc,newpc2
         LD   (next),a
         XOR  a
         LD   (rot),a                   ; Move On And Calculate Piece addr
newrot                                  ; New Rotation Of Piece
         LD   a,(piece)
         ADD  a,a
         ADD  a,a
         ADD  a,a
         LD   c,a
         LD   a,(rot)                   ; Get Rotation
         AND  3
         ADD  a,a
         ADD  a,c                       ; Offset = 8 * Piece + Rot * 2
         LD   e,a
         LD   d,0
         LD   hl,bloktble
         ADD  hl,de                     ; HL = Address Of Table
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         EX   de,hl
         LD   b,(hl)
         INC  hl
         LD   c,(hl)
         INC  hl                        ; C = Height, B = Width
         LD   (shapehw),bc
         LD   (shapead),hl
         RET  
drawblok                                ; Display Block On Screen
         LD   hl,(spradr)               ; Entry A=0 Erase Block A<>0 Draws it
         LD   (oldspr),hl
         OR   a
         JR   nz,drawb1
         LD   hl,sprites+#170
         LD   (spradr),hl
drawb1
         CALL calcp1
;
         EX   de,hl
         LD   hl,(shapead)
         LD   bc,(shapehw)
;
db1
         PUSH bc
         PUSH de
db2
         LD   a,(hl)
         INC  hl
         OR   a
         CALL nz,blok
         INC  de
         INC  de
         DJNZ db2
         POP  de
;
         LD   a,#50                     ; Add 8 Lines To Screen Address
         ADD  a,e
         LD   e,a
         LD   a,d
         ADC  a,0
         OR   #c0
         LD   d,a
         POP  bc
         DEC  c
         JR   nz,db1
;
         LD   hl,0
oldspr   EQU  $-2
         LD   (spradr),hl
         RET  
blok
         PUSH bc
         PUSH de
         PUSH hl
         LD   hl,sprites+#100
spradr   EQU  $-2
         LD   b,8
blok1
         LD   a,(hl)
         LD   (de),a
         INC  hl
         INC  de
         LD   a,(hl)
         LD   (de),a
         INC  hl
         DEC  de
         CALL addlnde
         DJNZ blok1
         POP  hl
         POP  de
         POP  bc
         RET  
;
cleargrd                                ; Clear Play Area For New Game
         LD   hl,playgrid+1
         LD   c,20
clgd1
         LD   b,10
clgd2
         LD   (hl),0
         INC  hl
         DJNZ clgd2
         INC  hl
         INC  hl
         DEC  c
         JR   nz,clgd1
         RET  
pbox                                    ; Print A Box
         LD   a,1
         CALL pboxs
         LD   a,b
         OR   a
         JR   z,pbox1
         PUSH bc
pbox1a
         INC  h
         INC  h
         LD   a,2
         CALL pboxs
         DJNZ pbox1a
         POP  bc
pbox1
         LD   a,3
         INC  h
         INC  h
         CALL pboxs
         LD   a,c
         OR   a
         JR   z,pbox3
         PUSH bc
pbox2
         LD   a,l
         ADD  a,8
         LD   l,a
         LD   a,4
         CALL pboxs
         DEC  c
         JR   nz,pbox2
         POP  bc
pbox3
         LD   a,l
         ADD  a,8
         LD   l,a
         LD   a,5
         CALL pboxs
         LD   a,b
         OR   a
         JR   z,pbox5
         PUSH bc
pbox4
         DEC  h
         DEC  h
         LD   a,6
         CALL pboxs
         DJNZ pbox4
         POP  bc
pbox5
         DEC  h
         DEC  h
         LD   a,7
         CALL pboxs
         LD   a,c
         OR   a
         RET  z
pbox6
         LD   a,l
         SUB  8
         LD   l,a
         LD   a,8
         CALL pboxs
         DEC  c
         JR   nz,pbox6
         RET  
add8
         LD   a,#50
         ADD  a,l
         LD   l,a
         LD   a,h
         ADC  a,0
         OR   #c0
         LD   h,a
         RET  
sub8
         LD   a,l
         SUB  #50
         LD   l,a
         LD   a,h
         SBC  a,0
         OR   #c0
         LD   h,a
         RET  
;
pboxs
         PUSH hl
         PUSH bc
         LD   bc,#208
         CALL pspr
         POP  bc
         POP  hl
         RET  
pspr                                    ; Draw Sprite ; A = Sprite, L = Y, H = 
         PUSH af
         CALL calcaddr
         POP  af
         ADD  a,a
         LD   e,a
         LD   d,0
         PUSH hl
         LD   hl,sprites
         LD   l,a
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   hl,sprites+#100
         ADD  hl,de
         POP  de
pspr1
         PUSH bc
         PUSH de
pspr2
         LD   a,(hl)
         LD   (de),a
         INC  hl
         INC  de
         DJNZ pspr2
         POP  de
         CALL addlnde
         POP  bc
         DEC  c
         JR   nz,pspr1
         RET  
shownext                                ; Show Next Piece
         LD   a,0
shownf   EQU  $-1
         OR   a
         RET  z
         LD   hl,(spradr)
         PUSH hl
         LD   a,(next)
         ADD  a,a
         ADD  a,a
         ADD  a,a                       ; Multiply By 8
         LD   c,a                       ; Store In C
         ADD  a,a
         LD   e,a
         LD   d,0
         LD   hl,sprites+#100
         ADD  hl,de
         LD   (spradr),hl               ; Store Address
         LD   hl,(play1x)
         PUSH hl
         LD   l,12*8
         LD   h,3
         LD   (play1x),hl
         LD   a,(piece)
         LD   c,a
         LD   a,(rot)
         LD   b,a
         PUSH bc
         XOR  a
         LD   (rot),a
         LD   a,(next)
         LD   (piece),a
         CALL newrot
         CALL calcp1
         LD   c,16
shn1
         LD   b,8
         PUSH hl
shn2
         LD   (hl),0
         INC  hl
         DJNZ shn2
         POP  hl
         CALL addline
         DEC  c
         JR   nz,shn1
         CALL dblok
         POP  bc
         LD   a,c
         LD   (piece),a
         LD   a,b
         LD   (rot),a
         POP  hl
         LD   (play1x),hl
         POP  hl
         LD   (spradr),hl
;
         CALL newrot
         CALL calcp1
         RET  
calcp1                                  ; Calculate Player 1 Screen Address
         LD   a,(play1x)
         ADD  a,a
         ADD  a,xoff
         LD   h,a
         LD   a,(play1y)
         ADD  a,yoff
         ADD  a,a
         ADD  a,a
         ADD  a,a
         LD   l,a
         CALL calcaddr
         LD   (bscraddr),hl
         RET  
calcaddr                                ; Calculate Physical Address
         PUSH af
         PUSH bc
         PUSH de
         LD   c,h                       ; L = Y, H = X
         LD   h,0
         LD   b,h
         ADD  hl,hl
         LD   de,scraddrt
         ADD  hl,de
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         EX   de,hl
         ADD  hl,bc
         POP  de
         POP  bc
         POP  af
         RET  
;
addline
         PUSH af
         LD   a,8
         ADD  a,h
         JR   nc,addline1
         LD   a,#50
         ADD  a,l
         LD   l,a
         LD   a,#c8
         ADC  a,h
addline1
         OR   #c0
         LD   h,a
         POP  af
         RET  
;
addlnde
         PUSH af
         LD   a,8
         ADD  a,d
         JR   nc,addlnde1
         LD   a,#50
         ADD  a,e
         LD   e,a
         LD   a,#c8
         ADC  a,d
addlnde1
         OR   #c0
         LD   d,a
         POP  af
         RET  
setplay
         XOR  a
         CALL setmode
         LD   bc,#101
         CALL setbord
         LD   ix,inks
         XOR  a
setink1
         LD   b,(ix+0)
         LD   c,b
         PUSH af
         CALL setink
         POP  af
         INC  ix
         INC  a
         CP   16
         JR   nz,setink1
         RET  
;
setscrd
         LD   ix,scraddrt               ; Point To Screen Address Table
         LD   b,200                     ; Number Of Lines On The Screen
         LD   hl,#c000                  ; First Screen Address
setscrad
         LD   (ix+0),l
         LD   (ix+1),h
         INC  ix
         INC  ix
         CALL addline
         DJNZ setscrad
         RET  
load
         LD   hl,start-1
         LD   a,(hl)
         OR   a
         RET  nz
         LD   (hl),#ff
         LD   hl,name
         LD   b,len
         CALL #bc77
         LD   hl,sprites
         CALL #bc83
         JP   #bc7a
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
         LD   hl,#300
pu
         DEC  hl
         LD   a,h
         OR   l
         JR   nz,pu
         DI   
         CALL scrolmb
         LD   a,0
exitmes  EQU  $-1
         BIT  7,a
         JR   nz,exitkey1
         LD   a,27
exitkey  EQU  $-1
         CALL scankey
         JR   z,scrmess1
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
         LD   a,mboxw*4
dspace1
         PUSH af
         CALL framefly
         CALL scrolmb
         POP  af
         DEC  a
         JR   nz,dspace1
         RET  
scrolmb
         LD   hl,#c002
scrolmba EQU  $-2
         LD   d,5
scrolmb1
         PUSH hl
         LD   b,47
scrolmbl EQU  $-1
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
         LD   a," "
         CALL dmess1
         XOR  a
         LD   (messagep),a
         RET  
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
         SUB  15
         LD   d,0
         LD   h,d
         LD   e,a
         ADD  a,a
         LD   l,a
         ADD  hl,hl
         ADD  hl,de
         ADD  hl,hl
         LD   a,(messagep)
         BIT  1,a
         JR   z,dmess2
         LD   e,5
         ADD  hl,de
dmess2
         LD   de,0
txtchar  EQU  $-2
         ADD  hl,de
         EX   de,hl
         LD   hl,#c030
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
pnum                                    ; Print Decimal Number
         LD   d,100
         CALL pnum1
         LD   d,10
         CALL pnum1
         LD   d,1
pnum1
         LD   c,0
pnum2
         SUB  d
         INC  c
         JR   nc,pnum2
         ADD  a,d
         DEC  c
         PUSH af
         LD   a,#30
         ADD  a,c
         PUSH de
         CALL text
         POP  de
         POP  af
         RET  
print                                   ; Print Text
         LD   a,(hl)
         INC  hl
         OR   a
         RET  z
         PUSH hl
         CALL text
         POP  hl
         JR   print
tcolour
         ADD  a,17
         LD   e,a
         XOR  a
         LD   (messagep),a
         LD   d,0
         LD   hl,einktble
         ADD  hl,de
         LD   a,(hl)
         LD   (lcolmask),a
         RET  
locate                                  ; Equivalent To Print Locate !
         CALL calcaddr                  ; Entry L=Y, C=X
         LD   (textaddr),hl
         RET  
text                                    ; Display Text On Screen !
         SUB  17
         JR   c,tcolour
         SUB  15
         LD   de,0
textch1  EQU  $-2
;
         LD   c,a
         LD   b,0
         LD   h,b
         ADD  a,a                       ; A*2
         LD   l,a
         ADD  hl,hl
         ADD  hl,bc
         ADD  hl,hl                     ; HL = A*10 !!!
;
         ADD  hl,de                     ; HL Now Points To Address Of Character
         LD   de,#c000                  ; Location To Dump Text
textaddr EQU  $-2
         LD   b,5                       ; 5 Iterations Make 1 Character !
         LD   a,(lcolmask)
         LD   c,a                       ; C = Colour To Mask Characters
         PUSH de
text1
         LD   a,(hl)
         AND  c
         LD   (de),a
         INC  hl
         INC  hl
         INC  hl
         INC  hl
         INC  hl
         INC  de
         LD   a,(hl)
         AND  c
         LD   (de),a
         DEC  hl
         DEC  hl
         DEC  hl
         DEC  hl
         DEC  de
         LD   a,8
         ADD  a,d
         JR   nc,text2
         LD   a,#50
         ADD  a,e
         LD   e,a
         LD   a,#c8
         ADC  a,d
text2
         OR   #c0
         LD   d,a
         DJNZ text1
         POP  hl
         INC  hl
         INC  hl
         SET  7,h
         SET  6,h
         LD   (textaddr),hl
         RET  
;
einktble
         DEFB 0,#c0,#c,#cc,#30,#f0,#3c
         DEFB #fc,3,#c3,15,#cf,#33,#f3
         DEFB #3f,#ff
;
;
name
         DEFM TETRIS.SPR
len      EQU  $-name
;
bscraddr                                ; Block Physical Screen Address
         DEFW #c000
;
piece    DEFB 0                         ; What Piece Is In Use
next     DEFB 6                         ; Next Piece
rot      DEFB 0                         ; What Rotation Is Used.
bloktble                                ; Table Of Addressess For Block Types
;
         DEFW bl1a,bl1b,bl1c,bl1d
         DEFW bl2a,bl2b,bl2c,bl2d
         DEFW bl3a,bl3b,bl3c,bl3d
         DEFW bl4,bl4,bl4,bl4
         DEFW bl5a,bl5b,bl5c,bl5d
         DEFW bl6a,bl6b,bl6c,bl6d
         DEFW bl7a,bl7b,bl7c,bl7d
;
bl1a                                    ; Block Descriptions : Height,Width,Col
         DEFB 3,2
         DEFB 1,1,1
         DEFB 0,1,0
bl1b
         DEFB 3,3
         DEFB 0,0,1
         DEFB 0,1,1
         DEFB 0,0,1
bl1c
         DEFB 3,3
         DEFB 0,0,0
         DEFB 0,1,0
         DEFB 1,1,1
bl1d
         DEFB 2,3
         DEFB 1,0
         DEFB 1,1
         DEFB 1,0
;
bl2a
         DEFB 3,2
         DEFB 2,2,2
         DEFB 2,0,0
bl2b
         DEFB 3,3
         DEFB 0,2,2
         DEFB 0,0,2
         DEFB 0,0,2
bl2c
         DEFB 3,3
         DEFB 0,0,0
         DEFB 0,0,2
         DEFB 2,2,2
bl2d
         DEFB 2,3
         DEFB 2,0
         DEFB 2,0
         DEFB 2,2
bl3a
         DEFB 3,2
         DEFB 3,3,3
         DEFB 0,0,3
bl3b
         DEFB 3,3
         DEFB 0,0,3
         DEFB 0,0,3
         DEFB 0,3,3
bl3c
         DEFB 3,3
         DEFB 0,0,0
         DEFB 3,0,0
         DEFB 3,3,3
bl3d
         DEFB 2,3
         DEFB 3,3
         DEFB 3,0
         DEFB 3,0
bl4
         DEFB 2,2
         DEFB 4,4
         DEFB 4,4
bl5a
         DEFB 3,2
         DEFB 0,5,5
         DEFB 5,5,0
bl5b
         DEFB 3,3
         DEFB 0,5,0
         DEFB 0,5,5
         DEFB 0,0,5
bl5c
         DEFB 3,3
         DEFB 0,0,0
         DEFB 0,5,5
         DEFB 5,5,0
bl5d
         DEFB 2,3
         DEFB 5,0
         DEFB 5,5
         DEFB 0,5
bl6a
         DEFB 3,2
         DEFB 6,6,0
         DEFB 0,6,6
bl6b
         DEFB 3,3
         DEFB 0,0,6
         DEFB 0,6,6
         DEFB 0,6,0
bl6c
         DEFB 3,3
         DEFB 0,0,0
         DEFB 6,6,0
         DEFB 0,6,6
bl6d
         DEFB 2,3
         DEFB 0,6
         DEFB 6,6
         DEFB 6,0
bl7a
         DEFB 4,1
         DEFB 7,7,7,7
bl7b
         DEFB 2,4
         DEFB 0,7
         DEFB 0,7
         DEFB 0,7
         DEFB 0,7
bl7c
         DEFB 4,1
         DEFB 7,7,7,7
bl7d
         DEFB 3,4
         DEFB 0,0,7
         DEFB 0,0,7
         DEFB 0,0,7
         DEFB 0,0,7
inks
         DEFB 0,26,3,25,1,24,18,19
         DEFB 13,2,14,16,8,7,15,6
scraddrt                                ; Table Of Screen Addressess
         DEFS 400,#c0
blast    DEFB 0
nfulline DEFW 0
npieces  DEFS 14,0                      ; Number Of Blocks
play1x   DEFB 0                         ; Player 1 X Co-ord
play1y   DEFB 0                         ; Player 1 Y Co-ord
shapehw  DEFW 0                         ; Shapes Height And Width
shapead  DEFW 0                         ; Location Of Shape
keyc1    DEFB ptime
keyc2    DEFB ptime
keyc3    DEFB ptime
keyc4    DEFB ptime
keyc5    DEFB ptime
gtimer   DEFW 10
resett   DEFW 50
         DEFS 12,#ff
playgrid                                ; Playing Table
         DEFS 12*21,#ff
;
welcome  DEFB 5,32,32
         DEFM TETRIS WRITTEN BY 
         DEFM JASON BROO
         DEFM KS 1987
         DEFM ...  
         DEFB 0
         DEFB #ff
spaces   DEFS 30,32
