;
         ORG  #7aa0                     ; SPRITE HANDLING ROUTINES
start                                   ; Written By Jason Brooks
         ENT  $                         ; (C) 1992 JacesofT Software
sprdata  EQU  #8400                     ; Graphics Table Address
snum     EQU  40*5                      ; Numbers Are Stored At Sprite 40
         LD   a,#c9
         LD   (start),a                 ; Stop RSX Being RE-Initialized !
         LD   hl,work
         LD   bc,rsxtable
         CALL #bcd1
         DI   
         LD   hl,#4000
         LD   e,(hl)
         LD   (hl),0
         LD   d,0
         LD   bc,#7fc4
         OUT  (c),c
         LD   (hl),#ff
         LD   bc,#7fc0
         OUT  (c),c
         LD   a,(hl)
         LD   (hl),e
         LD   l,(ix+0)
         LD   h,(ix+1)
         LD   (hl),a
         OR   a
         RET  z
         LD   a,#c9
         LD   (speech),a
         RET  
speech                                  ; Speech Processor
         DEC  a
         RET  nz
         LD   a,(spon)
         OR   a
         RET  z
         DI   
         LD   bc,#7fc4
         OUT  (c),c
         CALL #4000
         LD   bc,#7fc0
         OUT  (c),c
         RET  
SPON
         LD   a,#FF
SPON1
         LD   (spon),a
         RET  
SPOFF
         XOR  a
         JR   SPON1
coin
         CP   3
         RET  nz
         LD   e,(ix+4)                  ; Which Coin ?
         LD   d,0
         LD   hl,coinhgt
         ADD  hl,de
         LD   b,(hl)
         LD   a,(ix+0)
         SUB  b
         LD   (ix+0),a
         LD   a,6
         ADD  a,(ix+4)
         LD   (ix+4),a
         LD   a,3
         JP   sprites
numbers                                 ; Small Numbers !
         CP   3
         RET  nz
         LD   a,1
         LD   (mask),a
         LD   iy,sprdata+snum
         LD   e,(iy+0)
         LD   d,(iy+1)
         CALL getspra
         LD   iy,sprdata+snum
         ADD  a,a                       ; A*10
         LD   l,a
         LD   h,0
         ADD  hl,de                     ; HL = Offset Of Data
         CALL numit
         XOR  a
         LD   (mask),a
         RET  
getspra
         LD   a,(ix+4)                  ; User Sprite Entry Address
getspra1
         LD   b,a                       ; Calculate Loaction In Sprite
         ADD  a,a                       ; Address Table Where Sprite Info
         ADD  a,a                       ; Is.  BYTE 0 = LSB Offset
         ADD  a,b                       ; BYTE 1 = MSB Offset, BYTE 2 = Storage
         LD   l,a                       ; Byte 3 = Width, Byte 4 = Height
         LD   h,sprdata/256
         PUSH hl                        ; HL = Address In Table
         POP  iy                        ; IY=Location In Look Up Table Sprite N
         RET  
sproing                                 ; Sproing That Boingy Nose !
         LD   l,(ix+0)
         LD   h,(ix+2)
         CALL calcbyte
         INC  hl
         LD   (spnose),hl
         DEC  hl
         CALL calcdwn
         CALL calcdwn
         CALL calcdwn
         CALL calcdwn
         LD   (spring),hl
         LD   hl,15*5+sprdata
         PUSH hl
         POP  ix
         LD   l,(ix+0)
         LD   h,(ix+1)
         LD   de,sprdata+#100
         ADD  hl,de
         LD   (nosedata),hl
         LD   (nosed1),hl
         LD   l,(ix+5)
         LD   h,(ix+6)
         ADD  hl,de
         LD   (springd),hl
         LD   h,(ix+3)
         LD   l,(ix+4)
         LD   (nosed),hl
         LD   (noseda),hl
         LD   h,(ix+8)
         LD   l,(ix+9)
         LD   (spd),hl
         LD   a,#ae
         LD   (fastx),a
         LD   a,8                       ; Main Loop Counter
mainloop
         PUSH af
         LD   hl,(spnose)
         LD   de,4
         ADD  hl,de
         LD   (spnose),hl
         LD   (back1a),hl
         LD   hl,0                      ; Screen Address To Place Spring
spring   EQU  $-2
         LD   de,0
springd  EQU  $-2
         LD   bc,0                      ; Dimensions For Springs.
spd      EQU  $-2
         CALL fast1                     ; Switch In Sprite Fast !
         CALL #bd19                     ; Framefly Back
         CALL putnose
         CALL #bd19
         CALL putnose
         LD   hl,(spring)
         LD   de,4
         ADD  hl,de
         LD   (spring),hl
         POP  af
         DEC  a
         JR   nz,mainloop
         CALL putnose
         LD   a,9                       ; Spring Back !
back1
         PUSH af
         CALL #bd19
         LD   hl,0
