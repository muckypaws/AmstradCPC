;
         ORG  #7000
         ENT  $
char     EQU  #bb09
output   EQU  #bb5a
enable   EQU  #bb66
cursor   EQU  #bb75
pens     EQU  #bb90
paper    EQU  #bb96
initial  EQU  #bbff
mode     EQU  #bc0e
ink      EQU  #bc32
border   EQU  #bc38
position EQU  #bc1d
flyback  EQU  #bd19
stixsize EQU  #0805
         ORG  #9000
init
         CALL initial
         XOR  a
         LD   hl,inks
setinks
         LD   b,(hl)
         INC  hl
         LD   c,(hl)
         INC  hl
         PUSH af
         PUSH hl
         CALL ink
         POP  hl
         POP  af
         INC  a
         CP   16
         JR   nz,setinks
         LD   bc,#0404
         CALL border
         LD   hl,start
         LD   de,hlplayer
         LD   bc,start-hlplayer
         LDIR 
gameloop
         LD   hl,start
         LD   de,hlplayer
         LD   bc,score-hlplayer
         LDIR 
         CALL rndpos
         XOR  a
         CALL mode
         LD   hl,#0107
         CALL cursor
         LD   hl,#c190
         LD   c,4
         CALL magenta
         CALL horedge
         CALL vertside
         CALL horedge
         LD   c,3
         CALL magenta
         LD   hl,0
         LD   de,#1304
         CALL enable
         LD   a,3
         CALL pens
         LD   a,2
         CALL paper
         LD   hl,screen
         CALL print
         CALL printsc
         LD   hl,#0704
         CALL cursor
         LD   a,(lives)
         ADD  a,#30
         CALL output
levell
         XOR  a
         LD   (old),a
         LD   hl,start
         LD   de,hlplayer
         LD   bc,percent-hlplayer
         LDIR 
         LD   hl,#1002
         CALL cursor
         LD   hl,timer
         CALL print
         LD   bc,stixsize
         LD   de,(stixaddr)
         LD   hl,(stixpic)
         CALL drawbl
         LD   bc,(startc)
         LD   hl,(starthl)
         LD   (cplayer),bc
         LD   (hlplayer),hl
         LD   a,#3c
         CALL absolute
         LD   a,#c0
         LD   (trail),a
         LD   (pen),a
         CALL rndvel
framel
         CALL flyback
         LD   bc,stixsize
         LD   de,(stixaddr)
         LD   hl,(stixpic)
         CALL drawbl
         LD   a,(mip)
         OR   a
         JR   nz,domip
         CALL joystick
         LD   (old),a
         OR   a
         JR   nz,next
         LD   a,(old)
next
         LD   hl,(playerm)
         CALL jphl
         JR   nc,nomove
domip
         OR   a
         DEC  a
         LD   (mip),a
         LD   hl,(chkrout)
         CALL z,jphl
         JR   c,nomove
         LD   bc,(cplayer)
         LD   hl,(hlplayer)
         LD   a,(pen)
         CALL absolute
         LD   de,(relrout)
         CALL jpde
         LD   (cplayer),bc
         LD   (hlplayer),hl
         LD   a,#3c
         CALL absolute
         LD   a,(trail)
         LD   (pen),a
nomove
         LD   a,(xstix)
         LD   hl,xvel
         ADD  a,(hl)
         PUSH af
         BIT  7,(hl)
         JR   nz,xcol1
         ADD  a,7
xcol1
         LD   d,0
         LD   e,a
         LD   hl,(ystix)
         CALL position
         LD   b,8
         LD   de,retadd
xcol2
         CALL relative
         JR   nz,xcol3
         LD   de,linedown
         DJNZ xcol2
         SCF  
xcol3
         POP  bc
         JR   c,nobx
         CP   5
         JP   z,death
         LD   a,(xvel)
         NEG  
         LD   (xvel),a
         LD   a,(xstix)
         LD   b,a
nobx
         LD   a,b
         LD   (xstix),a
         LD   a,(ystix)
         LD   hl,yvel
         ADD  a,(hl)
         PUSH af
         BIT  7,(hl)
         JR   z,ycol1
         SUB  7
ycol1
         LD   h,0
         LD   l,a
         LD   de,(xstix)
         CALL position
         LD   b,8
         LD   de,retadd
ycol2
         CALL relative
         JR   nz,ycol3
         LD   de,right
         DJNZ ycol2
         SCF  
ycol3
         POP  bc
         JR   c,noby
         CP   5
         JP   z,death
         LD   a,(yvel)
         NEG  
         LD   (yvel),a
         LD   a,(ystix)
         LD   b,a
