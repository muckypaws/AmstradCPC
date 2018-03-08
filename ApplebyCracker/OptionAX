;
         ORG  #40                       ; The Appleby Cracker
adam     EQU  #1900                     ; V1.89 Written By Jason Brooks 1989
loadfile EQU  #2000                     ; Option C 47K Files
xaddress DEFW #1000                     ; Option AX - Revised 1/3/91
filelen  DEFW 0
flag     DEFB 0
duff     DEFM APPLEBY .BIN
print
         EXX  
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
         DEFM The Appleby Tape - Disk 
         DEFM Copier
         DEFB 13,10,10
         DEFM (C) 1989 Jason Brooks.
         DEFB 13,10,10,15,2
         DEFM Please 
         DEFM Insert Your Destination 
         DEFM Disk
         DEFB 13,10,10
         DEFM Put Your Fully Rewoun
         DEFM d Cassette Into
         DEFB 13,10,10
         DEFM Your Tape Deck 
         DEFM And Press Play On Tape.
         DEFB 13,10,10
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
         DEFB 12,15,3
         DEFM Decodeing....
         DEFB 13,10,10,15,1,0
;
appleby  ENT  $
         DI   
         LD   sp,#bff8
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
         DI   
         LD   sp,#c000
         LD   hl,#1000
         LD   de,#1001
         LD   bc,#a100
         LD   (hl),l
         LDIR 
         LD   hl,getlen
         LD   de,#be00
         LD   bc,#100
         LDIR 
         LD   hl,tapedisk
         LD   de,#be80
         LD   bc,#bff0-#be80
         LDIR 
         CALL #bd37
         CALL #bc65
         LD   a,#ff
         CALL #bc6b
         LD   de,#2000
         LD   b,0
         CALL #bc77
         JP   nc,0
         LD   (laddress),de
         LD   b,8
         LD   de,filename
         LD   (filetype+1),a
gname
         LD   a,(hl)
         OR   a
         JR   z,blank
         CP   32
         JR   z,blank
         CP   "'"
         JR   z,blank
         LD   (de),a
         INC  hl
         INC  de
         DJNZ gname
         JR   loadin
blank
         LD   a,b
         CP   8
         JR   nz,blank1
         LD   hl,duff
         LD   de,filename
         LD   bc,8
         LDIR 
         JR   loadin
blank1
         LD   a,32
         LD   (de),a
         INC  de
         DJNZ blank1
loadin
         LD   hl,(laddress)
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
         LD   sp,#c000
         LD   bc,#7f8e
         XOR  a
         EXX  
         EX   af,af
         LD   hl,(number)
         INC  hl
         LD   (number),hl
detect                                  ; Detect Various Routines
         LD   hl,(naddress)
         LD   a,(hl)
         CP   #c3
         JP   z,hackit                  ; Refresh Waste Type Routine
         CP   #f3                       ; End Of Decode Sequence
         JP   z,hackit
         LD   hl,(number)
         LD   de,140
         AND  a
         SBC  hl,de
         JP   z,hackit
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
t5a
         LD   de,#b4c2
         LD   b,20
         CALL compare
         JP   c,clcjpnz
;
         LD   de,#23c2
         LD   b,20
         CALL compare
         JP   c,clcjpnz
         LD   de,#ebb2
         LD   b,40
         CALL compare
         JP   c,type25
         LD   de,#28d9
         LD   b,40
         CALL cmp1
         JP   c,type13
t4a
         LD   de,#2028
         LD   b,30
         CALL cmp1
         JP   c,type3
         JP   hackit
type25
         CALL copyrest
         PUSH de
         PUSH hl
         LD   hl,Decrypt+Restorel+10
         LD   a,(Decrypt+Restorel)
         CP   #d9
         JR   nz,t25a
         INC  hl
t25a
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
         LD   a,(Decrypt+Restorel)
         CP   #d9
         JR   nz,t13a
         INC  hl
         INC  de
t13a
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
         LD   a,(Decrypt+Restorel)
         CP   #d9
         JR   nz,ta
         INC  hl
         INC  de
ta
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
         JP   hackit
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
         JP   hackit
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
         LD   de,#ed5f
         CALL cp1
         POP  de
         JP   c,clcjrnz1
         PUSH de
         LD   de,#7ec6
         CALL cp1
         POP  de
         JP   c,clcjrnz1
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
         JP   c,clcjrnz1
;
         PUSH de
         LD   de,#7ec6
         CALL cp1
         POP  de
         JP   c,clcjrnz1
;
         PUSH de
         LD   de,#7ece
         CALL cp1
         POP  de
         JP   c,clcjrnz1
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
         LD   de,#0b35
         CALL cp1
         POP  de
         JP   c,clcjrnz1
;
;
         PUSH de
         LD   de,#0b78
         CALL cp1
         POP  de
         JP   c,clcjrnz1
