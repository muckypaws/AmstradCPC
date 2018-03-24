;
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
         ORG  #8a00                     ; Mouse Control : Written By 
start                                   ; Jason Brooks 10/1/94
         ENT  $
         LD   a,r
         LD   (random),a
         CALL settable
         CALL loadspr
         LD   hl,sprites+30
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   hl,sprites+#100
         ADD  hl,de
         LD   (ALFA),hl                 ; Store Location Of Alfa Letters !
         XOR  a
         LD   (rasterc),a
         INC  a
         CALL #bc0e
         CALL #bb00
         CALL setinks
         LD   hl,ftb
         LD   b,#81
         LD   c,#ff
         LD   de,fastrout
         CALL #bd19
         CALL #bce0                     ; Enable Fast Ticker Event
;
newgame
         CALL putscr
         LD   h,GRIDY-15
         LD   l,GRIDX
         LD   de,TIMEM
         CALL plocalfa
         LD   hl,(alfaaddr)
         INC  hl
         INC  hl
         LD   (ptimen),hl
         CALL ptime
         LD   hl,STARTUP
         CALL restart
         DEC  hl
         LD   (messageb),hl
waitgame
         LD   a,60
         CALL #bb1e
         JR   nz,gameon
         LD   a,(rasterc)
         CP   2
         JR   nz,waitgame
         CALL scroll
         CALL smessage
         JR   waitgame
gameon
         CALL showit
         XOR  a
         LD   l,a
         LD   h,l
         LD   (buttont),hl
         LD   (time),hl
         LD   (time+2),hl
         LD   a,(MAXFLAGS)
         LD   (FLAGS),a
         CALL clgrid
         CALL drawgrid
         CALL setgrid
         CALL ptime
         CALL showit
gameloop
         CALL inctime
         CALL flashdot
         CALL double
;CALL ptime
         LD   a,(msey)
         LD   l,a
         LD   de,(msex)
         CALL calcaddr
         CALL raster
         CALL restoreb                  ; Delete Mouse
         XOR  a
         LD   (accelf),a
         CALL keys                      ; Update Mouse Keyboard ?
         CALL c,pbut
         CALL joystick                  ; Update Mouse Joystick ?
         CALL faster                    ; Move Mouse Faster ?
         CALL showit                    ; Show Mouse
         CALL endgame
         JP   nc,newgame
         LD   a,6
         CALL #bb1e
         JR   z,gameloop
quit
         LD   hl,ftb
         CALL #bce6                     ; Disable Fast Ticker Event
         CALL flush
         RET  
endgame
         LD   a,(maxgy)
         INC  a
         LD   e,a
         LD   a,(maxgx)
         INC  a
         CALL multiply
         EX   de,hl
         LD   hl,gamegrid
endgame1
         LD   a,(hl)
         OR   a
         JR   z,endgame2
         CP   BOMB
         JR   z,endgame2
         INC  hl
         DEC  de
         LD   a,e
         OR   d
         JR   nz,endgame1
         AND  a
         SCF  
endgame2
         CCF  
         RET  
fastrout
         DI   
         PUSH hl
         LD   hl,rasterc
         INC  (hl)
         LD   a,(hl)
         SUB  6
         JR   c,fastr2
         LD   (hl),a
fastr1
         LD   hl,fifty
         INC  (hl)
         LD   a,(hl)
         SUB  50
         JR   c,fastr2
         LD   (hl),a
fastr2
         POP  hl
         EI   
         RET  
setinks
         LD   ix,colours
         XOR  a
setink1
         PUSH af
         LD   b,(ix+0)
         LD   c,b
         CALL #bc32
         POP  af
         INC  a
         INC  ix
         CP   4
         JR   c,setink1
         RET  
drawflag
         CALL whichbut
         BIT  7,h
         RET  nz
         PUSH hl
         LD   de,gamegrid
         ADD  hl,de
         LD   b,(hl)                    ; Get Sprite Number
         BIT  6,b
         JR   nz,resetfl
         LD   a,(FLAGS)
         OR   a
         JR   z,drawfl1
         DEC  a
         LD   (FLAGS),a
         SET  6,b
drawfl1
         LD   (hl),b
         LD   a,b
         POP  hl
         CALL pbutfl
drawfl2
         LD   a,21
         CALL #bb1e
         JR   nz,drawfl2
         RET  
resetfl
         RES  6,b
         LD   a,(FLAGS)
         INC  a
         LD   (FLAGS),a
         JR   drawfl1
;
resetflx
         POP  af
         RET  
pbut
         CALL whichbut
         BIT  7,h
         RET  nz
         PUSH hl
         LD   de,gamegrid
         ADD  hl,de
         LD   a,(hl)                    ; Get Sprite Number
         OR   a
         JR   nz,pbut1
         LD   a,1
pbut1
         LD   (hl),a
         POP  hl
pbutfl
         PUSH af
         LD   a,(maxgy)
         INC  a
         CALL divide
         LD   h,l                       ; H = Y, A = X
