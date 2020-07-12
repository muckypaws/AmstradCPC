;
fblanks                                 ; Fill In All Blank Squares
         CALL whichbut
         BIT  7,h
         RET  nz
         PUSH hl
         LD   de,gamegrid
         ADD  hl,de
         LD   a,(hl)                    ; Get Sprite Number
         CP   2
         POP  hl
         RET  nc                        ; Quit If Not Blank Square
         LD   a,(maxgy)
         INC  a
         CALL divide
         CALL rstack                    ; Reset Stack Pointers
         LD   h,l
         LD   l,a                       ; Calculate X, Y Co-ordinates
         CALL pushstak                  ; Push X, Y onto Stack
         CALL leftfill
         CALL flush
flush
         CALL #bb09
         JR   c,flush
         RET  
leftfill
         XOR  a
         LD   (upflag),a
         LD   (downflag),a
         CALL popstak                   ; Get HL Off Stack
         RET  c                         ; Quit If No More On Stack !
leftf1
         PUSH hl
leftf2
         PUSH hl
         CALL cblock
         SUB  2
         JR   nc,leftout                ; Wall
         LD   (hl),FILLFLAG             ; Set Open Flag
         POP  hl
         PUSH hl
         CALL showfill
         POP  hl
         CALL checkup
         CALL checkdwn
         DEC  l
         BIT  7,l
         JR   z,leftf2                  ; Still O.K.
leftf3
         XOR  a
         LD   (upflag),a
         LD   (downflag),a
         POP  hl                        ; Get Original Co-Ordinates
rightf2
         INC  l
         LD   a,(maxgx)
         SUB  l
         JR   c,rightf3                 ; Still O.K.
;
         PUSH hl
         CALL cblock
         SUB  2
         JR   nc,rightout               ; Wall
         LD   (hl),FILLFLAG             ; Set Open Flag
         POP  hl
         PUSH hl
         CALL showfill
         POP  hl
         CALL checkup
         CALL checkdwn
         JR   rightf2
rightf3
         XOR  a
         LD   (upflag),a
         LD   (downflag),a
         JR   leftfill
rightout
         POP  hl
         PUSH hl
         ADD  a,2
         CALL showfil1
         POP  hl
         JR   rightf3
leftout
         POP  hl
         PUSH hl
         ADD  a,2
         CALL showfil1
         POP  hl
         JR   leftf3
showfill
         LD   a,FILLFLAG
showfil1
         PUSH af
;PUSH hl
;LD   hl,#1405
;CALL #bb75
;POP  hl
;CALL printhl
         LD   a,l
         JP   pbutsp
checkup                                 ; Is There A Gap Above ?
         PUSH hl
         DEC  h
         BIT  7,h
         JR   nz,checkout
         PUSH hl
         CALL cblock
         POP  hl
         SUB  2
         JR   nc,checkupl               ; Put Last Co-Ordinates Onto Block
         LD   a,(upflag)
         OR   a
         JR   nz,checkout
         PUSH hl
         CALL pushstak
         POP  hl
         LD   a,1
         LD   (upflag),a
checkout
         POP  hl
         RET  
checkupl                                ; Add New Co-Ordinate To Stack
         ADD  a,2
         CALL showfil1
         XOR  a
         LD   (upflag),a
         JR   checkout
checkdwn
         PUSH hl
         INC  h
         LD   a,(maxgy)
         SUB  h
         JR   c,checkout
         PUSH hl
         CALL cblock
         POP  hl
         SUB  2
         JR   nc,checkdl                ; Put Last Co-Ordinates Onto Block
         LD   a,(downflag)
         OR   a
         JR   nz,checkout
         PUSH hl
         CALL pushstak
         POP  hl
         LD   a,1
checkd5
         LD   (downflag),a
         POP  hl
         RET  
checkdl
         ADD  a,2
         CALL showfil1
         XOR  a
         JR   checkd5
rstack                                  ; Reset Stack Pointers
         PUSH hl
         LD   hl,0
         LD   (STACKCNT),hl
         LD   hl,STACK
         LD   (STACKPT),hl
         POP  hl
         RET  
