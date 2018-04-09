;
;
         ORG  #40                       ; The Appleby Cracker
adam     EQU  #1900                     ; V1.89 Written By Jason Brooks 1989
loadfile EQU  #2000
laddress DEFW #7d39
xaddress DEFW #1000
naddress DEFW 0
filelen  DEFW 0
flag     DEFB 0
duff     DEFM APPLEBY .BIN
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
         DEFM The Appleby Tape - Disk 
         DEFM Copier
         DEFB 13,10,10
         DEFM (C) 1989 Nemesis
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
         DEFB 12,7,15,3
         DEFM This Will Take About 5 Mi
         DEFM nutes To Decode
         DEFB 13,10,10,15,1
         DEFM So Please Don't Panic
         DEFB 13,10,10
         DEFM To Make Things Interestin
         DEFM g,
         DEFB 13,10,10
         DEFM Watch The Dots Below
         DEFB 13,10,10,0
;
appleby  ENT  $
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
         LD   bc,#a04f
         LD   (hl),l
         LDIR 
         LD   hl,getlen
         LD   de,#be00
         LD   bc,#100
         LDIR 
         LD   hl,tapedisk
         LD   de,#be80
         LD   bc,#c000-#be80
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
         LD   hl,loadfile
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
         LD   hl,loadfile
         LD   de,(laddress)
         LD   bc,#1000
         LDIR 
         LD   ix,#50*10+#c000
;
here                                    ; Return To Here At End Of Xor
         DI   
         LD   hl,(naddress)
         LD   a,(hl)
         CP   #d9
         JR   nz,here1
         INC  hl
         LD   (naddress),hl
         LD   hl,(xaddress)
         LD   (hl),#d9
         INC  hl
         LD   (xaddress),hl
here1
         LD   a,(flag)
         CP   13
         JR   nz,herey
         LD   hl,(naddress)
         DEC  hl
         LD   a,(hl)
         CP   #d9
         JR   z,herey
         LD   (naddress),hl
         LD   hl,(xaddress)
         DEC  hl
         LD   (xaddress),hl
herey
         CALL detect
         OR   a
         JP   z,hackit
         LD   (ix+0),a
         INC  ix
         LD   (flag),a
         DI   
         LD   hl,loadfile
         LD   de,(laddress)
         LD   bc,#1000
         LDIR 
         CALL return
         CALL #1000
         JR   here
;
return                                  ; Place Return Code
         LD   hl,returnc
         LD   de,(xaddress)
         LD   bc,6
         LDIR 
         RET  
returnc
         LD   sp,#c000
         JP   here
detect                                  ; Detect Next Xor To Uncover
;Is is   Type 1 ?
;
         LD   hl,(naddress)             ; HL = Address Of Next Xor
         LD   a,(hl)
         CP   1                         ; Is It A LD BC Command ?
         JR   nz,nott1
         INC  hl
         INC  hl
         INC  hl
         LD   a,(hl)
         CP   #21
         JR   nz,nott1
         LD   hl,(naddress)
         LD   de,x1-t1x
         ADD  hl,de
         EX   de,hl
         LD   hl,x1                     ; HL=Address Of Xor Type1
         CALL scan
         JP   z,t1
nott1
         LD   hl,(naddress)
         LD   a,(hl)
         CP   #21
         JR   nz,nott2
         INC  hl
         INC  hl
         INC  hl
         LD   a,(hl)
         CP   1
         JR   nz,nott2
         LD   hl,(naddress)
         LD   de,x2-t2x
         ADD  hl,de
         EX   de,hl
         LD   hl,x2
         CALL scan
         JP   z,t2
nott2
         LD   hl,(naddress)
         LD   a,(hl)
         CP   #fd
         JR   nz,nott3
         INC  hl
         LD   a,(hl)
         CP   #21
         JR   nz,nott3
         INC  hl
         INC  hl
         INC  hl
         LD   a,(hl)
         CP   #11
         JR   nz,nott3
         LD   hl,(naddress)
         LD   de,x3-t3x
         ADD  hl,de
         EX   de,hl
         LD   hl,x3
         CALL scan
         JP   z,t3