pbutsp
         ADD  a,a
         ADD  a,GRIDX
         LD   l,a
         LD   a,h
         ADD  a,a
         ADD  a,a
         ADD  a,a
         ADD  a,GRIDY
         LD   h,a
         LD   bc,#208
         POP  af
         JP   drawsprc
fblanks                                 ; Fill In All Blank Squares
         CALL whichbut
         BIT  7,h
         RET  nz
         PUSH hl
         LD   de,gamegrid
         ADD  hl,de
         LD   a,(hl)                    ; Get Sprite Number
         CP   2
         POP  hl
         RET  nc                        ; Quit If Not Blank Square
         LD   a,(maxgy)
         INC  a
         CALL divide
         CALL rstack                    ; Reset Stack Pointers
         LD   h,l
         LD   l,a                       ; Calculate X, Y Co-ordinates
         CALL pushstak                  ; Push X, Y onto Stack
         CALL leftfill
         CALL flush
flush
         CALL #bb09
         JR   c,flush
         RET  
leftfill
         XOR  a
         LD   (upflag),a
         LD   (downflag),a
         CALL popstak                   ; Get HL Off Stack
         RET  c                         ; Quit If No More On Stack !
leftf1
         PUSH hl
leftf2
         PUSH hl
         CALL cblock
         SUB  2
         JR   nc,leftout                ; Wall
         LD   (hl),FILLFLAG             ; Set Open Flag
         POP  hl
         PUSH hl
         CALL showfill
         POP  hl
         CALL checkup
         CALL checkdwn
         DEC  l
         BIT  7,l
         JR   z,leftf2                  ; Still O.K.
leftf3
         XOR  a
         LD   (upflag),a
         LD   (downflag),a
         POP  hl                        ; Get Original Co-Ordinates
rightf2
         INC  l
         LD   a,(maxgx)
         SUB  l
         JR   c,rightf3                 ; Still O.K.
;
         PUSH hl
         CALL cblock
         SUB  2
         JR   nc,rightout               ; Wall
         LD   (hl),FILLFLAG             ; Set Open Flag
         POP  hl
         PUSH hl
         CALL showfill
         POP  hl
         CALL checkup
         CALL checkdwn
         JR   rightf2
rightf3
         XOR  a
         LD   (upflag),a
         LD   (downflag),a
         JR   leftfill
rightout
         POP  hl
         PUSH hl
         ADD  a,2
         CALL showfil1
         POP  hl
         JR   rightf3
leftout
         POP  hl
         PUSH hl
         ADD  a,2
         CALL showfil1
         POP  hl
         JR   leftf3
showfill
         LD   a,FILLFLAG
showfil1
         PUSH af
;PUSH hl
;LD   hl,#1405
;CALL #bb75
;POP  hl
;CALL printhl
         LD   a,l
         JP   pbutsp
checkup                                 ; Is There A Gap Above ?
         PUSH hl
         DEC  h
         BIT  7,h
         JR   nz,checkout
         PUSH hl
         CALL cblock
         POP  hl
         SUB  2
         JR   nc,checkupl               ; Put Last Co-Ordinates Onto Block
         LD   a,(upflag)
         OR   a
         JR   nz,checkout
         PUSH hl
         CALL pushstak
         POP  hl
         LD   a,1
         LD   (upflag),a
checkout
         POP  hl
         RET  
checkupl                                ; Add New Co-Ordinate To Stack
         ADD  a,2
         CALL showfil1
         XOR  a
         LD   (upflag),a
         JR   checkout
checkdwn
         PUSH hl
         INC  h
         LD   a,(maxgy)
         SUB  h
         JR   c,checkout
         PUSH hl
         CALL cblock
         POP  hl
         SUB  2
         JR   nc,checkdl                ; Put Last Co-Ordinates Onto Block
         LD   a,(downflag)
         OR   a
         JR   nz,checkout
         PUSH hl
         CALL pushstak
         POP  hl
         LD   a,1
checkd5
         LD   (downflag),a
         POP  hl
         RET  
checkdl
         ADD  a,2
         CALL showfil1
         XOR  a
         JR   checkd5
rstack                                  ; Reset Stack Pointers
         PUSH hl
         LD   hl,0
         LD   (STACKCNT),hl
         LD   hl,STACK
         LD   (STACKPT),hl
         POP  hl
         RET  
popstak                                 ; Get A Value Off The Stack !
         LD   hl,(STACKCNT)
;PUSH hl
;LD   hl,#1402
;CALL #bb75
;POP  hl
;CALL printhl
         LD   a,h
         OR   l
         SCF  
         RET  z                         ; Nothing On The Stack !
         DEC  hl
         LD   (STACKCNT),hl
         LD   hl,(STACKPT)
         DEC  hl
         LD   d,(hl)
         DEC  hl
         LD   e,(hl)
         LD   (STACKPT),hl
         EX   de,hl
         AND  a
         RET                            ; POP INTO HL 
pushstak                                ; push HL onto Stack
         EX   de,hl
         LD   hl,(STACKCNT)
         LD   bc,STACKMAX
         AND  a
         SBC  hl,bc
         RET  nc                        ; Quit If No More Room
         EX   de,hl
         CALL validate
         RET  c
         EX   de,hl
