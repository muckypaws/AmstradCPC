;
         ORG  #3000                     ; Speedlock Cracker V2.90 - Disk
start                                   ; Designed & Developed By Jason Brooks
         ENT  $                         ; (C) 1990 JacesofT Software Ltd.
         DI                             ; Currently For Version 90 Types
         IM   1                         ; Executed By RUN "DISC
         LD   sp,#c000
         LD   bc,#7fc0
         OUT  (c),c
         CALL #bd37
         LD   hl,#40
         LD   de,#41
         LD   bc,start-#30
         LD   (hl),h
         LDIR 
         LD   hl,#3600
         LD   de,#3601
         LD   bc,#a900-#3600
         LD   (hl),l
         LDIR 
         LD   hl,#abff
         LD   de,#40
         LD   c,7
         CALL #bcce
         LD   hl,name
         LD   b,len
         CALL #bc77
         CALL nc,DISK                   ; Possibly Spelt Differently
         EX   de,hl
         LD   (filetype),a
         CALL #bc83
         PUSH hl
         CALL #bc7a
         LD   hl,comm
         CALL #bcd4
         EX   de,hl
         LD   hl,read
         LD   (hl),e
         INC  hl
         LD   (hl),d
         INC  hl
         LD   (hl),c
         POP  hl
         LD   a,0
filetype EQU  $-1
         BIT  1,a
         JR   z,CPM
         LD   b,0
         LD   de,#790e
         CALL compare1
         INC  hl
         LD   c,(hl)
         LD   hl,#40
entry1
         LD   de,0
         RST  #18
         DEFW read
         DI   
         LD   a,0
wrong    EQU  $-1
         OR   a
         JR   nz,DISK1
         LD   hl,#100
         LD   de,#d5ed
         LD   b,0
         CALL compare1
         DEC  hl
         LD   (hl),0
         DEC  hl
         LD   d,(hl)
         DEC  hl
         LD   e,(hl)
         PUSH de
         CALL #100
         POP  hl
         DEC  hl
         LD   (hl),a
         DEC  hl
         LD   (hl),#3e
         LD   (naddress),hl
         JR   return
CPM                                     ; Those Executed With |CPM
         LD   hl,#100
         LD   c,#41
         JR   entry1
DISK
         CALL #bc7d
         LD   a,"K"
         LD   (wrong),a
         LD   (name+3),a
         LD   hl,name
         LD   b,len
         CALL #bc77
         RET  c
         RST  0
DISK1
         LD   hl,#108
DI1
         INC  hl
         LD   a,(hl)
         CP   #c3
         JR   nz,DI1
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (naddress),de
         LD   de,return
         LD   (hl),d
         DEC  hl
         LD   (hl),e
         JP   #100
return
         DI   
         LD   sp,#bf90
         LD   bc,#7f8e
         XOR  a
         EXX  
         EX   af,af
         LD   hl,(number)
         INC  hl
         LD   (number),hl
         CALL detect
waster
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (naddress),de
         LD   a,(refresh)
         INC  a
         AND  #7f
         LD   (refresh),a
detect                                  ; Detect Various Routines
         LD   hl,(naddress)
         LD   a,(hl)
         CP   #c3
         JR   z,waster                  ; Refresh Waste Type Routine
         CP   #f3                       ; End Of Decode Sequence
         JP   z,adam
t1                                      ; Isit Type 1
         LD   de,#b1c2
         CALL compare
         JP   c,calcjpnz
t2
         LD   de,#b3c2
         CALL compare
         JP   c,calcjpnz
t3
         LD   de,#b0ca
         CALL compare
         JP   c,calcjpz
t4
         LD   de,#b0c2
         CALL compare
         JP   c,calcjpnz
t5
         LD   de,#e018
         CALL compare
         JP   c,calcjrpo