nott3
;
         LD   hl,(naddress)
         LD   a,(hl)
         CP   #31
         JR   nz,nott4
         INC  hl
         INC  hl
         INC  hl
         LD   a,(hl)
         CP   #21
         JR   nz,nott4
         LD   hl,(naddress)
         LD   de,x4-t4x
         ADD  hl,de
         EX   de,hl
         LD   hl,x4
         LD   b,12
         CALL scanl1
         JP   z,t4
nott4
         LD   hl,(naddress)
         LD   de,x5-t5x
         ADD  hl,de
         EX   de,hl
         LD   hl,x5
         CALL scanl
         JP   z,t5
nott5
         LD   hl,(naddress)
         LD   de,x6-t6x
         ADD  hl,de
         EX   de,hl
         LD   hl,x6
         CALL scanl
         JP   z,t6
nott6
         LD   hl,(naddress)
         LD   de,x7-t7x
         ADD  hl,de
         EX   de,hl
         LD   hl,x7
         LD   b,13
         CALL scanl1
         JP   z,t7
nott7
         LD   hl,(naddress)
         LD   de,x8-t8x
         ADD  hl,de
         EX   de,hl
         LD   hl,x8
         CALL scanm
         JP   z,t8
nott8
         LD   hl,(naddress)
         LD   a,(hl)
         CP   1
         JR   nz,nott9
         INC  hl
         INC  hl
         INC  hl
         LD   a,(hl)
         CP   #21
         JR   nz,nott9
         INC  hl
         INC  hl
         INC  hl
         LD   a,(hl)
         CP   #7e
         JR   nz,nott9
         INC  hl
         LD   a,(hl)
         CP   #d6
         JR   nz,nott9
         INC  hl
         INC  hl
         EX   de,hl
         LD   hl,x9+3
         CALL scanm
         JP   z,t9
nott9
         LD   hl,(naddress)
         LD   de,x10-t10x
         ADD  hl,de
         EX   de,hl
         LD   hl,x10
         CALL scanl
         JP   z,t10
notta
         LD   hl,(naddress)
         LD   de,x11-t11x
         ADD  hl,de
         EX   de,hl
         LD   hl,x11
         CALL scanl
         JP   z,t11
nottb
         LD   hl,(naddress)
         LD   a,(hl)
         CP   1
         JR   nz,nottc
         INC  hl
         INC  hl
         INC  hl
         LD   a,(hl)
         CP   #21
         JR   nz,nottc
         INC  hl
         INC  hl
         INC  hl
         LD   a,(hl)
         CP   #37
         JR   nz,nottc
         INC  hl
         LD   a,(hl)
         CP   #7e
         JR   nz,nottc
         INC  hl
         LD   a,(hl)
         CP   #ce
         JR   nz,nottc
         INC  hl
         INC  hl
         EX   de,hl
         LD   hl,x12+3
         CALL scanm
         JP   z,t12
nottc
         LD   hl,(naddress)
         LD   de,x13-t13x
         ADD  hl,de
         EX   de,hl
         LD   hl,x13
         CALL scan
         JP   z,t13
nottd
         LD   hl,(naddress)
         LD   a,(hl)
         CP   #21
         JR   nz,notte
         INC  hl
         INC  hl
         INC  hl
         LD   a,(hl)
         CP   #11
         JR   nz,notte
         INC  hl
         INC  hl
         INC  hl
         EX   de,hl
         LD   hl,x14
         CALL scanm
         JP   z,t14
notte
         LD   hl,(naddress)
         LD   a,(hl)
         CP   1
         JR   nz,nottf
         INC  hl
         INC  hl
         INC  hl
         LD   a,(hl)
         CP   #21
         JR   nz,nottf
         INC  hl
         INC  hl
         INC  hl
         LD   a,(hl)
         CP   #7e
         JR   nz,nottf
         INC  hl
         LD   a,(hl)
         CP   #c6
         JR   nz,nottf
         INC  hl
         INC  hl
         EX   de,hl
         LD   hl,x15add+2
         CALL scanm
         JP   z,t15