;
         LD   hl,(STACKPT)
         LD   (hl),e
         INC  hl
         LD   (hl),d
         INC  hl
         LD   (STACKPT),hl
         LD   hl,(STACKCNT)
         INC  hl
         LD   (STACKCNT),hl
;PUSH hl
;LD   hl,#1402
;CALL #bb75
;POP  hl
;CALL printhl
;
         RET  
validate                                ; Are Co-Ordinates Valid ? C = ok NC = 
         LD   a,(maxgy)
         SUB  h
         RET  c
         LD   a,(maxgx)
         INC  a
         SUB  l
         RET  
printhl1
         LD   a,13
         CALL #bb5a
         LD   a,10
         CALL #bb5a
printhl
         LD   a,h
         CALL hex
         LD   a,l
hex
         PUSH af
         RRCA 
         RRCA 
         RRCA 
         RRCA 
         CALL hex1
         POP  af
hex1
         AND  15
         CP   10
         JR   c,hex2
         ADD  a,7
hex2
         ADD  a,#30
         JP   #bb5a
setgrid
         LD   a,(nobombs)               ; Get Number Of Bombs
         LD   b,a
setgrida
         PUSH bc
setgrids
         LD   a,18
         CALL #bb1e
         RET  nz
         CALL getrand                   ; Get A Random Number
         LD   l,a
         LD   h,0                       ; Place In HL
         LD   a,(maxgx)
         INC  a                         ; Get Grid Width
         CALL divide                    ; Divide So remainder Free
         LD   e,a                       ; Store Remainder In E
;
         PUSH de                        ; Preserve DE
         CALL getrand                   ; Get Another Random Number
;ADD  a,5
         LD   l,a
         LD   h,0                       ; Store In HL
         LD   a,(maxgy)                 ; Get Grid Height
         INC  a
         CALL divide                    ; Get Remainder (Modulus !)
         POP  de                        ; Get Back DE
         LD   d,a                       ; Place Y In D
;
         PUSH de
         LD   h,a                       ; Put Y In H
         LD   l,e                       ; Put X in E
         CALL chekvic
         POP  de
         JR   nc,setgrids
         PUSH de
         POP  hl
;CALL printhl1
         PUSH de
         LD   a,(maxgy)
         INC  a
         LD   e,a
         LD   a,d                       ; A = Y
         CALL multiply                  ; Multiply A by E
         POP  de
         LD   d,0
         ADD  hl,de
         LD   de,gamegrid
         ADD  hl,de                     ; Point HL To Grid
         LD   a,(hl)
         OR   a                         ; Check If Bomb Exists
         JR   nz,setgrids               ; If So, Select Another Point.
         LD   (hl),BOMB
         POP  bc
         DJNZ setgrida
workbomb                                ; Work Out Bomb Numbers On Squares
         LD   hl,0                      ; Reset Co-Ordinate : H = Y, L = X
         LD   a,(maxgy)
         INC  a
         LD   c,a
workb0
         LD   a,(maxgx)
         INC  a
         LD   b,a
         LD   l,0
workb1
         PUSH bc
         PUSH hl
         CALL cblock
         CP   BOMB
         JR   z,workb2
         POP  de
         PUSH de
         PUSH hl
         EX   de,hl
         CALL bombcnt
         LD   a,d
         OR   a
         JR   z,workb3
         LD   a,4
         ADD  a,d
workb3
         POP  hl
         LD   (hl),a
workb2
         POP  hl
         POP  bc
         INC  l
         DJNZ workb1
         INC  h
         DEC  c
         JR   nz,workb0
         RET  
cblock                                  ; Calculate Which Block
         PUSH hl
         LD   a,(maxgy)
         INC  a
         LD   e,a
         LD   a,h
         CALL multiply
         POP  de
         LD   d,0
         ADD  hl,de
         LD   de,gamegrid
         ADD  hl,de
         LD   a,(hl)
         RET                            ; Exit HL = Grid Location.
check
         PUSH af
         PUSH hl
         LD   l,d
         LD   h,a
         CALL printhl
         POP  hl
         POP  af
         RET  
chekvic
         CALL chekvic4
         RET  nc
         DEC  h
;
         CALL chekvic4
         RET  nc
         INC  l
;
         CALL chekvic4
         RET  nc
         INC  h
;
         CALL chekvic4
         RET  nc
         INC  h
;
         CALL chekvic4
         RET  nc
         INC  h
;
         CALL chekvic4
         RET  nc
         DEC  l
;
         CALL chekvic4
         RET  nc
         DEC  l
;
         CALL chekvic4
         RET  nc
         DEC  h
;
         CALL chekvic4
         RET  nc
         DEC  h
chekvic4
         PUSH hl
         CALL bombcnt                   ; Count Bombs In Area
         LD   a,d                       ; A = Number Of Bombs
         POP  hl
         CP   MAXBOMBS
         RET  
;
multiply                                ; Entry : E, A = Multiplicands  HL=RESU
         PUSH bc
         PUSH de
         LD   hl,0
         LD   d,l
         LD   b,8
