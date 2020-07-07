;
         ORG  #3000                     ; PACMAN - Written By Jason Brooks
start    ENT  $                         ; Project Started 2nd May 1991
topval   EQU  32                        ; Top Of Playing Area
botval   EQU  200-topval                ; Bottom Of PLaying Area
minval   EQU  4                         ; Left Side Of Playing Area
hrzval   EQU  #4f-minval                ; Right Side Of Playing Area
pacsize  EQU  4                         ; Pacman Size = pacsize*2 W * W*2 = H !
         DI   
         CALL load
         CALL setinks
         XOR  a
         CALL #bc0e
         CALL calcaddr
         LD   hl,#c04f-6
         LD   (pacaddr),hl
         LD   a,#4f-20
         LD   (pacx),a
         LD   a,%1000
         LD   (pacstat),a
         LD   a,40
         LD   (pacy),a
         XOR  a
         LD   (powerm),a
         LD   a,92
         LD   c,38
         CALL calcscr
         LD   (powera),hl
         LD   a,topval-1
         LD   c,minval-1
         CALL calcscr
         LD   b,hrzval-minval+2
line1
         LD   (hl),#ff
         INC  hl
         DJNZ line1
         LD   b,botval-topval+1
line2
         LD   (hl),#ff
         LD   a,8
         ADD  a,h
         JR   nc,line2a
         LD   a,#50
         ADD  a,l
         LD   l,a
         LD   a,#c8
         ADC  a,h
line2a
         OR   #c0
         LD   h,a
         DJNZ line2
         LD   b,hrzval-minval+2
line3
         LD   (hl),#ff
         DEC  hl
         DJNZ line3
         LD   a,topval
         LD   c,minval-1
         CALL calcscr
         LD   b,botval-topval+1
line4
         LD   (hl),#ff
         LD   a,8
         ADD  a,h
         JR   nc,line4a
         LD   a,#50
         ADD  a,l
         LD   l,a
         LD   a,#c8
         ADC  a,h
line4a
         OR   #c0
         LD   h,a
         DJNZ line4
         CALL vertspr
mainloop
         DI   
         CALL framefly
;CALL #bb18
         CALL vertspr
         CALL pbleat
         LD   hl,pacstat
;INC  (hl)
         LD   hl,movec
         DEC  (hl)
         JR   nz,mainl1
         LD   (hl),1
         LD   a,71
         CALL #bb1e
         CALL nz,pacleft
         LD   a,63
         CALL #bb1e
         CALL nz,pacright
         LD   a,19
         CALL #bb1e
         CALL nz,pacup
         LD   a,22
         CALL #bb1e
         CALL nz,pacdown
mainl1
         CALL vertspr
         LD   a,47
         CALL #bb1e
         JR   z,mainloop
         RET  
;
pause
         PUSH af
         CALL framefly
         POP  af
         DEC  a
         JR   nz,pause
         RET  
framefly
         LD   b,#f5
ffly1
         IN   a,(c)
         RRA  
         RET  c
         JR   ffly1
calcpspr
         LD   a,(powerm)                ; Get Power Man Status
         AND  3
         ADD  a,39
         ADD  a,a
         LD   e,a
         LD   d,0
         LD   hl,psprload
         ADD  hl,de
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   hl,psprload
         ADD  hl,de
;EX   de,hl
         RET  
pbleat                                  ; Power Bleat ! - Ken's Addition !
         LD   ix,poweri                 ; Point To Index
         CALL calcpspr
         LD   b,4
pbleata
         PUSH bc
         DEC  (ix+0)
         JR   nz,pbleata1
         LD   (ix+0),5
         PUSH hl
         LD   e,(ix+2)
         LD   d,(ix+3)
         LD   a,(ix+1)
         OR   a
         CALL nz,putspr
         POP  hl
pbleata1
         POP  bc
         LD   de,4
         ADD  ix,de
         DJNZ pbleata
pbleatu                                 ; Power Bleat Update Routine !
         LD   a,(powerm)
         BIT  7,a
         JR   nz,decbleat               ; Deflating !
         INC  a
         CP   4
         JR   nz,pbleat1
         LD   a,%10000010