nottf
         LD   hl,(naddress)
         LD   de,x16-t16x
         ADD  hl,de
         EX   de,hl
         LD   hl,x16
         LD   b,10
         CALL scanl1
         JP   z,t16
nottg
         LD   hl,(naddress)
         LD   a,(hl)
         CP   1
         JR   nz,notth
         INC  hl
         INC  hl
         INC  hl
         LD   a,(hl)
         CP   #21
         JR   nz,notth
         INC  hl
         INC  hl
         INC  hl
         LD   a,(hl)
         CP   #16
         JR   nz,notth
         INC  hl
         INC  hl
         EX   de,hl
         LD   hl,x17
         LD   b,9
         CALL scanl1
         JP   z,t17
notth
         LD   hl,(naddress)
         LD   a,(hl)
         CP   #fd
         JR   nz,notti
         INC  hl
         LD   a,(hl)
         CP   #21
         JR   nz,notti
         INC  hl
         INC  hl
         INC  hl
         LD   a,(hl)
         CP   #21
         JR   nz,notti
         INC  hl
         INC  hl
         INC  hl
         LD   a,(hl)
         CP   #11
         JR   nz,notti
         INC  hl
         INC  hl
         INC  hl
         LD   a,(hl)
         CP   6
         JR   nz,notti
         INC  hl
         INC  hl
         EX   de,hl
         LD   hl,x18
         LD   b,8
         CALL scanl1
         JP   z,t18
notti
         LD   hl,(naddress)
         LD   de,6
         ADD  hl,de
         LD   b,3
         EX   de,hl
         LD   hl,t19x+6
         CALL scanl1
         JR   nz,nottj
         INC  de
         LD   hl,x19+3
         LD   b,6
         CALL scanl1
         JP   z,t19
nottj
         LD   hl,(naddress)
         LD   de,6
         ADD  hl,de
         EX   de,hl
         LD   hl,x20
         LD   b,6
         CALL scanl1
         JP   z,t20
nottk
         LD   hl,(naddress)
         LD   a,(hl)
         CP   1
         JR   nz,nottl
         INC  hl
         INC  hl
         INC  hl
         LD   a,(hl)
         CP   #21
         JR   nz,nottl
         INC  hl
         INC  hl
         INC  hl
         EX   de,hl
         LD   b,3
         LD   hl,x21-1
         CALL scanl1
         JR   nz,nottl
         INC  de
         LD   hl,x21+3
         LD   b,6
         CALL scanl1
         JP   z,t21
nottl
         LD   hl,(naddress)
         LD   de,8
         ADD  hl,de
         EX   de,hl
         LD   hl,x22
         CALL scanm
         JP   z,t22
nottm
         LD   hl,(naddress)
         LD   a,(hl)
         CP   1
         JR   nz,nottn
         INC  hl
         INC  hl
         INC  hl
         LD   a,(hl)
         CP   #21
         JR   nz,nottn
         INC  hl
         INC  hl
         INC  hl
         EX   de,hl
         LD   b,7
         LD   hl,x23
         CALL scanl1
         JP   z,t23
nottn
         LD   hl,(naddress)
         LD   de,x24-t24x
         ADD  hl,de
         EX   de,hl
         LD   hl,x24
         LD   b,10
         CALL scanl1
         JP   z,t24
notto
         LD   hl,(naddress)
         LD   de,x25-t25x
         ADD  hl,de
         EX   de,hl
         LD   b,12
         LD   hl,x25
         CALL scanl1
         JP   z,t25
nottp
         LD   hl,(naddress)
         LD   de,6
         ADD  hl,de
         EX   de,hl
         LD   hl,x26-1
         CALL scanm
         JP   z,t26
nottq
         LD   hl,(naddress)
         LD   de,x27-t27x
         ADD  hl,de
         EX   de,hl
         LD   hl,x27
         CALL scanm
         JP   z,t27
nottr
         LD   hl,(naddress)
         LD   de,x28s-t28x
         ADD  hl,de
         EX   de,hl
         LD   hl,x28s
         CALL scanm
         JP   z,t28
notts
         LD   a,0
         RET  
scanm    LD   b,5
         JR   scanl1
scanh    LD   b,9
         JR   scanl1
