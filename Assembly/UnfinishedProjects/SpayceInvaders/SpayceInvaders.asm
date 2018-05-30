;
         ORG  #3000                     ; SPAYCE INVAYDURS - Created By
spayce                                  ; THE ARGONAUT
         ENT  $                         ; STARTED 7th December 1990
columns  EQU  7                         ; Columns Of Invaders
         DI   
         LD   a,(sprload+2)
         CP   #30
         CALL nz,load
         DI   
         CALL cleanscr
         CALL setinks
         CALL bline                     ; Draw Bottom Line
         CALL tline
newgame
         LD   a,3
         LD   (lives),a
fresh
         LD   hl,#e6e0
         LD   (tankaddr),hl
         LD   hl,#c140
         LD   (vadaddr),hl
         LD   de,iarray2
         LD   a,5
         LD   (dvaderno),a
         LD   (ovadaddr),hl
         LD   (nvadaddr),hl
         LD   a,columns
         LD   (dvaderl),a
jace
         LD   hl,invarray
         LD   b,columns*5
setinv
         LD   (hl),#ff
         INC  hl
         DJNZ setinv
         CALL shields
         CALL setcord                   ; Set Invaders Co-Ordinates
         LD   a,3
         LD   (minx),a
         LD   a,38
         LD   (maxx),a
         LD   a,20
         LD   (maxy),a
dieloop
         XOR  a
         LD   (tankx),a
         LD   (tanks),a
         LD   (vadir),a
         LD   (vaders),a
         LD   (movedy),a
         LD   hl,#c780
         LD   b,80
         LD   c,8
         CALL wipeout
         LD   a,(lives)
         DEC  a
         JR   z,gameloop
         LD   hl,#c780
dlives                                  ; Display Lives Remaining
         PUSH af
         PUSH hl
         XOR  a
         CALL calcspra
         POP  de
         PUSH de
         LD   bc,#608
         CALL Generals
         POP  hl
         LD   de,6
         ADD  hl,de
         POP  af
         DEC  a
         JR   nz,dlives
gameloop
         CALL framefly
         CALL disptank
         CALL updbull                   ; Update Bullet If Possible
         CALL hshield
         CALL updv                      ; Update Invaders
         CALL dvaders
         CALL checkxy                   ; Check Max X , Y
         LD   a,(lives)
         OR   a
         RET  z
         LD   a,47
         CALL scankey
         RET  z
         LD   a,21
         CALL scankey
         CALL z,tankfire
         LD   a,71
         CALL scankey
         CALL z,tankleft
         LD   a,63
         CALL scankey
         CALL z,tankrght
         LD   a,18
         CALL scankey
         CALL z,shot
         JR   gameloop
checkxy                                 ; Check Max X , Y
         LD   hl,columns*5+invarray
         LD   c,5
         LD   d,20
         LD   e,20
cxy1
         LD   b,5
cxy2
         LD   a,(hl)
         OR   a
         JR   nz,cxyl
         DEC  hl
         DJNZ cxy2
         INC  e
         INC  e
         LD   a,e
         LD   (maxy),a
         DEC  c
         JR   nz,cxy1
cxyl
         LD   hl,invarray
         LD   a,3
         EX   af,af
         LD   c,columns
cxyl1
         PUSH hl
         LD   b,5
         LD   de,columns
cxyl2
         LD   a,(hl)
         OR   a
         JR   nz,cxyl3
         ADD  hl,de
         DJNZ cxyl2
         EX   af,af
         SUB  6
         LD   (minx),a
         EX   af,af
         POP  hl
         INC  hl
         DEC  c
         JR   nz,cxyl1
cxyl3
         POP  hl
;
cxyr
         LD   hl,invarray+columns-1
         LD   a,38
         EX   af,af
         LD   c,columns
cxyr1
         PUSH hl
         LD   b,5
         LD   de,columns
