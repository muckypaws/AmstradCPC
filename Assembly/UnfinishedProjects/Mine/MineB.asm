;
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
         LD   c,9
scroll1
         LD   b,#40
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
         XOR  a
         LD   (messpart),a
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
         LD   (messageb),hl
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
;
         LD   de,messbuff
         LD   bc,18
         LDIR 
sm1
         LD   hl,(messaddr)
         LD   de,messbuff
smx      EQU  $-2
         LD   c,9
sm2
         LD   a,(de)
         AND  %10001000
         RRCA 
         RRCA 
         RRCA 
         OR   (hl)
         LD   (hl),a
;
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
         LD   hl,#abff
         LD   de,#40
         LD   c,7
         CALL #bcce
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
*f,message.adm
