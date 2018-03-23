;
         ORG  #1000                     ; SPRITE HANDLING ROUTINES
start                                   ; Written By Jason Brooks
         ENT  $                         ; (C) 1992 JacesofT Software
sprdata  EQU  #2000                     ; Graphics Table Address
jb
         XOR  a
         CALL #bc0e
         CALL test1
         LD   a,1
         LD   (SIZE2W),a
         CALL test1
         LD   a,1
         LD   (SIZE2H),a
         CALL test1
         XOR  a
         LD   (SIZE2W),a
test1
         CALL test
         JP   #bb18
test
         LD   ix,#bf00
         LD   a,1
         LD   b,2
         LD   c,40
         LD   (ix+0),c
         LD   (ix+2),b
         LD   (ix+4),a
user                                    ; User Entry Point
         LD   a,(ix+4)
;
getaddr                                 ; Get Address Of Sprite From Table
         LD   b,a                       ; Calculate Loaction In Sprite
         ADD  a,a                       ; Address Table Where Sprite Info
         ADD  a,a                       ; Is.  BYTE 0 = LSB Offset
         ADD  a,b                       ; BYTE 1 = MSB Offset, BYTE 2 = Storage
         LD   l,a                       ; Byte 3 = Width, Byte 4 = Height
         LD   h,sprdata/256
         PUSH hl                        ; HL = Address In Table
         POP  iy                        ; IY=Location In Look Up Table Sprite N
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
         LD   l,(iy+0)
         LD   h,(iy+1)                  ; HL = Offset Of Data
         LD   de,sprdata+#100
         ADD  hl,de                     ; HL Points To Address Of Graphic.
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
         PUSH af
         LD   a,0
SIZE2W   EQU  $-1
         OR   a
         JR   nz,doublew1
         POP  af
         LD   (hl),a                    ; If Single Place Byte
         CALL dbldwn                    ; Double If Bytes Height*2
         JR   mirr
doublew1
         POP  af
         LD   e,a
         AND  #aa                       ; Get Left Bit
         LD   c,a
         RRA  
         OR   c                         ; Make Solid Bits
         LD   (hl),a
         CALL dbldwn                    ; If Double Height Next Byte Down
         CALL mirr                      ; Mirror Byte If Needed
         INC  hl
         LD   a,e
         AND  #55
         LD   e,a
         RLA  
         OR   e
         LD   (hl),a
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
         LD   (hl),a
         POP  hl
         RET  
dbldwn2
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
         LD   (hl),a                    ; Write To Screen
         CALL dbldwn                    ; Double Byte Down If Must
         POP  bc
         POP  de
         POP  hl
         RET                            ; Exit With HL In Tact
double
         CALL size2h
size2w                                  ; Size2 Width Routine
         LD   a,1
         LD   (SIZE2W),a
         RET  
size2h                                  ; Double Height Sprite
         LD   a,1
         LD   (SIZE2H),a
         RET  
single                                  ; Cancel All Sizes So Single Height * W
         CALL size1h
size1w                                  ; Single Width Sprite
         XOR  a
         LD   (SIZE2W),a
         RET  
size1h                                  ; Single Height Sprite
         XOR  a
         LD   (SIZE2W),a
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
counter  DEFB 0
;
finish