back1a   EQU  $-2
         LD   de,0
nosed1   EQU  $-2
         LD   bc,0
noseda   EQU  $-2
         PUSH bc
         PUSH de
         PUSH hl
         CALL fast1
         POP  hl
         LD   de,4
         AND  a
         SBC  hl,de
         POP  de
         POP  bc
         LD   (back1a),hl
         CALL fastor
         CALL #bd19
         POP  af
         DEC  a
         JR   nz,back1
         RET  
putnose
         LD   hl,0
spnose   EQU  $-2
         LD   de,0
nosedata EQU  $-2
         LD   bc,0
nosed    EQU  $-2
         JP   fast1
Fastor
         CP   3
         RET  nz
         LD   a,1
         JR   fasts
fastxor
         LD   a,#ae
         JR   fastx3
fast
         CP   3
         RET  nz
         XOR  a
fastx3
         LD   (fastx),a
fasts
         LD   (fastt),a
         LD   l,(ix+0)
         LD   h,(ix+2)
         CALL calcbyte
         PUSH hl
         CALL getspra
         LD   a,(iy+2)
         DEC  a
         JP   nz,maskingo               ; Check Sprite Is Type 1
         LD   b,(iy+3)
         LD   c,(iy+4)
         LD   l,(iy+0)
         LD   h,(iy+1)
         LD   de,sprdata+#100
         ADD  hl,de
         EX   de,hl                     ; DE=Location
         POP  hl                        ; HL=SCR ADDR
         LD   a,0
fastt    EQU  $-1
         DEC  a
         JR   z,fastor
fast1
         PUSH bc
         PUSH hl
fast2
         LD   a,(de)
fastx    XOR  (hl)                      ; Fast XOR !
         LD   (hl),a
         INC  hl
         INC  de
         DJNZ fast2
         POP  hl
         CALL calcdwn
         POP  bc
         DEC  c
         JR   nz,fast1
         RET  
fastor
         PUSH bc
         PUSH hl
fastor2
         LD   a,(de)
         OR   a
         JR   z,fastor3
         LD   c,a
         AND  #aa
         JR   nz,fasto4
         LD   a,c
         AND  #55
         LD   c,a
         LD   a,(hl)
         AND  #aa
         OR   c
         LD   c,a
fasto4
         LD   (hl),c
fastor3
         INC  hl
         INC  de
         DJNZ fastor2
         POP  hl
         CALL calcdwn
         POP  bc
         DEC  c
         JR   nz,fastor
         RET  
sprites
         DI   
         CP   3
         RET  nz
user                                    ; User Entry Point
;
getaddr                                 ; Get Address Of Sprite From Table
         CALL getspra
         LD   l,(iy+0)
         LD   h,(iy+1)                  ; HL = Offset Of Data
numit
         LD   de,sprdata+#100
         ADD  hl,de                     ; HL Points To Address Of Graphic.
         LD   b,(iy+2)                  ; Determine How Sprite Stored
         LD   a,b
         AND  #80
         LD   (mirror),a                ; Set Mirror Imageing Flag
         LD   a,(iy+3)
         LD   (width),a                 ; Store Width
         LD   (width1),a
         LD   a,(iy+4)
         LD   (height),a                ; Store Height
         LD   (height1),a
;
         LD   a,b
         AND  #3f
         CP   1                         ; 1 = Standard Format X, Y
         JR   z,laydown
         CP   2                         ; 2 = Horizontally Compressed
         JR   z,cmphrz
         CP   3                         ; 3 = Vertically Compressed
         JR   z,cmpvrt
         RET                            ; Undetermined Type
cmpvrt                                  ; Decompress And Plot Vertical Data
         PUSH hl
         LD   hl,vrtpb
         LD   (decomp1),hl
         LD   (decomp2),hl
         JR   cmphrz1
cmphrz
         PUSH hl
         LD   hl,hrzpb
         LD   (decomp1),hl
         LD   (decomp2),hl
cmphrz1
         POP  hl
         CALL parms                     ; Set Up Widths Etc
         LD   iy,counter
cmphrzl                                 ; Loop
         LD   a,(de)
         OR   a
         RET  z                         ; If Zero End Of Compressed Data
         BIT  7,a
         JR   nz,cmphrzr                ; Repeat Bytes
;
         LD   (iy+0),a
         INC  de
cmphrzs1
         LD   a,(de)
         INC  de
         CALL hrzpb
decomp2  EQU  $-2
         DEC  (iy+0)
         JR   nz,cmphrzs1
         JR   cmphrzl
cmphrzr
         AND  #7f
         LD   (iy+0),a
         INC  de
cmphrzr1
         LD   a,(de)
         CALL hrzpb
decomp1  EQU  $-2
         DEC  (iy+0)
         JR   nz,cmphrzr1
         INC  de
         JR   cmphrzl
