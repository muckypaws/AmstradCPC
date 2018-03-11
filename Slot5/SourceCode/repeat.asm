;
retpres                                 ; Is return Still Pressed
         LD   a,18
         CALL scankey
         JR   z,retpres
         RET  
repeat                                  ; Draw Up Repeat Grid
         CALL gameff
         LD   hl,#e690+#50
         LD   bc,#281c
         PUSH hl
         PUSH bc
         PUSH hl
         PUSH bc
         CALL copyscr
         POP  bc
         POP  hl
         XOR  a
         LD   (rflglse),a
         CALL wipeout
         LD   a,(functcnt)
         CP   9
         JR   z,repeaten
         LD   hl,sprload
         PUSH hl
         LD   de,178
         ADD  hl,de
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         POP  hl
         ADD  hl,de
         EX   de,hl
         LD   hl,#ceee+#51
         LD   b,#c
         LD   c,5
         CALL gen
repeaten
         LD   b,5
         LD   a,1
         LD   hl,repeatlc
yesnod                                  ; Display Yes / No
         INC  a
         PUSH af
         PUSH bc
         PUSH hl
         AND  1
         ADD  a,a
         ADD  a,180
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
         POP  hl
         PUSH hl
         LD   b,4
         LD   c,13
         CALL gen
         POP  hl
         INC  hl
         INC  hl
         INC  hl
         INC  hl
         INC  hl
         POP  bc
         POP  af
         DJNZ yesnod
         LD   de,#c0cc
         CALL setcs
         CALL retpres
         LD   a,(functcnt)
         SUB  9
         JR   nz,repeatc
         LD   (repmean),a
repeatc                                 ; Repeat Control Loop
         LD   a,0
repeatf  EQU  $-1
         CALL calcrpad
         LD   a,#c0
         CALL swichrep
         CALL udrepm
         CALL calcrpad
         LD   a,#cc
         CALL swichrep
         CALL rpause
         LD   a,0
rflglse  EQU  $-1
         OR   a
         JR   nz,repeatk
         LD   a,18
         CALL scankey
         JR   nz,repeatc
         LD   a,#ff
         LD   (rflglse),a
         LD   a,0
repmean  EQU  $-1
         OR   a
         JR   z,repeatk
         LD   a,(repeatf)
         AND  1
         JR   z,repeatc
repeatk
         LD   a,(repeatf)
         EX   af,af
         CALL dpause
         POP  bc
         POP  hl
         CALL putscr
         LD   a,(repmean)
         XOR  1
         LD   (repmean),a
repnum1
         EX   af,af
         AND  1
         RET  z
         SCF  
         RET  
udrepm                                  ; Update Repeat Motion
         LD   hl,repeatf
         LD   de,backfrth
         LD   a,0
backfrth EQU  $-1
         OR   a
         JR   nz,back
         INC  (hl)
         LD   a,(hl)
         CP   5
         RET  nz
         LD   a,#ff
forth
         LD   (de),a
         LD   a,3
         LD   (hl),a
         RET  
back
         DEC  (hl)
         LD   a,(hl)
         CP   #ff
         LD   a,(hl)
         RET  nz
         XOR  a
         LD   (de),a
         INC  a
         LD   (hl),a
         RET  
rpause
         LD   a,(repeatf)
         AND  1
         CALL rnoise
         INC  a
         ADD  a,a
         JP   pause
calcrpad
         ADD  a,a
         LD   e,a
         LD   d,0
         LD   hl,repeatad
         ADD  hl,de
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         EX   de,hl
         RET  
swichrep
         PUSH af
         CALL framefly
         POP  af
         LD   bc,#40d
         JP   swichgwa
gen
         PUSH bc
         PUSH hl
gen1
         LD   a,(de)
         LD   (hl),a
         INC  hl
         LD   a,h
         OR   #c0
         LD   h,a
         INC  de
         DJNZ gen1
         POP  hl
         LD   a,8
         ADD  a,h
         JR   nc,gen2
         LD   a,#50
         ADD  a,l
         LD   l,a
         LD   a,#c8
         ADC  a,h
gen2
         OR   #c0
         LD   h,a
         POP  bc
         DEC  c
         JR   nz,gen
         RET  
*f,digital.adm