cxyr2
         LD   a,(hl)
         OR   a
         JR   nz,cxyr3
         ADD  hl,de
         DJNZ cxyr2
         EX   af,af
         ADD  a,6
         LD   (maxx),a
         EX   af,af
         POP  hl
         INC  hl
         DEC  c
         JR   nz,cxyr1
cxyr3
         POP  hl
         RET  
shot
         LD   hl,(iar)
         LD   (hl),0
         INC  hl
         LD   (iar),hl
         LD   hl,(iar1)
         LD   (hl),0
         INC  hl
         INC  hl
         LD   (iar1),hl
         RET  
scrcord                                 ; Calculate X Y Co-Ordinates From SCR A
         LD   a,h
         AND  7
         LD   h,a
         LD   de,#50                    ; How Many #50 s ?
         AND  a
         LD   bc,0
scrcord1
         SBC  hl,de
         INC  b
         JR   nc,scrcord1
         DEC  b
         ADD  hl,de
         LD   c,l
         RET  
setcord                                 ; Set Up Space Invaders Co-Ordinates
         LD   de,invarray               ; HL = Invaders Array
         LD   hl,iarray2                ; DE = Co-Ordinate Array
         LD   b,35/columns
         LD   b,5
         LD   c,27
setcord1
         PUSH bc
         LD   a,columns
         LD   b,0
setcord2
         LD   (hl),c
         INC  hl
         LD   (hl),b
         INC  hl
         INC  b
         INC  b
         INC  b
         INC  b
         DEC  a
         JR   nz,setcord2
         POP  bc
         DEC  c
         DEC  c
         DJNZ setcord1
         RET  
updv                                    ; Update Space Invaders
         LD   a,(rowsdone)
         OR   a
         RET  nz
         LD   a,(dvaderl)
         CP   columns
         RET  nz
         LD   hl,invcnt
         INC  (hl)
         LD   a,(hl)
         SUB  1
         RET  nz
         LD   (hl),a
         LD   a,(vaders)
         XOR  1
         LD   (vaders),a
         LD   b,a
         LD   a,(vadir)
         OR   a
         JR   nz,left
         LD   a,b
         OR   a
         RET  nz
         JR   udv4
left
         LD   a,b
         OR   a
         RET  z
udv4
         LD   a,(vadir)                 ; Get Vader Direction !
         OR   a
         JR   z,leftvad                 ; Move Vaders Left
udv3
         LD   a,(minx)
         LD   b,a
         LD   a,(movedx)
         CP   b
         JR   z,vaddown
         DEC  a
         LD   (movedx),a
         LD   hl,(vadaddr)
         DEC  hl
         LD   (ovadaddr),hl
         LD   (vadaddr),hl
         LD   (nvadaddr),hl
         LD   hl,iarray2+1
         LD   de,invarray
         LD   b,columns*5
upda1
         LD   a,(de)
         OR   a
         JR   z,upda2
         DEC  (hl)
upda2
         INC  hl
         INC  hl
         DJNZ upda1
         RET  
leftvad
         LD   a,(maxx)
         LD   b,a
         LD   a,(movedx)
         CP   b
         JR   z,vaddown
         INC  a
         LD   (movedx),a
         LD   hl,(vadaddr)
         INC  hl
         LD   (ovadaddr),hl
         LD   (vadaddr),hl
         LD   (nvadaddr),hl
         LD   hl,iarray2+1
         LD   de,invarray
         LD   b,columns*5
updb1
         LD   a,(de)
         OR   a
         JR   z,updb2
         INC  (hl)
updb2
         INC  hl
         INC  hl
         DJNZ updb1
         RET  
vaddown                                 ; Move Vaders Down
         LD   a,(vadir)
         XOR  1
         LD   (vadir),a
         LD   a,(movedy)
         INC  a
         LD   (movedy),a
         LD   b,a
         LD   a,(maxy)
         SUB  b
         JR   nz,vadd
         XOR  a
         LD   (lives),a
         RET  
vadd
         LD   hl,(vadaddr)
         LD   (ovadaddr),hl
         LD   a,#20
         ADD  a,h
         JR   nc,vaddown1
         LD   a,#50
         ADD  a,l
         LD   l,a
         LD   a,#e0
         ADC  a,h