pbleat1
         LD   (powerm),a
         RET  
decbleat                                ; Deflate Ken'S Acid Chap !
         AND  3
         SUB  1
         JR   nc,pbleat2
         LD   a,1
         JR   pbleat1
pbleat2
         OR   128
         JR   pbleat1
putspr                                  ; Horizontal Sprite Routine !
         LD   b,16
putspr1
         PUSH bc
         PUSH de                        ; DE=Screen Address ; HL=Sprite Data
         LDI  
         LDI  
         LDI  
         LDI  
         POP  de
         LD   a,8
         ADD  a,d
         JR   nc,putspr2
         LD   a,#50
         ADD  a,e
         LD   e,a
         LD   a,#c8
         ADC  a,d
putspr2
         OR   #c0
         LD   d,a
         POP  bc
         DJNZ putspr1
         RET  
pacleft                                 ; Move Pacman Left
         LD   a,(pacstat)
         AND  %11100111
         OR   %1000
         XOR  %100
         LD   (pacstat),a
         AND  %100
         JR   z,pacmouth
         LD   a,(pacx)
         CP   minval
         JR   nz,pacl1
         LD   a,hrzval+1
pacl1
         DEC  a
         LD   (pacx),a
         JR   pacleft1
pacleft1
         LD   a,(pacstat)
         JR   pacmouth
pacright
         LD   a,(pacstat)
         AND  %11100111
         XOR  %100
         LD   (pacstat),a
         AND  %100
         JR   nz,pacmouth
         LD   a,(pacx)
         CP   hrzval
         JR   nz,pacr1
         LD   a,minval-1
pacr1
         INC  a
         LD   (pacx),a
         LD   a,(pacstat)
         JR   pacmouth
pacup
         LD   a,(pacstat)
         AND  %100
         RET  nz
         LD   a,(pacy)
         CP   topval+2
         JR   nc,pacup1
         JR   z,pacup1
;JR   nz,pacup1
         LD   a,botval
pacup1
         SUB  2
         LD   (pacy),a
         LD   a,(pacstat)
         AND  %11100111
         OR   %10000
         LD   (pacstat),a
         JR   pacmouth
;
pacdown
         LD   a,(pacstat)
         AND  %100
         RET  nz
         LD   a,(pacy)
         CP   botval-2
         JR   c,pacdown1
;JR   z,pacdown1
;JR   nz,pacdown1
;JR   c,pacdown1
         LD   a,topval-4
pacdown1
         ADD  a,2
         LD   (pacy),a
         LD   a,(pacstat)
         AND  %11100111
         OR   %11000
         LD   (pacstat),a
pacmouth
         LD   hl,mcount
         DEC  (hl)
         RET  nz
         LD   (hl),4
         LD   a,(pacstat)
         AND  %100000
         JR   nz,closing
opening
         LD   a,(pacstat)
         AND  3
         INC  a
         CP   4
         CALL z,pacbch
open1
         LD   b,a
         LD   a,(pacstat)
         AND  %11111100
         OR   b
         LD   (pacstat),a
         RET  
closing
         LD   a,(pacstat)
         AND  3
         DEC  a
         CALL z,pacbch
         JR   open1
;
pacbch
         LD   a,(pacstat)
         XOR  %100000
         LD   (pacstat),a
         BIT  5,a
         JR   z,pacbch1
         OR   3
         RET  
pacbch1
         AND  %11111100
         RET  
calcaddr
         LD   ix,scraddrt
         LD   b,200
         LD   hl,#c000
calcadr1
         LD   (ix+0),l
         LD   (ix+1),h
         INC  ix
         INC  ix
         LD   a,8
         ADD  a,h
         JR   nc,calcadr2
         LD   a,#50
         ADD  a,l
         LD   l,a
         LD   a,#c8
         ADC  a,h
calcadr2
         OR   #c0
         LD   h,a
         DJNZ calcadr1
         RET  