mult1
         ADD  hl,hl
         RLA  
         JR   nc,mult2
         ADD  hl,de
mult2
         DJNZ mult1
         POP  de
         POP  bc
         RET  
;
divide                                  ; Entry : HL = Dividend, A = Divisor
         PUSH bc
         LD   c,a
         XOR  a
         LD   b,16
divide1
         ADD  hl,hl
         RLA  
         CP   c
         JR   c,divide2
         SUB  c
         INC  l
divide2
         DJNZ divide1
         POP  bc
         RET                            ; Exit HL = Result, A = Remainder
;
bombcnt                                 ; Count Number Of Bombs From Position
         LD   a,(maxgx)
         CP   l
         RET  c
         LD   a,(maxgy)
         CP   h
         RET  c
         LD   d,0
         DEC  h
         CALL cgpos
         INC  l
         CALL cgpos
         INC  h
         CALL cgpos
         INC  h
         CALL cgpos
         DEC  l
         CALL cgpos
         DEC  l
         CALL cgpos
         DEC  h
         CALL cgpos
         DEC  h
         CALL cgpos
         LD   a,d
         RET  
cgpos                                   ; Calculate Grid Position
         BIT  7,h
         JR   nz,poserror               ; Check If Within Grid
         BIT  7,l
         JR   nz,poserror
         LD   a,(maxgx)
         CP   l
         JR   c,poserror
         LD   a,(maxgy)
         CP   h
         JR   c,poserror
         PUSH de
         PUSH hl
         PUSH hl
         LD   e,h
         LD   a,(maxgx)
         INC  a
         CALL multiply
         LD   de,gamegrid
         ADD  hl,de                     ; Calculate Position In Grid
         POP  de
         LD   d,0
         ADD  hl,de
         EX   de,hl
         POP  hl
         LD   a,(de)
         POP  de
         OR   a
         RET  z
         CP   14
         RET  nz
         INC  d                         ; Increment Bomb Count
         RET  
poserror                                ; Position Error
         LD   a,#ff
         SCF  
         RET  
settable
         LD   a,(tableset)
         OR   a
         RET  nz
         DEC  a
         LD   (tableset),a
         LD   hl,table
         XOR  a
         LD   b,2
sett1
         LD   (hl),a
         INC  hl
         INC  a
         JR   nz,sett1
         DEC  a
sett2
         LD   (hl),a
         INC  hl
         DEC  a
         JR   nz,sett2
         LD   hl,table
         LD   (tablea),hl
         CALL seta
         LD   hl,table+256
         LD   (tablea),hl
         CALL seta
         LD   hl,table+128
         LD   (tablea),hl
seta
         CALL settx
         CALL settx
settx
         LD   a,#ff
         LD   (maxlimit),a
sett3
         LD   a,(maxlimit)
         CP   2
         RET  c
;JR   c,sett4
         CALL randswap
         JR   sett3
getrand                                 ; Get A Random Number
         LD   a,(maxlimit)
         CP   2
         JR   nc,randswap
         LD   a,#ff
         LD   (maxlimit),a
         LD   a,(randoffs)
         INC  a
         LD   (randoffs),a
         LD   e,a
         LD   d,0
         LD   hl,table
         ADD  hl,de
         LD   (tablea),hl
randswap
         LD   hl,rs1
         INC  (hl)
         LD   a,r
         RRCA 
         ADD  a,0
rs1      EQU  $-1
         LD   l,a
         LD   h,0
         LD   a,(maxlimit)
         CALL divide                    ; A = Remainder Within Limit !
         LD   e,a
         LD   d,0
         LD   a,(maxlimit)
         DEC  a
         LD   (maxlimit),a
         LD   hl,(tablea)
         ADD  hl,de
         EX   de,hl
         LD   a,(maxlimit)
         LD   c,a
         LD   b,0
         LD   hl,(tablea)
         ADD  hl,bc
         LD   b,(hl)
         LD   a,(de)
         LD   (hl),a
         LD   a,b
         LD   (de),a
         RET  
getrandj                                ; Get Random Number
         PUSH bc
         PUSH de
         LD   hl,getrand1
         INC  (hl)
         LD   a,(random)
         RLCA 
         LD   c,a
         LD   a,r
         XOR  c
         LD   e,c
         CALL multiply
         XOR  l
         XOR  h
         RRA  
         ADD  a,0
getrand1 EQU  $-1
         POP  de
         POP  bc
         OR   a
         LD   (random),a
         RET  nz
         INC  a
         LD   (random),a
         DEC  a
         RET  
clgrid                                  ; Clear The Game Grid For A New Game
         LD   hl,gamegrid
         LD   de,gamegrid+1
         LD   bc,399
         LD   (hl),0
         LDIR 
         RET  
drawgrid
         CALL restoreb                  ; Hide Mouse
         LD   h,GRIDY
         LD   l,GRIDX
         LD   de,gamegrid
         LD   b,GRIDW
         LD   c,GRIDH
drawg1
         PUSH bc
         PUSH hl