vaddown1
         OR   #c0
         LD   h,a
         LD   (vadaddr),hl
         LD   (nvadaddr),hl
topvad
         LD   hl,(ovadaddr)
         LD   de,invarray
         LD   c,5
         LD   b,columns
topvad1
         PUSH bc
         PUSH hl
topvad2
         LD   a,(de)
         OR   a
         CALL nz,topvad3                ; Display Vader If Array Says So
         INC  de
         INC  hl
         INC  hl
         INC  hl
         INC  hl
         INC  hl
         INC  hl
         DJNZ topvad2
         POP  hl
         LD   a,#a0
         ADD  a,l
         LD   l,a
         LD   a,0
         ADC  a,h
         LD   h,a
         POP  bc
         DEC  c
         JR   nz,topvad1
         LD   hl,iarray2
         LD   de,invarray
         LD   b,columns*5
updc1
         LD   a,(de)
         OR   a
         JR   z,updc2
         DEC  (hl)
updc2
         INC  hl
         INC  hl
         DJNZ updc1
         RET  
topvad3
         PUSH af
         PUSH bc
         PUSH hl
         LD   b,4
topvada
         PUSH hl
topvadb
         XOR  a
         LD   (hl),a
         INC  hl
         LD   (hl),a
         INC  hl
         LD   (hl),a
         INC  hl
         LD   (hl),a
         POP  hl
         LD   a,8
         ADD  a,h
         JR   nc,topvadc
         LD   a,#50
         ADD  a,l
         LD   l,a
         LD   a,#c8
         ADC  a,h
topvadc
         OR   #c0
         LD   h,a
         DJNZ topvada
         POP  hl
         POP  bc
         POP  af
         RET  
dvaders                                 ; New Routine To Display 1 Vader At A T
         LD   de,iarray2
dvadera  EQU  $-2
         LD   hl,(nvadaddr)
         LD   c,5
dvaderno EQU  $-1
         LD   b,columns
dvaderl  EQU  $-1
;
         LD   a,(de)
         OR   a
         CALL nz,dvader3
         CALL dvaderu
         RET  c
         DEC  de
         DEC  de
         LD   a,(de)
         OR   a
         JR   z,dvaders
         RET  
dvaderu                                 ; Update Invaders Screen Addressess Etc
         INC  hl
         INC  hl
         INC  hl
         INC  hl
         INC  hl
         INC  hl
         INC  de
         INC  de
         DEC  b
         JR   nz,dvadero
         LD   hl,rowsdone
         INC  (hl)
         LD   hl,(ovadaddr)
         LD   a,#a0
         ADD  a,l
         LD   l,a
         ADC  a,h
         SUB  l
         LD   h,a
         LD   (ovadaddr),hl
         LD   a,(dvaderno)
         ADD  a,2
         CP   11
         JR   nz,dvadero1
         SUB  2
dvadero1
         LD   (dvaderno),a
         LD   a,(rowsdone)
         SUB  5
         CCF  
         JR   nz,dvadero2
         LD   (rowsdone),a
         LD   a,5
         LD   (dvaderno),a
         LD   hl,(vadaddr)
         LD   (ovadaddr),hl
         LD   de,iarray2
         SCF  
dvadero2
         LD   b,columns
dvadero
         LD   (nvadaddr),hl
         LD   (dvadera),de
         LD   a,b
         LD   (dvaderl),a
         RET  
dvader3
         LD   a,c                       ; Get Sprite Number
         PUSH af
         PUSH bc
         PUSH de
         PUSH hl
         PUSH hl
         LD   hl,vaders
         ADD  a,(hl)                    ; Add Shift Value
         CALL calcspra
         LD   bc,#408
         POP  de
         CALL putfs
         POP  hl
         POP  de
         POP  bc
         POP  af
         RET  
tline
         LD   hl,#c0a0
         JR   bline1