;
hrzpb                                   ; Horizontal Put Bytes
         CALL putbyteh
         DEC  b
         RET  nz
         LD   b,0
width1   EQU  $-1
         LD   h,(ix+2)
         JR   updy
;
vrtpb                                   ; Horizontal Put Bytes
         CALL putbytev
         DEC  c
         RET  nz
         LD   c,0
height1  EQU  $-1
         LD   l,(ix+0)
         DEC  b
         JR   updx
parms
         EX   de,hl                     ; DE = Location Of Data
         LD   l,(ix+0)                  ; L = Y Address
         LD   h,(ix+2)                  ; E = X Address
         LD   bc,0
width    EQU  $-1                       ; Width Of Sprite
height   EQU  $-2                       ; Height Of Sprite
         RET  
laydown                                 ; Print Sprite On Screen At Location
         CALL parms
laydown1
         PUSH bc
laydown2
         LD   a,(de)
         INC  de
         CALL putbyteh
         DJNZ laydown2
         POP  bc
         LD   h,(ix+2)
         CALL updy
         DEC  c
         JR   nz,laydown1
         RET  
updy
         LD   a,(SIZE2H)
         INC  a
         ADD  a,l
         LD   l,a
         RET  
;
putbyteh                                ; Put Byte Onto Screen
         PUSH hl
         PUSH de
         PUSH bc
         PUSH af
         CALL calcbyte                  ; Calculate Adress To Put Byte
         POP  af                        ; Restore byte
         POP  bc                        ; Restore Width Temporarily
         PUSH bc
         CALL doublew                   ; Double Width Byte ?
         POP  bc
         POP  de
         POP  hl
updx                                    ; Update On X Position
         LD   a,(SIZE2W)
         INC  a
         ADD  a,h
         LD   h,a
         RET  
;
putbytev                                ; Put Byte Vertically On Screen
         PUSH hl
         PUSH de
         PUSH bc
         PUSH af
         CALL calcbyte                  ; Calculate Adress To Put Byte
         POP  af                        ; Restore byte
         POP  bc                        ; Restore Width Temporarily
         PUSH bc
         CALL doublew                   ; Double Width Byte ?
         POP  bc
         POP  de
         POP  hl
         JR   updy
;
doublew                                 ; Byte Is Double Width
         CALL masking                   ; Does Byte Need Masking?
         PUSH af
         LD   a,0
SIZE2W   EQU  $-1
         OR   a
         JR   nz,doublew1
         POP  af
         CALL writhl                    ; If Single Place Byte
         CALL dbldwn                    ; Double If Bytes Height*2
         JR   mirr
doublew1
         POP  af
         LD   e,a
         AND  #aa                       ; Get Left Bit
         LD   c,a
         RRA  
         OR   c                         ; Make Solid Bits
         CALL writhl
         CALL dbldwn                    ; If Double Height Next Byte Down
         CALL mirr                      ; Mirror Byte If Needed
         INC  hl
         LD   a,e
         AND  #55
         LD   e,a
         RLA  
         OR   e
         CALL writhl
         CALL dbldwn
         DEC  hl
         DEC  hl
         JR   mirr
dbldwn
         PUSH af
         LD   a,0
SIZE2H   EQU  $-1
         OR   a
         JR   z,dbldwn2
         POP  af
         PUSH hl
         CALL calcdwn
         CALL writhl
         POP  hl
         RET  
dbldwn2
         POP  af
         RET  
writhl                                  ; Write HL To Screen From Screen!
         PUSH af
         PUSH bc
         LD   b,a
         LD   a,3
sprmode1 EQU  $-1                       ; Write Byte Style
         OR   a
         JR   z,writhl1
         DEC  a
         JR   z,writhl2
writehl3                                ; OVERLAY
         LD   c,(hl)
         LD   a,b
         OR   a
         JR   z,writhlq                 ; Quit If Null Byte
         AND  #aa
         JR   nz,writhl3a
         LD   a,c
         AND  #aa
         OR   b
         LD   b,a
writhl3a
         LD   a,b
         AND  #55
         JR   nz,writhl1
         LD   a,c
         AND  #55
         OR   b
         LD   b,a
writhl1                                 ; Force Byte
         LD   (hl),b
writhlq
         POP  bc
         POP  af
         RET  
writhl2                                 ; XOR Byte With Screen
         LD   a,b
         XOR  (hl)
         LD   (hl),a
         POP  bc
         POP  af
         RET  
calcdwn                                 ; Calculate Next Physical Byte Down
         PUSH af
         LD   a,8
         ADD  a,h
         JR   nc,calcdwn1
         LD   a,#50
         ADD  a,l
         LD   l,a
         LD   a,#c8
         ADC  a,h
calcdwn1
         OR   #c0
         LD   h,a
         POP  af
         RET  
mirr                                    ; Mirror Image Byte And Place
         PUSH af
         LD   a,0