popstak                                 ; Get A Value Off The Stack !
         LD   hl,(STACKCNT)
;PUSH hl
;LD   hl,#1402
;CALL #bb75
;POP  hl
;CALL printhl
         LD   a,h
         OR   l
         SCF  
         RET  z                         ; Nothing On The Stack !
         DEC  hl
         LD   (STACKCNT),hl
         LD   hl,(STACKPT)
         DEC  hl
         LD   d,(hl)
         DEC  hl
         LD   e,(hl)
         LD   (STACKPT),hl
         EX   de,hl
         AND  a
         RET                            ; POP INTO HL 
pushstak                                ; push HL onto Stack
         EX   de,hl
         LD   hl,(STACKCNT)
         LD   bc,STACKMAX
         AND  a
         SBC  hl,bc
         RET  nc                        ; Quit If No More Room
         EX   de,hl
         CALL validate
         RET  c
         EX   de,hl
;
         LD   hl,(STACKPT)
         LD   (hl),e
         INC  hl
         LD   (hl),d
         INC  hl
         LD   (STACKPT),hl
         LD   hl,(STACKCNT)
         INC  hl
         LD   (STACKCNT),hl
;PUSH hl
;LD   hl,#1402
;CALL #bb75
;POP  hl
;CALL printhl
;
         RET  
validate                                ; Are Co-Ordinates Valid ? C = ok NC = 
         LD   a,(maxgy)
         SUB  h
         RET  c
         LD   a,(maxgx)
         INC  a
         SUB  l
         RET  
printhl1
         LD   a,13
         CALL #bb5a
         LD   a,10
         CALL #bb5a
printhl
         LD   a,h
         CALL hex
         LD   a,l
hex
         PUSH af
         RRCA 
         RRCA 
         RRCA 
         RRCA 
         CALL hex1
         POP  af
hex1
         AND  15
         CP   10
         JR   c,hex2
         ADD  a,7
hex2
         ADD  a,#30
         JP   #bb5a
setgrid
         LD   a,(nobombs)               ; Get Number Of Bombs
         LD   b,a
setgrida
         PUSH bc
setgrids
         LD   a,18
         CALL #bb1e
         RET  nz
         CALL getrand                   ; Get A Random Number
         LD   l,a
         LD   h,0                       ; Place In HL
         LD   a,(maxgx)
         INC  a                         ; Get Grid Width
         CALL divide                    ; Divide So remainder Free
         LD   e,a                       ; Store Remainder In E
;
         PUSH de                        ; Preserve DE
         CALL getrand                   ; Get Another Random Number
;ADD  a,5
         LD   l,a
         LD   h,0                       ; Store In HL
         LD   a,(maxgy)                 ; Get Grid Height
         INC  a
         CALL divide                    ; Get Remainder (Modulus !)
         POP  de                        ; Get Back DE
         LD   d,a                       ; Place Y In D
;
         PUSH de
         LD   h,a                       ; Put Y In H
         LD   l,e                       ; Put X in E
         CALL chekvic
         POP  de
         JR   nc,setgrids
         PUSH de
         POP  hl
;CALL printhl1
         PUSH de
         LD   a,(maxgy)
         INC  a
         LD   e,a
         LD   a,d                       ; A = Y
         CALL multiply                  ; Multiply A by E
         POP  de
         LD   d,0
         ADD  hl,de
         LD   de,gamegrid
         ADD  hl,de                     ; Point HL To Grid
         LD   a,(hl)
         OR   a                         ; Check If Bomb Exists
         JR   nz,setgrids               ; If So, Select Another Point.
         LD   (hl),BOMB
         POP  bc
         DJNZ setgrida
workbomb                                ; Work Out Bomb Numbers On Squares
         LD   hl,0                      ; Reset Co-Ordinate : H = Y, L = X
         LD   a,(maxgy)
         INC  a
         LD   c,a
workb0
         LD   a,(maxgx)
         INC  a
         LD   b,a
         LD   l,0
workb1
         PUSH bc
         PUSH hl
         CALL cblock
         CP   BOMB
         JR   z,workb2
         POP  de
         PUSH de
         PUSH hl
         EX   de,hl
         CALL bombcnt
         LD   a,d
         OR   a
         JR   z,workb3
         LD   a,4
         ADD  a,d