scanl                                   ; On Entry HL=Skeleton XOR
         LD   b,7                       ; DE=GamesXOR
         JR   scanl1
scan                                    ; On Entry HL=Skeleton XOR
         LD   b,8                       ; DE=GamesXOR
scanl1
         LD   a,(de)
         CP   (hl)
         INC  hl
         INC  de
         RET  nz                        ; Quit If Not This Xor
         DJNZ scanl1
         XOR  a                         ; Exit Z If Ok. NZ If Not Ok
         RET  
copycod1
         PUSH hl
         LD   hl,(naddress)
         ADD  hl,bc
         LD   (naddress),hl
         POP  hl
         LD   de,(xaddress)
         LDIR 
         LD   (xaddress),de
         LD   a,13
         RET  
copycode
         PUSH hl
         LD   hl,(naddress)
         ADD  hl,bc
         LD   (naddress),hl
         POP  hl
         LD   de,(xaddress)
         LDIR 
         LD   (xaddress),de
         LD   a,%111100
         RET  
t1                                      ; Type 1 Type Xors
         LD   hl,(naddress)             ; HL=Address Of This XOR To DO
         INC  hl                        ; Point HL To Regs
         LD   e,(hl)
         INC  hl
         LD   d,(hl)                    ; DE Now Equals BC Value For XOR
         LD   (t1f+1),de                ; Store It Into First Xor
         INC  hl
         INC  hl                        ; HL Now Points To HL Value In Xor
         LD   e,(hl)
         INC  hl
         LD   d,(hl)                    ; HL=Value For Xor HL
         LD   (t1s+1),de                ; Store This Value For Xor
         INC  hl
         INC  hl                        ; HL Points To D Value In XOR
         LD   a,(hl)                    ; A=D Value
         LD   (t1t+1),a                 ; Store Value In XOR Type 1 Loop
         INC  hl
         INC  hl
         INC  hl                        ; Point HL To A Value In Type 1 XOR
         INC  hl
         LD   a,(hl)                    ; Get Value & Store
         LD   (t1h+1),a                 ; Store This Value-XOR Type 1 Now Ready
         LD   de,(xaddress)             ; DE = Xor Next Address
         LD   bc,t1xl                   ; Get Length Of Type 1 XOR
         LD   hl,t1x                    ; HL=Type 1 XOR
         JR   copycode
t1x                                     ; Type 1 Xor Routine
t1f      LD   BC,0                      ; Self Mod Code
t1s      LD   HL,0
t1t      LD   D,0
         IM   1
t1h      LD   A,0
         LD   R,A
x1
         LD   A,(HL)
         XOR  D
         LD   D,A
         LD   (HL),A
         INC  HL
         DEC  BC
         LD   A,B
         OR   C
         JR   nz,x1
t1xl     EQU  $-t1x                     ; Calculate Length
;
t2                                      ; Type 2 Xor Routine
         LD   hl,(naddress)
         INC  hl                        ; Point HL To Data In LD HL,xxxx
         LD   e,(hl)
         INC  hl
         LD   d,(hl)                    ; DE = xxxx
         LD   (t2f+1),de                ; Store In Type 2 Loop
         INC  hl
         INC  hl                        ; Point HL To Data In LD BC,xxxx
         LD   e,(hl)
         INC  hl
         LD   d,(hl)                    ; DE = To This Data
         LD   (t2s+1),de                ; Store In Type 2 Loop
         LD   de,(xaddress)
         LD   bc,t2xl
         LD   hl,t2x
         JR   copycode
t2x
t2f      LD   HL,0
t2s      LD   BC,0
x2
         LD   A,R
         XOR  (HL)
         DEC  BC
         LD   (HL),A
         LD   A,B
         INC  HL
         OR   C
         JR   NZ,x2
t2xl     EQU  $-t2x
;
t3                                      ; Type 3 Xors
         LD   hl,(naddress)
         INC  hl
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         PUSH hl
         LD   hl,(xaddress)
         LD   bc,#a
         ADD  hl,bc
         LD   (t3f+2),hl
         POP  hl
         INC  hl
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t3s+1),de
         INC  hl
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t3t+1),de
         LD   bc,t3xl
         LD   hl,t3x
         JP   copycode
