;
         ORG  #40                       ; The Appleby Cracker
         JP   appleby
print
         LD   a,(hl)
         OR   a
         RET  z
         INC  hl
         CALL #bb5a
         JR   print
basic
         LD   hl,mess
         CALL print
         JP   appleby1
mess     DEFM A Basic File Has Been Det
         DEFM ected
         DEFB 13,10,10
         DEFM There May Be A Long Paus
         DEFM e Before The
         DEFB 13,10,10
         DEFM Loader Is Found.
         DEFB 13,10,10,0
mess1    DEFB 12,7
         DEFM The Appleby Decoder Syste
         DEFM m - 1989 - 1991
         DEFB 13,10,10,15,2
         DEFM (C) Jason 'THE ARGONAUT' 
         DEFM Brooks.
         DEFB 13,10,10,15,2
         DEFB 0
         DEFM Dedicated To SAMMY & ER
         DEFM IC Two Dogs Gone 
         DEFM But Never Forgotten.
         DEFM Created By Jason Brooks 
         DEFM 1989. Thanks To COLIN, I
         DEFM AN SHARPE, CHRIS PRICE, M
         DEFM Y PUBLISHERS & All My Fre
         DEFM inds.
mess2
         DEFB 12
         DEFM Decodeing...
         DEFB 13,10,10,0
;
appleby  ENT  $
         DI   
         LD   sp,#bff8
         LD   bc,#7fc0
         OUT  (c),c
         CALL #bd37
         LD   a,1
         CALL #bc0e
         LD   bc,0
         LD   a,b
         CALL #bc32
         LD   a,1
         LD   bc,#1a1a
         CALL #bc32
         LD   a,2
         LD   bc,#606
         CALL #bc32
         LD   a,3
         LD   bc,#1818
         CALL #bc32
         LD   hl,mess1
         CALL print
appleby1
         LD   sp,#bff8
         LD   hl,#1000
         LD   de,#1001
         LD   bc,#a04f
         LD   (hl),l
         LDIR 
         LD   hl,cheat
         LD   de,#be80
         LD   bc,#100
         LDIR 
         CALL #bd37
         CALL #bc65
         LD   a,#ff
         CALL #bc6b
         LD   de,#2000
         LD   b,0
         CALL #bc77
         JP   nc,0
         LD   (filetype),a
loadin
         EX   de,hl
         LD   (laddress),hl
         CALL #bc83
         JP   nc,0
         CALL #bc7a
         JP   nc,0
filetype LD   a,0
         BIT  1,a
         JP   z,basic
;
         LD   hl,mess2
         CALL print
         LD   hl,(laddress)
         LD   de,#17
         ADD  hl,de
         LD   (naddress),hl
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
         JP   z,quit                    ; Refresh Waste Type Routine
         CP   #f3                       ; End Of Decode Sequence
         JP   z,quit
t1a                                     ; Converted For Appleby Protections
         LD   de,#b120
         LD   b,26
         CALL compare
         JP   c,clcjrnz
t2a
         LD   hl,(naddress)
         LD   de,#14
         ADD  hl,de
         LD   de,#fdb5
         LD   b,10
         CALL compare1
         JP   c,type18
t3a                                     ; Is it Type 13 Encryption ???
         LD   de,#28d9
         LD   b,40
         CALL cmp1
         JP   c,type13
t4a
         LD   de,#2028
         LD   b,30
         CALL cmp1
         JP   c,type3
t5a
         LD   de,#b4c2
         LD   b,20
         CALL compare
         JP   c,clcjpnz
         LD   de,#ebb2
         LD   b,40
         CALL compare
         JP   c,type25
         LD   de,#23c2
         LD   b,20
         CALL compare
         JP   c,clcjpnz
         JP   quit
type25
         CALL copyrest
         PUSH de
         PUSH hl
         LD   hl,Decrypt+Restorel+10
         LD   (hl),#21
         INC  hl
         PUSH hl
         POP  de
         INC  de
         INC  de
         LD   (hl),e
         INC  hl
         LD   (hl),d
         INC  hl
         LD   (hl),0
         POP  hl
         POP  de
         LD   a,#c0
         LD   (de),a
         INC  de
         JR   jace