bline                                   ; Draw Bottom line
         LD   hl,#e730+#800
bline1
         LD   b,80
bline2
         LD   (hl),#ff
         INC  hl
         DJNZ bline2
         RET  
tankrght
         LD   hl,tankx
         LD   a,(hl)
         CP   148
         RET  z
         INC  (hl)
         LD   a,(tanks)
         XOR  1
         LD   (tanks),a
         RET  nz
         LD   hl,(tankaddr)
         INC  hl
         LD   (tankaddr),hl
         RET  
tankleft
         LD   hl,tankx
         LD   a,(hl)
         OR   a
         RET  z
         DEC  (hl)
         LD   a,(tanks)
         XOR  1
         LD   (tanks),a
         RET  z
         LD   hl,(tankaddr)
         DEC  hl
         LD   (tankaddr),hl
         RET  
tankfire                                ; If Possible Fire A Bullet
         LD   hl,fireflag               ; Am I Already Firing ?
         LD   a,(hl)
         LD   (hl),#ff                  ; Poke Fire Status
         OR   a                         ; If Fire Was In Existence Quit !
         RET  nz
         LD   a,(tanks)
         OR   2
         LD   (fires),a
         SUB  #50
         NEG  
         LD   b,a
         LD   hl,(tankaddr)
         LD   a,l
         SUB  b
         LD   l,a
         LD   a,h
         SBC  a,0
         ADD  a,#18
         OR   #c0
         LD   h,a
         LD   (bullet),hl
         XOR  a
         LD   (bullety),a
         LD   a,(tankx)
         LD   (bulletx),a
dbullet
         LD   a,(fires)
         CALL calcspra
         LD   de,(bullet)
         LD   bc,#105
         JP   Generals
rbullet                                 ; Remove Players Bullet
         LD   hl,(bullet)
         LD   b,5
rbullet1
         LD   (hl),0
         LD   a,h
         ADD  a,8
         JR   nc,rbullet2
         LD   a,#50
         ADD  a,l
         LD   l,a
         LD   a,h
         ADC  a,#c8
rbullet2
         OR   #c0
         LD   h,a
         DJNZ rbullet1
         RET  
updbull                                 ; Update Bullet If Possible !
         LD   a,(fireflag)
         OR   a
         RET  z
         CALL rbullet                   ; Erase Bullet
         LD   hl,bullety
         INC  (hl)
         LD   a,(hl)
         SUB  40
         JR   nz,updbull1
         LD   (fireflag),a
         RET  
updbull1                                ; Bullet Still Here
         LD   hl,(bullet)               ; Get Bullets Screen Address
         LD   a,h
         SUB  #20
         LD   h,a
         CP   #c0
         JR   nc,updbull2
         LD   a,#b0
         ADD  a,l
         LD   l,a
         LD   a,h
         ADC  a,#3f
updbull2
         OR   #c0
         LD   h,a
         LD   (bullet),hl
         JR   dbullet
disptank
         LD   hl,sprload
         LD   a,(tanks)
         CALL calcspra
         LD   de,(tankaddr)
         LD   b,6
         LD   c,8
         JP   Generals
hshield                                 ; Has Bullet Hit Shield ?
         LD   hl,(bullet)
         LD   b,(hl)                    ; B = Mask
         CALL sub800
         LD   a,(hl)
         AND  b
         RET  z
         LD   a,b
         XOR  #ff
         AND  (hl)
         LD   (hl),a
         XOR  a
         LD   (fireflag),a
         JR   rbullet
sub800                                  ; Subtract Screen #800 From HL
         LD   a,h
         SUB  8
         CP   #c0
         JR   nc,sub8001
         PUSH bc
         LD   bc,#3fb0
         ADD  hl,bc
         POP  bc
         RET  
         LD   a,#b0
         ADD  a,l
         LD   l,a
         LD   a,h
         ADC  a,#3f-8
sub8001
         OR   #c0
         LD   h,a
         RET  
