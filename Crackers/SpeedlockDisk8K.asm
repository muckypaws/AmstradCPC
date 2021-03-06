;
         ORG  #1000                     ; Speedlock Cracker V2.90 - Disk
start                                   ; Designed & Developed By Jason Brooks
         ENT  $                         ; (C) 1990 JacesofT Software Ltd.
         DI                             ; Currently For Version 90 Types
         IM   1                         ; Executed By RUN "DISC
         LD   sp,#c000
         LD   bc,#7fc0
         OUT  (c),c
         CALL #bd37
         LD   hl,Decrypt
         LD   de,Decrypt+1
         LD   bc,#a900-Decrypt
         LD   (hl),0
         LDIR 
         LD   hl,#abff
         LD   de,#40
         LD   c,7
         CALL #bcce
         LD   hl,name
         LD   b,len
         CALL #bc77
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
         JR   copygame
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
         LD   hl,load
         LD   de,#be80
         LD   bc,#100
         LDIR 
         LD   a,#c3
         LD   hl,end3a
         LD   (#bd16),a
         LD   (#bd17),hl
         LD   hl,(naddress)
         JP   (hl)
end3a
         LD   (naddress),hl
         LD   b,0
sc1
         INC  b
         LD   a,b
         OR   a
         JR   z,sc2
         INC  hl
         LD   a,(hl)
         CP   #21
         JR   nz,sc1
         INC  hl
         LD   a,(hl)
         OR   a
         JR   nz,sc1
         INC  hl
         LD   a,(hl)
         CP   #c0
         JR   nz,sc1
         INC  hl
         LD   a,(hl)
         CP   #cd
         JR   nz,sc1
sc2
         LD   a,b
         OR   a
         JR   z,sc2a                    ; Inks Not Found
         INC  hl
         INC  hl
         INC  hl
         INC  hl
         LD   e,(hl)
         INC  hl
         PUSH hl
         LD   d,(hl)
         EX   de,hl
         LD   de,inks
         LD   bc,16
         LDIR 
         POP  hl
sc2a                                    ; Get Execution Address
         INC  hl
         LD   a,(hl)
         CP   #cd
         JR   nz,sc2a
         INC  hl
         INC  hl
         INC  hl
         LD   a,(hl)
         CP   #21
         JR   nz,sc2a
         PUSH hl
         LD   (xdest),hl
         LD   de,execcode
         LD   bc,#100
         LDIR 
         POP  hl
         LD   de,save1
         LD   (hl),#c3
         INC  hl
         LD   (hl),e
         INC  hl
         LD   (hl),d
         JP   #b000
save                                    ; Save Code
         ORG  #b000
         LD   hl,(naddress)
         PUSH hl
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
         LD   sp,#bff8
         CALL #bd37
         CALL #bc11
         LD   (mode),a
         LD   hl,#af00
         LD   c,7
         CALL #bcce
         LD   bc,#606
         CALL #bc38
         LD   a,7
         CALL #bb5a
savek
         LD   a,51
         CALL #bb1e
         JR   z,savek
         LD   hl,#be80
         LD   de,#bfa0-#be80
         LD   b,4
         CALL saver
         LD   hl,#c000
         LD   de,#4000
         LD   b,slen
         CALL saver
         LD   hl,#3f
savex
         INC  hl
         LD   a,(hl)
         OR   a
         JR   z,savex
         LD   de,#a600
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
         CALL saver
         RST  0
saver
         PUSH de
         PUSH hl
         LD   hl,saven+4
         INC  (hl)
         LD   hl,saven
         CALL #bc8c
         POP  hl
         POP  de
         LD   bc,#be80
         LD   a,2
         CALL #bc98
         JP   #bc8f
saven    DEFM DISC
         DEFB "0"-1
slen     EQU  $-saven
load                                    ; Loader Code
         ORG  #be80
         DI   
         LD   sp,#b100
         LD   bc,#7fc0
         OUT  (c),c
         LD   hl,#b090
         LD   c,7
         CALL #bcce
         LD   bc,0
         CALL #bc38
         LD   ix,inks
         XOR  a
seti
         PUSH af
         LD   b,(ix+0)
         LD   c,b
         CALL #bc32
         POP  af
         INC  ix
         INC  a
         CP   16
         JR   nz,seti
         LD   a,0
mode     EQU  $-1
         CALL #bc0e
         CALL loader
         CALL loader
         DI   
         LD   hl,execcode
         LD   de,0
xdest    EQU  $-2
         PUSH de
         LD   bc,#100
         LDIR 
         RET  
loader
         LD   hl,namel+4
         INC  (hl)
         LD   hl,namel
         LD   b,lenl
         CALL #bc77
         EX   de,hl
         CALL #bc83
         JP   #bc7a
namel    DEFM DISC0
lenl     EQU  $-namel
inks     DEFS 16,0
execcode                                ; Place Execution Code Here
         DEFS 100,0