mirror   EQU  $-1
         OR   a
         JR   z,dbldwn2
         POP  af
         PUSH hl
         PUSH de
         PUSH bc
         LD   c,a
         LD   a,b                       ; B = Width Counter Of Sprite
         INC  a
         ADD  a,a
         LD   e,a
         LD   a,(SIZE2W)
         OR   a
         JR   z,mirr2
         LD   a,e
         ADD  a,a
         LD   e,a
mirr2
         LD   a,(SIZE2W)
         INC  a
         ADD  a,a
         INC  a
;ADD  a,a
         LD   d,a
         LD   a,e
         SUB  d
         LD   e,a
         LD   d,0
         ADD  hl,de                     ; HL = HL + (B * 2)
         LD   a,c
         LD   b,c                       ; Reverse MODE 0 Bits   12121212
         AND  #aa
         RRA  
         LD   c,a
         LD   a,b
         AND  #55
         RLA  
         OR   c
         CALL writhl                    ; Write To Screen
         CALL dbldwn                    ; Double Byte Down If Must
         POP  bc
         POP  de
         POP  hl
         RET                            ; Exit With HL In Tact
sprmode                                 ; Set Sprite Mode
         DEC  a
         RET  nz
         LD   a,(ix+0)
         AND  3
         LD   (sprmode1),a              ; Write Sprite Mode
         RET  
double
         LD   a,1
         JR   single1
single                                  ; Cancel All Sizes So Single Height * W
         XOR  a
single1
         LD   (SIZE2W),a
         LD   (SIZE2H),a
         RET  
masking                                 ; Mask Byte If Necessary
         PUSH af
         LD   a,0
mask     EQU  $-1
         OR   a
         JR   z,maskingo                ; Quit
         DEC  a
         JR   nz,mask1
         POP  af
         AND  0
maskink  EQU  $-1
         RET  
maskingo
         POP  af
         RET  
mask1                                   ; Swap Coloured Inks
         POP  af
         PUSH bc
         CALL mask2
         LD   a,b
         RLCA 
         CALL mask2
         LD   a,b
         RRCA 
         POP  bc
         RET  
mask2
         LD   b,a
         AND  #aa
         CP   0
mask2o   EQU  $-1
         RET  nz
         LD   a,b
         AND  #55
         OR   0
mask2ni  EQU  $-1                       ; New Ink
         LD   b,a
         RET  
mon                                     ; Masking On
         LD   a,2
mon1
         LD   (mask),a
         RET  
moff
         XOR  a
         JR   mon1
mi                                      ; Maskinks |MI,oldink,newink
         CP   2
         RET  nz
         LD   a,(ix+0)
         CALL #bc2c
         AND  #aa
         LD   (mask2o),a
         LD   a,(ix+2)
         CALL #bc2c
         AND  #aa
         LD   (mask2ni),a
         RET  
;
calcbyte                                ; Entry L=Row (0-199) , E=Column (0-79)
         LD   e,h
         LD   h,0
         LD   a,l
         AND  7
         ADD  a,a
         ADD  a,a
         ADD  a,a
         SRL  l
         SRL  l
         SRL  l
         LD   c,a
         LD   a,l
         ADD  a,a
         ADD  a,a
         ADD  a,l
         ADD  a,a
         LD   l,a
         ADD  hl,hl
         ADD  hl,hl
         ADD  hl,hl
         LD   a,c
         ADD  a,h
         OR   #c0
         LD   h,a
         LD   a,e
         ADD  a,l
         LD   l,a
         ADC  a,h
         SUB  l
         OR   #c0
         LD   h,a
         RET  
tip                                     ; |TIP,ink,paper
         CP   2
         RET  nz
         CALL settp1
         LD   a,(ix+2)
         JR   stxtpen
setxtpen                                ; Set Text Pen From Basic
         DEC  a
         RET  nz
         LD   a,(ix+0)
stxtpen
         LD   (penink),a
         CALL #bc2c
         LD   (maskink),a
         RET  
settp                                   ; Set Text Paper From Basic
         DEC  a
         RET  nz
settp1
         LD   a,(ix+0)
         LD   (paperink),a
         RET  
barstr                                  ; Get String Length |STRLEN,@len%,@a$
         DI   
         CP   2
         RET  nz
         CALL strlen
         LD   l,(ix+2)
         LD   h,(ix+3)
         LD   (hl),a
         RET  
strlen
         LD   l,(ix+0)
         LD   h,(ix+1)
         LD   a,(hl)
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)                    ; Get Location Of Message
         OR   a
         RET  z                         ; Quit If No Message
         LD   c,a                       ; Preserve Length Counter
         DEC  a
         JR   z,strlen6                 ; Quit Addition Of Gaps If Only 1 Char
         LD   b,a                       ; Length Of ASCII Message
         CALL gspcwid
strlen3
         LD   l,a
         XOR  a
strlen4
         ADD  a,l
         DJNZ strlen4
