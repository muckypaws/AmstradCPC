
.COPYRIGHT 1985 MICRO-APPLICATION.
.DAMS.

;
         ORG  #40                       ; Speedlock Encryption Breaker
start                                   ; Designed And Written By
         ENT  $                         ; Jason (THE ARGONAUT) Brooks
adam     EQU  #4000                     ; (C) 1990 JacesofT
         DI   
         LD   sp,#c000
         LD   bc,#7fc0
         OUT  (c),c
         CALL #bd37
         LD   bc,0
         CALL #bc38
         XOR  a
         LD   b,a
         LD   c,b
         CALL #bc32
         LD   b,0
         LD   de,#1000
         CALL #bc77
         PUSH de
         LD   de,tname
         LD   c,0
         LD   b,8
getinfo1
         LD   ix,Template
         LD   b,templen
getinfo2
         LD   a,(hl)
         CP   "."
         JR   z,end
         OR   a
         JR   z,end
         CP   32
         JR   z,end
         CP   (ix+0)
         JR   z,getinfo3
         INC  ix
         DJNZ getinfo2
         JR   getinfo4
getinfo3
         LD   (de),a
         INC  de
         INC  c
getinfo4
         INC  hl
         LD   a,c
         CP   8
         JR   nz,getinfo1
end
         LD   a,c
         OR   a
         JR   z,end2
         LD   a,8
         SUB  c
         LD   b,a
         LD   a,32
end3
         LD   (de),a
         INC  de
         DJNZ end3
end2
         POP  hl
         CALL #bc83
         LD   a,(hl)
         CP   #f3
         JR   nz,set
         INC  hl
set
         LD   (naddress),hl
         CALL #bc7a
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
         ADD  a,1
         RES  7,a
         LD   (refresh),a
detect                                  ; Detect Various Routines
         LD   hl,(naddress)
         LD   a,(hl)
         CP   #c3
         JR   z,waster                  ; Refresh Waste Type Routine
         CP   #f3                       ; End Of Decode Sequence
         JP   z,quit
;
t1                                      ; Isit Type 1
         LD   de,#b3c2
         LD   b,14
         CALL compare
         JR   nc,t2
         JP   calcjpnz
t2
         LD   de,#b1c2
         LD   b,#3f
         CALL compare
         JR   nc,t3
         JP   calcjpnz
t3
         LD   de,#e018
         LD   b,#24
         CALL compare
         JR   nc,t4
         JP   calcjrpo
t4
         LD   de,#b0ca
         LD   b,#1f
         CALL compare
         JR   nc,t5
         JP   calcjpz
t5
         LD   hl,(naddress)
         LD   (naddresx),hl
         LD   de,0
         LD   b,#30
         CALL compare
         JR   nc,t6
         INC  hl
         CALL calcjp
         PUSH de
         LD   de,#edb8
         LD   b,18
         LD   hl,(naddresx)
         CALL compare1
         DEC  hl
         LD   (offset),hl
         LD   hl,Decrypt
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
t6
         LD   de,#b0c2
         LD   b,28
         CALL compare
         JR   nc,t7
         JP   calcjpnz
t7
         LD   sp,#bff8
         LD   bc,#7fc4
         OUT  (c),c
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
         CALL calcjp
         LD   hl,(naddress)
         INC  hl
         LD   (naddress),hl
         CALL copypres
execute
         CALL swichcol
         CALL checkout
         JP   Decrypt
checkout
         LD   b,#f0
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
;LD   sp,(Decstak)
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
;LD   (Decstak),sp
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
Decstak  DEFW 0
Stackreg EQU  #bff0
naddress DEFW 0
naddresx DEFW 0
laddress DEFW 0
Decrypt  EQU  #2000
BordeR   DEFB #54
offset   DEFB 0
number   DEFW 0
Template
         DEFM ABCDEFGHIJKLMNOPQRSTUVWXY
         DEFM Z0123456789!"#$&+-@^
