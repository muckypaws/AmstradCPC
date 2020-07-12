;
         ORG  #9000                     ; Mouse Control : Written By 
start                                   ; Jason Brooks 10/1/94
         ENT  $
         LD   hl,memflag
         LD   a,(hl)
         OR   a
         CALL z,loadspr
test
         LD   a,1
         CALL #bc0e
         CALL #bb00
         LD   hl,kernel
         LD   bc,commands
         JP   #bcd1
;
mshow                                   ; Show Mouse
         LD   a,(mstat)
         OR   a
         RET  nz
         DEC  a
         LD   (mstat),a
         LD   a,(bitstate)
         CALL putmse                    ; Initially Display Mouse
         LD   hl,fblock
         LD   b,#81
         LD   c,255
         LD   de,mouse
         JP   #bcd7
mhide
         LD   a,(mstat)
         OR   a
         RET  z
         XOR  a
         LD   (mstat),a
         CALL restoreb
         LD   hl,fblock
         JP   #bcdd
mouse
         CALL #b903
         PUSH af
         DI   
         LD   a,(msey)
         LD   l,a
         LD   de,(msex)
         CALL calcaddr
         CALL raster
         CALL restoreb
         DI   
         XOR  a
         LD   (accelf),a
         CALL keys
         CALL joystick
         CALL faster
         LD   a,(msey)
         LD   l,a
         LD   de,(msex)
         CALL calcaddr
         LD   (scraddr2),hl
         LD   a,(bitstate)
         CALL putmse
         POP  af
         CALL #b900
         RET  
loop
         DI   
         CALL #bb09
         DI   
         RET  nc
jjj
         CP   8
         JR   c,loop1
         CP   12
         JR   c,loop
loop1
         CALL #bb0c
         JR   loop
;JR   loop
         RET  
joystick
         RET  
         CALL #bb24
         DI   
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
;LD   a,23
;CALL #bb1e
;RET  z
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
         LD   a,(msey)
         CP   48
         RET  nc
         LD   hl,150
raster1
         DEC  hl
         LD   a,l
         OR   h
         JR   nz,raster1
         RET  
up
         DI   
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
         DI   
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
         DI   
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
         DI   
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
loadspr
         RET  
         LD   (hl),#ff
         LD   hl,name
         LD   b,len
         LD   de,#c000
         CALL #bc77
         LD   hl,mouses
         CALL #bc83
         JP   #bc7a
name
         DEFM MOUSE.SPR
len      EQU  $-name
memflag  EQU  #100                      ; Flag Address For Loaded Data
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
kernel   DEFS 4,0
commands DEFW comtab
         JP   mshow
         JP   mhide
mstat    DEFB 0                         ; #FF If On
;
comtab
         DEFM MSHO
         DEFB "W"+#80
         DEFM MHID
         DEFB "E"+#80
         DEFB 0
;
mbuffer1 DEFS 10*4,0                    ; Screen Buffer 1
mbuffer2 DEFS 10*4,0                    ; Mouse Buffer 2
fblock   DEFS 10,0
mouses                                  ; Data Address
;
         DEFB #0F,#08,#00,#7F
         DEFB #8C,#00,#7F,#08
         DEFB #00,#7F,#8C,#00
         DEFB #5F,#CE,#00,#05
         DEFB #EF,#00,#00,#7F
         DEFB #08,#00,#37,#08
         DEFB #00,#03,#00
;
