;
         ORG  #3000
start    ENT  $                         ; Maze Editor V1.00 (C) 1991 Jason Broo
mboxx    EQU  11
mboxy    EQU  0
mboxw    EQU  16
mboxh    EQU  3
mazew    EQU  38                        ; Width Of Maze
mazeh    EQU  20                        ; Maze Height
mazel    EQU  mazeh+1*mazew             ; Maze Length In Bytes
nscreens EQU  10                        ; Maximum Number Of Screen Allowed
mazet    EQU  mazel*nscreens            ; Maze Total Bytes * Screen Numbers
adam     EQU  #4000
editor
         DI   
         LD   sp,#bff8
         LD   bc,#7fc0
         OUT  (c),c
         CALL calcscra                  ; Calculate Screen Address For Verticle
         CALL load
         DI   
         CALL blackink
         CALL resethrd
         CALL cleanscr
         CALL setinks
         CALL blackink
         CALL framefly
         LD   l,mboxy
         LD   c,mboxx
         LD   b,mboxw
         LD   e,mboxh
         CALL box
         LD   l,1
         LD   c,3
         LD   e,3
         LD   b,3
         CALL box
         LD   hl,#c000
         LD   (textaddr),hl
         LD   hl,Selected
         CALL print
         LD   l,0
         LD   c,30
         CALL locate
         LD   hl,Status
         CALL print
         LD   a,1
         LD   (screen),a
         CALL drawscr
         LD   a,4
         LD   l,3
         LD   c,8
symbols
;CALL boxspr
         INC  c
         INC  c
         INC  a
         CP   19
         JR   nz,symbols
         LD   l,mboxy+1*8+1
         LD   c,mboxx+1*2
         CALL calcaddr
         LD   (scrolmba),hl
         LD   a,mboxw-1*2
         LD   (scrolmbl),a
         LD   e,a
         LD   d,0
         ADD  hl,de
         DEC  hl
         LD   (dmessad),hl
         LD   l,10
         CALL setinks
         CALL framefly
         CALL drawscr
         LD   a,4
         LD   (cursory),a
         LD   a,1
         LD   (cursorx),a
         LD   a,8
         LD   (selected),a
         LD   a,#ff
         LD   (status),a
         CALL changes
loop
         LD   hl,welcome
         CALL setupms
         LD   a,47
         CALL scrmess
         JR   c,loop
         CALL ped
decide                                  ; Get Key Presses And Act On Them !
         CALL framefly
         LD   l,2
         LD   c,4
         LD   a,(selected)
         CALL calcblk
         INC  hl
         CALL spriteb
         CALL cursor
         LD   hl,keylist
decide1
         PUSH hl
         LD   a,(hl)
         CP   #ff
         JR   z,decide2
         CALL scankey
         POP  hl
         CALL z,callfunc                ; Call Appropriate Function If Set
         INC  hl
         INC  hl
         INC  hl
         JR   decide1
decide2
         POP  hl
;
         LD   a,67                      ; Q For Quit !
         CALL scankey
         JR   nz,decide
quit
         LD   bc,#7fc4
         OUT  (c),c
         POP  bc
         JP   adam