drawg2
         LD   a,(de)
         PUSH bc
         PUSH de
         PUSH hl
         LD   bc,#208
         PUSH af
         PUSH bc
         PUSH de
         PUSH hl
         LD   bc,8
         LD   e,8
         CALL addbut
         POP  hl
         POP  de
         POP  bc
         POP  af
         CALL drawsprc
         POP  hl
         POP  de
         POP  bc
         INC  l
         INC  l
         INC  de
         DJNZ drawg2
         POP  hl
         LD   a,h
         ADD  a,8
         LD   h,a
         POP  bc
         DEC  c
         JR   nz,drawg1
         RET  
whichbut                                ; Which Button Is Pressed, If Any
         LD   bc,(buttont)
         LD   a,c
         OR   b
         RET  z                         ; Quit If No Buttons
         LD   a,(msey)
         INC  a
         LD   (wbuty),a
         LD   ix,buttons
;
isitthis
         PUSH bc
         LD   b,0
wbuty    EQU  $-1
         LD   a,(ix+4)
         SUB  b
         JR   nc,notthis
         LD   a,(ix+5)
         SUB  b
         JR   c,notthis
;
         LD   hl,(msex)
         LD   c,(ix+0)
         LD   b,(ix+1)
         AND  a
         SBC  hl,bc
         JR   c,notthis
         LD   hl,(msex)
         LD   c,(ix+2)
         LD   b,(ix+3)
         AND  a
         SBC  hl,bc
         JR   c,thisone
;
notthis
         LD   bc,6
         ADD  ix,bc
         POP  bc
         DEC  bc
         LD   a,b
         OR   c
         JR   nz,isitthis
         LD   hl,#ffff
         AND  a
         RET  
thisone
         LD   hl,(buttont)
         AND  a
         POP  bc
         SBC  hl,bc
         SCF  
         RET  
;
;  Add A Button, If Possible
;
; Entry
;
;    H = Y   (Hard Block - Screen X/4, Y/25) i.e. H = 1, Actual = 8 !
;    L = X   As Above Except * 4
;   BC = Width Of Button (Actual)
;    E = Height Of Button
;
addbut                                  ; Add A Button If Possible
         PUSH hl
         PUSH bc
         LD   hl,(buttont)
         LD   bc,maxbut
         AND  a
         SBC  hl,bc                     ; Have we Reached Maximum Yet ?
         POP  bc
         POP  hl
         RET  nc                        ; Quit If Have
         PUSH hl
         PUSH de
         LD   de,(buttont)
         LD   h,d
         LD   l,e
         ADD  hl,hl
         ADD  hl,de
         ADD  hl,hl                     ; Multiply By 6
         LD   de,buttons
         ADD  hl,de
         PUSH hl
         POP  ix                        ; Let IX=HL
         POP  de
         POP  hl
         LD   a,h
         LD   (ix+4),a                  ; Store Y1
         ADD  a,e
         LD   (ix+5),a                  ; Store Last Y
         LD   h,0
         ADD  hl,hl
         ADD  hl,hl                     ; Multiply X By 4
         LD   (ix+0),l
         LD   (ix+1),h
         ADD  hl,bc
         LD   (ix+2),l
         LD   (ix+3),h
         LD   hl,(buttont)
         INC  hl
         LD   (buttont),hl
         DEC  a
         SCF  
         RET                            ; Exit A = Button Set  Carry = Set
;
calcscr
         PUSH af
         PUSH bc
         PUSH de
         LD   a,h
         AND  7
         RLCA 
         RLCA 
         RLCA 
         OR   #c0
         LD   b,a
         LD   c,l
         LD   a,h
         AND  %11111000
         LD   e,a
         LD   d,0
         LD   h,d
         LD   l,a
         ADD  hl,hl
         ADD  hl,hl
         ADD  hl,de
         ADD  hl,hl
         ADD  hl,bc
         LD   a,h
         OR   #c0
         LD   h,a
         POP  de
         POP  bc
         POP  af
         RET  
drawsprc                                ; Calculate HL Address And Place Sprite
         CALL calcscr
drawspr                                 ; A = Sprite
         BIT  6,a
         JR   z,dsnf
         LD   a,FLAG
dsnf
         AND  %11111
         ADD  a,a
         LD   e,a
         LD   d,0
         PUSH hl
         LD   hl,sprites
         ADD  hl,de
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   hl,sprites+#100
         ADD  hl,de
         EX   de,hl
         POP  hl
drawspr1
         PUSH bc
         PUSH hl
drawspr2
         LD   a,(de)
         LD   (hl),a
         INC  hl
         INC  de
         DJNZ drawspr2
         POP  hl
         LD   a,h
         ADD  a,8
         JR   nc,drawspr3
         LD   a,l
         ADD  a,#50
         LD   l,a
         LD   a,h
         ADC  a,8
drawspr3
         OR   #c0
         LD   h,a
         POP  bc
         DEC  c
         JR   nz,drawspr1
         RET  
double
         XOR  a
         LD   (click2),a
         LD   a,0
part1    EQU  $-1
         OR   a
         JR   nz,doublec
         LD   a,47                      ; Check If Click Button Pressed
         CALL #bb1e
         JR   z,doublea                 ; If Not Button Released ?
