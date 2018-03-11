;
calcgwsa                                ; Calculate Gamble Win Screen Address
         LD   l,a                       ; Entry A=Height In Table
         LD   h,0
         LD   de,gwsat
         ADD  hl,de
         LD   a,(hl)
         LD   c,a
         AND  15
         OR   #e0
         LD   h,a
         LD   a,c
         AND  #f0
         OR   3
         LD   l,a
         RET  
cleartf                                 ; Clear Trail Flags
         LD   hl,trailfc
         LD   b,12
         XOR  a
ctf
         LD   (hl),a
         INC  hl
         DJNZ ctf
         CALL framefly
trailc                                  ; Trail Control Routine
         LD   de,#cc3c
         CALL setcs
         CALL framefly
         LD   de,trailfc
         LD   hl,trailfo
         LD   c,0
trailc1
         LD   a,(de)
         CP   (hl)
         LD   (hl),a
         CALL nz,trailc2
         INC  hl
         INC  de
         INC  c
         LD   a,c
         CP   11
         JR   NZ,trailc1
         CALL framefly
         LD   de,#c0cc
         CALL setcs
         LD   hl,#ef23
         LD   a,(lose)
         OR   a
         LD   a,#cc
         JR   nz,l3
         LD   a,#c0
l3
         AND  #55
         LD   d,a
         RLCA 
         LD   e,a
         LD   bc,#d12
         JR   swichgw1
trailc2
         PUSH bc
         PUSH de
         PUSH hl
         LD   b,(hl)
         LD   a,c
         CALL calcgwsa
         XOR  a
         OR   b
         LD   a,#cc
         CALL nz,gtable
         JR   nz,trailc3
         LD   a,#3c
trailc3
         CALL swichgw
         POP  hl
         POP  de
         POP  bc
         RET  
setcs                                   ; Set Colours To Switch
         LD   a,d
         AND  #55
         LD   (sgw2a),a
         RLCA 
         LD   (sgw1a),a
         LD   a,e
         AND  #55
         LD   (sgw2b),a
         RLCA 
         LD   (sgw1b),a
         RET  
swichgw                                 ; Switch Money Counters
         LD   bc,#d0f
swichgwa
         AND  #55
         LD   d,a
         RLCA 
         LD   e,a
swichgw1
         PUSH bc
         PUSH hl
swichgw2
         LD   a,(hl)
         AND  #aa
         CP   #28
sgw1a    EQU  $-1
         JR   z,swichgw3
         CP   #88
sgw1b    EQU  $-1
         JR   nz,swichgw4
swichgw3
         LD   a,(hl)
         AND  #55
         OR   e
         LD   (hl),a
swichgw4
         LD   a,(hl)
         AND  #55
         CP   #14
sgw2a    EQU  $-1
         JR   z,swichgw5
         CP   #44
sgw2b    EQU  $-1
         JR   nz,swichgw6
swichgw5
         LD   a,(hl)
         AND  #aa
         OR   d
         LD   (hl),a
swichgw6
         INC  hl
         LD   a,h
         OR   #c0
         LD   h,a
         DJNZ swichgw2
         POP  hl
         LD   a,h
         ADD  a,8
         JR   nc,swichgw7
         LD   a,#50
         ADD  a,l
         LD   l,a
         LD   a,#c8
         ADC  a,h
swichgw7
         OR   #c0
         LD   h,a
         POP  bc
         DEC  c
         JR   nz,swichgw1
         RET  
bags                                    ; Player Won 4.80 Spin To Bags
         CALL setpoint
         LD   a,%10001
         LD   (heldf),a
         CALL acellrls
bags1
         CALL getwin
         LD   de,winlbuff+3
         LD   hl,reel2spd
         CALL bags5
         LD   hl,reel3spd
         CALL bags5
         LD   hl,reel4spd
         CALL bags5
         CALL bags4
         JR   z,bags3
bags2
         CALL moveallr
         CALL checkm0
         JR   nz,bags2
         JR   bags1
bags3
         SUB  a
         LD   (heldf),a
         RET  
bags4
         EX   de,hl
         LD   a,#40
         DEC  hl
         CP   (hl)
         RET  nz
         DEC  hl
         CP   (hl)
         RET  nz
         DEC  hl
         CP   (hl)
         RET  
bags5
         LD   a,(de)
         AND  #f8
         LD   (de),a
         INC  de
         CP   #40
         RET  nz
         LD   (hl),0
         JP   boing
gamble
         CALL sdisable
         XOR  a
         LD   (flaglse),a
         LD   a,3
gt       EQU  $-1
         CALL pause
         CALL addnum1
         INC  a
         LD   (gt),a
         CALL retpres