noby
         LD   a,b
         LD   (ystix),a
         LD   l,a
         LD   h,0
         LD   de,(xstix)
         CALL position
         LD   (stixaddr),hl
         EX   de,hl
         LD   hl,#1002
         CALL cursor
         LD   hl,frames
         DEC  (hl)
         JR   nz,drawstix
         LD   (hl),50
         INC  hl
         LD   a,(hl)
         SUB  1
         DAA  
         LD   (hl),a
         PUSH af
         LD   b,1
         CALL printbcd
         POP  af
         JR   z,death
drawstix
         LD   bc,stixsize
         LD   hl,stixpic1
         LD   a,(xstix)
         AND  1
         JR   z,ds1
         LD   hl,stixpic2
ds1
         LD   (stixpic),hl
         CALL drawbl
         CALL chgvel
         LD   a,(blockd)
         OR   a
         CALL nz,fillb
readkeys
         CALL char
         JR   nc,noquit
         CP   #fc
         RET  z
noquit
         LD   a,(percent)
         CP   #75
         JP   c,framel
         JP   message
death
         LD   b,10
d1
         PUSH bc
         CALL flyback
         LD   bc,#0606
         CALL border
         CALL flyback
         LD   bc,#0404
         CALL border
         POP  bc
         DJNZ d1
         LD   hl,#0704
         CALL cursor
         LD   a,(lives)
         DEC  a
         LD   (lives),a
         JP   z,init
         ADD  a,#30
         CALL output
         CALL chg5to0
         LD   bc,(cplayer)
         LD   hl,(hlplayer)
         LD   a,0
         CALL absolute
         JP   levell
printsc
         LD   hl,#0902
         CALL cursor
         LD   hl,score
         LD   b,3
printbcd
         LD   a,#30
pb1
         RLD  
         CALL output
         RLD  
         CALL output
         RLD  
         INC  hl
         DJNZ pb1
         RET  
drawbl
         PUSH bc
         PUSH de
db0
         LD   a,(de)
         XOR  (hl)
         LD   (de),a
         INC  hl
         INC  de
         DEC  c
         JR   nz,db0
         POP  de
         EX   de,hl
         LD   bc,2048
         ADD  hl,bc
         JR   nc,db1
         LD   bc,#c050
         ADD  hl,bc
db1
         EX   de,hl
         POP  bc
         DJNZ drawbl
         RET  
print
         LD   a,(hl)
         INC  hl
         OR   a
         RET  z
         CALL output
         JR   print
magenta
         LD   b,80
         PUSH hl
m1
         LD   (hl),#30
         INC  hl
         DJNZ m1
         POP  hl
         CALL linedown
         DEC  c
         JR   nz,magenta
         RET  
horedge
         PUSH hl
         LD   (hl),#30
         INC  hl
         LD   b,77
he1
         LD   (hl),#c0
         INC  hl
         DJNZ he1
         LD   (hl),#90
         INC  hl
         LD   (hl),#30
         POP  hl
         CALL linedown
         RET  
vertside
         LD   b,151
vs1
         PUSH hl
         LD   (hl),#30
         INC  hl
         LD   (hl),#80
         LD   de,77
         ADD  hl,de
         LD   (hl),#90
         INC  hl
         LD   (hl),#30
         POP  hl
         CALL linedown
         DJNZ vs1
         RET  
jphl
         JP   (hl)
jpde
         PUSH de
         RET  
pmove1
         CALL pmovec
         RET  nz
         LD   (relrout),de
         PUSH de
         CALL relative
         POP  de
         CP   2
         RET  nc
         CALL relative
         CP   2
         RET  nc
         DEC  a
         JR   z,onedge
         LD   bc,(cplayer)
         LD   hl,(hlplayer)
         LD   (startc),bc
         LD   (starthl),hl
         LD   hl,pmove2
         LD   (playerm),hl
         LD   hl,checkd
         LD   (chkrout),hl
         LD   a,#f0
         LD   (trail),a
onedge
         LD   a,2
         SCF  
         RET  
pmove2
         CALL pmovec
         RET  nz
         LD   (relrout),de
         LD   a,b
         LD   (blockf),a
         PUSH de
         CALL relative
         POP  de
         CP   2
         RET  nc
         CALL relative
         CP   2
         RET  nc
         LD   a,2
         RET  