templen  EQU  $-Template
tname    DEFS 8,32
quit
         LD   sp,#bff8
         LD   de,#EDB8
         LD   b,0
         CALL compare
         INC  hl
         PUSH hl
         LD   a,#c3
         LD   hl,trap
         LD   (#bd16),a
         LD   (#bd17),hl
         RET  
trap
         LD   (naddress),hl
         LD   (naddresx),hl
trap1
         INC  hl
         LD   a,(hl)
         CP   #cd
         JR   nz,trap1
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)                    ; DE = Address To Call Page
         PUSH de
         LD   de,#edb8
         LD   b,0
         CALL compare
trap2
         INC  hl
         LD   a,(hl)
         CP   #c3
         JR   nz,trap2
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         EX   de,hl
         LD   (naddress),hl             ; naddress = Load Prog Routine
         POP  bc
         CALL jpbc
         DI   
         LD   hl,(naddress)
         INC  hl
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         PUSH de
         POP  ix                        ; IX = Load Address
         INC  hl
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)                    ; DE = Length
         INC  hl
         INC  hl
         LD   c,(hl)
         INC  hl
         LD   b,(hl)                    ; BC = Load Routine
         INC  hl
         LD   (naddress),hl             ; naddress = Prog. Continue
         LD   (spload),bc
         CALL jpbc
         LD   hl,(spload)
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         EX   de,hl
getexec
         INC  hl
         LD   a,(hl)
         CP   #c2
         JR   nz,getexec
         INC  hl
         INC  hl
         INC  hl
         LD   a,(hl)
         CP   #11
         JR   nz,getexec
         INC  hl
         INC  hl
         INC  hl
         LD   a,(hl)
         CP   #ed
         JR   nz,getexec
         INC  hl
         LD   a,(hl)
         CP   #53
         JR   nz,getexec
         INC  hl
         INC  hl
         INC  hl
         LD   a,(hl)
         CP   #11
         JR   nz,getexec
         INC  hl
         INC  hl
         INC  hl
         LD   a,(hl)
         CP   #d5
         JR   nz,getexec
         INC  hl
         LD   a,(hl)
         CP   #ed
         JR   nz,getexec
         INC  hl
         LD   a,(hl)
         CP   #5b
         JR   nz,getexec
         LD   de,12
         AND  a
         SBC  hl,de
         LD   a,#c3
         LD   de,next2
         LD   (hl),a
         INC  hl
         LD   (hl),e
         INC  hl
         LD   (hl),d
         LD   hl,copycode
         LD   de,next2
         LD   bc,#1a0
         LDIR 
         LD   hl,tname
         LD   de,#b160
         LD   bc,8
         LDIR 
         LD   hl,jump
         LD   de,#be80
         PUSH de
         LD   bc,#40
         LDIR 
         JP   #bd37
jump
         DI   
         LD   hl,(naddress)
         PUSH hl
         LD   hl,(naddresx)
         PUSH hl
         LD   bc,#40
         AND  a
         SBC  hl,bc
         PUSH hl
         POP  bc
         LD   hl,#40
         LD   de,#41
         LD   (hl),h
         LDIR 
         POP  hl
         LD   (searchl+1),hl
         POP  hl
         LD   sp,#bffe
         JP   (hl)
jpbc
         PUSH bc
         RET  
spload   DEFW 0
copycode
         ORG  #b050
next2
         DI   
         LD   sp,#c000-2
         LD   hl,loader
         LD   de,#be80
         LD   bc,codelen
         LDIR 
         CALL #bc11
         LD   (mode+1),a
         LD   ix,inks
         XOR  a
getinks
         PUSH af
         CALL #bc35
         LD   (ix+0),b
         INC  ix
         POP  af
         INC  a
         CP   16
         JR   nz,getinks
         LD   bc,#f600
         OUT  (c),c
         LD   hl,#afff
         LD   de,#40
         LD   c,7
         CALL #bcce
         LD   hl,#bf00
getchek
         INC  hl
         LD   a,(hl)
         CP   #3a
         JR   nz,getchek
         LD   (hl),#af
         INC  hl
         LD   (hl),0
         INC  hl
         LD   (hl),0
getchek1
         LD   a,h
         CP   #c0
         JR   z,getchek3
         INC  hl
         LD   a,(hl)
         DEC  a
         JR   nz,getchek1
         INC  hl
         LD   a,(hl)
         DEC  hl
         CP   #7f
         JR   nz,getchek1
         INC  hl
         INC  hl
         LD   a,(hl)
         DEC  hl
         DEC  hl
         CP   #fb
         JR   nz,getchek1
         INC  hl
         INC  hl
         INC  hl
         INC  hl
         INC  hl
         LD   (hl),0
         INC  hl
         LD   (hl),0
getchek3
         LD   hl,#be80
         LD   de,#bfd0-#be80
         LD   b,8
         CALL save
         LD   hl,#c000
         LD   de,#4000
         LD   b,10
         CALL save
         LD   hl,#3f
len1
         INC  hl
         LD   a,(hl)
         OR   a
         JR   z,len1
searchl
         LD   de,0
len2
         DEC  de
         LD   a,(de)
         OR   a
         JR   z,len2
         EX   de,hl
         AND  a
         SBC  hl,de
         INC  hl
         INC  hl
         EX   de,hl
         LD   b,10
         CALL save
         RST  0
save
         PUSH hl
         PUSH de
         LD   hl,name+9
         INC  (hl)
         LD   hl,name
         LD   de,#c000
         CALL #bc8c
         POP  de
         POP  hl
         LD   bc,#be80
         LD   a,2
         CALL #bc98
         JP   #bc8f
loader
         ORG  #be80
         DI   
         LD   sp,#bff8
         LD   bc,#7fc0
         OUT  (c),c
         LD   hl,#b0ff
         LD   de,#40
         LD   c,7
         CALL #bcce
mode     LD   a,0
         CALL #bc0e
         LD   bc,0
         CALL #bc38
         LD   ix,inks
         XOR  a
setinks
         PUSH af
         LD   b,(ix+0)
         LD   c,b
         CALL #bc32
         INC  ix
         POP  af
         INC  a
         CP   16
         JR   nz,setinks
         CALL load
         CALL load
         DI   
         JR   #bf00
load
         LD   hl,name+9
         INC  (hl)
         LD   hl,name
         LD   de,#c000
         LD   b,10
         CALL #bc77
         EX   de,hl
         CALL #bc83
         JP   #bc7a
name     DEFM SPEDLOCK.
         DEFB "0"-1
inks     DEFS 16,0
codelen  EQU  $-#be80