;
         LD   hl,part1c                 ; Point To Counter
doubleb
         INC  (hl)
         LD   a,(hl)
         CP   15
         RET  c                         ; Check That Held For Small Period
doublef
         XOR  a
         LD   (hl),a
         LD   (part1c),a                ; Reset Counters
         LD   (part2c),a
         LD   (part1),a
         RET  
doublea
         LD   a,(part1c)
         LD   (part1),a                 ; Set Part 1 Flag
         RET  
doublec                                 ; Next Of Click
         LD   a,47
         CALL #bb1e
         LD   hl,part2c
         JR   z,doubleb
;
         LD   a,(part2c)
         OR   a
         RET  z
         LD   (click2),a
         LD   (part2c),a
         JR   doublef
;
part1c   DEFB 0
part2c   DEFB 0
click2   DEFB 0
;
joystick
         CALL #bb24
         PUSH af
         BIT  0,a
         CALL nz,up
         POP  af
         PUSH af
         BIT  1,a
         CALL nz,down
         POP  af
         PUSH af
         BIT  2,a
         CALL nz,left
         POP  af
         BIT  3,a
         CALL nz,right
         RET  
keys
         LD   a,(click2)
         OR   a
         CALL nz,fblanks
         LD   a,21
         CALL #bb1e
         CALL nz,drawflag
         LD   a,8
         CALL #bb1e
         CALL nz,left
         LD   a,1
         CALL #bb1e
         CALL nz,right
         LD   a,0
         CALL #bb1e
         CALL nz,up
         LD   a,2
         CALL #bb1e
         CALL nz,down
         LD   a,47
         CALL #bb1e
         SCF  
         RET  nz
         AND  a
         RET  
faster
         LD   a,(accelf)
         OR   a
         JR   nz,faster1
         LD   (accel),a
         RET  
faster1
         LD   hl,counter
         INC  (hl)
         LD   a,(accel)
         SLA  a
         SLA  a
         SLA  a
         CP   (hl)
         RET  nc
         LD   (hl),0
         LD   hl,accel
         INC  (hl)
         LD   a,(hl)
         CP   7
         RET  c
         LD   (hl),7
         RET  
raster
         EI   
         LD   a,(msey)
         CP   55
         JR   nc,raster2
raster1
         LD   a,(rasterc)
         CP   3
         JR   nz,raster1
         RET  
raster2
         LD   a,(rasterc)
         OR   a
         JR   nz,raster2
         RET  
up
         LD   a,(accel)                 ; Get Accellorated Value
         LD   b,a
         LD   a,#ff
         LD   (accelf),a
         LD   a,(msey)
         SUB  b
         LD   (msey),a
         RET  nc
         XOR  a
         LD   (msey),a
         RET  
down
         LD   a,(accel)                 ; Get Accellorated Value
         LD   b,a
         LD   a,#ff
         LD   (accelf),a
         LD   a,(msey)
         ADD  a,b
         LD   (msey),a
         CP   190
         RET  c
         LD   a,190
         LD   (msey),a
         RET  
left
         LD   a,#ff
         LD   (accelf),a
         LD   a,(accel)                 ; Get Accellorated Value
         LD   c,a
         LD   b,0
         LD   hl,(msex)
         AND  a
         SBC  hl,bc
         LD   (msex),hl
;
         LD   de,(mlx)
         JR   c,left2
left1
         AND  a
         SBC  hl,de
         RET  nc
left2
         LD   (msex),de
         RET  
;
right
         LD   a,#ff
         LD   (accelf),a
         LD   a,(accel)                 ; Get Accellorated Value
         LD   hl,(msex)
         LD   c,a
         LD   b,0
;
         ADD  hl,bc
         LD   (msex),hl
         LD   de,(mmx)
         AND  a
         SBC  hl,de
         RET  c
         LD   (msex),de
         RET  
showit
         LD   a,(msey)
         LD   l,a
         LD   de,(msex)
         CALL calcaddr
         LD   (scraddr2),hl
         LD   a,(bitstate)
putmse
         LD   hl,mbuffer2
         LD   de,mbuffer2+1
         LD   bc,39
         LD   (hl),0
         LDIR 
         LD   hl,mbuffer2
         LD   de,mouses
         LD   bc,#309
         CALL bitspr
putmse1
         LD   hl,#c000
scraddr2 EQU  $-2
         LD   de,mbuffer2
         LD   bc,#409
         LD   ix,mbuffer1
blk1
         PUSH bc
         PUSH hl
blk2
         LD   a,(hl)
         LD   (ix+0),a
;
         LD   a,(de)
         PUSH bc
         LD   c,a
         RRCA 
         RRCA 
         RRCA 
         RRCA 
         OR   c
         XOR  #ff
         LD   b,a
         LD   a,(hl)
         AND  b
         OR   c
         LD   (hl),a
         POP  bc
         INC  ix
         INC  hl
         INC  de
         DJNZ blk2
         POP  hl
         LD   a,h
         ADD  a,8
         JR   nc,blk3
         LD   a,l
         ADD  a,#50
         LD   l,a
         LD   a,h
         ADC  a,#c8