callfunc                                ; Call Appropriate Function Set In (HL+
         PUSH hl
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         CALL callde
         POP  hl
         RET  
callde
         PUSH de
         RET  
piecel                                  ; Rotate Selected Game Piece
         LD   a,15
         CALL scankey
         JR   z,piecel
         LD   a,(selected)
         OR   a
         RET  z
         DEC  a
         CP   7
         JR   nz,piecel1
         XOR  a
piecel1
         LD   (selected),a
         RET  
piecer
         LD   a,7
         CALL scankey
         JR   z,piecer
         LD   a,(selected)
         OR   a
         JR   nz,piecer1
         LD   a,7
piecer1
         INC  a
         CP   34
         RET  z
         LD   (selected),a
         RET  
control                                 ; Control Key Pressed Check For Functio
         LD   a,60                      ; Key Number For SAVE Maze Data
         CALL scankey
         JP   z,save
         LD   a,62
         CALL scankey
         JR   z,clearg                  ; Clear Grid
         LD   a,36                      ; Key Number For L - LOAD Maze Data.
         CALL scankey
         RET  nz
loadmaze
         LD   hl,Load
         CALL setupms
         LD   a,80
         CALL scrmess
         CALL yn
         JP   nc,ped                    ; Quit If No
         LD   a,1
         LD   (screen),a
         LD   hl,mazetble
         LD   de,mazetble+1
         LD   bc,#2000
         LD   (hl),0
         LDIR 
         LD   hl,#abff
         LD   de,#40
         LD   c,7
         CALL #bcce                     ; Restore Disk Drive Ready For Saveing 
         LD   hl,mazename               ; Point HL To Maze Name
         LD   de,mazetble
         LD   b,len
         CALL #bc77
         JP   nc,#bc7d
         LD   hl,mazetble
         CALL #bc83
         CALL #bc7a
         DI   
         CALL setinks
         CALL ped
         JP   drawscr
clearg                                  ; Clear Grid Routine
         LD   hl,Clear
         CALL setupmsa
         JR   nc,ped
         LD   a,#ff
         LD   (putmazef),a
         LD   l,4
clearg1
         LD   c,1
clearg2
         XOR  a
         CALL boxspr
         INC  c
         LD   a,c
         CP   mazew+1
         JR   nz,clearg2
         INC  l
         LD   a,l
         CP   mazeh+5
         JR   nz,clearg1
         LD   b,37
         LD   l,4
         LD   c,1
         LD   e,21
         CALL box
         XOR  a
         LD   (putmazef),a
         RET  
save
         LD   hl,Save
         CALL setupmsa
         JR   nc,ped                    ; Quit If No
         LD   hl,#abff
         LD   de,#40
         LD   c,7
         CALL #bcce                     ; Restore Disk Drive Ready For Saveing 
         LD   hl,mazename               ; Point HL To Maze Name
         LD   de,#c000
         LD   b,len
         CALL #bc8c
         JR   nc,save1
         LD   hl,mazetble
         LD   de,nscreens*2+mazet
         LD   bc,0
         LD   a,2
         CALL #bc98
         JR   nc,save1
         CALL #bc8f
save1
         POP  hl
         LD   bc,#650
save2
         PUSH bc
         CALL framefly
         POP  bc
         DEC  c
         JR   nz,save2
         DJNZ save2
         JP   editor
ped
         LD   hl,Editing
         CALL setupms
         LD   a,80
         JP   scrmess
setupmsa
         CALL setupms
         LD   a,80
         CALL scrmess
yn                                      ; Is Yes Or No Being Pressed ?
         LD   a,43                      ; Key Number For Y
         CALL scankey
         SCF  
         RET  z                         ; Quit If Y Pressed
         LD   a,46
         CALL scankey
         JR   nz,yn
         RET                            ; Exit Carry Set If Yes Carry 0 NO
screenp                                 ; Goto Prevoius Screen If Possible
         LD   a,(screen)
         DEC  a
         RET  z
         LD   (screen),a
         JP   drawscr
screenn
         LD   a,(screen)
         INC  a
         CP   nscreens+1
         RET  z
         LD   (screen),a
         JP   drawscr
drawscr                                 ; Draw Up Current Playing Grid !
@
         LD   l,2
         LD   c,30
         CALL locate
         LD   hl,Screen
         CALL print
@
         LD   a,(screen)
         CALL pnum
         LD   a,(screen)
         DEC  a
         ADD  a,a
         LD   e,a
         LD   d,0
         LD   hl,mazetble
         ADD  hl,de
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   hl,mazetble
         ADD  hl,de                     ; Calculate Address Of Maze Table Data
         XOR  a
         LD   (putmazef),a              ; Reset Flag So Not Poking To Array
         LD   c,mazeh+1
         EX   de,hl
         LD   l,4
drawscr1
         LD   b,mazew
         PUSH bc
         LD   c,1
drawscr2
         PUSH hl
         PUSH de
         PUSH bc
         LD   a,(de)
         CALL boxspr
         POP  bc
         POP  de
         POP  hl
         INC  de
         INC  c
         DJNZ drawscr2
         POP  bc
         INC  l
         DEC  c
         JR   nz,drawscr1
         RET  
box                                     ; Draw A Pretty Box !!!!
         DEC  e
         RET  z
         LD   a,e
         OR   a
         RET  z
         LD   a,l
         CP   25
         RET  nc                        ; Quit If Y Is Greater Than End Screen 
         LD   a,b
         CP   2
         RET  c
         CP   40
         RET  nc
         LD   a,e
         ADD  a,l
         CP   25
         RET  nc
         PUSH de
         PUSH bc
box2
         LD   a,12
         CALL boxspr
         INC  c
         DEC  b
box4
         LD   a,8
         CALL boxspr
         INC  c
         DJNZ box4
         LD   a,13
         CALL boxspr
         INC  l
         DEC  e
         JR   z,box6
box5
         LD   a,10
         CALL boxspr
         INC  l
         DEC  e
         JR   nz,box5
box6
         LD   a,15
         CALL boxspr
         LD   a,c
         POP  bc
         DEC  a
         LD   c,a
         DEC  b
box7
         LD   a,9
         CALL boxspr
         DEC  c
         DJNZ box7
         LD   a,14
         CALL boxspr
         POP  de
         DEC  l
         DEC  e
         RET  z
box8
         LD   a,11
         CALL boxspr
         DEC  l
         DEC  e
         JR   nz,box8
         RET  
changes
         LD   a,68
         CALL scankey
         JR   z,changes
         LD   a,(status)
         INC  a
         CP   2
         JR   nz,changes1
         XOR  a
changes1
         LD   (status),a
         ADD  a,a
         LD   e,a
         LD   d,0
         LD   hl,statusm                ; Point To Status Messages
         ADD  hl,de
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         PUSH de
         LD   l,1
         LD   c,30
         CALL locate
         POP  hl
         JP   print
cursorf
         LD   a,(status)
         OR   a
         JR   z,cursorff                ; Jump To Final Depending On Status
cursorff                                ; Finally Place Selected Cursor At Posi
         LD   a,#ff
         LD   (putmazef),a
         LD   a,(cursorx)
         LD   c,a
         LD   a,(cursory)
         LD   l,a
         LD   a,(selected)
         CALL boxspr
         XOR  a
         LD   (putmazef),a
         RET  
cursorl                                 ; Move Cursor Left
         CALL cursorrs
         LD   a,(cursorx)
         DEC  a
         JR   z,cursore
         LD   (cursorx),a
         JR   cursore
cursorr
         CALL cursorrs
         LD   a,(cursorx)
         INC  a
         CP   mazew+1
         JR   z,cursore
         LD   (cursorx),a
         JR   cursore
cursoru
         CALL cursorrs
         LD   a,(cursory)
         DEC  a
         CP   3
         JR   z,cursore
         LD   (cursory),a
         JR   cursore
cursord
         CALL cursorrs
         LD   a,(cursory)
         INC  a
         CP   25
         JR   z,cursore
         LD   (cursory),a
         JR   cursore
cursorrs                                ; Reset Screen To Original Contents
         CALL framefly
         XOR  a
         LD   (cflag),a
         INC  a
         LD   (ccount),a
         JR   cursor
cursore
         CALL framefly
         LD   a,#ff
         LD   (cflag),a
         LD   a,1
         LD   (ccount),a
cursor
         XOR  a
         LD   (putmazef),a
         LD   hl,ccount                 ; Point HL To Cursor Counter
         DEC  (hl)
         RET  nz
         LD   (hl),6
         LD   a,(cflag)
         XOR  255
         LD   (cflag),a
         OR   a
         LD   a,(selected)
         JR   z,cursor1
         LD   a,(cursory)
         LD   l,a
         LD   a,(cursorx)
         LD   c,a
         CALL getmazea
         LD   a,(hl)
cursor1
         LD   e,a
         LD   a,(cursorx)
         LD   c,a
         LD   a,(cursory)
         LD   l,a
         LD   a,e
boxspr
         PUSH af
         PUSH bc
         PUSH de
         PUSH hl
         CALL calcblk
         CALL spriteb
         POP  hl
         POP  de
         POP  bc
         POP  af
putmaze                                 ; Put Co-Ordinates Into Maze Data
         PUSH af
         PUSH bc
         PUSH de
         PUSH hl
         LD   e,a
         LD   a,0                       ; See If Block Is To Be Put In Maze !
putmazef EQU  $-1
         OR   a
         JR   z,putmazeq                ; If Not In Maze Data Then Quit !
         CALL getmazea
;POP  de                        ; Resto
         LD   (hl),e                    ; Poke Maze Data Address With Sprite
putmazeq
         POP  hl
         POP  de
         POP  bc
         POP  af
         RET  
getmazea                                ; Get Address Of Maze Data In Array Of 
         DEC  c
         LD   a,l
         SUB  4
         LD   l,a
         PUSH de
         PUSH hl
         LD   hl,mazetble               ; Point HL To Maze Table
         LD   a,(screen)                ; Get Current Screen Were Editing
         DEC  a
         ADD  a,a
         LD   e,a
         LD   d,0
         ADD  hl,de
         LD   e,(hl)
         INC  hl
         LD   d,(hl)                    ; Calculate Position In Table
         LD   hl,mazetble
         ADD  hl,de                     ; HL Points To Address in Table !
         LD   b,0
         ADD  hl,bc                     ; HL=ADDRESS + X Offset
         POP  de                        ; Get Height E=Y Co-ord
         PUSH hl                        ; Preserve Maze Address
         LD   a,mazew                   ; A=Width Of Maze
         CALL multiply                  ; E * A = HL
         POP  de                        ; Get MazeAddress In DE
         ADD  hl,de                     ; Add Together To Get Final Result
         POP  de
         RET  
multiply                                ; Multiplication Routine
         LD   hl,0                      ; Enter E , A = Multiplicand
         LD   d,h
         LD   b,8
mult1
         ADD  hl,hl
         RLA  
         JR   nc,mult2
         ADD  hl,de
mult2
         DJNZ mult1
         RET                            ; Exit HL=Result
sprite                                  ; Draw up Maze Sprite ! 
         CALL calcaddr
spriteb                                 ; Entry Point For Pre-Calculated Addres
         PUSH hl
         ADD  a,a                       ; Entry A=Sprite Number
         LD   e,a
         LD   d,0
         LD   hl,msprload               ; Point HL To Maze Sprite Data
         ADD  hl,de                     ; Point HL To Appropriate Offset
         LD   e,(hl)
         INC  hl
         LD   d,(hl)                    ; DE = Offset Of Sprite Data
         LD   hl,msprload               ; Point HL To Start Of Table
         ADD  hl,de                     ; Add So HL = Exact Address Of Sprite
         POP  de                        ; DE=Sprite Physical Address
sprite1                                 ; Now To Force Sprite Onto Screen
         LD   b,8                       ; Sprite Block Is 8 Rows Down !
sprite2
         PUSH bc                        ; Preserve Counter
         LDI  
         LDI  
         DEC  de
         DEC  de
         LD   a,8
         ADD  a,d
         JR   nc,sprite3
         LD   a,#50
         ADD  a,e
         LD   e,a
         LD   a,#c8
         ADC  a,d
sprite3
         OR   #c0
         LD   d,a
         POP  bc
         DJNZ sprite2
         RET  
calcaddr                                ; Calculate Physical Screen Address
         SLA  l                         ; L = Y-Axis
         LD   h,0
         LD   b,h                       ; Entry C = X-Axis
         LD   de,scrtable
         ADD  hl,de                     ; Point HL To Indirection !
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         EX   de,hl                     ; HL = Y Physical Address
         ADD  hl,bc                     ; Add Y Physical To X Physical !
         RET  
calcblk                                 ; Calculate Block Physical Address
         SLA  c
         SLA  l
         SLA  l
         SLA  l
         LD   h,0
         LD   b,h
         ADD  hl,hl
         LD   de,scrtable
         ADD  hl,de
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         EX   de,hl
         ADD  hl,bc
         RET  
calcscra
         LD   ix,scrtable
         LD   b,200
         LD   hl,#c000
clcscra1
         LD   (ix+0),l
         LD   (ix+1),h
         INC  ix
         INC  ix
         LD   a,8
         ADD  a,h
         JR   nc,clcscra2
         LD   a,#50
         ADD  a,l
         LD   l,a
         LD   a,#c8
         ADC  a,h
clcscra2
         OR   #c0
         LD   h,a
         DJNZ clcscra1
         RET  
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
         SUB  #0f
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
         LD   ix,psprload
         LD   e,(ix+42)
         LD   d,(ix+43)
         ADD  hl,de
         LD   de,psprload
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
         CALL calcblk                   ; Entry L=Y, C=X
         LD   (textaddr),hl
         RET  
text                                    ; Display Text On Screen !
         SUB  17
         JR   c,tcolour
         SUB  15
         LD   ix,psprload
         LD   e,(ix+42)
         LD   d,(ix+43)
         LD   hl,psprload
         ADD  hl,de                     ; HL Now Points To TypeSet 2
         EX   de,hl
         LD   c,a
         LD   b,0
         LD   h,b
         ADD  a,a                       ; A*2
         LD   l,a
         ADD  hl,hl
         ADD  hl,bc
         ADD  hl,hl                     ; HL = A*10 !!!
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
load                                    ; Load In Sprite Information Data !
         LD   hl,#ff
         BIT  0,(hl)
         LD   (hl),#ff
         RET  nz                        ; Quit If Sprites And Tables Initialize
         LD   hl,mazetble
         LD   de,mazetble+1
         LD   bc,#2000
         LD   (hl),0
         LDIR 
         LD   ix,mazetble
         LD   de,mazeh+1*mazew
         LD   hl,nscreens*2
         LD   b,nscreens
table1
         LD   (ix+0),l
         LD   (ix+1),h
         INC  ix
         INC  ix
         ADD  hl,de
         DJNZ table1
;
         LD   a,1
         LD   (putmazef),a
setmaze1
         LD   (screen),a
         PUSH af
         LD   b,37
         LD   l,4
         LD   c,1
         LD   e,mazeh
         CALL box
         POP  af
         INC  a
         CP   nscreens+1
         JR   nz,setmaze1
         XOR  a
         LD   (putmazef),a
         INC  a
         LD   (screen),a
         LD   hl,name1
         LD   b,len
         CALL #bc77
         LD   hl,psprload
         CALL #bc83
         CALL #bc7a
         LD   hl,name
         LD   b,len
         CALL #bc77
         LD   hl,msprload
         CALL #bc83
         JP   #bc7a
;
inkset   DEFB 0,26,18,8,1,23,5,14
         DEFB 4,1,15,6,3,16,24,25,17
         DEFB 19,21,23
;
mazename DEFM MAZES   .DAT
name     DEFM MAZEDATA.SPR
name1    DEFM PACMAN2 .SPR
len      EQU  $-name1
msprload EQU  #1000
psprload EQU  #1900
spaces   DEFS 30,32
         DEFB 255
screen   DEFB 0                         ; Which Screen Currently Working On
cursorx  DEFB 1                         ; Cursor X Position In Grid
cursory  DEFB 5                         ; Cursor Y Position In Grid
ocursorx DEFB 0                         ; Old Cursor Position
ocursory DEFB 0                         ; Old Cursor Y Position !
selected DEFB 0                         ; Selected Game Piece
status   DEFB 255                       ; Status Indication Flag
mode     DEFB 0                         ; Current Mode Of Operation
ccount   DEFB 5
cflag    DEFB 0
keylist                                 ; List Of Keys And Appropriate Function
         DEFB 10                        ; Key Number For F7
         DEFW screenp
         DEFB 3                         ; Key Number For F9
         DEFW screenn
         DEFB 23                        ; Key For Control
         DEFW control
         DEFB 15                        ; Key Number For F0
         DEFW piecel
         DEFB 7                         ; Key Number For F.
         DEFW piecer
         DEFB 71                        ; Key Number For Z - Cursor Left
         DEFW cursorl
         DEFB 63                        ; Key Number For X - Cursor Right
         DEFW cursorr
         DEFB 19                        ; Key Number For ] - Cursor Up
         DEFW cursoru
         DEFB 22                        ; Key Number For ; - Cursor Down
         DEFW cursord
         DEFB 21                        ; Key Number For SHIFT - Drop Piece
         DEFW cursorf
         DEFB 68                        ; Key For TAB - Change Status
         DEFW changes                   ; Change Status
         DEFB #ff                       ; Signify End Of Scan List
