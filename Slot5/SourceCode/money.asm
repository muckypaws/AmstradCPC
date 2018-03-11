;
meancont                                ; Control Mean Streak Of Computer
         ENT  $
         LD   de,200                    ; How Much Paid Out
paidout  EQU  $-2
         LD   hl,0
         ADD  hl,de
         ADD  hl,hl
         ADD  hl,de
         ADD  hl,hl
         ADD  hl,hl
         ADD  hl,hl
         ADD  hl,de
         ADD  hl,hl
         ADD  hl,hl                     ; HL=Winnings * 100
division                                ; 16 Bit Division Routine
         PUSH hl
         POP  bc
         LD   hl,0
         LD   de,400                    ; Computers Takings !
takings  EQU  $-2
         LD   a,b
         LD   b,16
divshift
         SLA  c
         RLA  
         ADC  hl,hl
         SBC  hl,de
         JR   c,divskip
         INC  c
         JR   divover
divskip
         ADD  hl,de
divover
         DJNZ divshift
         LD   a,c                       ; C = Roughly % Payout
         LD   (percent),a
         CP   40                        ; Is Payout < Legal Minimum ?
         JR   c,notmean                 ; If < Than Increase Chances
         CP   84
         RET  c
notmean
         CCF  
         SBC  a,a
         LD   (mean),a
         LD   (suppress),a
         RET  
submoney                                ; Money Handling Routines
         CALL submon2
         JR   meancont
submon2
         LD   hl,DigitalN+1
         LD   b,3
submon1
         DEC  (hl)
         LD   a,(hl)
         CP   #ff
         JR   nz,submon3
         LD   (hl),9
         INC  hl
         DJNZ submon1
submon3
         LD   hl,(takings)
         INC  hl
         LD   (takings),hl
         BIT  1,h
         RET  z
intake1                                 ; Divide Takings & Winnings By 2
         LD   hl,(takings)
         SRL  h
         RR   l
         LD   (takings),hl
         LD   hl,(paidout)
         SRL  h
         RR   l
         LD   (paidout),hl
         RET  
addmoney
         CALL admon2
         JR   meancont
admon2
         LD   hl,DigitalN+1
         LD   b,3
addmony1
         INC  (hl)
         LD   a,(hl)
         CP   #a
         JR   nz,addmony2
         LD   (hl),0
         INC  hl
         DJNZ addmony1
addmony2
         LD   hl,(paidout)
         INC  hl
         LD   (paidout),hl
         BIT  1,h
         RET  z
         JR   intake1
checkmon
         LD   de,(DigitalN)
         LD   hl,(DigitalN+2)
         XOR  a
         OR   l
         OR   h
         ADD  a,a
         OR   e
         OR   d
         RET  z
         DEC  a
         RET  nz
         DEC  d
         RET  
resetwb
         LD   hl,#00
         LD   (DigitalN),hl
         INC  l
         LD   (DigitalN+2),hl
         RET  
getnum
         LD   a,(lastwin)
         OR   a
         RET  nz
         LD   hl,winlbuff+1
         LD   e,0
         LD   c,e
         PUSH hl
         CALL addnum
         CALL addnum
         LD   a,e
         LD   (number1),a
         POP  hl
         INC  hl
         LD   e,0
         CALL addnum
         CALL addnum
         CALL addnum
         LD   a,e
         LD   (number2),a
         LD   hl,winlbuff+5
         LD   e,0
         CALL addnum
         CALL addnum
         LD   a,e
         LD   (number3),a
         LD   a,c
         LD   (numbers),a
         OR   a
         RET  
dispfunc
         LD   a,(functcnt)
         OR   a
         RET  nz
         LD   a,(lastwin)
         OR   a
         RET  nz
         CALL gameff
         CALL setfuncc
         CALL dcash
         CALL dropr1
         CALL dropr2
         CALL dropr3
         JP   copyfunc
addnum
         LD   a,(hl)
         AND  7
         CP   4
         CALL z,addnum1
         ADD  a,e
         LD   e,a
         ADD  a,c
         LD   c,a
         INC  hl
         INC  hl
         RET  
addnum1
         LD   a,r
         AND  3
         RET  
getwin
         CALL getwinl
getwiner
         XOR  a
         LD   (lastwin),a
         LD   hl,winlbuff
         CALL checkw2
         CALL checkw2
checkw2
         LD   a,(hl)
         AND  %11111000
         LD   e,a
         INC  hl
         LD   a,(hl)
         AND  %11111000
         LD   d,a
         INC  hl
         LD   a,(hl)
         AND  %11111000
         LD   b,e
         LD   c,a
         LD   a,d
         INC  hl
         SUB  b
         RET  nz
         LD   a,b
         SUB  c
         LD   b,4
         LD   a,c
         JR   nz,gw1
         CALL calcwin
gw1
         LD   a,(lastwin)
         ADD  a,b
         LD   (lastwin),a
         RET  
incmoney
         CALL convert
         LD   a,255
lastwin  EQU  $-1
         OR   a
         RET  z
         LD   b,a
im1
         PUSH bc
         PUSH hl
         CALL addmoney
         CALL framefly
         CALL Digital
         CALL ping
         LD   a,20
         CALL pause
         POP  hl
         POP  bc
         DJNZ im1
         JP   cleartf
im2
         XOR  a
         LD   (funcheld),a
         JP   resetf
getwinl                                 ; Get Winning Lines Out In To Table
         LD   de,winlbuff
         LD   hl,reelt1+mid+1
         CALL getwinla
         LD   hl,reelt2+mid+2
         CALL getwinla
         LD   hl,reelt3+mid+3
getwinla
         CALL getwinlb
         CALL getwinlb