pmovec
         LD   bc,(cplayer)
         LD   hl,(hlplayer)
         LD   b,1
         LD   de,lineup
         CP   1
         RET  z
         LD   de,linedown
         CP   2
         RET  z
         LD   b,2
         LD   de,left
         CP   4
         RET  z
         LD   de,right
         XOR  8
         RET  
checkd
         LD   bc,(cplayer)
         LD   hl,(hlplayer)
         LD   de,(relrout)
         CALL relative
         DEC  a
         OR   a
         RET  nz
         LD   a,(blockf)
         LD   (blockd),a
         SCF  
retadd
         RET  
fillb
         LD   bc,(cplayer)
         LD   hl,(hlplayer)
         DEC  a
         JR   z,sidelr
         PUSH bc
         PUSH hl
         CALL linedown
         CALL findstix
         JR   c,filldone
         CALL chg7to0
         POP  hl
         POP  bc
         CALL lineup
         JR   find2
sidelr
         PUSH bc
         PUSH hl
         CALL left
         CALL findstix
         JR   c,filldone
         CALL chg7to0
         POP  hl
         POP  bc
         CALL right
find2
         CALL findstix
         PUSH hl
         PUSH hl
filldone
         POP  hl
         POP  hl
         LD   ix,0
         CALL chg7to2
         CALL chg5to1
         PUSH ix
         POP  hl
         LD   de,0
         LD   a,(pixels)
         LD   b,a
         XOR  a
doscore
         DJNZ dsc1
         ADD  a,1
         DAA  
         LD   b,231
dsc1
         SCF  
         SBC  hl,de
         JR   nz,doscore
         PUSH af
         LD   hl,score+2
         ADD  a,(hl)
         DAA  
         LD   (hl),a
         LD   a,0
         DEC  hl
         ADC  a,(hl)
         DAA  
         LD   (hl),a
         LD   a,0
         DEC  hl
         ADC  a,(hl)
         DAA  
         LD   (hl),a
         LD   a,b
         LD   (pixels),a
         CALL printsc
         LD   hl,#1004
         CALL cursor
         POP  af
         LD   hl,percent
         ADD  a,(hl)
         DAA  
         LD   (hl),a
         LD   b,1
         CALL printbcd
         LD   hl,pmove1
         LD   (playerm),hl
         LD   hl,retadd
         LD   (chkrout),hl
         XOR  a
         LD   (blockd),a
         LD   (mip),a
         LD   a,#c0
         LD   (trail),a
         LD   (pen),a
         LD   bc,(cplayer)
         LD   hl,(hlplayer)
         CALL absolute
         LD   de,(relrout)
         CALL jpde
         LD   (cplayer),bc
         LD   (hlplayer),hl
         LD   (startc),bc
         LD   (starthl),hl
         LD   a,#3c
         JP   absolute
chg7to0
@
         LD   hl,#e991
         LD   c,151
chg70a
         LD   b,77
         PUSH hl
chg70b
         LD   a,(hl)
         LD   d,a
         AND  #aa
         CP   #a8
         LD   a,d
         JR   nz,chg70c
         AND  #55
         LD   d,a
chg70c
         AND  #55
         CP   #54
         LD   a,d
         JR   nz,chg70d
         AND  #aa
chg70d
         LD   (hl),a
         INC  hl
         DJNZ chg70b
         POP  hl
         CALL linedown
         DEC  c
         JR   nz,chg70a
@
         RET  
chg7to2
         LD   hl,#e991
         LD   c,151
chg72a
         LD   b,77
         PUSH hl
chg72b
         LD   a,(hl)
         LD   d,a
         AND  #aa
         CP   #a8
         LD   a,d
         JR   nz,chg72c
         AND  #5d
         LD   d,a
         INC  ix
chg72c
         AND  #55
         CP   #54
         LD   a,d
         JR   nz,chg72d
         AND  #ae
         INC  ix
chg72d
         LD   (hl),a
         INC  hl
         DJNZ chg72b
         POP  hl
         CALL linedown
         DEC  c
         JR   nz,chg72a
         RET  
chg5to1
         LD   hl,#e991
         LD   c,151
chg52a
         LD   b,77
         PUSH hl
chg52b
         LD   a,(hl)
         LD   d,a
         AND  #aa
         CP   #a0
         LD   a,d
         JR   nz,chg52c
         AND  #df
         LD   d,a
         INC  ix
chg52c
         AND  #55
         CP   #50
         LD   a,d
         JR   nz,chg52d
         AND  #ef
         INC  ix
chg52d
         LD   (hl),a
         INC  hl
         DJNZ chg52b
         POP  hl
         CALL linedown
         DEC  c
         JR   nz,chg52a
         RET  