cpacman
         LD   a,(pacstat)               ; Get PAC Status
         AND  31
         ADD  a,a
         LD   e,a
         LD   d,0
         LD   hl,psprload
         ADD  hl,de
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   hl,psprload
         ADD  hl,de                     ; HL = Address Of Sprite DATA !
         EX   de,hl
         PUSH de
         LD   a,(pacx)
         LD   c,a
         LD   a,(pacy)
         CALL calcscr
         POP  de
         LD   a,(pacstat)
         AND  %100
         LD   b,pacsize+1
         RET  nz
         DEC  b
         RET  
vertspr                                 ; Draw A Verticle Sprite !
         CALL cpacman
         LD   a,(pacx)
         CP   hrzval-5
         JR   nc,vertsprc
         LD   a,(pacy)
         CP   botval-15
         JR   nc,vertsprc
;
vtspra
         LD   a,(pacx)
vtspr1
         PUSH hl
         PUSH bc
vtspr3
         LD   c,a
         LD   a,(pacy)
         LD   b,pacsize*2
vtspr2
         PUSH af
         PUSH bc
         LD   a,(de)
         XOR  (hl)
         LD   (hl),a
         INC  de
         LD   a,8
         ADD  a,h
         JR   nc,vt2a
         LD   a,#50
         ADD  a,l
         LD   l,a
         LD   a,#c8
         ADC  a,h
vt2a
         OR   #c0
         LD   h,a
;
         LD   a,(de)
         XOR  (hl)
         LD   (hl),a
         INC  de
         LD   a,8
         ADD  a,h
         JR   nc,vt3a
         LD   a,#50
         ADD  a,l
         LD   l,a
         LD   a,#c8
         ADC  a,h
vt3a
         OR   #c0
         LD   h,a
         POP  bc
         POP  af
         ADD  a,2
vtspr2a
         DJNZ vtspr2
         POP  bc
         POP  hl
         INC  hl
         INC  c
         LD   a,c
vtspr2b
         DJNZ vtspr1
         RET  
jason
vertsprc
;CALL cpacman
vertspra
         LD   a,(pacx)
vertspr1
         PUSH hl
         PUSH bc
vertspr3
         LD   c,a
         LD   a,(pacy)
         LD   b,pacsize*2
vertspr2
         PUSH af
         PUSH bc
         LD   a,(de)
         XOR  (hl)
         LD   (hl),a
         INC  de
         LD   a,8
         ADD  a,h
         JR   nc,vts2a
         LD   a,#50
         ADD  a,l
         LD   l,a
         LD   a,#c8
         ADC  a,h
vts2a
         OR   #c0
         LD   h,a
;
         LD   a,(de)
         XOR  (hl)
         LD   (hl),a
         INC  de
         LD   a,8
         ADD  a,h
         JR   nc,vts3a
         LD   a,#50
         ADD  a,l
         LD   l,a
         LD   a,#c8
         ADC  a,h
vts3a
         OR   #c0
         LD   h,a
         JR   argy
;
         LD   a,(de)
         XOR  (hl)
         LD   (hl),a
         INC  de
         LD   a,8
         ADD  a,h
         JR   nc,vts4a
         LD   a,#50
         ADD  a,l
         LD   l,a
         LD   a,#c8
         ADC  a,h
vts4a
         OR   #c0
         LD   h,a
;
         LD   a,(de)
         XOR  (hl)
         LD   (hl),a
         INC  de
         LD   a,8
         ADD  a,h
         JR   nc,vts5a
         LD   a,#50
         ADD  a,l
         LD   l,a
         LD   a,#c8
         ADC  a,h
vts5a
         OR   #c0
         LD   h,a
argy                                    ; Temporary Break Point For Finite Cont
         POP  bc
         POP  af
         ADD  a,2
         CP   botval-2
jjj
         JR   z,vrtspr2a
         JR   c,vrtspr2a
         LD   a,topval
         PUSH af
         PUSH bc
         PUSH de
         CALL calcscr
         POP  de
         POP  bc
         POP  af
vrtspr2a
         DJNZ vertspr2
         POP  bc
         POP  hl
         INC  hl
         INC  c
         LD   a,c
         CP   hrzval
         JR   z,vrtspr2b
         JR   c,vrtspr2b
         PUSH bc
         PUSH de
         LD   c,minval
         LD   a,(pacy)
         CALL calcscr
         POP  de
         POP  bc
         LD   c,minval-1
         LD   a,c
