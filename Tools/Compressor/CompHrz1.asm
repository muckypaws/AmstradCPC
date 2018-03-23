;
         ORG  #9000
this     EQU  #4012
comp
         ENT  $
         DI   
         LD   hl,this
         LD   de,this+1
         LD   bc,#100
         LD   (hl),0
         LDIR 
         LD   hl,main
         LD   de,this
         LD   bc,mainl
         LDIR                           ; Set Up Main Section
;
comphorx                                ; Compress Horizontal
         DI   
         LD   de,data
         LD   l,#50
         LD   a,200
         LD   b,0
         LD   c,0
compact
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
         CALL compress                  ; DE=Location To Place Sprite
         XOR  a
         LD   (de),a
         INC  de
         LD   hl,mainl+#12
         ADD  hl,de
         LD   (#3ff0),hl
         RET  
compress                                ; Sprite Compressor
         LD   hl,smallpic+#4000
         OR   a
         SBC  hl,de
         RET  c
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
         LD   a,c
         CP   200
e4       EQU  $-1
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
e2       EQU  $-1
         JR   nz,gb2
         LD   b,0
e3       EQU  $-1
         INC  c
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
         LD   a,b
         DEC  a
         CP   0
e5       EQU  $-1
         JR   nz,bs1
         DEC  c
         LD   a,79
e1       EQU  $-1
bs1
         LD   b,a
         POP  af
         RET  
count    DEFW 0
diffs    DEFS 127
smallpic EQU  #4000
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
;
main                                    ; Main Start Code - Set Up Colours.
         ORG  #4012
mainl1
         LD   ix,#4000
         LD   a,(ix+0)
         CALL #bc0e
         LD   b,(ix+1)
         LD   c,b
         CALL #bc38
         INC  ix
         INC  ix
         LD   a,15
main1
         PUSH af
         LD   b,(ix+0)
         LD   c,b
         CALL #bc32
         POP  af
         INC  ix
         DEC  a
         JP   p,this+#17
main2                                   ; This Is Where The Decomp Code Goes
;
decomp
         LD   hl,#c000
         LD   (scr),hl
         LD   (oscr),hl
         LD   e,l
         LD   d,e
         LD   ix,data
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
         LD   hl,#c000
scr      EQU  $-2
         LD   (hl),a
         INC  hl
         LD   (scr),hl
         INC  e
         LD   a,e
rrr
         SUB  81
         RET  nz
         LD   e,0
         LD   hl,#c000
oscr     EQU  $-2
         LD   a,8
         ADD  a,h
         JR   nc,rrr1
         LD   a,#50
         ADD  a,l
         LD   l,a
         LD   a,#c8
         ADC  a,h
rrr1
         OR   #c0
         LD   h,a
         LD   (oscr),hl
         LD   (scr),hl
         INC  d
         LD   a,d
         SUB  200
         RET  
mainl    EQU  $-mainl1
data