t3x                                     ; Type 3 Xor Routine
t3f      LD   IY,0
t3s      LD   DE,0
t3t      LD   HL,0
x3       LD   A,R
         XOR  (HL)
         XOR  (IY+#05)
         LD   (HL),A
         DEC  DE
         LD   A,D
         INC  HL
         OR   E
         JR   NZ,t3xp
t3xp     JR   z,t3xn
         JP   (iy)
t3xn
t3xl     EQU  $-t3x
;
t4
         LD   hl,(naddress)
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t4f+1),de
         INC  hl
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t4s+1),de
         LD   hl,x4
         LD   de,x4-t4x
         ADD  hl,de
         LD   hl,(xaddress)
         ADD  hl,de
         LD   (t4c+1),hl
         LD   bc,t4xl
         LD   hl,t4x
         JP   copycode
t4x
t4f      LD   SP,0
t4s      LD   HL,0
x4
         LD   A,R
         LD   C,A
         POP  DE
         LD   A,E
         XOR  C
         LD   E,D
         LD   D,A
         PUSH DE
         DEC  SP
         DEC  SP
         DEC  HL
         LD   A,L
         OR   H
t4c      JP   NZ,x4
t4xl     EQU  $-t4x
;
t5
         LD   hl,(naddress)
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t5f+1),de
         INC  hl
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t5s+1),de
         LD   bc,t5xl
         LD   hl,t5x
         JP   copycode
t5x                                     ; Skeleton Type 5 Xor
t5f      LD   HL,0
t5s      LD   BC,0
x5
         LD   A,(HL)
         CPL  
         LD   (HL),A
         INC  HL
         DEC  BC
         LD   A,B
         OR   C
         JR   NZ,x5
t5xl     EQU  $-t5x
t6
         LD   hl,(naddress)
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t6f+1),de
         INC  hl
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t6s+1),de
         LD   bc,t6xl
         LD   hl,t6x
         JP   copycode
t6x                                     ; Type 6 Skeleton Xor Routine
t6f      LD   HL,0
t6s      LD   BC,0
x6
         LD   A,(HL)
         NEG  
         LD   (HL),A
         INC  HL
         DEC  BC
         LD   A,B
         OR   C
         JR   NZ,x6
t6xl     EQU  $-t6x
;
t7
         LD   hl,(naddress)
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t7f+1),de
         INC  hl
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t7s+1),de
         LD   hl,x7
         LD   de,x7-t7x
         ADD  hl,de
         LD   hl,(xaddress)
         ADD  hl,de
         LD   (t7c+1),hl
         LD   bc,t7xl
         LD   hl,t7x
         JP   copycode
t7x
t7f      LD   SP,#89E5
t7s      LD   HL,#5FB
x7
         LD   A,R
         LD   C,A
         POP  DE
         LD   A,D
         XOR  C
         LD   D,E
         LD   E,A
         PUSH DE
         DEC  SP
         DEC  SP
         DEC  HL
         LD   A,L
         OR   H
t7c      JP   NZ,#7DDF                  ; Alter According To New Address
t7xl     EQU  $-t7x
t8
         LD   hl,(naddress)
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t8f+1),de
         INC  hl
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t8s+1),de
         LD   bc,t8xl
         LD   hl,t8x
         JP   copycode
t8x
t8f      LD   HL,0
t8s      LD   BC,0
x8
         DEC  BC
         DEC  (HL)
         LD   A,B
         INC  HL
         OR   C
         JR   NZ,x8
t8xl     EQU  $-t8x
t9
         LD   hl,(naddress)
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t9f+1),de
         INC  hl
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t9s+1),de
         INC  hl
         INC  hl
         INC  hl
         LD   a,(hl)
         LD   (t9b+1),a
         LD   bc,t9xl
         LD   hl,t9x
         JP   copycode
t9x                                     ; Skeleton Type 9 Xor Routine
t9f      LD   BC,0
t9s      LD   HL,0
x9
         LD   A,(HL)
t9b      SUB  0
         DEC  BC
         LD   (HL),A
         LD   A,B
         INC  HL
         OR   C
         JR   NZ,x9