shields                                 ; Display 3 Barriers
         LD   hl,#c5fa
         CALL shields1
         LD   hl,#c5fa+25
         CALL shields1
         LD   hl,#c5fa+50
shields1
         PUSH hl
         LD   a,4
         CALL calcspra
         POP  de
         LD   b,9
         LD   c,22
         JP   Generals
calcspra                                ; Calculate Sprite Address
         ADD  a,a                       ; Enter A = Sprite Number
         LD   hl,sprload
         PUSH hl
         LD   e,a
         LD   d,0
         ADD  hl,de
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         INC  d
         POP  hl
         ADD  hl,de
         RET                            ; Exit HL = Sprite Address Data
;
load
         LD   hl,fname
         LD   b,len
         CALL #bc77
         LD   hl,sprload
         CALL #bc83
         JP   #bc7a
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
putfs
         LD   a,(vadir)
         OR   a
         JR   nz,putfl
putfast                                 ; Put Sprite On Screen Fast
         PUSH bc
         PUSH de
         XOR  a
         LD   (de),a
         INC  de
         LDI  
         LDI  
         LDI  
;LD   (de),a
         POP  de
         LD   a,d
         ADD  a,8
         JR   nc,putfast1
         LD   a,#50
         ADD  a,e
         LD   e,a
         LD   a,#c8
         ADC  a,d
putfast1
         OR   #c0
         LD   d,a
         POP  bc
         DEC  c
         JR   nz,putfast
         RET  
putfl                                   ; Put Sprite On Screen Fast
         PUSH bc
         PUSH de
         XOR  a
         LDI  
         LDI  
         LDI  
         LD   (de),a
         POP  de
         LD   a,d
         ADD  a,8
         JR   nc,putfl1
         LD   a,#50
         ADD  a,e
         LD   e,a
         LD   a,#c8
         ADC  a,d
putfl1
         OR   #c0
         LD   d,a
         POP  bc
         DEC  c
         JR   nz,putfl
         RET  
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
         LD   a,1
         CALL setmode
         LD   b,6
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
         CP   4
         JR   nz,setinks1
         RET  
;
fname
         DEFM SPAYCE.SPR
len      EQU  $-fname
hardinks DEFB 20,4,21,28,24,29,12,5
         DEFB 13,22,6,23,30,0,31
         DEFB 14,7,15,18,2,19,26,25
         DEFB 27,10,3,11
inks     DEFB 0,26,6,26
sprload  EQU  #2000
lives    DEFB 3                         ; Number of Lives
fireflag DEFB 0                         ; Player Fire Flag
bullet   DEFW 0                         ; Bullet Address
bulletx  DEFB 0                         ; Bullets X Co-ordinates
bullety  DEFB 0                         ; Bullets Y Co-ordinates
jason    DEFW 0
fires    DEFB 0                         ; Fire Bullet State
tankaddr DEFW 0                         ; Screen Address Of Tank
tankx    DEFB 0                         ; X Position Of Tank
tanks    DEFB 0                         ; Tank Shift State
vaders   DEFB 0                         ; Invaders Shift State
invarray DEFS columns*5,#ff             ; Space Invaders Array
iarray2  DEFS columns*10+2,0            ; Space Invaders Co-ordinate Array
invcnt   DEFB 0                         ; Counter For Updating Vaders
iar      DEFW invarray
iar1     DEFW iarray2
maxx     DEFB 0                         ; Maximum Left Vaders Can Move
minx     DEFB 0                         ; Minimum Right Vaders Can Move
maxy     DEFB 0                         ; How Far Invaders Can Move Down
vadir    DEFB 0                         ; Invaders Direction Bit
vadaddr  DEFW 0                         ; Invaders Screen Address
nvadaddr DEFW 0                         ; Current Invaders Screen Address
ovadaddr DEFW 0                         ; Old Invaders Screen Address
movedx   DEFB 0                         ; How Far Invaders Moved Across
movedy   DEFB 0                         ; How Far Hav Invaders Moved Down ?
rowsdone DEFB 0