vrtspr2b
         DEC  b
         JP   nz,vertspr1
         RET  
;
calcscr                                 ; Convert X, Y Co-Ords into PHYSICAL Ad
;ADD  a,a                       ; Entry
         LD   l,a                       ; C=X-Co-ord !
         LD   h,0
         ADD  hl,hl
         LD   de,scraddrt
         ADD  hl,de
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         EX   de,hl
         LD   b,0
         ADD  hl,bc
         RET                            ; Exit HL=Physical Address : All Regs C
putpac                                  ; Put PACMAN On Screen !
         LD   a,(pacstat)               ; Get PAC Status
         AND  31
         ADD  a,a
         LD   e,a
         LD   d,0
         LD   hl,psprload
         ADD  hl,de
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   hl,psprload
         ADD  hl,de                     ; HL = Address Of Sprite DATA !
         EX   de,hl
         LD   hl,(pacaddr)              ; Get Screen Address !
         LD   c,22
putpac1
         PUSH hl
putpac2
         LD   a,(de)
         XOR  (hl)
         LD   (hl),a
         INC  hl
         INC  de
;
         LD   a,(de)
         XOR  (hl)
         LD   (hl),a
         INC  hl
         INC  de
         LD   a,(de)
         XOR  (hl)
         LD   (hl),a
         INC  hl
         INC  de
         LD   a,(de)
         XOR  (hl)
         LD   (hl),a
         INC  hl
         INC  de
         LD   a,(de)
         XOR  (hl)
         LD   (hl),a
         INC  hl
         INC  de
         LD   a,(de)
         XOR  (hl)
         LD   (hl),a
         INC  hl
         INC  de
         POP  hl
         LD   a,8
         ADD  a,h
         JR   nc,putpac3
         LD   a,#50
         ADD  a,l
         LD   l,a
         LD   a,#c8
         ADC  a,h
putpac3
         OR   #c0
         LD   h,a
         DEC  c
         JR   nz,putpac1
         RET  
;
setinks
         LD   bc,#101
         CALL #bc38
         LD   ix,inkset
         XOR  a
setink1
         PUSH af
         LD   b,(ix+0)
         LD   c,b
         CALL #bc32
         INC  ix
         POP  af
         INC  a
         CP   16
         JR   nz,setink1
         RET  
load
         LD   hl,#ff
         BIT  0,(hl)
         RET  nz
         LD   (hl),#ff
         LD   hl,name
         LD   de,#c000
         LD   b,len
         CALL #bc77
         LD   hl,psprload
         CALL #bc83
         JP   #bc7a
;
name     DEFM PACMAN2 .spr
len      EQU  $-name
pacstat  DEFB 0                         ; Rotate Status Of Pacman
pacaddr  DEFW 0                         ; Screen Address Of Pacman !
pacx     DEFB #4f-6
pacy     DEFB 0                         ; Pacman'S Y Addresss !
powerm   DEFB 0
powera   DEFW #c000
pcount   DEFB 6
mcount   DEFB 2
movec    DEFB 2
inkset   DEFB 0,26,18,8,1,23,5,14
         DEFB 4,1,15,6,3,16,24,25,17
         DEFB 19,21,23
poweri                                  ; Power Index Array
         DEFB 6                         ; This Count
         DEFB 255                       ; Power Flag !
         DEFW #c300                     ; Pysical Address Of POWER MAN !
;
         DEFB 5                         ; Count For Man 2
         DEFB 255                       ; Power Flag
         DEFW #c330                     ; POWER MAN 2
;
         DEFB 4                         ; Count For Man 3
         DEFB 255                       ; Power Flag
         DEFW #c540                     ; POWER MAN 3
;
         DEFB 3                         ; Count For Man 4
         DEFB 255                       ; Power Flag
         DEFW #c560                     ; POWER MAN 4 !
;
psprload EQU  #1000                     ; Address To Load Pacmen !
scraddrt DEFS 400,#c0                   ; Screen Address Table