blk3
         OR   #c0
         LD   h,a
         POP  bc
         DEC  c
         JR   nz,blk1
         RET  
restoreb
         LD   hl,(scraddr2)
         LD   de,mbuffer1
         LD   bc,#409
resb1
         PUSH bc
         PUSH hl
resb2
         LD   a,(de)
         LD   (hl),a
         INC  hl
         INC  de
         DJNZ resb2
         POP  hl
         LD   a,h
         ADD  a,8
         JR   nc,resb3
         LD   a,l
         ADD  a,#50
         LD   l,a
         LD   a,h
         ADC  a,#c8
resb3
         OR   #c0
         LD   h,a
         POP  bc
         DEC  c
         JR   nz,resb1
         RET  
;
drawmse                                 ; Draw Mouse At Co-Ordinates
         LD   de,mouses
         LD   c,9
drawmse1
         PUSH hl
         LD   b,3
drawmse2
         LD   a,(de)
         LD   (hl),a
         INC  hl
         INC  de
         DJNZ drawmse2
         POP  hl
         LD   a,h
         ADD  a,8
         JR   nc,drawmse3
         LD   a,l
         ADD  a,#50
         LD   l,a
         LD   a,h
         ADC  a,#c8
drawmse3
         OR   #c0
         LD   h,a
         DEC  c
         JR   nz,drawmse1
         RET  
bitspr                                  ; Place Sprite With Bit Shift
         PUSH ix
;
         LD   (bitshift),a              ; Store Number Of Rotations
bitspr1
         PUSH bc
         LD   c,b
bitspr4
         PUSH de
         PUSH hl
         LD   a,(de)
         LD   h,a
         LD   l,0
         LD   b,0
bitshift EQU  $-1
         XOR  a
         OR   b
         JR   z,bitspr3
bitspr2
         OR   a
         SRL  l
         LD   a,h
         AND  %10001
         RLCA 
         RLCA 
         RLCA 
         OR   l
         LD   l,a
         LD   a,h
         AND  %11101110
         RRA  
         LD   h,a
         DJNZ bitspr2
bitspr3
         EX   de,hl
         POP  hl
         LD   a,d
         OR   (hl)
         LD   (hl),a
         LD   a,e
         INC  hl
         OR   (hl)
         LD   (hl),a
;
         POP  de
         INC  de
         DEC  c
         JR   nz,bitspr4
         INC  hl
         POP  bc
         DEC  c
         JR   nz,bitspr1
;
         POP  ix
         RET  
calcaddr                                ; Calculate Screen Address
         PUSH de
         LD   h,0
         LD   b,h
;
         LD   a,l
         AND  7
         RLCA 
         RLCA 
         RLCA 
         LD   d,a
         LD   a,l                       ; Multiply Hard Line * #50
         AND  %11111000
         LD   c,a
         LD   l,a
         ADD  hl,hl
         ADD  hl,hl
         ADD  hl,bc
         ADD  hl,hl
         LD   e,0
         ADD  hl,de
;
         POP  de
         LD   a,e                       ; Calculate Bit Shift State
         AND  3
         LD   (bitstate),a
         LD   a,c
;
         SRL  d
         RR   e
         SRL  d
         RR   e
         ADD  hl,de
         LD   c,0
         ADD  hl,bc
         LD   a,h
         OR   #c0
         LD   h,a
         RET  
calcdig                                 ; Calculate Digital Number
         LD   hl,sprites+4              ; A=Digital Number
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   hl,sprites+#100
         ADD  hl,de
         LD   c,a
         ADD  a,a
         ADD  a,c
         ADD  a,a
         LD   c,a
         ADD  a,a
         ADD  a,c
         LD   e,a
         LD   d,0
         ADD  hl,de
         EX   de,hl
         RET  
drawdig                                 ; DE = Address Of Sprite Data
         LD   hl,#c000
ptimea   EQU  $-2
         LD   bc,#209
         CALL drawspr1
         LD   hl,(ptimea)
         INC  hl
         INC  hl
         LD   (ptimea),hl
         RET  
flashdot
         LD   a,(fifty)
         CP   25
         LD   a,3
         JR   nc,flash1
         INC  a
flash1
         ADD  a,a
         LD   e,a
         LD   d,0
         LD   hl,sprites
         ADD  hl,de
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   hl,sprites+#100
         ADD  hl,de
         EX   de,hl
         LD   hl,#c000
flash2   EQU  $-2
         LD   bc,#109
         JP   drawspr1
rout1
         PUSH hl
         LD   a,(hl)
         CALL calcdig
         CALL drawdig
         POP  hl
         INC  hl
         RET  
ptime
         LD   hl,#c856
ptimen   EQU  $-2
         LD   (ptimea),hl
         LD   hl,time
ptime1
         CALL rout1
         CALL rout1
         PUSH hl
         LD   hl,(ptimea)
         INC  hl
         LD   (ptimea),hl
         DEC  hl
ptimey
         LD   (flash2),hl
         CALL flashdot
         POP  hl
         CALL rout1
         JR   rout1