gambleaz
         LD   a,(lastwin)
         OR   a
         RET  z
         SUB  48
         JR   nc,bags
         LD   hl,gwin-1
         ADD  a,48
         LD   b,11
gamble1
         CP   (hl)
         JR   z,gamble2
         JR   c,gamble2
         DEC  hl
         DJNZ gamble1
         RET  
gamble2
         LD   a,(hl)
         LD   (lastwin),a
         CALL settrail
         CALL settf
         CALL framefly
         LD   a,7                       ; Get Computer Timings
computg  EQU  $-1
         CALL ploseg
         JR   c,finalm
         CALL collect
         LD   a,(gwun)
         JR   c,finalm1
         LD   a,7
playertg EQU  $-1
         CALL pwing
         JR   nc,gambleaz
wungamb
         LD   a,(gwin)
finalm1
         LD   (gwun),a
         LD   e,a
         LD   d,0
         LD   hl,gmoney
         ADD  hl,de
         LD   a,(hl)
         LD   (lastwin),a
         CALL cleartf
         LD   hl,gwun
         CALL settf2
         CALL trailc
         LD   a,(lastwin)
         OR   a
         CALL z,losecont
         CALL sdisable                  ; Switch Off Sound
resetgc
         CALL rswich
         CALL nz,switchst
         CALL cs
         RET  z
         JP   swichcan
finalm
         LD   a,(glose)
         JR   finalm1
ploseg
         EX   af,af
         LD   hl,glose
         CALL settf2
         CALL trailc
         EX   af,af
plosega
         EX   af,af
         CALL framefly
         CALL gcancel
         CALL collect
         CCF  
         RET  nc
         LD   a,0
flaglse  EQU  $-1
         OR   a
         SCF  
         RET  nz
         LD   a,18
         CALL scankey
         SCF  
         RET  z
         EX   af,af
         DEC  a
         JR   nz,plosega
         LD   hl,glose
         CALL cleft2
         OR   a
         RET  
collect
         LD   a,51
         CALL scankey
         SCF  
         RET  z
         LD   a,62
         CALL scankey
         SCF  
         RET  z
         CCF  
         RET  
gcancel
         CALL delay
         RET  c
         CALL switchst
         JP   swichcan
pwing
         EX   af,af
         LD   hl,gwin
         CALL settf2
         CALL trailc
         EX   af,af
pwinga
         EX   af,af
         CALL framefly
         CALL gcancel
         CALL collect
         CCF  
         RET  nc
         LD   a,18
         CALL scankey
         JR   z,pwing1
pwing1l
         EX   af,af
         DEC  a
         JR   nz,pwinga
         LD   hl,gwin
         CALL cleft2
         OR   a
         RET  
pwing1
         LD   hl,flaglse
         LD   a,(mean)
         OR   a
         LD   (hl),a
         JR   nz,pwing1l
         CALL cleartf
         CALL trailc
         CALL wungamb
         OR   a
         RET  
losecont
         CALL addnum1
losec1
         ADD  a,a
         LD   c,a
         LD   b,0
         LD   hl,losttble
         ADD  hl,bc
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         EX   de,hl
         JP   scrmessj
settrail LD   c,a
         LD   a,0
tsetg    EQU  $-1
         OR   a
         LD   a,c
         RET  nz
         LD   hl,#503
         SUB  14
         JR   z,cgt2
         SUB  4
         JR   z,cgt2
         INC  h
         INC  l
cgt2
         LD   (gtrailo),hl
         LD   a,c
         LD   (tsetg),a
         RET  
settf                                   ; Set Trail Flags
         LD   hl,gtrail
         LD   a,b
         LD   bc,20
settf1
         CPIR 
         DEC  hl
         LD   a,(hl)
         LD   (gwun),a
         CALL settf2
         DEC  hl
         LD   a,(hl)
         LD   (gwin),a
         CALL cleft2
         INC  hl
         INC  hl
         LD   a,(hl)
         LD   (glose),a
         LD   a,0
gamblet  EQU  $-1
         OR   a
         JR   z,settf2
         LD   a,11
         LD   (glose),a
         LD   hl,gtrail+10
settf2
         PUSH hl
         LD   e,(hl)
         LD   d,0
         LD   hl,trailfc
         ADD  hl,de
         LD   (hl),#ff
settf3   EQU  $-1
         POP  hl
         RET  
cleft2
         XOR  a
         LD   (settf3),a
         CALL settf2
         DEC  a
         LD   (settf3),a
         RET  
delay1
         LD   hl,count1
         INC  (hl)
         LD   a,(hl)
         SUB  15
         RET  c
         LD   (hl),a
         RET  
*f,reelcont.adm