;
         JP   hackit
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
Stackreg EQU  #c000
naddress DEFW 0
naddresx DEFW 0
laddress DEFW 0
Decrypt  EQU  #2000
BordeR   DEFB #54
offset   DEFB 0
number   DEFW 0
;
hacki    DEFW 0
hackit
         DI   
         LD   sp,#c000
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
eiret                                   ; Command That Finally Executes The Gam
         LD   hl,(e1)
         INC  hl
         LD   (e1),hl
         LD   a,(hl)
         CP   #fb
         JR   z,eiret1
         CP   #f3
         JR   z,eiret1
         CP   #cd
         JR   nz,eiret
         INC  hl
         LD   a,(hl)
         CP   9
         JR   z,call1
         CP   3
         JR   nz,eiret
call1                                   ; Is There A Call To #b909/3 & Ret ?
         INC  hl
         LD   a,(hl)
         CP   #b9
         JR   nz,eiret
         INC  hl
         LD   a,(hl)
         CP   #c9
         JR   nz,eiret
         LD   (e1),hl
         JR   call2
eiret1
         INC  hl
         LD   a,(hl)
         CP   #c9
         JR   nz,eiret
call2
         LD   hl,(e1)
         LD   (hl),#f7
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
         LD   (hl),#00
         INC  hl
         LD   (hl),#be
jump     JP   0
e1       DEFW 0
getlen                                  ; Get Program Start And Length
         LD   hl,#3f
upl
         INC  hl
         LD   a,(hl)
         OR   a
         JR   z,upl
         LD   (gs+1),hl
         LD   de,#b000
downl
         DEC  de
         LD   a,(de)
         OR   a
         JR   z,downl
         LD   a,d
         CP   #a7
         JR   c,downl1
         XOR  a
         DEC  a                         ; LD A #FF
         LD   (bigk),a                  ; Is It A Lot Of K ?
         LD   de,#a001
dl1
         DEC  de
         LD   a,(de)
         OR   a
         JR   z,dl1
         EX   de,hl
         AND  a
         SBC  hl,de
         INC  hl
         LD   (gl+1),hl
         LD   hl,#a000
         LD   de,#c000
         LD   bc,#1e80
         LDIR 
         JP   #be80
downl1
         EX   de,hl
         AND  a
         SBC  hl,de
         INC  hl
         LD   (gl+1),hl
         JP   #be80
tapedisk
         ORG  #be80
         DI   
         POP  hl
         POP  hl
         LD   sp,#c000
         PUSH hl
         CALL #b903
         CALL #b909
         LD   hl,loader
         LD   de,#b050
         LD   bc,#100-#50
         LDIR 
         LD   a,(bigk)
         OR   a
         JR   nz,sv
         LD   hl,0
         LD   (cold),hl
sv
         LD   hl,filename
         LD   de,file
         LD   bc,8
         LDIR 
         LD   a,#30
         LD   (file+9),a
         CALL #bc11
         LD   (mode),a
         CALL #bc3b
         LD   a,b
         LD   (border),a
         LD   ix,inks
         XOR  a
getink
         PUSH af
         CALL #bc35
         LD   (ix+0),b
         POP  af
         INC  ix
         INC  a
         CP   #f
         JR   nz,getink
         LD   hl,#afff
         LD   de,#40
         LD   c,7
         CALL #bcce
         LD   hl,#b050
         LD   de,#100-#50
         LD   b,8
         CALL save
         POP  hl
         LD   (exe+1),hl
         LD   hl,filename+9
         LD   (hl),#30
         LD   hl,#c000
         LD   de,#4000
         LD   b,len
         CALL save
gs       LD   hl,0
gl       LD   de,0
         LD   b,len
         CALL save
         RST  0
save
         PUSH hl
         PUSH de
         LD   hl,fnext
         INC  (hl)
         LD   hl,filename
         LD   de,#c000
         CALL #bc8c
         POP  de
         POP  hl
exe      LD   bc,#b050
         LD   a,2
         CALL #bc98
         JP   #bc8f
filename DEFS 8,32
         DEFM .
fnext    DEFB #1f,32,32
len      EQU  $-filename
bigk     DEFB 0
;
loader
         ORG  #b050
         DI   
         LD   sp,#c000
         LD   hl,#abff
         LD   de,#40
         LD   c,7
         CALL #bcce
         LD   a,(mode)
         CALL #bc0e
         LD   a,(border)
         LD   b,a
         LD   c,b
         CALL #bc38
         LD   ix,inks
         XOR  a
set
         PUSH af
         LD   b,(ix+0)
         LD   c,b
         CALL #bc32
         INC  ix
         POP  af
         INC  a
         AND  #f
         JR   nz,set
         CALL load
         CALL load
         LD   hl,copy
         LD   de,#be80
         LD   bc,#50
         LDIR 
gex      LD   hl,0
         JP   #be80
copy
         DI   
         PUSH hl
         LD   hl,#c000
         LD   de,#a000
         LD   bc,#1e80
cold     LDIR 
         RET  
load
         LD   hl,filee
         INC  (hl)
         LD   hl,file
         LD   b,len
         LD   de,#c000
         CALL #bc77
         EX   de,hl
         CALL #bc83
         LD   (gex+1),hl
         JP   #bc7a
file     DEFS 8,32
         DEFM .
filee    DEFM 0  
mode     DEFB 0
border   DEFB 0
inks     DEFS 16,0
;