t6
         LD   hl,(naddress)
         LD   (naddresx),hl
         LD   de,0
         LD   b,#30
         CALL compare
         JR   nc,t7
         INC  hl
         CALL calcjp
         PUSH de
         LD   de,#edb8
         LD   b,18
         LD   hl,(naddresx)
         CALL compare1
         DEC  hl
         LD   (offset),hl
         LD   hl,Decrypt+Restorel
         LD   b,60
         CALL compare1
         DEC  hl
         PUSH hl
         DEC  hl
         DEC  hl
         POP  de
         LD   c,(hl)
         LD   (hl),e
         INC  hl
         LD   b,(hl)
         LD   (hl),d
         LD   (offset),bc
         LD   de,6
         ADD  hl,de
         LD   (hl),#21
         INC  hl
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         DEC  hl
         DEC  hl
         PUSH hl
         LD   hl,(offset)
         ADD  hl,de
         EX   de,hl
         POP  hl
         LD   (hl),e
         INC  hl
         LD   (hl),d
         INC  hl
         LD   (hl),0
         INC  hl
         LD   (hl),0
         LD   hl,(naddress)
         INC  hl
         LD   (naddress),hl
         POP  de
         CALL copypres
         JP   execute
t7
         JP   adam
calcjrpo                                ; Calculate Offset On RET PO : JR Rout.
         PUSH hl
         LD   hl,(naddress)
         LD   (naddresx),hl
         LD   de,#ed5f
         LD   b,#1e
         CALL compare
         EX   de,hl
         POP  hl
         PUSH hl
         AND  a
         SBC  hl,de
         LD   a,l
         CPL  
         SUB  2
         LD   (offset),a
         POP  hl
         CALL copyrest
         LD   hl,(naddresx)
         LD   a,(offset)
         LD   (de),a
         INC  de
         PUSH de
         LD   de,#b8ea
         LD   b,#14
         CALL compare1
         POP  de
         INC  hl
         LD   c,(hl)
         LD   (hl),e
         INC  hl
         LD   b,(hl)
         LD   (hl),d
         INC  hl
         LD   (naddress),bc
         CALL copypres
         JR   execute
calcjpz
         LD   bc,(naddress)
         PUSH bc
         INC  hl
         LD   (naddresx),hl
         INC  hl
         INC  hl
         CALL calcjp
         LD   hl,(naddress)
         INC  hl
         LD   (naddress),hl
         PUSH de
         CALL copypres
         POP  de
         POP  bc
         PUSH de
         LD   hl,(naddresx)
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (naddress),de
         AND  a
         SBC  hl,bc
         EX   de,hl
         LD   hl,Decrypt+Restorel
         ADD  hl,de
         POP  de
         DEC  hl
         LD   (hl),e
         INC  hl
         LD   (hl),d
         JP   execute
calcjpnz
         PUSH hl
         LD   hl,(naddress)
         LD   de,#dde1
         LD   b,30
         CALL compare1
         POP  hl
         JR   c,jpnz1
         CALL calcjp
         LD   hl,(naddress)
         INC  hl
         LD   (naddress),hl
         CALL copypres
execute
         CALL swichcol
         CALL checkout
         JP   Decrypt
jpnz1
         PUSH de
         LD   de,8
         ADD  hl,de
         POP  de
         CALL copyrest
         PUSH de
         LD   hl,Decrypt+Restorel
         LD   de,#dde1
         LD   b,0
         CALL compare1
         DEC  hl
         DEC  hl
         LD   d,(hl)
         DEC  hl
         LD   e,(hl)
         DEC  hl
         LD   (hl),#dd
         INC  hl
         LD   (hl),#21
         INC  hl
         LD   (hl),e
         INC  hl
         LD   (hl),d
         INC  hl
         LD   (hl),0
         LD   de,#b0c2
         LD   b,0
         CALL compare1
         POP  de
         PUSH de
         DEC  de
         DEC  de
         DEC  de
         INC  hl
         LD   (hl),e
         INC  hl
         LD   (hl),d
         INC  hl
         INC  hl
         POP  de
         PUSH de
         LD   (hl),e
         INC  hl
         LD   (hl),d
         PUSH hl
         LD   hl,Decrypt+Restorel
         LD   de,#ed5f
         LD   b,0
         CALL compare1
         EX   de,hl
         DEC  de
         POP  hl
         INC  hl
         INC  hl
         LD   (hl),e
         INC  hl
         LD   (hl),d
         POP  de
         CALL copypres
         JP   execute
checkout
         LD   b,0
         LD   de,#ed49
         LD   hl,Decrypt
         CALL compare1
         RET  nc
         LD   (hl),0
         DEC  hl
         LD   (hl),0
         JR   checkout