strlen6
         LD   (spcwid),a                ; Store space Width
         LD   b,c                       ; Restore Width Counter
         LD   c,0                       ; RESET WIDTH COUNTER
strlen1
         LD   a,(de)                    ; Get ASCII Char
         CALL getlen                    ; Get Width Of Character
         DEC  a
         ADD  a,c                       ; Sum To Existing Counter
         LD   c,a                       ; C = Total Length
         INC  de
         DJNZ strlen1                   ; Loop For Message
         LD   a,(cwidth)
         LD   b,a
         XOR  a
strlen2                                 ; WIDTH * CHARACTER WIDTH
         ADD  a,c
         DJNZ strlen2
         ADD  a,0                       ; + SPACE WIDTH
spcwid   EQU  $-1
         RET                            ; Exit With A = String Length
gspcwid                                 ; Get Width Of Spaces Between Letters
         LD   a,(cwidth)                ; Determin Width Of Gap Of
         SRL  a                         ; Spaces
         AND  a
         RET  nz
         INC  a
         RET  
central                                 ; Centralise Proportional Text Around P
         CP   3
         RET  nz
         DI   
         CALL strlen
         SRL  a                         ; Half Total Width
         LD   c,a
         JR   nc,central7
         LD   a,(ix+4)
         AND  1
         JR   z,central7
         INC  (ix+4)
central7
         LD   a,(ix+4)                  ; Get X to Centre Around
         SUB  c                         ; (X = Pivot-Length)
         JR   nc,central5               ; Centralize If No Wrap
         XOR  a                         ; Set X Counter To _
central5
         LD   (ix+4),a
text                                    ; Proportional Character Printing.
         DI   
         CALL calctad
text1
         PUSH bc
         PUSH hl
         LD   a,(hl)
         CALL char
         POP  hl
         POP  bc
         INC  hl
         DJNZ text1
         RET  
indv                                    ; Individual Chars Between Interrupts !
         CALL calctad
         LD   (messg),hl                ; Store Message Pointer
         LD   a,b
         LD   (mssgc),a                 ; Store Message Length
         RET  
talk                                    ; Print Each Character As Is
         DEC  a
         RET  nz
         LD   l,(ix+0)
         LD   h,(ix+1)
         LD   a,(mssgc)
         LD   (hl),a                    ; Return Length Left To BASIC
         OR   a
         RET  z                         ; Quit If No More Messages To Print
         DEC  a
         LD   (mssgc),a                 ; Store New Message Counter
         LD   hl,(messg)                ; Get Address Of Message
         LD   a,(hl)                    ; Get ASCII Char From A$
         PUSH hl                        ; Preserve Pointer
         CALL char                      ; Print Proportional Character
         POP  hl
         INC  hl
         LD   (messg),hl
         RET  
;
calctad                                 ; Calculate Text Address From | Command
         LD   l,(ix+2)
         LD   a,(ix+4)
         RRA  
         LD   h,a
         LD   a,0
         ADC  a,0
         LD   (nshift),a
         LD   (shift),a
         CALL calcbyte
         LD   (ascraddr),hl
         LD   l,(ix+0)
         LD   h,(ix+1)
         LD   b,(hl)
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         EX   de,hl                     ; HL = Address Of String To Print
         RET  
;
char                                    ; Display Character
         LD   hl,(ascraddr)
         LD   (scraddr),hl              ; Screen Address To Place Char
         LD   (oscraddr),hl
         CALL getlen                    ; Get Location Of Character And Width
         LD   b,a
         LD   a,(nshift)
         LD   (shift),a
         LD   (oshift),a
         PUSH bc
         PUSH de
         PUSH hl
         LD   c,b
         LD   a,(cwidth)
         LD   b,a
         DEC  c
         XOR  a
charx
         ADD  a,c
         DJNZ charx
;SRA  a
         LD   e,a
         CALL gspcwid
         ADD  a,e
         SRL  a
         LD   e,a
         LD   a,(oshift)
         JR   nc,charx1
         LD   a,(oshift)
         XOR  1
         JR   nz,charx1
         INC  e
charx1
         LD   d,0
         LD   hl,(ascraddr)
         ADD  hl,de
         LD   (ascraddr),hl
         LD   (nshift),a
         POP  hl
         POP  de
         POP  bc
         LD   a,(penink)
         CALL #bc2c
         LD   (wpen),a
         LD   a,(paperink)
         CALL #bc2c
         LD   (wpaper),a
         LD   a,(shift)
         LD   (oshift),a                ; Preserve shifted bit state.
         LD   c,8
char1
         PUSH hl
         PUSH bc
         LD   a,(hl)
char2
         RLCA 
         PUSH af
         CALL c,charpen                 ; Plot in pen if point
         CALL nc,chrpaper               ; Plot in paper if no point
         POP  af
         DJNZ char2
         INC  de                        ; Point DE to next character
         LD   a,(oshift)
         LD   (shift),a                 ; Restore Old Shift State
         LD   a,(cheight)               ; Get proportion height
         LD   b,a
         LD   hl,(oscraddr)             ; Get original Screen address