type3
         CALL copyrest
         DEC  de
         DEC  de
         LD   a,2
;LD   (de),a
         INC  de
         INC  de
         LD   (de),a
         INC  de
         LD   a,#fd
         LD   (de),a
         INC  de
         LD   a,#e9
         LD   (de),a
         INC  de
         PUSH hl
         PUSH de
         LD   de,Decrypt+Restorel+10
         LD   hl,Decrypt+Restorel+2
         LD   (hl),e
         INC  hl
         LD   (hl),d
         LD   hl,(naddress)
         INC  hl
         INC  hl
         LD   (naddress),hl
         POP  de
         POP  hl
         JR   jace
type13
         CALL copyrest
         LD   a,#e9
         LD   (de),a
         INC  de
         PUSH hl
         PUSH de
         LD   hl,Decrypt+Restorel+11
         LD   de,Decrypt+Restorel+13
         LD   (hl),e
         INC  hl
         LD   (hl),d
         POP  de
         POP  hl
         JR   jace
type18                                  ; Type 18 Xor Routine
         CALL copyrest
         CALL update
         LD   a,#20
         LD   (de),a
         INC  de
         PUSH de
         LD   de,#ed5f
         CALL cp1
         POP  de
         DEC  hl
         DEC  hl
         JR   c,clcjrnz1
         JP   quit
clcjrnz                                 ; Calculate JR NZ,xxxx
         CALL copyrest
         PUSH de
         LD   de,#7eaa
         CALL cp1
         POP  de
         JR   nc,rrc
clcjrnz1
         DEC  hl
         CALL clcjr
jace
         CALL copypres
         CALL update
         CALL swichcol
         CALL checkout
         JP   Decrypt
clcjpnz                                 ; Calculate JP NZ,xxxxx
         CALL copyrest
         PUSH de
         LD   de,#ed5f
         LD   b,10
         LD   hl,Decrypt+Restorel
         CALL compare1
         POP  de
         DEC  hl
         EX   de,hl
         LD   (hl),e
         INC  hl
         LD   (hl),d
         EX   de,hl
         CALL update
         INC  de
         JR   jace
update
         LD   hl,(naddress)
         INC  hl
         LD   (naddress),hl
         RET  
rrc
         PUSH de
         LD   de,#cb0e
         CALL cp1
         POP  de
         JR   c,clcjrnz1
;
         PUSH de
         LD   de,#cb06
         CALL cp1
         POP  de
         JR   c,clcjrnz1
;
         PUSH de
         LD   de,#7e2f
         CALL cp1
         POP  de
         JR   c,clcjrnz1
;
         PUSH de
         LD   de,#7ed6
         CALL cp1
         POP  de
         JR   c,clcjrnz1
;
         PUSH de
         LD   de,#7eed
         CALL cp1
         POP  de
         JR   c,clcjrnz1
;
         PUSH de
         LD   de,#7ec6
         CALL cp1
         POP  de
         JR   c,clcjrnz1
;
         PUSH de
         LD   de,#7ece
         CALL cp1
         POP  de
         JR   c,clcjrnz1
;
         PUSH de
         LD   de,#0b35
         CALL cp1
         POP  de
         JP   c,clcjrnz1
;
         PUSH de
         LD   de,#7eac
         CALL cp1
         POP  de
         JP   c,clcjrnz1
;
         PUSH de
         LD   de,#7ede
         CALL cp1
         POP  de
         JP   c,clcjrnz1
;
         PUSH de
         LD   de,#0b78
         CALL cp1
         POP  de
         JP   c,clcjrnz1
;
         PUSH de
         LD   de,#ed5f
         CALL cp1
         POP  de
         JP   c,clcjrnz1
         PUSH de
         LD   de,#7ec6
         CALL cp1
         POP  de
         JP   c,clcjrnz1
         JP   quit
