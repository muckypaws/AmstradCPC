;
hilocont                                ; Hi \ Lo Control
         CALL togglehl
         LD   b,150
kpause
         PUSH bc
         LD   a,44
         CALL scankey
         JR   z,higher
         LD   a,36
         CALL scankey
         JR   z,lower
         CALL collect
         JR   c,take
         LD   a,0
functcnt EQU  $-1
         OR   a
         CALL nz,flashfnt               ; Flash Current Function To Gamble
         LD   a,0
coinflsh EQU  $-1
         OR   a
         CALL nz,flshcoin
         POP  bc
         DJNZ kpause
         JR   hilocont
higher
         CALL resfunt
         POP  hl
         CALL resethl
         CALL sethi
         LD   a,#ff
         CALL movenumb
         JR   z,higher1
         CCF  
         RET  
lower
         CALL resfunt
         POP  hl
         CALL resethl
         CALL setlo
         XOR  a
         CALL movenumb
         RET  
take
         CALL resfunt
         POP  hl
         CALL resethl
higher1
         XOR  a
         SCF  
         RET  
movenumb
         LD   (hilop),a
         LD   a,8
hilonum  EQU  $-1
         DEC  a
         JR   nz,mov2
         LD   a,13
mov2
         LD   (hilocomp),a
         CALL accelnms
         CALL resethl
         LD   a,(hilonum)
         DEC  a
         JR   nz,movenum1
         LD   a,13
movenum1
         CP   0
hilocomp EQU  $-1
         LD   a,#ff
         RET  
togglehl
         LD   de,#c0cc
         CALL setcs
         CALL framefly
         LD   hl,#800
framel
         DEC  hl
         LD   a,l
         OR   h
         JR   nz,framel
         CALL swichhi
         CALL framefly
swichlo
         LD   a,#cc
         XOR  #c
         LD   (swichlo+1),a
swichlo1
         LD   hl,#db04
         LD   bc,#d0e
         JP   swichgwa
swichhi                                 ; Switch HI Colours
         LD   a,#c0
         XOR  #c
         LD   (swichhi+1),a
swichhi1
         LD   hl,#c884
         LD   bc,#d0e
         JP   swichgwa
sethi
         CALL framefly
         LD   a,#cc
         JR   swichhi1
setlo
         CALL framefly
         LD   a,#cc
         JR   swichlo1
resethl
         LD   de,#c0cc
         CALL setcs
         LD   a,#c0
         CALL swichhi1
         LD   a,#c0
         JR   swichlo1
accelnms                                ; Accelerate Number Reels On Start Up
         LD   a,0
suppress EQU  $-1
         LD   a,r
         XOR  %101010
acelnmr  EQU  $-1
         LD   (acelnmr),a
         AND  15
         ADD  a,5
         CP   15
         JR   z,accelnms
         LD   c,a
         LD   a,(mean)
         OR   a
         JR   z,accelnmc
accelnmd
         LD   a,2
counthi  EQU  $-1
         DEC  a
         LD   (counthi),a
         JR   nz,accelnmc
         LD   a,r
         AND  3
         INC  a
         LD   (counthi),a
         LD   a,0
hilop    EQU  $-1
         OR   a
         LD   c,16
         JR   z,accelnmc
         DEC  c
         DEC  c
accelnmc
         LD   a,c
         DEC  a
accelnme
         LD   (amount2),a
         XOR  a
         LD   (movedhi),a
         CALL sethilob
         LD   hl,accelsqn
         LD   b,11
accelnm1
         PUSH bc
         PUSH hl
         LD   a,(hl)
         LD   (hilospd),a
         CALL framefly
         CALL scrlhilo
         POP  hl
         LD   b,(hl)
         LD   a,6
         SUB  b
         ADD  a,a
accelnm2
         PUSH af
         CALL framefly
         POP  af
         DEC  a
         JR   nz,accelnm2
         POP  bc
         INC  hl
         DJNZ accelnm1
movnumb
         LD   a,12
amount2  EQU  $-1
         DEC  a
         LD   (amount2),a
         JR   z,movnumb3
         XOR  a
         LD   (movedhi),a
movnumb2
         CALL framefly
         CALL scrlhilo
         LD   a,(movedhi)
         OR   a
         JR   nz,movnumb2
         JR   movnumb
movnumb3
         LD   a,(suppress)
         OR   a
         JP   z,boing
         LD   a,(hilonum)
         DEC  a
         JP   nz,boing
         LD   a,r
         AND  3
         ADD  a,2
         LD   (amount2),a
         JR   movnumb
;
sethilob                                ; Set Hi Lo Buffer
         LD   a,(hilonum)
         ADD  a,a
         ADD  a,30
         LD   e,a
         LD   d,0
         LD   hl,sprload
         PUSH hl
         ADD  hl,de
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         POP  hl
         ADD  hl,de
         EX   de,hl
         LD   hl,reel1bfd
         LD   (hilobufa),hl
         LD   b,14
         LD   a,36
         LD   c,1
         JP   decomp
scrlhilo                                ; Scroll Hi Lo Grid UP
         LD   a,0
movedhi  EQU  $-1
         OR   a
         CALL z,sethilob
         LD   a,0
hilospd  EQU  $-1
         OR   a
         RET  z
         DEC  a
         LD   c,a
         LD   hl,hilofs
         LD   e,a
         LD   d,0
         ADD  hl,de
         LD   a,(hl)
         LD   (hilrep),a
         LD   e,7
         ADD  hl,de
         LD   a,(hl)
         LD   (hiloscam),a
         LD   a,c
         ADD  a,a
         LD   e,a
         LD   hl,hiloscad
         ADD  hl,de
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         EX   de,hl
         LD   de,#f923
         LD   b,0
hiloscam EQU  $-1
hilosc
         PUSH bc
         PUSH de
         PUSH hl
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         POP  hl
         LD   a,8
         ADD  a,h
         JR   nc,hilosc1
         LD   a,#50
         ADD  a,l
         LD   l,a
         LD   a,#c8
         ADC  a,h
hilosc1
         OR   #c0
         LD   h,a
         POP  de
         LD   a,8
         ADD  a,d
         JR   nc,hilosc2
         LD   a,#50
         ADD  a,e
         LD   e,a
         LD   a,#c8
         ADC  a,d
hilosc2
         OR   #c0
         LD   d,a
         POP  bc
         DJNZ hilosc
         LD   hl,reel1bfd
hilobufa EQU  $-2
         LD   b,0
hilrep   EQU  $-1
hreploop
         PUSH bc
         PUSH de
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         POP  de
         LD   a,8
         ADD  a,d
         JR   nc,hrepl1
         LD   a,#50
         ADD  a,e
         LD   e,a
         LD   a,d
         ADC  a,#c8
hrepl1
         OR   #c0
         LD   d,a
         POP  bc
         DJNZ hreploop
         LD   (hilobufa),hl
         LD   a,(hilrep)
         LD   hl,movedhi
         ADD  a,(hl)
         LD   (hl),a
         SUB  36
         RET  nz
         LD   (hl),a
         LD   hl,hilonum
         INC  (hl)
         LD   a,(hl)
         SUB  14
         RET  nz
         LD   (hl),1
         RET  
*f,money.adm