char3
         CALL calcdwn
         DJNZ char3                     ; Calculate Next proportionate address 
         LD   (scraddr),hl
         LD   (oscraddr),hl
         POP  bc
         POP  hl
         INC  hl
         DEC  c                         ; Loop For Full Character.
         JR   nz,char1
         RET  
chrpaper
         LD   a,(wpaper)
         LD   (maskit),a
         JR   plotdot
charpen                                 ; Display Point In Pen Colour.
         LD   a,(wpen)
         LD   (maskit),a
plotdot
         PUSH af
         PUSH bc
         PUSH de
         PUSH hl
         LD   b,1
cwidth   EQU  $-1                       ; Self Modifying Width Count
charpenl
         PUSH bc
         LD   hl,#c000                  ; Self Modigying Screen Address
scraddr  EQU  $-2
         LD   c,0                       ; Contains Encoded In In Which To PLot
maskit   EQU  $-1
         LD   a,0                       ; Self Modifying SHIFT Register
shift    EQU  $-1
         LD   d,#aa                     ; Mask Bit
         OR   a                         ; Is To Be SHIFTED ?
         JR   z,charpen1
         LD   d,#55
charpen1
         LD   a,c
         AND  d
         LD   c,a                       ; Get Appropriate Bit To Plot
         LD   a,d
         XOR  #ff                       ; Reverse Mask For Printing
         LD   d,a
;
         LD   a,(cheight)
         LD   b,a
chrpdl
         LD   a,(hl)
         AND  d
         OR   c
         LD   (hl),a                    ; Plot the point (Finally)
         CALL calcdwn
         DJNZ chrpdl
         LD   a,(shift)
         XOR  1
         LD   (shift),a
         JR   nz,charpen2
         LD   hl,(scraddr)
         INC  hl
         LD   (scraddr),hl
charpen2
         POP  bc
         DJNZ charpenl
         POP  hl
         POP  de
         POP  bc
         POP  af
         RET  
getlen                                  ; Get width of ASCII Char (32 -> 122)
         PUSH bc                        ; Entry A=Ascii Char To Print
         PUSH de
         SUB  32
         PUSH af
         LD   l,a
         LD   h,0
         ADD  hl,hl
         ADD  hl,hl
         ADD  hl,hl                     ; HL = Offset into CHARACTER Matrix
         LD   de,matrix
         ADD  hl,de                     ; HL Points To Char
         POP  af
         PUSH hl
         LD   e,a
         RRA  
         LD   l,a
         LD   h,0
         LD   bc,pctable
         ADD  hl,bc
         LD   a,e
         RRA  
         LD   a,(hl)
         JR   c,getlen1
         RRCA 
         RRCA 
         RRCA 
         RRCA 
getlen1
         AND  #0f
         POP  hl                        ; HL = Address Of character in matrix
         POP  de
         POP  bc
         RET  
texth                                   ; Set Text Height
         DEC  a
         RET  nz
         LD   a,(ix+0)
texth1
         OR   a
         RET  z
         LD   (cheight),a
         RET  
textw
         DEC  a
         RET  nz
textw1
         LD   a,(ix+0)
         OR   a
         RET  z                         ; Can not allow 0 Width
         LD   (cwidth),a
         RET  
texthw                                  ; Combined Text Height Width
         CP   2
         RET  nz
         CALL textw1
         LD   a,(ix+2)
         JR   texth1
setinks                                 ; Set Inks
         PUSH ix
         PUSH ix
         LD   bc,0
         CALL #bc38
         LD   ix,inkt0a
         LD   a,16
         LD   (li),a
         XOR  a
si1
         CALL seti2
         POP  ix
         LD   a,(ix+0)
         LD   b,a
         ADD  a,a
         ADD  a,b
         ADD  a,a
         LD   e,a
         LD   d,0
         LD   hl,inkt0
         ADD  hl,de
         PUSH hl
         POP  ix
         LD   a,6
         LD   (li),a
         XOR  a
         CALL seti2
         POP  ix
         RET  
seti2
         LD   b,(ix+0)
         LD   c,b
         PUSH af
         CALL #bc32
         POP  af
         INC  ix
         INC  a
         CP   16
li       EQU  $-1
         JR   nz,seti2
         RET  
blank
         LD   bc,0
         CALL #bc38
         XOR  a
blank1
         LD   bc,0
         PUSH af
         CALL #bc32
         POP  af
         INC  a
         CP   16
         JR   nz,blank1
         RET  
;
reset                                   ; RESET Graphics VDU Drivers
         LD   de,0
         LD   l,e
         LD   h,l
         CALL #bbc9                     ; Reset Graphics Origin.
         CALL #bbba                     ; GRA INITIALISE - Init Graphic Drivers
         JP   #bbbd                     ; GRA RESET - Reset graphics drivers