calcjp
         INC  hl
         PUSH hl
         LD   l,(hl)
         LD   bc,(naddress)
         AND  a
         SBC  hl,bc
         LD   h,0
         LD   (offset),hl
         POP  hl
         CALL copyrest
         LD   hl,Decrypt+Restorel
         LD   bc,(offset)
         DEC  de
         ADD  hl,bc
         EX   de,hl
         LD   (hl),e
         INC  hl
         LD   (hl),d
         INC  hl
         EX   de,hl
         RET  
compare
         LD   hl,(naddress)
         LD   b,70
compare1
         INC  hl
         LD   a,(hl)
         CP   d
         JR   nz,compare2
         INC  hl
         LD   a,(hl)
         CP   e
         JR   z,compare3
compare2
         DJNZ compare1
         OR   a
         RET  
compare3
         SCF  
         RET  
swichcol
         PUSH af
         PUSH bc
         LD   a,(BordeR)
         INC  a
         AND  #1f
         OR   #40
         LD   (BordeR),a
         LD   bc,#7f10
         OUT  (c),c
         OUT  (c),a
         POP  bc
         POP  af
         RET  
;
disk
         LD   hl,#abff
         LD   de,#40
         LD   c,7
         JP   #bcce
;
Restore                                 ; Restore Registers To Original Content
         DI   
         LD   sp,Stackreg-20
         LD   a,0
refresh  EQU  $-1
         LD   r,a
         POP  hl
         POP  de
         POP  bc
         POP  af
         EX   af,af
         EXX  
         POP  iy
         POP  ix
         POP  hl
         POP  de
         POP  bc
         POP  af                        ; Decryption Starts Here
Restorel EQU  $-Restore
copyrest
         PUSH hl
         LD   hl,Restore
         LD   de,Decrypt
         LD   bc,Restorel
         LDIR 
         POP  hl
         LD   bc,(naddress)
         AND  a
         SBC  hl,bc
         INC  hl
         PUSH hl
         LD   hl,(naddress)
         POP  bc
         LDIR 
         LD   (naddress),hl
         RET  
copypres
         LD   hl,Preserve
         LD   bc,Preservl
         LDIR 
         RET  
Preserve
         LD   sp,Stackreg
         PUSH af
         PUSH bc
         PUSH de
         PUSH hl
         PUSH ix
         PUSH iy
         EXX  
         EX   af,af
         PUSH af
         PUSH bc
         PUSH de
         PUSH hl
         LD   a,r
         SUB  31
         RES  7,a
         LD   (refresh),a
         JP   return
Preservl EQU  $-Preserve
Stackreg EQU  #bff0
naddress DEFW 0
naddresx DEFW 0
Decrypt  EQU  #2000
BordeR   DEFB #54
offset   DEFW 0
number   DEFW 0
name     DEFM DISC
len      EQU  $-name
comm     DEFB #84
read     DEFS 3,0
adam
         JP   copygame
nobm
         DEFB 12,13,10,10
         DEFM Inserted Disk In DRIVE A
         DEFM :   Is Not A Recognized 
         DEFM BATMAN - THE CAPED CRUSAD
         DEFM ER DISK. Press A Key To Q
         DEFM uit.
         DEFB 13,10,10,7,0
adam1    EQU  #4000
adama
         DI   
         PUSH bc
         LD   bc,#7fc4
         OUT  (c),c
         LD   bc,#fa7e
         XOR  a
         OUT  (c),a
         POP  bc
         JP   adam1
notbatm
         LD   a,2
         CALL #bc0e
         LD   hl,nobm
         CALL print
         CALL #bb18
         RST  0
copygame                                ; Copy Game
         LD   hl,(naddress)
end1
         INC  hl
         LD   a,(hl)
         CP   #cd
         JR   nz,end1
         INC  hl
         INC  hl
         INC  hl
         LD   a,(hl)
         DEC  hl
         DEC  hl
         CP   #d9
         JR   z,end2
         CP   #21
         JR   nz,end1
end2
         INC  hl
         INC  hl
end2a
         LD   (naddress),hl
         LD   hl,end3
         LD   c,#ff
         CALL #bd16
