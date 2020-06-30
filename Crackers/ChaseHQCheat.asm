;
         ORG  #4000                     ; Speedlock Encryption Breaker
start                                   ; Designed And Written By
         ENT  $                         ; Jason (THE ARGONAUT) Brooks
adam     EQU  #4000                     ; (C) 1990 JacesofT
         DI   
         LD   sp,#c000
         LD   bc,#7fc0
         OUT  (c),c
         LD   hl,code
         LD   de,#be00
         LD   bc,#100
         LDIR 
         CALL #bd37
         LD   b,0
         LD   de,#1000
         CALL #bc77
         EX   de,hl
         CALL #bc83
         INC  hl
         LD   (naddress),hl
         CALL #bc7a
         LD   sp,#bff8
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
         JP   adam
t7
         JP   adam
calcjrpo                                ; Calculate Offset On RET PO : JR Rout.
         PUSH hl
         LD   de,#ed5f
         LD   b,#18
         CALL compare
         EX   de,hl
         POP  hl
         PUSH hl
         AND  a
         SBC  hl,de
         LD   a,l
         CPL  
         LD   (offset),a
         LD   hl,(naddress)
         LD   (naddresx),hl
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
         JP   execute
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
         DEFM Speedlock De-cryption An
         DEFM alyser Designed & Prog
         DEFM rammed By Jason (THE AR
         DEFM GONAUT) Brooks (C) 199
         DEFM 0 JacesofT Software Ltd. 
         DEFM Not To Be Used For Infrin
         DEFM ging Copyright.
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
;
code
         ORG  #be00
         NOP  
cheat1
         DI   
         XOR  a
         LD   h,a
         LD   l,h
         LD   (#2082),hl
         LD   (#2074),a
         EXX  
         JP   (hl)
quit
         DI   
         CALL #a6c1
         DI   
         LD   ix,#a9fa
         LD   de,#c6
         CALL #a655
         DI   
         LD   hl,adamit
         LD   a,#c3
         LD   (#a627),a
         LD   (#a628),hl
         JP   #aa33
adamit
         LD   hl,cheat
         LD   de,#bf87
         LD   bc,cheatl
         LDIR 
         JP   #bf1e
cheat
         JP   cheat1
cheatl   EQU  $-cheat
