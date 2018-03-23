
;
         ORG  #9000                     ; Sprite Compressor
         ENT  $                         ; Chooses best compression ratio
         DI                             ; Sprite Compiler For MONEY MATTERS
         LD   sp,#bff8                  ; Written By Jason Brooks
         LD   bc,#7fc0                  ; (C) 1992 JacesofT Software
         OUT  (c),c
         XOR  a
         CALL #bc0e
         LD   hl,#ff
         LD   a,(hl)
         LD   (hl),#ff
         OR   a
         JR   z,loaditin
         DI   
         LD   bc,#7fc5
         OUT  (c),c
         LD   hl,#4000
         LD   de,#c000
         LD   bc,#3fff
         LDIR 
         LD   bc,#7fc0
         OUT  (c),c
         EI   
         JR   jace
loaditin
         LD   hl,name
         LD   b,len
         CALL #bc77
         LD   hl,#c000
         CALL #bc83
         CALL #bc7a
         DI   
         LD   bc,#7fc5
         OUT  (c),c
         LD   hl,#c000
         LD   de,#4000
         LD   bc,#3fff
         LDIR 
         LD   bc,#7fc0
         OUT  (c),c
jace
         DI   
         PUSH iy
         PUSH ix
         LD   iy,#2000
         LD   de,#2100                  ; Location To Place Comp. Data
         LD   b,1
         LD   c,108
         LD   l,8
         LD   a,118
         CALL table
         LD   b,0
         LD   c,119
         LD   l,4
         LD   a,142
         CALL table
         LD   b,11
         LD   c,108
         LD   l,15
         LD   a,142
         CALL table
         LD   b,22
         LD   c,108
         LD   l,26
         LD   a,143
         CALL table
         LD   b,33
         LD   c,109
         LD   l,38
         LD   a,143
         CALL table
         LD   b,51
         LD   c,113
         LD   l,58
         LD   a,135
         CALL table
         LD   ix,sprtab                 ; Point To Sprite Table
loopit
         LD   a,(ix+0)
         CP   #ff
         JR   z,quit                    ; That's All Folks !
         CP   #fe
         CALL z,newfile
         LD   b,a
         LD   c,(ix+1)
         LD   l,(ix+2)
         LD   a,(ix+3)
         PUSH ix
         CALL table
         POP  ix
         INC  ix
         INC  ix
         INC  ix
         INC  ix
         JR   loopit
quit
         DI   
         POP  ix
         POP  iy
         LD   sp,#bff8
         LD   bc,#7fc4
         OUT  (c),c
         JP   #4000
newfile
         PUSH ix
         PUSH de
         LD   l,(ix+1)
         LD   h,(ix+2)
         LD   de,#c000
         LD   b,fillen
         CALL #bc77
         LD   hl,#c000
         CALL #bc83
         CALL #bc7a
         POP  de
         POP  ix
         INC  ix
         INC  ix
         INC  ix
         LD   a,(ix+0)
         RET  
nutty
         CALL check
         CALL #bb18
         RET  
;
         LD   l,40                      ; L=Max Width
         LD   a,79                      ; A=Max Height
         LD   b,12                      ; B=Min Width
         LD   c,0                       ; C=Min Height
         CALL table
         RET  
hhh      DEFW 0
name     DEFM MISC.SCR
len      EQU  $-name
check                                   ; Check If Sprite Is O.K.
         PUSH af
         PUSH bc
         PUSH de
         PUSH hl
         PUSH ix
         PUSH iy
         LD   l,(iy-5)
         LD   h,(iy-4)
         LD   a,h
         ADD  a,#21
         LD   h,a
         PUSH hl
         POP  ix
         LD   a,(iy-3)
         CP   2
         CALL z,hhdec
         CP   3
         CALL z,decomp
         CALL #bb06
;
         POP  iy
         POP  ix
         POP  hl
         POP  de
         POP  bc
         POP  af
         RET  
table                                   ; Write Information To Look Up Table In
         CALL tablea
         JR   check
tablea
         PUSH ix
         PUSH iy
         PUSH hl
         PUSH de
         PUSH bc
         PUSH af
         SUB  c
         INC  a
         LD   (iy+4),a                  ; Write Height Of Sprite To Table
         LD   a,d
         SUB  #21
         LD   (iy+0),e
         LD   (iy+1),a                  ; Write Offset Of Sprite
         LD   a,l
         SUB  b
         INC  a
         LD   (iy+3),a                  ; Width Of Sprite
         POP  af
         PUSH af
         LD   de,#100
         CALL decide
         LD   (iy+2),a                  ; Store How Sprite To Be Stored
         POP  af
         POP  bc
         POP  de
         POP  hl
         POP  iy
         LD   h,a
         LD   a,(iy+2)
         INC  iy
         INC  iy
         INC  iy
         INC  iy
         INC  iy
         CP   2
         JR   z,hrz                     ; Compress Horizontal And Store
         CP   3
         JR   z,vrt