gpen                                    ; Set Graphics Pen To Colour In IX
         DEC  a
         RET  nz
         LD   a,(ix+0)
         JP   #bbde                     ; Set Graphics Pen
gpaper                                  ; Set Graphics Backgounf Paper
         DEC  a
         RET  nz
         LD   a,(ix+0)
         JP   #bbe4
gcol                                    ; Try And Emulate BBC's GCOL Command.
         DEC  a
         DEC  a
         RET  nz
         LD   a,(ix+2)                  ; Gets Graphics Write Option
         CP   4
         JR   z,gcol4                   ; Invert Paper & Pen
         AND  3
         OR   a
         LD   e,0
         JR   z,gcol1
         DEC  a
         LD   e,#ae
         JR   z,gcol1
         DEC  a
         LD   e,#a6
         JR   z,gcol1
         DEC  a
         LD   e,#b6
gcol1
         LD   a,e
         LD   (code),a
         LD   a,(ix+2)
         LD   c,a                       ; Swap 3->1 and 1->3 To Make Comp. BBC
         AND  1
         RLA  
         XOR  c
         CALL #bc59                     ; Set Screen Access Rights
         LD   a,(ix+0)                  ; Get Colour Number !
         BIT  7,a
         JP   nz,#bbe4                  ; Set Paper COLOUR
         JP   #bbde                     ; Set Graphics Pen Colour
gcol4
         CALL #bbe1
         LD   b,a
         CALL #bbe7
         CALL #bbde
         LD   a,b
         JP   #bbe4
clg                                     ; BBC CLG - Including Xored Modes !!!
;
         CP   4
         RET  nz
;
         LD   l,(ix+0)
         LD   h,(ix+1)                  ; DE = Y2
         LD   e,(ix+4)
         LD   d,(ix+5)                  ; HL = Y1
         LD   (starty),hl
         AND  a
         SBC  hl,de
         LD   a,l
         SRL  h
         RRA  
         OR   a
         RET  z
         LD   (counth),a
         LD   l,(ix+2)
         LD   h,(ix+3)
         LD   e,(ix+6)
         LD   d,(ix+7)
         LD   (startx),de
         AND  a
         SBC  hl,de
         INC  hl
         LD   a,l
         SRL  h
         RRA  
         SRL  h
         RRA  
         SRL  h
         RRA  
;SRL  h                         ; Were 
;RRA                            ; HL/16
         INC  a
         LD   (count),a
         CALL #bbe7
         CALL #bc2c
         LD   (ink),a
         LD   hl,0
starty   EQU  $-2
         LD   a,l
         SRL  h
         RRA  
         LD   l,a
         LD   de,0
startx   EQU  $-2
         LD   a,e
         SRL  d
         RRA  
         SRL  d
         RRA  
         LD   e,a
         CALL #bc1d
clg1
         LD   b,0
counth   EQU  $-1
clg2
         LD   c,0
count    EQU  $-1
         PUSH bc
         PUSH hl
clg3
         LD   a,0
ink      EQU  $-1
         XOR  (hl)
code     EQU  $-1
         LD   (hl),a
         INC  hl
         SET  7,h
         SET  6,h
         DEC  c
         JR   nz,clg3
         POP  hl
         LD   a,h
         ADD  a,8
         JR   nc,clg4
         LD   a,#50
         ADD  a,l
         LD   l,a
         LD   a,h
         ADC  a,#c8
clg4
         OR   #c0
         LD   h,a
         POP  bc
         DJNZ clg2
         RET  
;
gmode                                   ; Change Graphics Mode - Compatible 464
         DEC  a
         RET  nz
         LD   a,(ix+0)
         JP   #bc59                     ; Set Screen Access Rights
box                                     ; Draw A Box On The Screen !
         CP   4
         RET  nz
         LD   l,(ix+0)
         LD   h,(ix+1)
         LD   (Xwidth),hl
         PUSH hl
         LD   l,(ix+2)
         LD   h,(ix+3)
         LD   (Yheight),hl
         LD   l,(ix+4)
         LD   h,(ix+5)
         LD   (Ybox),hl                 ; HL = Y Co-Ordinate
         LD   e,(ix+6)
         LD   d,(ix+7)
         LD   (Xbox),de                 ; DE = X Co-ordinate
         PUSH hl
         PUSH de
         CALL #bbc0                     ; Move To XY Position.
         POP  de
         POP  hl
         POP  bc
         EX   de,hl
         ADD  hl,bc
         EX   de,hl                     ; Add X Offset
         CALL drawline
         LD   bc,(Yheight)
         ADD  hl,bc                     ; Add Y Offset -> X+x1 , Y+y1
         CALL drawline
         LD   bc,(Xwidth)
         EX   de,hl
         AND  a
         SBC  hl,bc
         EX   de,hl                     ; Subtract X Offset -> X,Y+y1
         CALL drawline
         LD   hl,(Ybox)                 ; Draw Back to X , Y