cp1
         LD   hl,Decrypt+Restorel+5
         LD   b,11
         JR   compare1
clcjr
         PUSH de
         PUSH hl
         EX   de,hl
         AND  a
         SBC  hl,de
         LD   a,l
         CPL  
         POP  hl
         POP  de
         LD   (de),a
         INC  de
         RET  
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
cmp1
         LD   hl,(naddress)
cmp2
         INC  hl
         LD   a,(hl)
         CP   d
         JR   nz,cmp3
         INC  hl
         INC  hl
         LD   a,(hl)
         CP   e
         JR   z,compare3
cmp3
         DJNZ cmp2
         OR   a
         RET  
swichcol
         PUSH af
         PUSH bc
         LD   a,(BordeR)
         XOR  #10
         LD   (BordeR),a
         LD   bc,#7f10
         OUT  (c),c
         OUT  (c),a
         POP  bc
         POP  af
         RET  
;
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
         PUSH de
         PUSH bc
         LD   hl,#2000
         LD   de,#2001
         LD   bc,#200
         LD   (hl),l
         LDIR 
         POP  bc
         POP  de
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
loadfile EQU  #2000
filelen  DEFW 0
flag     DEFB 0
hacki    DEFW 0
quit
         LD   hl,(naddress)
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         EX   de,hl
         LD   bc,#29
         ADD  hl,bc
         LD   (hacki),hl
hack1
         LD   hl,(hacki)
         INC  hl
         LD   (hacki),hl
         LD   a,(hl)
         CP   #21
         JR   nz,hack1
         INC  hl
         INC  hl
         INC  hl
         LD   a,(hl)
         CP   #e
         JR   nz,hack1
         INC  hl
         LD   a,(hl)
         CP   #ff
         JR   nz,hack1
         INC  hl
         LD   a,(hl)
         CP   #d5
         JR   nz,hack1
         INC  hl
         LD   a,(hl)
         CP   #c9
         JR   nz,hack1
         LD   hl,(hacki)
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         EX   de,hl
         LD   (hacki),hl                ; Execution Address Is Now In Hacki
         LD   (e1),hl
pshsppop
         LD   hl,(e1)
         INC  hl
         LD   (e1),hl
         LD   a,(hl)
         CP   #e1
         JR   nz,pshsppop
         INC  hl
         LD   a,(hl)
         CP   #31
         JR   nz,pshsppop
         INC  hl
         LD   a,(hl)
         CP   #f8
         JR   nz,pshsppop
         INC  hl
         LD   a,(hl)
         CP   #bf
         JR   nz,pshsppop
         INC  hl
         LD   a,(hl)
         CP   #e5
         JR   nz,pshsppop
         LD   hl,(e1)
         LD   (hl),#f7
;DI   
;LD   bc,#7fc4
;OUT  (c),c
;JP   #4000
;
call2
         LD   hl,runit
         LD   de,#b000
         LD   bc,#50
         LDIR 
         JP   #b000
runit
         DI   
         LD   sp,#c000
         LD   hl,(hacki)
         PUSH hl
         LD   hl,(laddress)
         LD   de,#3d0
         ADD  hl,de
         PUSH hl
         POP  bc
         LD   hl,#40
         LD   de,#41
         LD   (hl),0
         LDIR 
         LD   hl,(#bd17)
         LD   a,h
         AND  #3f
         LD   h,a
         EX   de,hl
         POP  hl
         LD   (#b03f),hl
         LD   hl,#b033
         PUSH de
         LD   bc,#7f8b
         OUT  (c),c
         LD   c,#ff
         RET  
hello
         LD   hl,#30
         LD   (hl),#c3
         INC  hl
         LD   (hl),#80
         INC  hl
         LD   (hl),#be
jump     JP   0
e1       DEFW 0
;
cheat                                   ; Insert Cheat Code Here
         POP  de
         POP  hl
         PUSH de
         NOP  
         NOP  
         XOR  a
         LD   (#7a21),a
         LD   (#89cb),a
         RET  