statusm                                 ; Look Up Table For Messages
         DEFW Normal
         DEFW Trace
Normal
         DEFB 11
         DEFM NORMAL    
         DEFB 0
Trace
         DEFB 11
         DEFM TRACE    
         DEFB 0
Selected
         DEFB 14
         DEFM (SELECTED)
         DEFB 0
Save
         DEFB 5,32
         DEFM SAVE MAZES 
         DEFB 15
         DEFM Y/N
         DEFB #ff
Load
         DEFB 2,32
         DEFM LOAD MAZES 
         DEFB 15
         DEFM Y/N
         DEFB #ff
Clear
         DEFB 2,32
         DEFM CLEAR MAZE 
         DEFB 15
         DEFM Y/N
         DEFB #ff
Editing
         DEFB 3,32,32,32
         DEFM EDITING....   
         DEFB 255
Screen
         DEFB 13
         DEFM SCREEN: 
         DEFB 0
Status
         DEFB 11
         DEFM STATUS:
         DEFB 0
welcome  DEFB 15
         DEFM WELCOME TO THE SCREEN 
         DEFM EDITOR WRITTEN BY 
         DEFM JASON 
         DEFM BROOKS.  
         DEFM GRAPHICS BY 
         DEFB 14
         DEFM J. BROOKS 
         DEFB 15
         DEFM AND 
         DEFB 14
         DEFM MAD (KEN) TREVENA 
         DEFB 3
         DEFM (C) 1991 JACESOFT SOFTWAR
         DEFM E  
         DEFB 6
         DEFM PRESS SPACE TO START THE 
         DEFM EDITOR.  USE KEYS :- 
         DEFB 14
         DEFM Z, X, ;, / 
         DEFB 6
         DEFM TO POSITION 
         DEFB 255
         DEFB 0
;
scrtable DEFS 400,#c0
;
;         **** FIRMWARE.ADM ****
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
         CALL framefly
         XOR  a
         CALL setmode
         LD   b,0
         LD   a,16
         CALL setink
         LD   ix,inkset
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
;
;
hardinks DEFB 20,4,21,28,24,29,12,5
         DEFB 13,22,6,23,30,0,31
         DEFB 14,7,15,18,2,19,26,25
         DEFB 27,10,3,11
;
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
         LD   a,0
         LD   (horiz),a
         LD   a,180
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
mazetble EQU  #4000                     ; Location To Place MAZE DATA !