drawline
         PUSH hl
         PUSH de
         CALL #bbf6                     ; 82: GRA LINE ABSOLUTE
         POP  de
         POP  hl
         RET  
Xwidth   DEFW 0
Yheight  DEFW 0
Ybox     DEFW 0
Xbox     DEFW 0
;
;
pctable  EQU  sprdata+#d0
;
Jcwidth  DEFB 1                         ; Scaling Width Of character to plot
cheight  DEFB 1                         ; Scaling height of character to plot
penink   DEFB 13                        ; User Defined PEN Colour 0-15
paperink DEFB 0                         ; User Defined PAPER Colour 0-15
wpen     DEFB 0                         ; Calculated Pen Mask ENCODED
wpaper   DEFB 0                         ; Calculated Paper Mask ENCODED
Jscraddr DEFW #c000                     ; Address Where To Place Character
oscraddr DEFW #c000                     ; Old Address Where To Place Character
ascraddr DEFW #c000                     ; May not be needed yet
;
Jshift   DEFB 0                         ; Shift BIT plot flag
oshift   DEFB 0                         ; OLD Shift BIT plot flag
nshift   DEFB 0
counter  DEFB 0
matrix   EQU  #9fa1
inkt0a
         DEFB 0,26,2,15,24,25
         DEFB 23,6,13,11,15,16,18,7,4,3
inkt0
         DEFB 0,26,2,15,24,25
inkt1                                   ; Ink Table 1
         DEFB 0,26,16,2,1,24
inkt2
         DEFB 0,26,15,2,1,24
inkt3
         DEFB 0,26,5,8,25,24
inkt4
         DEFB 0,26,5,21,12,24
coinhgt                                 ; Coin Heights Starting With 1P ->
         DEFB 21,29,17,33,23,35,29,37
mssgc    DEFB 0                         ; Message Counter
messg    DEFW 0                         ; Pointer For Message In BASIC Variable
spon     EQU  #be82
work     DEFS 4,0                       ; RSX 4 Byte Work Table
rsxtable DEFW comms
         JP   sprites
         JP   texth
         JP   textw
         JP   setxtpen                  ; Set Pen Inks[
         JP   settp                     ; Set TEXT Paper
         JP   text                      ; Write String
         JP   double
         JP   single
         JP   setinks
         JP   gcol
         JP   gpaper
         JP   gpen
         JP   reset
         JP   clg
         JP   gmode
         JP   box
         JP   central
         JP   blank
         JP   numbers
         JP   coin
         JP   talk
         JP   indv
         JP   texthw
         JP   sprmode
         JP   barstr
         JP   tip
         JP   mon
         JP   moff
         JP   mi
         JP   fast
         JP   fastxor
         JP   Fastor
         JP   sproing
         JP   speech
         JP   SPON
         JP   SPOFF
;
comms                                   ; Added BASIC Commands
         DEFM SP
         DEFB "R"+#80
         DEFM TEXT
         DEFB "H"+#80
         DEFM TEXT
         DEFB "W"+#80
         DEFM TIN
         DEFB "K"+#80
         DEFM TPAPE
         DEFB "R"+#80
         DEFM TEX
         DEFB "T"+#80
         DEFM DB
         DEFB "L"+#80
         DEFM SG
         DEFB "L"+#80
         DEFM INKSE
         DEFB "T"+#80
commands DEFM GCO
         DEFB "L"+#80
         DEFM GPAPE
         DEFB "R"+#80
         DEFM GPE
         DEFB "N"+#80
         DEFM RESE
         DEFB "T"+#80
         DEFM CL
         DEFB "G"+#80
         DEFM GMOD
         DEFB "E"+#80
         DEFM BO
         DEFB "X"+#80
         DEFM CE
         DEFB "N"+#80
         DEFM BLAN
         DEFB "K"+#80
         DEFM NU
         DEFB "M"+#80
         DEFM COI
         DEFB "N"+#80
         DEFM TAL
         DEFB "K"+#80
         DEFM TSE
         DEFB "T"+#80
         DEFM TH
         DEFB "W"+#80
         DEFB "S","M"+#80
         DEFM SLE
         DEFB "N"+#80
         DEFM TI
         DEFB "P"+#80
         DEFM MO
         DEFB "N"+#80
         DEFM MOF
         DEFB "F"+#80
         DEFB "M","I"+#80
;
         DEFM FAS
         DEFB "T"+#80
;
         DEFM FXO
         DEFB "R"+#80
;
         DEFM FO
         DEFB "R"+#80
         DEFM SPROIN
         DEFB "G"+#80
         DEFM SPEEC
         DEFB "H"+#80
         DEFM SPO
         DEFB "N"+#80
         DEFM SPOF
         DEFB "F"+#80
;
         DEFB 0
;
finish