end3
         DI   
         LD   hl,save
         LD   de,#b000
         LD   bc,#200
         LDIR 
;LD   hl,load
         LD   de,#be80
         LD   bc,#100
;LDIR 
         LD   hl,(#bd38)
         LD   a,h
         AND  #3f
         LD   h,a
         LD   (bd37),hl
         LD   a,#c3
         LD   hl,end3a
         LD   (#bd16),a
         LD   (#bd17),hl
         LD   hl,(naddress)
         JP   (hl)
end3a
         LD   (naddress),hl
md1
         LD   hl,#a4ac
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   hl,#f3f5
         AND  a
         SBC  hl,de
         JP   z,notbatm                 ; Not Batman
         LD   a,0
scrflag  EQU  $-1
         OR   a
         LD   (barb),a
         LD   a,#c3
         JR   z,bat1
         LD   hl,save1
         LD   (#a4fc),a
         LD   (#a4fd),hl
         LD   (#a527),a
         LD   (#a528),hl
bat1
         LD   hl,save1
         LD   (#a545),a
         LD   (#a546),hl
         LD   hl,save1a
         LD   (#a51a),a
         LD   (#a51b),hl
         LD   hl,0
         LD   (#a4c1),hl
         JP   #b000
print
         LD   a,(hl)
         OR   a
         RET  z
         INC  hl
         CALL #bb5a
         JR   print
save                                    ; Save Code
         ORG  #b000
         LD   hl,(naddress)
         PUSH hl
         LD   l,0
         LD   (saves),hl
         LD   hl,#40
         LD   de,#41
         POP  bc
         PUSH bc
         LD   c,h
         LD   (hl),h
         LDIR 
         POP  hl
         JP   (hl)
save1
         DI   
         LD   hl,batg1                  ; BATMAN 1st Game
         JR   save1b
save1a
         LD   hl,batg2                  ; BATMAN 2nd Game
save1b
         LD   a,(barb)
         OR   a
         JR   z,save1c
         LD   hl,bats1
save1c
         LD   de,saven
         LD   bc,8
         LDIR 
         LD   sp,#bff8
         LD   bc,#7f8b
         OUT  (c),c
         CALL #44
         CALL 0
bd37     EQU  $-2
         XOR  a
         LD   bc,#7f8e
         OUT  (c),c
         EX   af,af
         EXX  
         LD   hl,xx
xx
         LD   c,7
         CALL #bcce
         LD   bc,#7f10
         LD   a,#44
         OUT  (c),c
         OUT  (c),a
         LD   a,7
         CALL #bb5a
savek
         LD   a,51
         CALL #bb1e
         JR   z,savek
         LD   a,0
barb     EQU  $-1
         OR   a
         LD   a,#20
         LD   de,#4000
         JR   nz,batsc
         LD   hl,#3f
savex
         INC  hl
         LD   a,(hl)
         OR   a
         JR   z,savex
         LD   de,#a600
saves    EQU  $-2
save2
         DEC  de
         LD   a,(de)
         OR   a
         JR   z,save2
         EX   de,hl
         AND  a
         SBC  hl,de
         INC  hl
         INC  hl
         EX   de,hl
         LD   b,slen
         LD   a,#31
         CALL saver
         LD   a,#32
         LD   de,#2000
batsc
         LD   hl,#c000
         LD   b,slen
         CALL saver
         LD   a,(barb)
         OR   a
         JR   z,batsc1
         LD   hl,bats2
         LD   (qq),hl
         LD   hl,#8000
         LD   de,#8900
lbat
         DEC  de
         LD   a,(de)
         OR   a
         JR   z,lbat
         RES  7,d
         INC  de
         LD   b,7
         CALL saver
batsc1
         RST  0
saver
         PUSH de
         PUSH hl
         LD   hl,saven+7
         LD   (hl),a
         LD   hl,saven
qq       EQU  $-2
         CALL #bc8c
         POP  hl
         POP  de
         LD   bc,#be80
         LD   a,2
         CALL #bc98
         JP   #bc8f
saven    DEFM ARGONAUT
slen     EQU  $-saven
batg1    DEFM BATFETE0
batg2    DEFM BATBIRD0
bats1    DEFM BATPAGE 
bats2    DEFM BATGAME 