getwinlb
         LD   a,(hl)
         LD   (de),a
         INC  de
         LD   bc,nfrtpr
         ADD  hl,bc
         RET  
calcwin
         PUSH hl
         SRL  c
         SRL  c
         SRL  c
         LD   e,c
         LD   d,0
         LD   hl,wintable
         ADD  hl,de
         LD   b,(hl)
         POP  hl
         RET  
multiple                                ; Multiple Key Presses
         PUSH hl
         PUSH bc
         LD   a,(hl)
         CALL scankey
         POP  bc
         POP  hl
         JR   nz,multkey2
         INC  hl
         DJNZ multiple
         SCF  
         RET  
multkey2
         OR   a
         RET  
regs                                    ; Display Machines Status
         LD   hl,regstr
         LD   b,4
         CALL multiple
         RET  nc
         LD   a,0
percent  EQU  $-1
         LD   d,10
         CALL subtract
         ADD  a,#30
         LD   (ppc+1),a
         LD   a,#30
         ADD  a,c
         CP   #30
         JR   nz,regs1
         ADD  a,#f
regs1
         LD   (ppc),a
         LD   hl,pms
         LD   a,(mean)
         CALL onoroff
         LD   a,(suppress)
         LD   hl,pms1
         CALL onoroff
         LD   hl,info
scrmessj
         CALL setupms
         LD   a,47
scrmessk
         CALL scrmess
         JP   dspace
onoroff
         OR   a
         JR   nz,onset
         CALL onoroff1
onoroff1
         LD   (hl),"F"
         INC  hl
         RET  
onset
         LD   (hl),"N"
         INC  hl
         LD   (hl),"?"
         RET  
convert
         XOR  a
         LD   (plus),a
         LD   a,(lastwin)               ; A=Amount Won
         OR   a
         RET  z
         LD   d,10                      ; Pounds
         CALL subtract
         LD   hl,pounds
         LD   (hl),c
         LD   (pence),a
         LD   d,5
         CALL subtract
         LD   hl,fifty
         LD   (hl),c
         LD   d,2
         CALL subtract
         LD   hl,twenty
         LD   (hl),c
         LD   d,1
         CALL subtract
         LD   hl,tens
         LD   (hl),c
         LD   hl,wunm
         LD   a,(pounds)
         OR   a
         JR   z,verbalm1
         LD   (hl),">"
         ADD  a,#30
         INC  hl
         LD   (hl),a
         INC  hl
         LD   (hl),"."
         INC  hl
verbalm1
         LD   a,0
pence    EQU  $-1
         ADD  a,#30
         LD   (hl),a
         INC  hl
         LD   (hl),#30
         INC  hl
         LD   a,(pounds)
         OR   a
         JR   nz,verbalm2
         LD   (hl),"P"
         INC  hl
verbalm2
         LD   (hl),"?"
         INC  hl
         LD   (hl),";"
         INC  hl
         LD   (hl),"?"
         INC  hl
         LD   a,0
pounds   EQU  $-1
         OR   a
         CALL nz,pounds1
         LD   a,0
fifty    EQU  $-1
         LD   d,5
         OR   a
         CALL nz,pence1
         LD   a,0
twenty   EQU  $-1
         LD   d,2
         OR   a
         CALL nz,pence1
         LD   a,0
tens     EQU  $-1
         SRL  d
         OR   a
         CALL nz,pence1
         LD   (hl),#ff
         LD   hl,youvewun
         CALL setupms
         LD   a,79
         CALL scrmess
         JP   dspace
pounds1
         LD   a,(pounds)
         CALL timesX
         LD   (hl),">"
         INC  hl
         LD   (hl),#31
         INC  hl
         LD   (hl),"?"
         INC  hl
         RET  
pence1
         EX   af,af
         LD   a,0
plus     EQU  $-1
         OR   a
         CALL nz,plus1
         EX   af,af
         CALL timesX
         LD   a,#30
         ADD  a,d
         LD   (hl),a
         INC  hl
         LD   (hl),#30
         INC  hl
         LD   (hl),"P"
         INC  hl
         LD   (hl),"?"
         INC  hl
         LD   (hl),"?"
         RET  
timesX
         LD   (hl),"?"
         INC  hl
         ADD  a,#30
         LD   (hl),a
         INC  hl
         LD   (hl),"?"
         INC  hl
         LD   (hl),"X"
         INC  hl
         LD   (hl),"?"
         INC  hl
         LD   a,#ff
         LD   (plus),a
         RET  
plus1
         LD   (hl),"?"
         INC  hl
         LD   (hl),"+"
         INC  hl
         LD   (hl),"?"
         INC  hl
         RET  
subtract
         LD   c,0
subt1
         SUB  d
         INC  c
         JR   nc,subt1
         ADD  a,d
         DEC  c
         RET  
updatemb                                ; Update Cash Pot Money Box
         LD   hl,nudges                 ; Update Nudges As Well
         LD   a,(hl)
         OR   a
         JR   nz,udnb1
         LD   (hl),1
udnb1
         CP   9
         JR   z,updatem1
         LD   a,15
udnb     EQU  $-1
         DEC  a
         LD   (udnb),a
         BIT  7,a
         JR   z,updatem1
         LD   a,r
         AND  7
         ADD  a,8
         LD   (udnb),a
         INC  (hl)
         CALL boing
updatem1
         LD   hl,cashpotm
         LD   a,(hl)
         CP   24
         RET  z
         LD   a,7
udmb     EQU  $-1
         DEC  a
         LD   (udmb),a
         BIT  7,a
         RET  z
         LD   a,r
         AND  7
         INC  a
         LD   (udmb),a
         INC  (hl)
         JP   ping
*f,decomp.adm