t9xl     EQU  $-t9x
t10
         LD   hl,(naddress)
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t10f+1),de
         INC  hl
         INC  hl
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t10s+2),de
         INC  hl
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t10t+1),de
         LD   bc,t10xl
         LD   hl,t10x
         JP   copycode
t10x
t10f     LD   BC,0
t10s     LD   IY,0
t10t     LD   HL,0
x10
         LD   A,R
         XOR  (IY+#00)
         XOR  H
         XOR  L
         LD   (IY+#00),A
         DEC  BC
         DEC  HL
         INC  IY
         LD   A,B
         OR   C
         JR   NZ,x10
t10xl    EQU  $-t10x
t11
         LD   hl,(naddress)
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t11f+1),de
         INC  hl
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t11s+1),de
         LD   bc,t11xl
         LD   hl,t11x
         JP   copycode
t11x                                    ; Type 11 Skeleton Xor Routine
t11f     LD   BC,0
t11s     LD   HL,0
x11
         RRC  (HL)
         DEC  BC
         LD   A,B
         INC  HL
         OR   C
         JR   NZ,x11
t11xl    EQU  $-t11x
t12
         LD   hl,(naddress)
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t12f+1),de
         INC  hl
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t12s+1),de
         INC  hl
         INC  hl
         INC  hl
         INC  hl
         LD   a,(hl)
         LD   (t12c+1),a
         LD   bc,t12xl
         LD   hl,t12x
         JP   copycode
t12x
t12f     LD   BC,0
t12s     LD   HL,0
         SCF  
x12
         LD   A,(HL)
t12c     ADC  A,0
         LD   (HL),A
         DEC  BC
         INC  HL
         LD   A,B
         OR   C
         JR   NZ,x12
t12xl    EQU  $-t12x
t13
         LD   hl,(naddress)
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t13f+1),de
         INC  hl
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t13s+1),de
         INC  hl
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t13t+1),de
         LD   hl,(xaddress)
         LD   de,x13a-t13x
         ADD  hl,de
         LD   (t13h+1),hl
         LD   bc,t13xl
         LD   hl,t13x
         JP   copycod1
t13x                                    ; Type 13 Skeleton Xor Routine
t13f     LD   BC,0
t13s     LD   HL,0
t13t     LD   DE,0
         EXX  
t13h     LD   HL,0
x13a
         EXX  
x13
         LD   A,R
         XOR  (HL)
         XOR  E
         XOR  D
         XOR  C
         XOR  B
         INC  DE
         LD   (HL),A
         DEC  BC
         LD   A,C
         INC  HL
         OR   B
         JR   Z,next13
         EXX  
         JP   (HL)
next13
         EXX  
t13xl    EQU  $-t13x
t14
         LD   hl,(naddress)
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t14x+1),de
         INC  hl
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t14x+4),de
         LD   hl,(xaddress)
         LD   de,x14-t14x
         ADD  hl,de
         LD   (t14h+1),hl
         LD   bc,t14xl
         LD   hl,t14x
         JP   copycode
t14x
         LD   HL,0
         LD   DE,0
x14
         LD   A,R
         XOR  (HL)
         LD   (HL),A
         DEC  DE
         LD   A,D
         OR   E
         INC  HL
t14h     JP   NZ,0
t14xl    EQU  $-t14x
;
t15
         LD   hl,(naddress)
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t15x+1),de
         INC  hl
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t15x+4),de
         INC  hl
         INC  hl
         INC  hl
         LD   a,(hl)
         LD   (x15add+1),a
         LD   bc,t15xl
         LD   hl,t15x
         JP   copycode
t15x
         LD   BC,0
         LD   HL,0
x15
         LD   A,(HL)
x15add   ADD  A,0
         LD   (HL),A
         INC  HL
         DEC  BC
         LD   A,B
         OR   C
         JR   NZ,x15
t15xl    EQU  $-t15x
t16
         LD   hl,(naddress)
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t16x+1),de
         INC  hl
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hL)
         LD   (t16x+4),de
         LD   bc,t16xl
         LD   hl,(xaddress)
         LD   de,x16-t16x
         ADD  hl,de
         LD   (t16h+1),hl
         LD   hl,t16x
         JP   copycode