decision
         PUSH de
         LD   e,b
         LD   l,c
         PUSH bc
         CALL calcbyte
         POP  bc
         POP  de
         LD   b,(iy-2)
         LD   c,(iy-1)
         CALL standard
         POP  ix
         RET  
hrz
         LD   a,h
         CALL comph
         POP  ix
         RET  
vrt
         LD   a,h
         CALL compv
         POP  ix
         RET  
decide                                  ; Choose Better Compression Method
         CALL decide1
         PUSH de
         PUSH af
         LD   a,(c6)
         LD   e,a
         LD   a,(c7)
         LD   hl,0
         LD   d,h
         LD   b,8
shift1                                  ; Multiply Width By Height Store In HL
         ADD  hl,hl
         RLA  
         JR   nc,over
         ADD  hl,de
over     DJNZ shift1
         POP  af
         POP  de
         AND  a
         SBC  hl,de
         RET  nc
         LD   a,1                       ; Better Storage Method Is Standard Byt
         RET  
decide1
         PUSH af
         PUSH bc
         PUSH de
         PUSH hl
         LD   de,#100
         CALL comph
         DEC  d
         LD   (horz),de
         POP  hl
         POP  de
         POP  bc
         POP  af
         LD   de,#100
         CALL compv
         DEC  d
         LD   hl,0
horz     EQU  $-2
         AND  a
         SBC  hl,de
         LD   a,2                       ; 1 Means Verticle Compressor Better
         RET  c
         INC  a                         ; 2 Means Horizontal Compressor Better
         RET  
standard                                ; Standard Byte Storer !
         PUSH bc                        ; B=Width, C=Height
         PUSH hl                        ; HL=SCR_PHYSICAL_ADDR , DE = LOCATION
stnd1
         LD   a,(hl)
         LD   (hl),#ff
         LD   (de),a
         INC  hl
         INC  de
         DJNZ stnd1
         POP  hl
         LD   a,8
         ADD  a,h
         JR   nc,stnd2
         LD   a,l
         ADD  a,#50
         LD   l,a
         LD   a,#c8
         ADC  a,h
stnd2
         OR   #c0
         LD   h,a
         POP  bc
         DEC  c
         JR   nz,standard
         RET  
comph
         DI   
         PUSH hl
         LD   hl,getbyteh
         LD   (a1),hl
         LD   (a2),hl
         LD   (a3),hl
         LD   (a4),hl
         LD   hl,backsmeh
         LD   (b1),hl
         LD   (b2),hl
         LD   (b3),hl
         POP  hl
         INC  a                         ; A=Maximum Height To Go To
         LD   (c4),a
         SUB  c
         LD   (c7),a
         LD   a,l                       ; L=Maximum Width
         LD   (c1),a
         INC  a
         LD   (c2),a
         SUB  b
         LD   (c6),a
         LD   a,b                       ; H=Minimum Width
         LD   (c3),a
         DEC  a
         LD   (c5),a
         JR   compact
compv                                   ; Compress Sprite Vertically !
         DI   
         PUSH hl
         LD   hl,getbytev
         LD   (a1),hl
         LD   (a2),hl
         LD   (a3),hl
         LD   (a4),hl
         LD   hl,backsmev
         LD   (b1),hl
         LD   (b2),hl
         LD   (b3),hl
         POP  hl
         LD   (e5),a
         INC  a
         SUB  c
         LD   (e6),a
         ADD  a,c
;SUB  c
         LD   (e1),a
         LD   a,c
         LD   (e2),a
         DEC  a
         LD   (e3),a
         LD   a,l
         INC  a
         LD   (e4),a
compact
         LD   ix,count
         CALL compress                  ; DE=Location To Place Sprite
         XOR  a
         LD   (de),a
         INC  de
         RET  
compress                                ; Sprite Compressor
         LD   hl,smallpic+#7000
         OR   a
         SBC  hl,de
         RET  c
         LD   hl,diffs
         CALL getbytev
a1       EQU  $-2
         RET  nc
         LD   (ix+1),a
         LD   (hl),a
         INC  hl
         LD   (ix+0),1
         CALL getbytev