inctime
         LD   a,(fifty)
         OR   a
         RET  nz
         CALL inctime1
         JR   ptime
inctime1
         LD   hl,time+3
         CALL time10
         RET  c
         CALL time6
         RET  c
         CALL time10
         RET  c
         CALL time10
         RET  c
         JR   time6
time10
         INC  (hl)
         LD   a,(hl)
         CP   10
         RET  c
         LD   (hl),0
         DEC  hl
         RET  
time6
         INC  (hl)
         LD   a,(hl)
         CP   6
         RET  c
         LD   (hl),0
         DEC  hl
         RET  
putscr
         LD   bc,#7fc7
         OUT  (c),c
         LD   hl,#4000
         LD   de,#c000
         LD   bc,#3fff
         LDIR 
         LD   bc,#7fc0
         OUT  (c),c
         EI   
         RET  
setmess
         LD   hl,STARTUP
         LD   (messageo),hl
         LD   (messageb),hl
scroll
         LD   hl,#c020
messaddr EQU  $-2
         LD   c,16
scroll1
         LD   b,#21
         PUSH bc
         PUSH hl
         LD   c,0
scroll2
         LD   a,(hl)
         AND  %10001000
         LD   e,a
         LD   a,(hl)
         RLCA 
         AND  %11101110
         OR   c
         LD   (hl),a
         LD   a,e
         RRCA 
         RRCA 
         RRCA 
         LD   c,a
         DEC  hl
         DJNZ scroll2
         POP  hl
         LD   a,h
         ADD  a,8
         JR   nc,scroll3
         LD   a,#50
         ADD  a,l
         LD   l,a
         LD   a,h
         ADC  a,#c8
scroll3
         OR   #c0
         LD   h,a
         POP  bc
         DEC  c
         JR   nz,scroll1
         RET  
;
restart
         LD   hl,(messageo)
         LD   (messageb),hl
         RET  
smessage                                ; Scrolled Message Print
         LD   a,(messpart)
         OR   a
         JR   nz,sm1
         LD   hl,(messageb)
         INC  hl
         LD   a,(hl)
         OR   a
         CALL z,restart
         LD   a,(hl)
         PUSH hl
;
         SUB  "@"
         LD   h,0
         LD   d,h
         LD   l,a
         ADD  a,a
         ADD  a,l
         ADD  a,a
         LD   l,a
         LD   e,l
         ADD  hl,hl
         ADD  hl,de
         LD   de,(ALFA)
         ADD  hl,de
         LD   de,messbuff
         LD   bc,18
         LDIR 
         POP  hl
         LD   (messageb),hl
sm1
         LD   hl,(messaddr)
         LD   de,messbuff
smx      EQU  $-2
         LD   c,9
sm2
         LD   a,(messpart)
         AND  3
         LD   b,a
         LD   a,(de)
         AND  %10001000
         RRCA 
         RRCA 
         RRCA 
         OR   (hl)
         LD   (hl),a
         LD   a,(de)
         RLCA 
         LD   (de),a
         INC  de
         INC  de
         LD   a,h
         ADD  a,8
         JR   nc,sm3
         LD   a,l
         ADD  a,#50
         LD   l,a
         LD   a,h
         ADC  a,#c8
sm3
         OR   #c0
         LD   h,a
         DEC  c
         JR   NZ,sm2
         LD   hl,messpart
         INC  (hl)
         LD   a,(hl)
         AND  7
         LD   (hl),a
         CP   4
         LD   hl,messbuff
         JR   c,sm4
         INC  hl
sm4
         LD   (smx),hl
         RET  
plocalfa
         PUSH de
         CALL calcscr
         LD   (alfaaddr),hl
         POP  hl
palfa
         LD   a,(hl)
         OR   a
         RET  z
         INC  hl
         PUSH hl
         CALL putalfa
         POP  hl
         JR   palfa
putalfa                                 ; Put Alfa Numeric On The Screen
         SUB  "@"
         LD   h,0
         LD   d,h
         LD   l,a
         ADD  a,a
         ADD  a,l
         ADD  a,a
         LD   l,a
         LD   e,l
         ADD  hl,hl
         ADD  hl,de
         LD   de,0
ALFA     EQU  $-2
         ADD  hl,de
;
         EX   de,hl
         LD   hl,#c000
alfaaddr EQU  $-2
         LD   bc,#209
         CALL drawspr1
         LD   hl,(alfaaddr)
         INC  hl
         INC  hl
         LD   (alfaaddr),hl
         RET  
loadspr
         LD   hl,memflag
         LD   a,(hl)
         OR   a
         RET  nz
         LD   (hl),#ff
         DI   
         LD   bc,#7fc7
         OUT  (c),c
         LD   hl,name1
         LD   b,len1
         CALL #bc77
         LD   hl,#4000
         CALL #bc83
         CALL #bc7a
         DI   
         LD   bc,#7fc0
         OUT  (c),c
         LD   hl,name
         LD   b,len
         LD   de,#c000
         CALL #bc77
         LD   hl,sprites
         CALL #bc83
         JP   #bc7a
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
