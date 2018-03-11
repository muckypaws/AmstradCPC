;
game0
         XOR  a
         JR   gamec
gameff
         LD   a,#ff
gamec
         OR   a
         JR   nz,fss
         LD   a,0
gamec1   EQU  $-1
         OR   a
         RET  z
         INC  a
         LD   (gamec1),a
         LD   a,0
funcheld EQU  $-1
         OR   a
         CALL nz,copyfunc
         CALL hrdrght
         CALL hrdrght
         CALL blitter
         LD   hl,#c026
         LD   c,19
mselect2
         PUSH bc
         CALL movsrght
         POP  bc
         DEC  c
         BIT  7,c
         JR   z,mselect2
         CALL hardlft
         JP   hardlft
fss
         LD   a,(gamec1)
         OR   a
         RET  nz
         DEC  a
         LD   (gamec1),a
fselect
         LD   c,0
         CALL getsaddr
         LD   c,20
         LD   hl,#c000
fselect1
         CALL strpstr
         DEC  c
         JR   nz,fselect1
         LD   hl,#c050
         LD   c,20
         JR   trans1
trans
         CALL resethrd
         LD   hl,#c000
         LD   c,0
transf
         CALL trans1
         LD   hl,sprload+#3a+40         ; Store Functions On 2nd 8K
         LD   b,20
sfp1
         PUSH bc
         PUSH hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         PUSH hl
         LD   hl,sprload
         ADD  hl,de
         EX   de,hl
         POP  hl
         PUSH de
         LD   de,79-40
         ADD  hl,de
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   hl,sprload
         ADD  hl,de
         EX   de,hl
         POP  hl
         LD   bc,#201
         LD   a,200
         CALL decomp
         POP  hl
         INC  hl
         INC  hl
         POP  bc
         DJNZ sfp1
         RET  
trans1
         PUSH bc
         CALL movsleft
         POP  bc
         INC  c
         LD   a,c
         CP   40
         JR   nz,trans1
         RET  
getsaddr                                ; Get Strip Addressess
         LD   hl,sprload
         PUSH hl
         LD   a,c                       ; C = Strip Number
         ADD  a,a
         ADD  a,#3a
         LD   e,a
         LD   d,0
         ADD  hl,de
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         POP  hl
         ADD  hl,de
         EX   de,hl                     ; EXIT DE=Location Of Strip
         RET  
strpstr
         LD   b,200
         PUSH hl
strpstr2
         LD   a,(hl)
         LD   (de),a
         INC  hl
         LD   a,h
         OR   #c0
         LD   h,a
         INC  de
         LD   a,(hl)
         LD   (de),a
         DEC  hl
         INC  de
         LD   a,h
         ADD  a,8
         JR   nc,strpstr3
         LD   a,#50
         ADD  a,l
         LD   l,a
         LD   a,#c8
         ADC  a,h
strpstr3
         OR   #c0
         LD   h,a
         DJNZ strpstr2
         POP  hl
         INC  hl
         INC  hl
         RET  
strips
         LD   b,200
         PUSH hl
trans2
         LD   a,(de)
         LD   (hl),a
         INC  hl
         LD   a,h
         OR   #c0
         LD   h,a
         INC  de
         LD   a,(de)
         LD   (hl),a
         DEC  hl
         INC  de
         LD   a,h
         ADD  a,8
         JR   nc,trans3
         LD   a,#50
         ADD  a,l
         LD   l,a
         LD   a,#c8
         ADC  a,h
trans3
         OR   #c0
         LD   h,a
         DJNZ trans2
         POP  hl
         INC  hl
         INC  hl
         RET  
movsleft
         CALL putstrip
         PUSH af
         PUSH bc
         PUSH de
         PUSH hl
         CALL hardlft
         POP  hl
         POP  de
         POP  bc
         POP  af
         RET  
copyfunc
         LD   c,20
         CALL getsaddr
         LD   hl,#c050
copyf1
         CALL strpstr
         DEC  c
         JR   nz,copyf1
         RET  
movsrght
         CALL putstrip
         PUSH af
         PUSH bc
         PUSH de
         PUSH hl
         CALL hrdrght
         POP  hl
         POP  de
         POP  bc
         POP  af
         DEC  hl
         DEC  hl
         DEC  hl
         DEC  hl
         RET  
putstrip
         PUSH hl
         CALL getsaddr
         POP  hl
         CALL blitter
         JR   strips
hardlft                                 ; HD6845 CRTC Controller Routines
         LD   hl,horiz
         INC  (hl)
         LD   a,(hl)
         OR   a
         RET  nz
         LD   hl,vert
         INC  (hl)
         RET  
hrdrght
         LD   a,(horiz)
         SUB  1
         LD   (horiz),a
         RET  nc
         LD   hl,vert
         DEC  (hl)
         RET  
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
         LD   a,217
         LD   (horiz),a
         LD   a,179
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
*f,funccont.adm