t16x
         LD   SP,0
         LD   HL,0
x16
         LD   A,R
         LD   C,A
         POP  DE
         LD   A,E
         XOR  C
         LD   E,D
         LD   D,A
         PUSH DE
         POP  BC
         DEC  HL
         LD   A,L
         OR   H
t16h     JP   NZ,0
t16xl    EQU  $-t16x
t17
         LD   hl,(naddress)
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t17x+1),de
         INC  hl
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t17x+4),de
         INC  hl
         INC  hl
         LD   a,(hl)
         LD   (mummy+1),a
         LD   bc,t17xl
         LD   hl,t17x
         JP   copycode
t17x
         LD   BC,0
         LD   HL,0
mummy    LD   D,0
x17
         LD   A,(HL)
         XOR  D
         LD   D,A
         DEC  BC
         LD   (HL),A
         LD   A,B
         INC  HL
         OR   C
         JR   NZ,x17
t17xl    EQU  $-t17x
t18
         LD   hl,(naddress)
         INC  hl
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t18a+2),de
         INC  hl
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t18b+1),de
         INC  hl
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t18c+1),de
         INC  hl
         INC  hl
         LD   a,(hl)
         LD   (t18d+1),a
         LD   bc,t18xl
         LD   hl,t18x
         JP   copycode
t18x
t18a     LD   IY,0
t18b     LD   HL,0
t18c     LD   DE,0
t18d     LD   B,0
x18
         LD   A,R
         XOR  E
         XOR  D
         XOR  (HL)
         LD   (HL),A
         INC  HL
         DEC  B
         JR   NZ,x18
         DEC  IY
         INC  DE
         DEFB #fd,#7c
         DEFB #fd,#b5
         JR   NZ,t18d
t18xl    EQU  $-t18x
t19
         LD   hl,(naddress)
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t19a+1),de
         INC  hl
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t19b+1),de
         INC  hl
         INC  hl
         INC  hl
         INC  hl
         LD   a,(hl)
         LD   (t19c+1),a
         LD   bc,t19xl
         LD   hl,t19x
         JP   copycode
t19x                                    ; Skeleton Type 19 Xor Routine
t19a     LD   BC,0
t19b     LD   HL,0
         SCF  
x19
         LD   A,(HL)
t19c     SBC  A,0
         LD   (HL),A
         INC  HL
         DEC  BC
         LD   A,B
         OR   C
         JR   NZ,x19
t19xl    EQU  $-t19x
t20
         LD   hl,(naddress)
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t20x+1),de
         INC  hl
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t20x+4),de
         LD   bc,t20xl
         LD   hl,t20x
         JP   copycode
t20x
         LD   HL,0
         LD   BC,0
x20
         DEC  BC
         LD   A,B
         INC  (HL)
         INC  HL
         OR   C
         JR   NZ,x20
t20xl    EQU  $-t20x
;
t21
         LD   hl,(naddress)
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t21x+1),de
         INC  hl
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t21x+4),de
         INC  hl
         INC  hl
         INC  hl
         INC  hl
         LD   a,(hl)
         LD   (x21+2),a
         LD   bc,t21xl
         LD   hl,t21x
         JP   copycode
t21x
         LD   BC,0
         LD   HL,0
         SCF  
x21
         LD   A,(HL)
         ADC  A,0
         LD   (HL),A
         DEC  HL
         DEC  BC
         LD   A,B
         OR   C
         JR   NZ,x21
t21xl    EQU  $-t21x
t22
         LD   hl,(naddress)
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t22x+1),de
         INC  hl
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t22x+4),de
         INC  hl
         INC  hl
         LD   a,(hl)
         LD   (t22x+7),a
         LD   bc,t22xl
         LD   hl,t22x
         JP   copycode
t22x
         LD   BC,0
         LD   HL,0
         LD   D,0
x22
R8000    LD   A,(HL)
         XOR  D
         LD   D,A
         LD   (HL),A
         DEC  HL
         DEC  BC
         LD   A,B
         OR   C
         JR   NZ,R8000
