;
modulec                                 ; Module Control Unit
         LD   a,(functcnt)
         OR   a
         RET  nz
         LD   hl,functcnt               ; Point To Function Counter
         EXX  
         LD   hl,row1bfo
         LD   de,row2bfo
         LD   bc,row3bfo
         LD   a,9
funcav                                  ; Is There A Gaming Function Available
         EX   af,af
         LD   a,(hl)
         OR   a
         RET  z
         LD   a,(de)
         OR   a
         RET  z
         LD   a,(bc)
         OR   a
         RET  z
         EXX  
         INC  (hl)
         EXX  
         EX   af,af
         INC  hl
         INC  de
         INC  bc
         DEC  a
         JR   nz,funcav
         RET  
funhfc
         CALL cleartf
         XOR  a
         LD   (funcheld),a
         CALL isany
         RET  z
         LD   a,(lastwin)
         OR   a
         RET  nz
         CALL checkmon
         RET  z
         LD   a,r
         CP   34
         RET  c
         CALL getnum
         LD   a,0
row1tot  EQU  $-1
         CP   4
         RET  nc
         LD   a,0
row2tot  EQU  $-1
         CP   3
         RET  nc
         LD   a,0
row3tot  EQU  $-1
         CP   5
         RET  nc
         LD   a,#ff
         LD   (funcheld),a
         CALL gamec
         LD   a,20
oscil1
         PUSH af
         LD   de,#3ccf
         CALL setcs
         LD   hl,#cee0+#50
         LD   bc,#e12
         LD   a,#3c
         CALL swichgwa
         POP  af
         PUSH af
         ADD  a,a
         CALL pause
         LD   hl,#cee0+#50
         LD   bc,#e12
         LD   a,#cf
         CALL swichgwa
         POP  af
         PUSH af
         ADD  a,a
         CALL pause
         POP  af
         CALL sosc
         DEC  a
         JR   nz,oscil1
         CALL copyfunc
         JP   dpause
gamblef                                 ; Gamble Gaming Function
         CALL cleartf
         LD   de,#3ccf
         CALL setcs
         LD   hl,#cee0+#50
         LD   bc,#e12
         LD   a,#3c
         CALL swichgwa
         CALL setfuncc
         LD   a,(functcnt)
         OR   a
         RET  z
         XOR  a
         LD   (funcheld),a
         CALL gameff
         CALL clearxs
         CALL setfuncc
         CALL setfun1
         LD   hl,suppress
         LD   a,(hl)
         PUSH af
         LD   (hl),#ff
         PUSH hl
         CALL movenumb
         POP  hl
         POP  af
         LD   (hl),a
gamblef1
         CALL clearix
         LD   a,(functcnt)
         LD   (lfunc),a
         CP   9
         JR   z,takeit
         CALL copyfunc
         CALL hilocont
         JR   nc,losthl
         OR   a
         JR   z,takeitb
         LD   a,(hilonum)
         DEC  a
         JR   z,mega
         CALL bardisp
         JR   gamblef1
takeitb
         LD   a,(functcnt)
         CP   2
         JR   nz,takeit
         CALL addmoney
         CALL addmoney
takeit
         CALL copyfunc
takeita
         LD   a,(functcnt)
         OR   a
         RET  z
         DEC  a
         ADD  a,a
         LD   e,a
         LD   d,0
         LD   hl,functab                ; HL=Address Table Of Gaming Functions
         ADD  hl,de
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         PUSH de
         RET  
takeit1
         CALL gameff
         CALL repeat
         PUSH af
         CALL dpause
         POP  af
         JR   nc,takeita
lostfunc
         CALL resetag
         CALL copyfunc
         CALL game0
         JP   losthl1
losthl
         LD   a,(hilonum)
         DEC  a
         JR   z,mega
         CALL resetag
losthl1
         CALL lostgame
         XOR  a
         LD   (winner),a
         LD   (functcnt),a
         LD   (funcheld),a
         RET  
bardisp
         CALL resethl
         CALL setfuncc
         CALL getfad
         LD   a,#ff
         CALL setfun
         CALL framefly
         CALL setfun1
         LD   hl,functcnt
         INC  (hl)
         RET  
mega                                    ; Mega Cash 4.80 Repeaters
         CALL clearix
         CALL bardisp
         LD   a,(hl)
         SUB  9
         JR   nz,mega
         CALL clearix
         DEC  a
         LD   (suppress),a
         CALL movenumb
         JP   takeit
lostgame
         CALL game0
         LD   a,0
lfunc    EQU  $-1
         DEC  a
         ADD  a,a
         LD   e,a
         LD   d,0
         LD   hl,gamelt
         ADD  hl,de
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         EX   de,hl
         CALL setupms
         LD   a,47
         CALL scrmess
         JP   dspace
clearix
         LD   a,(functcnt)
         DEC  a
         LD   hl,row1bf
         LD   de,row2bf
         LD   bc,row3bf
clearix1
         RET  z
         EX   af,af
         XOR  a
         LD   (hl),a
         LD   (de),a
         LD   (bc),a
         PUSH bc
         PUSH de
         PUSH hl
         CALL framefly
         CALL setfuncc
         CALL setfun1
         POP  hl
         POP  de
         POP  bc
         INC  hl
         INC  de
         INC  bc
         EX   af,af
         DEC  a
         JR   clearix1
clearxs                                 ; Clear Xcess Numbers
         LD   hl,row1bf+8
         LD   de,row2bf+8
         LD   bc,row3bf+8
         LD   a,8
clearx1
         EX   af,af
         LD   a,(de)
         OR   a
         JR   z,clearx2
         LD   a,(hl)
         OR   a
         JR   z,clearx2
         LD   a,(bc)
         OR   a
         JR   z,clearx2
         EX   af,af
         RET  
clearx2
         XOR  a
         LD   (hl),a
         LD   (de),a
         LD   (bc),a
         EX   af,af
         DEC  hl
         DEC  de
         DEC  bc
         DEC  a
         JR   nz,clearx1
         RET  
resfunt
         LD   a,(functcnt)
         OR   a
         RET  z
         XOR  a
         DEC  a
         LD   (flashrt),a
         LD   de,9
         JR   flashrt1
flashfnt                                ; Flash Current Function To Gamble
         LD   hl,count1
         INC  (hl)
         LD   a,(hl)
         SUB  18
         RET  c
         LD   (hl),a
flashrt1
         CALL setfuncc
         CALL getfad
         LD   a,0
flashrt  EQU  $-1
         XOR  #ff
         LD   (flashrt),a
         CALL setfun
         CALL framefly
setfun1
         CALL row1c
         CALL row2c
         JP   row3c
getfad
         LD   a,(functcnt)
         LD   e,a
         LD   d,0
         LD   hl,row1bf
         ADD  hl,de
         LD   e,9
         RET  
setfun
         LD   (hl),a
         ADD  hl,de
         LD   (hl),a
         ADD  hl,de
         LD   (hl),a
         RET  
*f,repeat.adm
