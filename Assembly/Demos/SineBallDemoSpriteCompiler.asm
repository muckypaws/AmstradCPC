;
         ORG  #9000                     ; Sprite Compresion VERTICLE
         ENT  $
         DI   
         LD   sp,#bff8
         LD   bc,#7fc0
         OUT  (c),c
         LD   hl,insert
         CALL print
         CALL #bb18
         LD   hl,name
         CALL load
         LD   iy,#100
         LD   de,#200
         CALL getballs
         CALL getbats
         PUSH de
         PUSH iy
         LD   hl,name2
         CALL load
         POP  iy
         POP  de
         CALL plunger
         CALL bumpers
         PUSH de
         PUSH iy
         CALL #bb18
         POP  iy
         POP  de
         DEC  d
         LD   hl,name1
         JP   save
getballs
         LD   hl,#c800
         CALL getb1
         LD   hl,#f800
         CALL getb1
         LD   hl,#e850
         CALL getb1
         LD   hl,#d0a0
getb1
         CALL putoffs
         LD   b,2
         LD   c,5
         JP   getspr
plunger
         CALL putoffs
         LD   hl,#c0f0
         LD   b,2
         LD   c,25
         JP   getspr
bumpers
         LD   hl,#e1e0
         CALL bumpers1
         LD   hl,#dad0
bumpers1
         CALL putoffs
         LD   b,5
         LD   c,19
         JP   getspr
getbats
         LD   hl,#c140
         CALL getbats1
         LD   hl,#e940
getbats1
         CALL putoffs
         LD   b,5
         LD   c,4
         JP   getspr
putoffs                                 ; Put Offset In IY
         DEC  d
         LD   (iy+0),e
         LD   (iy+1),d
         INC  iy
         INC  iy
         INC  d
         RET  
print
         LD   a,(hl)
         OR   a
         RET  z
         INC  hl
         CALL #bb5a
         JR   print
;
getspr
         PUSH bc
         PUSH hl
getspr2
         LD   a,(hl)
         LD   (hl),#ff
         LD   (de),a
         INC  hl
         INC  de
         DJNZ getspr2
         POP  hl
         LD   a,h
         ADD  a,8
         LD   h,a
         JR   nc,getspr3
         LD   bc,#c050
         ADD  hl,bc
getspr3
         POP  bc
         DEC  c
         JR   nz,getspr
         RET  
load
         PUSH de
         PUSH iy
         LD   b,len
         LD   de,#c000
         CALL #bc77
         LD   hl,#c000
         CALL #bc83
         CALL #bc7a
         POP  iy
         POP  de
         RET  
save
         PUSH de
         LD   b,len
         LD   de,#c000
         CALL #bc8c
         LD   hl,#100
         POP  de
         LD   bc,0
         LD   a,2
         CALL #bc98
         JP   #bc8f
;
name     DEFM PINBALL .SCR
name2    DEFM PINBALL1.SCR
name1    DEFM PINBALL .SPR
len      EQU  $-name1
;
compactv
         LD   (e5),a
         INC  a
         LD   (e1),a
         LD   a,c
         LD   (e2),a
         DEC  a
         LD   (e3),a
         LD   a,l
         INC  a
         LD   (e4),a
         LD   ix,count
         CALL compress                  ; DE=Location To Place Sprite
         XOR  a
         LD   (de),a
         INC  de
         RET  
compress                                ; Sprite Compressor
         LD   hl,diffs
         CALL getbyte
         RET  nc
         LD   (ix+1),a
         LD   (hl),a
         INC  hl
         LD   (ix+0),1
         CALL getbyte
         CALL nc,outsame
         RET  nc
         INC  (ix+0)
         LD   (hl),a
         INC  hl
         CP   (ix+1)
         LD   (ix+1),a
         JR   z,same
diffrent
         CALL getbyte
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
         CALL getbyte
         CALL nc,outsame
         RET  nc
         CP   (ix+1)
         CALL nz,backsame
         CALL nz,outsame
         JR   nz,compress
         CALL addsame
         JR   nc,compress
         JR   same
getbyte
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
         JR   nz,gb2
         LD   c,0
e2       EQU  $-1
         INC  b
gb2
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
         CALL backsame
backsame
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
count    DEFW 0
diffs    DEFS 150
insert   DEFB 12,7
         DEFM Insert Screen Files Sourc
         DEFM e Disk In Drive A: 
         DEFB 13,10,10
         DEFM With : PINBALL.SCR
         DEFB 13,10
         DEFB 0
insert1
         DEFB 13,10,10,10
         DEFM Insert Destination Disk F
         DEFM or Compressed Sprite Data
         DEFB 13,10,10
         DEFM With TEST.GAM On The Disk
         DEFB 13,10,10,7,0
;
finish