a2       EQU  $-2
         CALL nc,outsame
         RET  nc
         INC  (ix+0)
         LD   (hl),a
         INC  hl
         CP   (ix+1)
         LD   (ix+1),a
         JR   z,same
diffrent
         CALL getbytev
a3       EQU  $-2
         CALL nc,outdiff
         RET  nc
         CP   (ix+1)
         CALL z,backdiff
         CALL z,outdiff
         JR   z,compress
         CALL adddiff
         JR   nc,compress
         JR   diffrent
same
         CALL getbytev
a4       EQU  $-2
         CALL nc,outsame
         RET  nc
         CP   (ix+1)
         CALL nz,backsmev
b1       EQU  $-2
         CALL nz,outsame
         JR   nz,compress
         CALL addsame
         JR   nc,compress
         JR   same
getbytev
         LD   a,b
         SUB  200
e4       EQU  $-1
         RET  nc
         LD   a,c
         PUSH hl
         PUSH bc
         AND  7
         ADD  a,a
         ADD  a,a
         ADD  a,a
         ADD  a,#c0
         LD   h,a
         LD   l,b
         PUSH hl
         LD   b,0
         SRL  c
         SRL  c
         SRL  c
         PUSH bc
         POP  hl
         ADD  hl,hl
         ADD  hl,hl
         ADD  hl,bc
         ADD  hl,hl
         ADD  hl,hl
         ADD  hl,hl
         ADD  hl,hl
         POP  bc
         ADD  hl,bc
         POP  bc
         INC  c
         LD   a,c
         CP   0
e1       EQU  $-1
         JR   nz,gb2v
         LD   c,0
e2       EQU  $-1
         INC  b
gb2v
         LD   a,(hl)
         POP  hl
         SCF  
         RET  
adddiff
         LD   (ix+1),a
         LD   (hl),a
         INC  hl
         INC  (ix+0)
         LD   a,(ix+0)
         CP   127
         RET  c
outdiff
         LD   a,(ix+0)
         LD   (de),a
         INC  de
         LD   hl,diffs
         PUSH bc
         LD   c,a
         LD   b,0
         LDIR 
         POP  bc
         RET  
addsame
         INC  (ix+0)
         LD   a,(ix+0)
         CP   127
         RET  c
outsame
         LD   a,(ix+0)
         SET  7,a
         LD   (de),a
         INC  de
         LD   a,(ix+1)
         LD   (de),a
         INC  de
         RET  
backdiff
         PUSH af
         DEC  (ix+0)
         POP  af
         CALL backsmev
b2       EQU  $-2
         JP   backsmev
b3       EQU  $-2
backsmev
         PUSH af
         LD   a,c
         DEC  a
         CP   0
e3       EQU  $-1
         JR   nz,bs1
         LD   a,0
e5       EQU  $-1
         DEC  b
bs1
         LD   c,a
         POP  af
         RET  
calcbyte                                ; Entry L=Row (0-199) , E=Column (0-79)
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
decomp
         PUSH af
         CALL n1
         POP  af
         RET  
n1
         XOR  a
         LD   l,a
         LD   h,l
         LD   e,h
         LD   d,e
decomp1
         LD   a,(ix+0)
         OR   a
         RET  z
         BIT  7,a
         JR   nz,decr
         LD   b,a
         INC  ix
decomp3
         LD   a,(ix+0)
         INC  ix
         CALL decomp2
         RET  nc
         DJNZ decomp3
         JR   decomp1
decr
         RES  7,a
         LD   b,a
         INC  ix
decr1
         LD   a,(ix+0)
         CALL decomp2
         RET  nc
         DJNZ decr1
         INC  ix
         JR   decomp1
decomp2
         PUSH bc
         PUSH de
         PUSH hl
         PUSH af
         CALL calcbyte
         POP  af
         LD   (hl),a
         POP  hl
         POP  de
         POP  bc
         INC  l
         LD   a,l
         SUB  81
e6       EQU  $-1
         RET  nz
         LD   l,0
         INC  e
         SCF  
         RET  
;
cmprh
         INC  a                         ; A=Maximum Height To Go To
         LD   (e4),a
         LD   a,l                       ; L=Maximum Width
         LD   (e1),a
         INC  a
         LD   (e2),a
         LD   a,b                       ; H=Minimum Width
         LD   (e3),a
         DEC  a
         LD   (e5),a
         LD   ix,count
         CALL comph                     ; DE=Location To Place Sprite
         XOR  a
         LD   (de),a
         INC  de
         RET  