t22xl    EQU  $-t22x
t23
         LD   hl,(naddress)
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t23x+1),de
         INC  hl
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t23x+4),de
         LD   hl,t23x
         LD   bc,t23xl
         JP   copycode
t23x
         LD   BC,0
         LD   HL,0
x23
         LD   A,(HL)
         XOR  H
         XOR  L
         LD   (HL),A
         INC  HL
         DEC  BC
         LD   A,B
         OR   C
         JR   NZ,x23
t23xl    EQU  $-t23x
t24
         LD   hl,(naddress)
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t24x+1),de
         INC  hl
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t24x+4),de
         LD   hl,(xaddress)
         LD   de,x24-t24x
         ADD  hl,de
         LD   (t24c+1),hl
         LD   hl,t24x
         LD   bc,t24xl
         JP   copycode
t24x
         LD   SP,0
         LD   HL,0
x24
         LD   A,R
         LD   C,A
         POP  DE
         LD   A,D
         XOR  C
         LD   D,E
         LD   E,A
         PUSH DE
         POP  BC
         DEC  HL
         LD   A,L
         OR   H
t24c     JP   NZ,0
t24xl    EQU  $-t24x
t25
         LD   hl,(naddress)
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t25x+1),de
         INC  hl
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t25x+4),de
         INC  hl
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t25x+7),de
         LD   hl,(xaddress)
         LD   de,x25-t25x
         ADD  hl,de
         LD   (t25c+1),hl
         LD   hl,t25x
         LD   bc,t25xl
         JP   copycode
t25x
         LD   HL,0
         LD   SP,0
         LD   DE,0
         EXX  
t25c     CALL x25
x25
         POP  HL
         LD   BC,#08
         ADD  HL,BC
         PUSH HL
         POP  HL
         EXX  
         LD   A,R
         XOR  D
         XOR  (HL)
         XOR  E
         LD   (HL),A
         DEC  SP
         DEC  SP
         DEC  DE
         INC  HL
         EX   DE,HL
         LD   A,L
         EX   DE,HL
         OR   D
         RET  nz
t25xl    EQU  $-t25x
t26
         LD   hl,(naddress)
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t26x+1),de
         INC  hl
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t26x+4),de
         INC  hl
         INC  hl
         INC  hl
         INC  hl
         LD   a,(hl)
         LD   (R815C+2),a
         LD   hl,t26x
         LD   bc,t26xl
         JP   copycode
t26x
         LD   BC,0
         LD   HL,0
         SCF  
x26
R815C    LD   A,(HL)
         SBC  A,#88
         LD   (HL),A
         DEC  HL
         DEC  BC
         LD   A,B
         OR   C
         JR   NZ,R815C
t26xl    EQU  $-t26x
t27
         LD   hl,(naddress)
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t27x+1),de
         INC  hl
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t27x+4),de
         LD   hl,t27x
         LD   bc,t27xl
         JP   copycode
t27x
         LD   BC,0
         LD   HL,0
x27
         RLC  (HL)
         DEC  BC
         LD   A,B
         INC  HL
         OR   C
         JR   NZ,x27
t27xl    EQU  $-t27x
t28
         LD   hl,(naddress)
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t28x+1),de
         INC  hl
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (t28x+4),de
         INC  hl
         INC  hl
         INC  hl
         INC  hl
         LD   a,(hl)
         LD   (x28a+1),a
         LD   hl,t28x
         LD   bc,t28xl
         JP   copycode
t28x
         LD   BC,#79A
         LD   HL,#89E6
         SCF  
x28
         LD   A,(HL)
x28a     SBC  A,#64
x28s
         LD   (HL),A
         DEC  HL
         DEC  BC
         LD   A,B
         OR   C
         JR   NZ,x28
t28xl    EQU  $-t28x
hacki    DEFW 0
hackit
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
         LD   (hl),#c3
         INC  hl
         LD   (hl),#00
         INC  hl
         LD   (hl),#be
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
         LD   (scl+1),bc
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
         AND  #f
         JR   nz,getink
         LD   hl,#abff
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
scl      LD   de,#4000
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
loader
         ORG  #b050
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