chg5to0
         LD   hl,#e991
         LD   c,151
chg50a
         LD   b,77
         PUSH hl
chg50b
         LD   a,(hl)
         LD   d,a
         AND  #aa
         CP   #a0
         LD   a,d
         JR   nz,chg50c
         AND  #55
         LD   d,a
chg50c
         AND  #55
         CP   #50
         LD   a,d
         JR   nz,chg50d
         AND  #aa
chg50d
         LD   (hl),a
         INC  hl
         DJNZ chg50b
         POP  hl
         CALL linedown
         DEC  c
         JR   nz,chg50a
         RET  
rndpos
         CALL rnd
         LD   hl,#9304
         AND  #fe
         CALL arange
         JR   nc,rndpos
         LD   e,a
         LD   (xstix),a
rp1
         CALL rnd
         LD   hl,#960c
         CALL arange
         JR   nc,rp1
         LD   l,a
         LD   (ystix),a
         LD   d,0
         LD   h,0
         CALL position
         LD   (stixaddr),hl
         RET  
rndvel
         CALL rv1
         JR   rv2
chgvel
         CALL rnd
         CP   240
         RET  c
         CALL rnd
         RRCA 
         JR   c,rv2
rv1
         CALL velcom
         LD   (xvel),a
         RET  
rv2
         CALL velcom
         LD   (yvel),a
         RET  
velcom
         CALL rnd
         RRCA 
         SBC  a,a
         OR   1
         RET  
rnd
         LD   hl,rseed
         LD   a,r
         ADD  a,(hl)
         LD   (hl),a
         RET  
arange
         CP   h
         RET  nc
         CP   l
         CCF  
         RET  
findstix
         LD   iy,stack-1
         CALL pushuser
while1
         PUSH iy
         POP  hl
         LD   de,stack
         OR   a
         SBC  hl,de
         JP   c,wend1
         LD   h,(iy+0)
         DEC  iy
         LD   l,(iy+0)
         DEC  iy
         LD   c,(iy+0)
         DEC  iy
while2
         RRC  c
         JR   nc,w2a
         INC  hl
w2a
         LD   a,(hl)
         AND  c
         JR   z,while2
wend2
         BIT  7,c
         JR   nz,w2b
         RLCA 
w2b
         LD   de,4
w2c
         RRCA 
         RRCA 
         RL   d
         DEC  e
         JP   nz,w2c
         LD   a,d
         RRCA 
         RRCA 
         ADC  a,e
         RRCA 
         SBC  a,a
         AND  6
         XOR  d
         CP   7
         RET  nc
         RLC  c
         JR   nc,w2d
         DEC  hl
w2d
         LD   b,3
while3
         LD   a,(hl)
         AND  c
         JP   nz,wend3
         LD   a,#fc
         AND  c
         OR   (hl)
         LD   (hl),a
         PUSH hl
         CALL lineup
         LD   a,(hl)
         POP  hl
         AND  c
         JR   z,checktop
         SET  1,b
         JR   checkb
checktop
         BIT  1,b
         JR   z,checkb
         PUSH hl
         CALL lineup
         CALL pushuser
         POP  hl
         RES  1,b
checkb
         PUSH hl
         CALL linedown
         LD   a,(hl)
         POP  hl
         AND  c
         JR   z,checkbo
         SET  0,b
         JR   moveleft
checkbo
         BIT  0,b
         JR   z,moveleft
         PUSH hl
         CALL linedown
         CALL pushuser
         POP  hl
         RES  0,b
moveleft
         RLC  c
         JR   nc,ml1
         DEC  hl
ml1
         BIT  7,c
         JR   nz,ml2
         RLCA 
ml2
         LD   de,4
ml3
         RRCA 
         RRCA 
         RL   d
         DEC  e
         JP   nz,ml3
         LD   a,d
         RRCA 
         RRCA 
         ADC  a,e
         RRCA 
         SBC  a,a
         AND  6
         XOR  d
         CP   7
         RET  nc
         JP   while3
wend3
         JP   while1
wend1
         RET  
pushuser
         PUSH hl
         PUSH iy
         POP  hl
         LD   de,stack+256-3
         OR   a
         SBC  hl,de
         POP  hl
         RET  nc
         INC  iy
         LD   (iy+0),c
         INC  iy
         LD   (iy+0),l
         INC  iy
         LD   (iy+0),h
         RET  
lineup
         LD   de,#c800
         OR   a
         SBC  hl,de
         SET  7,h
         SET  6,h
         RET  nc
         LD   de,#4f
         SBC  hl,de
         RET  