getbyteh
         LD   a,c
         CP   200
c4       EQU  $-1
         RET  z
         PUSH hl
         PUSH bc
         AND  7
         ADD  a,a
         ADD  a,a
         ADD  a,a
         ADD  a,#c0
         LD   h,a
         LD   l,b
         PUSH hl
         LD   b,0
         SRL  c
         SRL  c
         SRL  c
         PUSH bc
         POP  hl
         ADD  hl,hl
         ADD  hl,hl
         ADD  hl,bc
         ADD  hl,hl
         ADD  hl,hl
         ADD  hl,hl
         ADD  hl,hl
         POP  bc
         ADD  hl,bc
         POP  bc
         INC  b
         LD   a,b
         CP   80
c2       EQU  $-1
         JR   nz,gb2h
         LD   b,0
c3       EQU  $-1
         INC  c
gb2h
         LD   a,(hl)
         POP  hl
         SCF  
         RET  
backsmeh
         PUSH af
         LD   a,b
         DEC  a
         CP   0
c5       EQU  $-1
         JR   nz,bs1h
         DEC  c
         LD   a,79
c1       EQU  $-1
bs1h
         LD   b,a
         POP  af
         RET  
hhdec
         PUSH af
         CALL hh2
         POP  af
         RET  
hh2
         XOR  a
         LD   l,a
         LD   h,l
         LD   e,h
         LD   d,e
hhdec1
         LD   a,(ix+0)
         OR   a
         JP   z,#bb18
         RET  z
         BIT  7,a
         JR   nz,hdecr
         LD   b,a
         INC  ix
hhdec3
         LD   a,(ix+0)
         INC  ix
         CALL hhdec2
         RET  nc
         DJNZ hhdec3
         JR   hhdec1
hdecr
         RES  7,a
         LD   b,a
         INC  ix
hdecr1
         LD   a,(ix+0)
         CALL hhdec2
         RET  nc
         DJNZ hdecr1
         INC  ix
         JR   hhdec1
hhdec2
         PUSH bc
         PUSH de
         PUSH hl
         PUSH af
         CALL calcbyte
         POP  af
         LD   (hl),a
         POP  hl
         POP  de
         POP  bc
         INC  e
         LD   a,e
rrr
         SUB  14
c6       EQU  $-1
         RET  nz
         LD   e,0
         INC  l
         LD   a,l
         SUB  38
c7       EQU  $-1
         RET  
;
count    DEFW 0
diffs    DEFS 127
smallpic EQU  0
;
sprtab                                  ; Sprite Adress Table Arrange
;        Start X, Start Y, End X, End Y
         DEFB 0,68,5,88                 ; 1P
         DEFB 6,68,13,96                ; 2P
         DEFB 15,68,19,84               ; 5P
         DEFB 20,68,28,100              ; 10P
         DEFB 30,68,36,90               ; 20P
         DEFB 38,68,47,102              ; 50P
         DEFB 48,68,55,96               ; 1Pound
         DEFB 57,68,66,104              ; 2Pound
         DEFB #FE                       ; Code To Load Next File
         DEFW FILE2                     ; Address Of Next File FILENAME
         DEFB 0,11,21,148               ; BOINGY
         DEFB 29,58,38,94               ; NOSE
         DEFB 0,153,4,176               ; Spring
         DEFB #fe
         DEFW FILE3
         DEFB 4,0,27,24                 ; COZMO'S Hat
         DEFB 0,25,15,93                ; COZMO's Face
         DEFB 0,102,3,113               ; EYE 1
         DEFB 0,117,3,128               ; EYE 2
         DEFB 0,134,1,136               ; NOSE
         DEFB #fe
         DEFW FILE4
         DEFB 0,0,10,90                 ; FIZZY POP
         DEFB 1,97,12,150               ; Drink
         DEFB 14,96,24,150              ; ICE CREAM
         DEFB 27,135,36,150             ; CHEW
         DEFB #fe
         DEFW FILE5
         DEFB 38,0,48,108               ; Piggy
         DEFB 34,126,64,197             ; PIG
         DEFB 0,161,1,173               ; COIN
         DEFB #FF                       ; Code To FINISH Compilation
;
FILE1    DEFM MISC    .SCR
FILE2    DEFM BOINGY  .SCR
FILE3    DEFM COZMO   .SCR
FILE4    DEFM FIZZY   .SCR
FILE5    DEFM PIGGY   .SCR
fillen   EQU  12
finish