workb3
         POP  hl
         LD   (hl),a
workb2
         POP  hl
         POP  bc
         INC  l
         DJNZ workb1
         INC  h
         DEC  c
         JR   nz,workb0
         RET  
cblock                                  ; Calculate Which Block
         PUSH hl
         LD   a,(maxgy)
         INC  a
         LD   e,a
         LD   a,h
         CALL multiply
         POP  de
         LD   d,0
         ADD  hl,de
         LD   de,gamegrid
         ADD  hl,de
         LD   a,(hl)
         RET                            ; Exit HL = Grid Location.
check
         PUSH af
         PUSH hl
         LD   l,d
         LD   h,a
         CALL printhl
         POP  hl
         POP  af
         RET  
chekvic
         CALL chekvic4
         RET  nc
         DEC  h
;
         CALL chekvic4
         RET  nc
         INC  l
;
         CALL chekvic4
         RET  nc
         INC  h
;
         CALL chekvic4
         RET  nc
         INC  h
;
         CALL chekvic4
         RET  nc
         INC  h
;
         CALL chekvic4
         RET  nc
         DEC  l
;
         CALL chekvic4
         RET  nc
         DEC  l
;
         CALL chekvic4
         RET  nc
         DEC  h
;
         CALL chekvic4
         RET  nc
         DEC  h
chekvic4
         PUSH hl
         CALL bombcnt                   ; Count Bombs In Area
         LD   a,d                       ; A = Number Of Bombs
         POP  hl
         CP   MAXBOMBS
         RET  
;
multiply                                ; Entry : E, A = Multiplicands  HL=RESU
         PUSH bc
         PUSH de
         LD   hl,0
         LD   d,l
         LD   b,8
mult1
         ADD  hl,hl
         RLA  
         JR   nc,mult2
         ADD  hl,de
mult2
         DJNZ mult1
         POP  de
         POP  bc
         RET  
;
divide                                  ; Entry : HL = Dividend, A = Divisor
         PUSH bc
         LD   c,a
         XOR  a
         LD   b,16
divide1
         ADD  hl,hl
         RLA  
         CP   c
         JR   c,divide2
         SUB  c
         INC  l
divide2
         DJNZ divide1
         POP  bc
         RET                            ; Exit HL = Result, A = Remainder
;
bombcnt                                 ; Count Number Of Bombs From Position
         LD   a,(maxgx)
         CP   l
         RET  c
         LD   a,(maxgy)
         CP   h
         RET  c
         LD   d,0
         DEC  h
         CALL cgpos
         INC  l
         CALL cgpos
         INC  h
         CALL cgpos
         INC  h
         CALL cgpos
         DEC  l
         CALL cgpos
         DEC  l
         CALL cgpos
         DEC  h
         CALL cgpos
         DEC  h
         CALL cgpos
         LD   a,d
         RET  
cgpos                                   ; Calculate Grid Position
         BIT  7,h
         JR   nz,poserror               ; Check If Within Grid
         BIT  7,l
         JR   nz,poserror
         LD   a,(maxgx)
         CP   l
         JR   c,poserror
         LD   a,(maxgy)
         CP   h
         JR   c,poserror
         PUSH de
         PUSH hl
         PUSH hl
         LD   e,h
         LD   a,(maxgx)
         INC  a
         CALL multiply
         LD   de,gamegrid
         ADD  hl,de                     ; Calculate Position In Grid
         POP  de
         LD   d,0
         ADD  hl,de
         EX   de,hl
         POP  hl
         LD   a,(de)
         POP  de
         OR   a
         RET  z
         CP   14
         RET  nz
         INC  d                         ; Increment Bomb Count
         RET  
poserror                                ; Position Error
         LD   a,#ff
         SCF  
         RET  
clgrid                                  ; Clear The Game Grid For A New Game
         LD   hl,gamegrid
         LD   de,gamegrid+1
         LD   bc,399
         LD   (hl),0
         LDIR 
         RET  
*f1,