linedown
         LD   de,#800
         ADD  hl,de
         RET  nc
         LD   de,#c050
         ADD  hl,de
         RET  
left
         RLC  c
         RET  nc
         DEC  hl
         RET  
right
         RRC  c
         RET  nc
         INC  hl
         RET  
relative
         CALL jpde
         LD   a,(hl)
         BIT  7,c
         JR   nz,gtr1
         RLCA 
gtr1
         LD   de,4
gtr2
         RRCA 
         RRCA 
         RL   d
         DEC  e
         JP   nz,gtr2
         LD   a,d
         RRCA 
         RRCA 
         ADC  a,e
         RRCA 
         SBC  a,a
         AND  6
         XOR  d
         RET  
absolute
         LD   b,a
         LD   a,(hl)
         XOR  b
         OR   c
         XOR  c
         XOR  b
         LD   (hl),a
         RET  
joystick
         LD   a,71
         CALL #bb1e
         JR   nz,left1
         LD   a,63
         CALL #bb1e
         JR   nz,right1
         LD   a,19
         CALL #bb1e
         JR   nz,up1
         LD   a,22
         CALL #bb1e
         JR   nz,down1
         LD   a,(old)
         RET  
left1
         LD   a,4
         RET  
right1
         LD   a,8
         RET  
up1
         LD   a,1
         RET  
down1
         LD   a,2
         RET  
message
         LD   a,12
         CALL #bb5a
         LD   hl,mssg
         CALL print
         LD   hl,percent
         LD   b,1
         CALL printbcd
         LD   hl,mssg1
         CALL print
         LD   b,0
pause
         CALL #bd19
         DJNZ pause
         JP   gameloop
hlplayer DEFW 0
cplayer  DEFW 0
newhlp   DEFW 0
         DEFW 0
pen      DEFB 0
trail    DEFB 0
blockf   DEFB 0
blockd   DEFB 0
playerm  DEFW 0
mip      DEFB 0
relrout  DEFW 0
chkrout  DEFW 0
frames   DEFB 0
seconds  DEFB 0
percent  DEFB 0
starthl  DEFW 0
startc   DEFW 0
score    DEFS 3,0
lives    DEFB 0
ystix    DEFW 0
xstix    DEFW 0
yvel     DEFB 0
xvel     DEFB 0
stixpic  DEFW 0
stixaddr DEFW 0
pixels   DEFB 0
start
         DEFW #e7a8
         DEFW #00aa
         DEFW 0
         DEFW 0
         DEFB #c0
         DEFB #c0
         DEFB 0,0
         DEFW pmove1
         DEFB 0
         DEFW retadd
         DEFW retadd
         DEFB 50
         DEFB #30
         DEFB 0
         DEFW #e7a8
         DEFW #00aa
         DEFS 3,0
         DEFB 9
         DEFW 0
         DEFW 0
         DEFB -1
         DEFB 1
         DEFW stixpic1
         DEFW 0
         DEFB 231
stixpic1
         DEFB 0,#82,#8a,#05,0,#8a,#82
         DEFB #8f,#a,0,#45,#cb,#0a,3,0
         DEFB #a
         DEFB #41,3,0,0,5,#b,#c7,#8a
         DEFB 0,3,#cb,#a,#45,0,#45,#41
         DEFB 7,#b,0,#8a,#82,#cb,5,0
stixpic2
         DEFB 0,#41,#45,0,#a,#45,#41
         DEFB #45
         DEFB #f,0,0,#cf,#87,1,2,5
         DEFB 0,#83,2,0,0,#f,#43,#cf
         DEFB 0,1,#47,#87,0,#8a,0,#8a
         DEFB #83,#f,2,#45,#41,#45,#82
         DEFB #a
screen   DEFB 12,31,2,2
         DEFM SCORE:
         DEFB 13,10,10
         DEFM LIVES:  FILLED 00 %
         DEFB 0
mssg
         DEFB 12,31,2,1,32,32
         DEFM CONGRATULATIONS !
         DEFB 13,10
         DEFM You Have completed.
         DEFB 31,5,5,0
mssg1
         DEFB 32
         DEFM Percent.
         DEFB 0
timer
         DEFM 30
         DEFB 0
inks     DEFB 0,0,24,24,6,6,20,20,4,4
         DEFB 24,24,0,26,0,0
         DEFB 20,20,18,18,2,2,6,6,0,0
         DEFB 0,0,0,0,0,0
stack    DEFS 256
rseed    DEFB #aa
old      DEFB 0
