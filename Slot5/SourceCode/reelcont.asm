;
insert
         CALL submoney
         CALL submoney
         CALL framefly
         JP   Digital
swichp
         LD   de,#cf
         CALL setcs
         CALL framefly
         LD   hl,#c000
         LD   bc,#91d
         JR   swich1
swichcan                                ; Switch Cancel/Take
         LD   de,#c
         CALL setcs
         CALL framefly
         LD   hl,#ee41
         LD   bc,#c24
colcn
         LD   a,0
         XOR  #c
         LD   (colcn+1),a
         JP   swichgwa
switchst                                ; Switch start/gamble Colours
         LD   de,#cf
         CALL setcs
         CALL framefly
         LD   hl,#fcb1
         LD   bc,#c24
swich1
         LD   a,0
colst    EQU  $-1
         XOR  #cf
         LD   (colst),a
         JP   swichgwa
delay
         CALL framefly
         LD   hl,count
         INC  (hl)
         LD   a,(hl)
         SUB  40
         RET  c
         LD   (hl),a
         RET  
rswich
         LD   a,(colst)
         OR   a
         RET  
cs
         LD   a,(colcn+1)
         OR   a
         RET  
getret
         LD   a,0
         OR   a
         CALL nz,holdr
         CALL regs
         XOR  a
         LD   (lastwin),a
         CALL delay
         CALL z,switchst
getret0
         LD   a,47
         CALL scankey
         RET  z
         LD   a,59
         CALL scankey
         JR   nz,nowalk
         LD   a,#ff
         LD   (walkf),a
         LD   hl,byebye
         CALL setupms
         LD   a,80
         JP   scrmess
nowalk
         LD   a,18
         CALL scankey
         JR   nz,getret
         CALL resetgc
spinrls                                 ; Spin The Reels
         CALL swichhld
         CALL insert
         CALL whichnum
         CALL setpoint                  ; Set Pointers
         CALL updatemb                  ; Update Money Box
         CALL acellrls
spinrls1
         CALL moveallr                  ; Move all reels
         CALL checkm0
         JR   nz,spinrls1
         LD   a,0
rscount  EQU  $-1
         DEC  a
         LD   (rscount),a
         LD   (lastwin),a
         CALL z,stopok
         LD   hl,heldf
         LD   a,(hl)
         CP   %11111
         JR   nz,spinrls1
         XOR  a
         LD   (hl),a
         LD   (lastwin),a
         RET  
stopok
         LD   a,0
winner   EQU  $-1
         OR   a
         JR   nz,winspin
         LD   a,0
mean     EQU  $-1
         OR   a
         JR   z,nxtpnt2
         CALL getwin
         LD   a,(lastwin)
         OR   a
         JR   nz,nxtpnt
         CALL getnum
         LD   hl,number2
numreel  EQU  $-2
         LD   a,(hl)
         OR   a
         JR   z,nxtpnt2
nxtpnt
         LD   a,2
         LD   (rscount),a
         LD   a,0
nxtpnt1  EQU  $-1
         INC  a
         LD   (nxtpnt1),a
         SUB  5
         RET  nz
         LD   (nxtpnt1),a
nxtpnt2
         JP   setheldb
winspin
         LD   a,(heldf)
         OR   a
         JR   z,nxtpnt2
         CALL getwin
         LD   a,(lastwin)
         OR   a
         JR   nz,nxtpnt2
         LD   a,2
         LD   (rscount),a
         RET  
whichnum                                ; Find Out Which Reel Number Is Needed
         LD   hl,number1
         LD   a,(row1tot)
         OR   a
         JR   z,whichn1
         LD   hl,number2
         LD   a,(row2tot)
         OR   a
         JR   z,whichn1
         LD   hl,number3
whichn1
         LD   (numreel),hl
         RET  
acellrls                                ; Accelerate Reels On Start Up
         LD   hl,accelsqn
nmac
         LD   b,11
accelrl1
         PUSH hl
         PUSH bc
         LD   a,(hl)
         CALL set5rspd
         CALL framefly
         CALL moveallr
         CALL framefly
         POP  bc
         POP  hl
         INC  hl
         DJNZ accelrl1
         RET  
checkm0                                 ; Check If MOVED = 0
         PUSH hl
         LD   hl,moved1
         XOR  a
         OR   (hl)
         INC  hl
         OR   (hl)
         INC  hl
         OR   (hl)
         INC  hl
         OR   (hl)
         INC  hl
         OR   (hl)
         POP  hl
         RET  
moveallr
         CALL mover1
         CALL mover2
         CALL mover3
         CALL mover4
         JP   mover5
mover1
         LD   a,(moved1)
         OR   a
         JR   nz,mover1a
         LD   a,(heldf)
         BIT  4,a
         JR   z,mover1a
         XOR  a
         LD   (reel1spd),a
mover1a
         LD   a,0
state    EQU  $-1
         BIT  4,a
         JP   z,reel1cd
         JP   reel1cu
mover2
         LD   a,(moved2)
         OR   a
         JR   nz,mover2a
         LD   a,(heldf)
         BIT  3,a
         JR   z,mover2a
         XOR  a
         LD   (reel2spd),a
         LD   hl,reel2bfd
         CALL ingamefd
mover2a
         LD   a,(state)
         BIT  3,a
         JP   z,reel2cd
         JP   reel2cu
mover3
         LD   a,(moved3)
         OR   a
         JR   nz,mover3a
         LD   a,(heldf)
         BIT  2,a
         JR   z,mover3a
         XOR  a
         LD   (reel3spd),a
mover3a
         LD   a,(state)
         BIT  2,a
         JP   z,reel3cd
         JP   reel3cu
mover4
         LD   a,(moved4)
         OR   a
         JR   nz,mover4a
         LD   a,(heldf)
         BIT  1,a
         JR   z,mover4a
         XOR  a
         LD   (reel4spd),a
         LD   hl,reel4bfd
         CALL ingamefd
mover4a
         LD   a,(state)
         BIT  1,a
         JP   z,reel4cd
         JP   reel4cu
mover5
         LD   a,(moved5)
         OR   a
         JR   nz,mover5a
         LD   a,(heldf)
         BIT  0,a
         JR   z,mover5a
         XOR  a
         LD   (reel5spd),a
mover5a
         LD   a,(state)
         BIT  0,a
         JP   z,reel5cd
         JP   reel5cu
set5rspd
         LD   de,reel1spd
         LD   b,5
set5rsp1
         LD   (de),a
         INC  de
         DJNZ set5rsp1
         RET  
rinchl
         INC  (hl)
         LD   a,(hl)
         CP   nfrtpr+1
         RET  nz
         LD   (hl),1
         RET  
rdechl
         DEC  (hl)
         RET  nz
         LD   (hl),nfrtpr
         RET  
resetspd
         LD   hl,reel1spd
         XOR  a
         LD   b,5
resetspa
         LD   (hl),a
         INC  hl
         DJNZ resetspa
         RET  
*f,general.adm
