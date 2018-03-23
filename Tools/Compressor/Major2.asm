;
         ORG  #9000                     ; Sprite Compressor
         ENT  $                         ; Chooses best compression ratio
         DI   
         LD   de,#100                   ; Location To Place Comp. Data
         LD   l,40                      ; L=Max Width
         LD   a,79                      ; A=Max Height
         LD   b,12                      ; B=Min Width
         LD   c,0                       ; C=Min Height
         CALL decide
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
shift1
         ADD  hl,hl
         RLA  
         JR   nc,over
         ADD  hl,de
over     DJNZ shift1
         DEC  h
         POP  af
         AND  a
         SBC  hl,de
         POP  de
         RET  nc
         LD   a,2                       ; Better Storage Method Is Standard Byt
         RET  
decide1
         PUSH af
         PUSH bc
         PUSH de
         PUSH hl
         CALL comph
         LD   (horz),de
         POP  hl
         POP  de
         POP  bc
         POP  af
         CALL compv
         LD   hl,0
horz     EQU  $-2
         AND  a
         SBC  hl,de
         LD   a,1                       ; 1 Means Verticle Compressor Better
         RET  nc
         XOR  a                         ; 0 Means Horizontal Compressor Better
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
         LD   (e6),a
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
         LD   hl,smallpic+#2000
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
         XOR  a
         LD   l,a
         LD   h,l
         LD   e,h
         LD   d,e
         LD   ix,#100
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
         XOR  a
         LD   l,a
         LD   h,l
         LD   e,h
         LD   d,e
         LD   ix,#100
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
finish
