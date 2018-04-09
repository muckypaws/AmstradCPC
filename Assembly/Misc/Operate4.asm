;
         ORG  #40                       ; JacesofT Operating System V1.00
start    ENT  $
         DI   
         CALL initprnt
Enterit                                 ; Start Operating System At This Point
         LD   hl,startup
         CALL print
getcommd
         LD   hl,Entercom
         CALL print
         CALL cursor
         CALL inputcom
         CALL wipecurs
getcomm
         CALL intrpret
         INC  ix
         LD   a,(0)
nocomand EQU  $-2
         OR   a
         JR   z,getcommd
         LD   a,c
         CP   NumbComm
         JR   nc,syntaxe
         LD   hl,comtable
         CALL CalcComm
seperate                                ; Is There A Seperator
         LD   hl,commbuff
         LD   b,commline
sepert1
         LD   a,(hl)
         OR   a
         JR   z,getcommd
         CP   ":"
         JR   z,moveit
         INC  hl
         DJNZ sepert1
         JR   getcommd
moveit
         INC  hl
         LD   de,commbuff
         LD   bc,commline
         LDIR 
         JR   getcomm
CalcComm
         ADD  a,a
         LD   e,a
         LD   d,0
         ADD  hl,de
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         PUSH de
         RET  
syntaxe
         LD   hl,SyntaxEr
         CALL print
         JR   getcommd
QUIT
         DI   
         POP  ix
         LD   ix,(oldIX)
         RET  
CLEAN
         POP  hl
         JR   Enterit
PATCH5a
         LD   a,(#bb5a)
         LD   hl,(#bb5b)
         LD   (bb5a),a
         LD   (bb5a+1),hl
         LD   a,#c3
         LD   hl,TRAP5A
TRAP5A2
         LD   (#bb5a),a
         LD   (#bb5b),hl
         RET  
RESTBB5A
         LD   a,(bb5a)
         LD   hl,(bb5a+1)
         JR   TRAP5A2
TRAP5A                                  ; Trap CHR$(10) From Being Printed
         CP   10
         RET  z
         CALL printchr
         RET  
CAT
         CALL PATCH5a
         LD   de,CATBUFFR
         CALL #bc9b
         DI   
         CALL RESTBB5A
         RET  
HELP
         LD   hl,HELPA
         CALL print
         RET  
PEN
         CALL intrprt5
         CALL numbers
         CP   3
         JP   nz,syntaxer
         INC  ix
         LD   a,(number)
         LD   (number1),a
         CALL numbers
         CP   3
         JR   nz,PEN1
         LD   a,(number)
         LD   (number2),a
         INC  ix
         CALL numbers
         LD   a,(number2)
         LD   b,a
         LD   a,(number)
         LD   c,a
         LD   a,(number1)
         JR   PEN2
PEN1
         LD   a,(number)
         LD   b,a
         LD   a,(number1)
         LD   c,b
PEN2
         JP   #bc32
IN
         CALL intrprt5
         CALL numbers
         CP   3
         JP   z,syntaxer
         LD   bc,(number)
         IN   a,(c)
         LD   ix,Inmess1
         CALL phex
         LD   hl,Inmess
         JP   print
OUT
         CALL intrprt5
         CALL numbers
         CP   3
         JP   nz,syntaxer
         INC  ix
         LD   hl,(number)
         LD   (number1),hl
         CALL numbers
         LD   bc,(number1)
         LD   a,(number+1)
         OR   a
         LD   a,4
         JP   nz,errorhan
         LD   a,(number)
         OUT  (c),a
         LD   hl,OK
         JP   print
BORDER
         CALL intrprt5
         CALL numbers
         CP   3
         JR   nz,BORDERSE               ; Not Two Parameters
         INC  ix
         LD   a,(number)
         LD   (number1),a
         CALL numbers
         LD   a,(number)
         LD   c,a
         LD   a,(number1)
         JR   BORDERS2
BORDERSE
         LD   a,(number)
         LD   c,a
BORDERS2
         LD   b,a
         JP   #bc38
PRCOLS
         LD   hl,ColMesg
         CALL print
         XOR  a
PRCOLS1
         PUSH af
         LD   ix,COLSMESR
         POP  af
         PUSH af
         CALL pdecimla
         INC  ix
         POP  af
         PUSH af
         CALL #bc35
         PUSH bc
         LD   a,b
         CALL pdecimla
         INC  ix
         POP  bc
         LD   a,c
         CALL pdecimla
         INC  ix
         LD   hl,ColsMess
         CALL print
         POP  af
         INC  a
         CP   16
         JR   nz,PRCOLS1
         RET  
INITIAL
         CALL intrprt5
         OR   a
         JP   z,syntaxer
         CALL moveit1
         LD   de,ADVERBS1
         LD   c,0
         CALL intrprt1
         LD   a,c
         CP   adverbl1
         JP   nc,syntaxer
         OR   a
         JR   z,INITFIRM
         DEC  a
         JR   z,INITDISK
         RET  
INITDISK
         CALL findat
         CALL numbers
         LD   hl,(number)
         LD   de,#504
         ADD  hl,de
         LD   de,#40
         LD   c,7
         CALL #bcce
         LD   hl,Initial
         JP   print
INITFIRM
         CALL findat
         CALL numbers
         LD   de,(number)
         PUSH de
         LD   hl,InitCode
         LD   bc,IntCodeL
         LDIR 
         POP  hl
         JP   (hl)
InitCode
         DI   
         LD   bc,#7f8a
         OUT  (c),c
         CALL #44
Initbd37
         CALL 0
         LD   bc,#7f8e
         OUT  (c),c
         LD   hl,OK
         JP   print
IntCodeL EQU  $-InitCode
findat
         INC  ix
         CALL intrprt5
         CP   "A"
         POP  hl
         JP   nz,syntaxer
         PUSH hl
         INC  ix
         LD   a,(ix+0)
         CP   "T"
         INC  IX
         POP  hl
         JP   nz,syntaxer
         PUSH hl
         JP   intrprt5
LIST
         CALL intrprt5
         OR   a
         JP   z,syntaxer
         CALL moveit1
         LD   de,ADVERBS
         LD   c,0
         CALL intrprt1
         LD   a,c
         CP   adverbl
         JP   nc,syntaxer
         OR   a
         JR   z,LISTCOMS
         DEC  a
         JP   z,PRCOLS
         RET  
moveit1
         PUSH ix
         POP  hl
         LD   de,commbuff
         LD   bc,commline
         LDIR 
         RET  
phex
         PUSH af
         RRCA 
         RRCA 
         RRCA 
         RRCA 
         CALL phex1
         POP  af
phex1
         AND  #f
         ADD  a,#30
         CP   #3a
         JR   c,phex2
         ADD  a,7
phex2
         LD   (ix+0),a
         INC  ix
         RET  
pdecimal                                ; Print Decimal 8 Bit Number In A
         LD   d,100
         CALL pdeciml1
pdecimla
         LD   d,10
         CALL pdeciml1
         LD   d,1
pdeciml1
         LD   c,0
pdeciml2
         SUB  d
         JR   c,pdeciml3
         INC  c
         JR   pdeciml2
pdeciml3
         ADD  a,d
         PUSH af
         LD   a,c
         OR   #30
         LD   (ix+0),a
         INC  ix
         POP  af
         RET  
LISTCOMS                                ; List O/S Commands
         LD   hl,CommandS
         CALL print
         LD   hl,COMMANDS
LISTCOM2
         LD   de,buffer
         LD   b,0
LISTCOM1
         LD   a,(hl)
         OR   a
         RET  z
         BIT  7,a
         RES  7,a
         LD   (de),a
         INC  hl
         INC  de
         JR   z,LISTCOM1
         LD   a,13
         LD   (de),a
         INC  de
         XOR  a
         LD   (de),a
         PUSH hl
         LD   hl,buffer
         CALL print
         POP  hl
         JR   LISTCOM2
numbers                                 ; Number & Error Handling
         CALL convertd
         RET  nc
         POP  hl
errorhan
         DEC  a
         JR   z,Overflow
         DEC  a
         JR   z,syntaxer
         DEC  a
         DEC  a
         JR   z,toolarge
         RET  
syntaxer
         POP  hl
         JP   syntaxe
Overflow
         LD   hl,OVERFLOW
         JP   print
toolarge
         LD   hl,Toolarge
         JP   print
Careturn
         LD   a,13
         CALL printchr
         JP   printchr
intrpret                                ; Inline Interpreter
         CALL Careturn
         LD   de,COMMANDS               ; DE=Address Of Command Table
         LD   c,0                       ; Start At Command 0
intrprt1
         LD   ix,commbuff
         LD   hl,0                      ; Comparatry Check Byte
intrprt2
         CALL intrprt5
         LD   (nocomand),ix
         LD   a,(ix+0)
         OR   a
         RET  z
         LD   a,(de)                    ; Command Start
         OR   a
         RET  z
         RES  7,a
         INC  l
         CP   (ix+0)                    ; Are They Equal ?
         JR   nz,intrprt3
         INC  h
         LD   a,(de)
         BIT  7,a
         JR   nz,intrprt4
         INC  de
         INC  ix
         JR   intrprt2
intrprt3
         LD   a,(de)
         INC  de
         BIT  7,a
         JR   z,intrprt3
         INC  c
         LD   a,c
         CP   NumbComm
         RET  z
         JR   intrprt1
intrprt4
         LD   a,(ix+1)
         OR   a
         JR   z,intrpt4a
         CP   32
         JR   nz,intrprt3
intrpt4a
         LD   a,l
         CP   h
         RET  z
         JR   intrprt1
intrprt5                                ; Find End Of Spaces
         LD   a,(ix+0)
         CP   32
         RET  nz
         INC  ix
         JR   intrprt5
inputcom
         LD   (oldIX),ix
         LD   hl,commbuff
         LD   de,commbuff+1
         LD   bc,commline
         LD   (hl),0
         LDIR 
         LD   ix,commbuff
         XOR  a
         LD   hl,Entered
         LD   (hl),a
inpcoml1
         CALL #bb06
         DI   
         CP   13
         RET  z
         CP   127
         JR   z,deletec
         PUSH af
         LD   a,(hl)
         CP   commline
         JR   nz,inpcoml2
         POP  af
         JR   inpcoml1
inpcoml2
         POP  af
         CALL validate
         JR   c,inpcoml1
         INC  (hl)
         LD   (ix+0),a
         INC  ix
         CALL printchr
         CALL cursor
         JR   inpcoml1
validate
         CP   32
         RET  c
         CP   97
         JR   c,validat1
         CP   123
         JR   nc,validat1
         AND  #df
validat1
         OR   a
         RET  
deletec
         LD   (ix+0),0
         LD   a,(hl)
         OR   a
         JR   z,inpcoml1
         DEC  a
         LD   (hl),a
         LD   a,32
         CALL printchr
         LD   a,8
         CALL printchr
         CALL printchr
         LD   a,32
         CALL printchr
         LD   a,8
         CALL printchr
         CALL cursor
         DEC  ix
         JR   inpcoml1
cursor
         LD   a,#ff
         LD   (inverse),a
wipecurs
         LD   a,32
         CALL printchr
         XOR  a
         LD   (inverse),a
         LD   a,8
         JP   printchr
convertd                                ; Convert Inputted Decimal Number
         LD   b,0
         LD   (Stack),sp
         LD   de,0
         LD   (number),de
         LD   a,(ix+0)
         OR   a
         JR   z,error
         CP   "&"
         JR   z,convertH
         CP   "#"
         JR   z,convertH
convertc
         LD   a,(ix+0)
         OR   a
         JR   z,done
         CP   ":"
         JR   z,done
         CP   ","
         JR   z,done1
         SUB  #30
         JR   c,error
         CP   10
         JR   nc,error
         PUSH af
         LD   hl,0
         LD   a,10
         LD   b,8
shift
         ADD  hl,hl
         JR   c,overflow
         RLA  
         JR   nc,over
         ADD  hl,de
         BIT  7,h
         JR   c,overflow
over     DJNZ shift
         POP  af
         ADD  a,l
         LD   e,a
         LD   a,0
         ADC  a,h
         LD   d,a
         JR   c,overflow
         INC  ix
         JR   convertc
done1
         LD   (number),de
         LD   a,3
         OR   a
done2
         LD   sp,(Stack)
         RET  
done
         LD   (number),de
         XOR  a
         OR   a
         JR   done2
overflow
         LD   a,1
         SCF  
         JR   done2
error
         LD   a,2
         SCF  
         JR   done2
convertH                                ; Convert Number To Hexadecimal
         INC  b
         INC  ix
         LD   de,(number)
         LD   a,(ix+0)
         OR   a
         JR   z,done
         CP   ":"
         JR   z,done
         CP   ","
         JR   z,done1
         SUB  #30
         JR   c,error
         CP   10
         JR   c,convrtH1
         SUB  7
         JR   c,error
         CP   #10
         JR   nc,error
convrtH1
         LD   de,(number)
         EX   de,hl
         ADD  hl,hl
         ADD  hl,hl
         ADD  hl,hl
         ADD  hl,hl
         OR   l
         LD   l,a
         LD   (number),hl
         LD   a,b
         CP   5
         JR   z,overflow
         JR   convertH
initprnt                                ; Initialize Print Routines
         CALL textset                   ; Set Up ASCII Characters
         DI   
         CALL scroll
         LD   hl,#c000
         LD   de,#c001
         LD   bc,#3fff
         LD   (hl),0
         LDIR 
         LD   hl,0
         CALL prlocate                  ; HL Already At 0
         LD   bc,#7f8e
         OUT  (c),c                     ; Mode 2
         LD   c,0
         LD   a,#54
         OUT  (c),c
         OUT  (c),a                     ; Paper 0
         LD   c,16
         OUT  (c),c
         OUT  (c),a                     ; Border 0
         LD   c,1
         LD   a,#4b
         OUT  (c),c
         OUT  (c),a                     ; Ink 1,26
         RET  
print
         LD   a,(hl)
         OR   a
         JP   z,wipecurs
         INC  hl
         CP   13
         JR   nz,print2
         PUSH af
         CALL wipecurs
         POP  af
print2
         CALL printchr
         CALL cursor
         CALL bd19
         JR   print
;
prlocate                                ; Locate Command
         LD   (currenty),hl
         PUSH de
         LD   e,h
         LD   d,0
         LD   h,0
         CALL bc1d
         LD   (screenxy),hl
         POP  de
         RET  
blank
         LD   hl,23
blanka
         CALL bc1d
         LD   b,#50
         LD   c,8
blank1
         PUSH bc
         PUSH hl
blank2
         LD   (hl),0
         INC  hl
         LD   a,h
         OR   #c0
         LD   h,a
         DJNZ blank2
         POP  hl
         LD   a,h
         ADD  a,8
         LD   h,a
         JR   nc,blank3
         LD   bc,#c050
         ADD  hl,bc
blank3
         LD   a,h
         OR   #c0
         LD   h,a
         POP  bc
         DEC  c
         JR   nz,blank1
         RET  
;
printchr                                ; Print Character At Current Cursor
         PUSH af
         PUSH bc
         PUSH de
         PUSH hl
         CP   32
         JP   c,controlc                ; If < 32 Then Control Codes Branch
         SUB  32
         LD   l,a
         LD   h,0
         ADD  hl,hl
         ADD  hl,hl
         ADD  hl,hl
         LD   de,charactr
         ADD  hl,de                     ; Calculate 
         EX   de,hl                     ; DE=Part Of Char Matrix To Copy
         LD   hl,(screenxy)             ; HL=Screen Address
         PUSH hl
         LD   b,8
         LD   a,(inverse)
         LD   c,a
printch1
         LD   a,(de)
         XOR  c
         LD   (hl),a
         LD   a,h
         ADD  a,8
         LD   h,a
         JR   nc,printch2
         PUSH bc
         LD   bc,#c050
         ADD  hl,bc
         POP  bc
printch2
         INC  de
         DJNZ printch1
         POP  hl
printch4
         INC  hl
         LD   a,h
         AND  7
         OR   #c0
         LD   h,a
         LD   (screenxy),hl
         LD   hl,currentx
         LD   a,(hl)
         INC  a
         CP   80
         LD   (hl),a
         JR   nz,printchx
         LD   hl,(currenty)
preturn
         LD   h,0
pdownlne
         INC  l
         LD   a,l
         CP   25
         JR   nz,preturn1
         DEC  l
         PUSH hl
         CALL up
         CALL blitter
         CALL blank
         POP  hl
         JR   preturn1
printch3
         LD   hl,(currenty)
preturn1
         CALL prlocate
         LD   (screenxy),hl
printchx
         POP  hl
         POP  de
         POP  bc
         POP  af
         RET                            ; Return All Registers INTACT
pforward                                ; Move Cursor Along One
         LD   hl,(screenxy)             ; Routine Already In Print !
         JR   printch4
pbackspc                                ; Print Back Space
         DEC  h
         LD   a,h
         CP   #ff
         JR   nz,preturn1
         LD   h,79
pupline
         DEC  l
         LD   a,l
         CP   #ff
         JR   nz,preturn1
         LD   l,0
         PUSH hl
         CALL down
         CALL blitter
         LD   hl,#ff
         CALL blanka
         POP  hl
         JR   preturn1
clearscr
         LD   a,(inverse)
         LD   hl,#c000
         LD   de,#c001
         LD   bc,#3fff
         LD   (hl),a
         LDIR 
         LD   hl,0
         JR   preturn1
pinvert
         LD   a,(inverse)
         CPL  
         LD   (inverse),a
         JR   preturn1
controlc
         LD   hl,(currenty)
         SUB  7
         JR   c,preturn1                ; Anything below CHR$(7) rejected
         JR   z,prbell
         DEC  a
         JR   z,pbackspc                ; CHR$(8)
         DEC  a                         ; CHR$(9) ?
         JR   z,pforward
         DEC  a                         ; CHR$(10) ?
         JR   z,pdownlne
         DEC  a                         ; CHR$(11) ?
         JR   z,pupline
         DEC  a                         ; CHR$(12) ?
         JR   z,clearscr
         DEC  a                         ; CHR$(13) ?
         JP   z,preturn
         CP   11
         JR   z,pinvert
         JR   preturn1
prbell                                  ; CHR$(7)
         PUSH hl
         LD   hl,bellcode
         LD   d,bellcodl
prbell1
         LD   a,(hl)
         INC  hl
         LD   c,(hl)
         INC  hl
         CALL bd34
         DEC  d
         JR   nz,prbell1
         POP  hl
         JP   preturn1
textset                                 ; Initialize Amsdos Character Set
         CALL nullchar
         LD   hl,(#bd38)
         LD   a,h
         AND  #3f
         LD   h,a
         LD   (Initbd37+1),hl
         LD   de,32
         LD   hl,charactr
         CALL #bbab
nullchar
         LD   de,256
         LD   hl,charactr
         JP   #bbab
scroll
         XOR  a
         LD   (horiz),a
         LD   (uper),a
         LD   (offset),a
         LD   hl,#c000
         LD   (hardscrn),hl
         LD   a,180
         LD   (vert),a
blitter
         PUSH af
         PUSH bc
         CALL bd19
         LD   bc,#bc0c
         LD   a,(vert)
         AND  #b7
         OR   #b0
         OUT  (c),c
         INC  b
         OUT  (c),a
         DEC  b
         INC  c
         LD   a,(horiz)
         OUT  (c),c
         INC  b
         OUT  (c),a
         POP  bc
         POP  af
         RET  
;
up                                      ; BLITTER that screen & Re-calc Co-ords
         LD   hl,(hardscrn)
         LD   de,#50
         ADD  hl,de
         LD   a,h
         AND  7
         OR   #c0
         LD   h,a
         LD   (hardscrn),hl
         LD   hl,uper
         INC  (hl)
         LD   a,(hl)
         CP   26
         JR   z,up1
         LD   a,(horiz)
         ADD  a,40
         LD   (horiz),a
         RET  nc
         LD   hl,vert
         INC  (hl)
         RET  
up1
         LD   (hl),1
         LD   a,(horiz)
         SUB  216
         LD   (horiz),a
         LD   a,(vert)
         SBC  a,3
         OR   #b0
         LD   (vert),a
         RET  
;
down
         LD   hl,(hardscrn)
         LD   de,#50
         AND  a
         SBC  hl,de
         LD   a,h
         AND  7
         OR   #c0
         LD   h,a
         LD   (hardscrn),hl
         LD   hl,uper
         DEC  (hl)
         LD   a,(hl)
         CP   #ff
         JR   z,down1
         LD   a,(horiz)
         SUB  40
         LD   (horiz),a
         RET  nc
         LD   hl,vert
         LD   a,(hl)
         DEC  a
         OR   #b0
         LD   (hl),a
         RET  
down1
         LD   (hl),25
         LD   a,(horiz)
         ADD  a,216
         LD   (horiz),a
         LD   a,(vert)
         ADC  a,3
         LD   (vert),a
         RET  
bc1d
         EX   de,hl
         PUSH hl
         LD   hl,0
         ADD  hl,de
         ADD  hl,hl
         ADD  hl,hl
         ADD  hl,de
         ADD  hl,hl
         ADD  hl,hl
         ADD  hl,hl
         ADD  hl,hl
         EX   de,hl
         LD   hl,(hardscrn)
         ADD  hl,de
         POP  de
         ADD  hl,de
         LD   a,(offset)
         SLA  a
         LD   e,a
         LD   d,0
         ADD  hl,de
         LD   a,h
         AND  7
         OR   #c0
         LD   h,a
         RET  
bd19
         LD   b,#f5
bd19a
         IN   a,(c)
         RRA  
         RET  c
         JR   bd19a
bd34
         DI   
         LD   B,#F4
         OUT  (C),A
         INC  b
         INC  b
         IN   A,(C)
         OR   #C0
         OUT  (C),A
         AND  #3F
         OUT  (C),A
         DEC  b
         DEC  b
         OUT  (C),C
         INC  b
         INC  b
         LD   C,A
         OR   #80
         OUT  (C),A
         OUT  (C),C
         RET  
bellcode                                ; Bellcodes For BD34
         DEFB 0,24,1,0,8,16,13,1,11,255
         DEFB 12,5,7,62
oldIX    DEFW 0
Entered  DEFB 40
bellcodl EQU  $-bellcode
hardscrn DEFW #c000
offset   DEFB 0
uper     DEFB 0
vert     DEFB 180
horiz    DEFB 0
currenty DEFB 0
currentx DEFB 0
screenxy DEFW #c000                     ; Initial Screen Address To Print
inverse  DEFB 0                         ; Inverse On If #FF Off If 0
charactr DEFS 256-32*8,0
number   DEFW 0                         ; Converted Decimal Number
number1  DEFW 0                         ; Temporary Storage
number2  DEFW 0
Stack    DEFW 0
bb5a     DEFS 3,0
startup                                 ; Start Up Message
         DEFB 12
         DEFM JacesofT's Operating Syst
         DEFM em V1.90 - Written By J
         DEFM ason Brooks
         DEFB 13
         DEFM (C) 1989 JacesofT Softwar
         DEFM e Ltd.
         DEFB 13,0
Entercom
         DEFB 13
         DEFM COMMAND => 
         DEFB 0
SyntaxEr DEFM SYNTAX ERROR.
         DEFB 13,0
OVERFLOW
         DEFM Over Flow Error.
         DEFB 13,0
Toolarge
         DEFM Number Too Large.
         DEFB 13,0
OK
         DEFM Okay.
         DEFB 13,0
Initial
         DEFM Disk Drive Initialized.
         DEFB 13,0
Inmess
         DEFM Byte Return : 
Inmess1
         DEFM 00
         DEFB 13,0
CommandS
         DEFM Commands Available To Use
         DEFM r :-
         DEFB 13,13,0
ColMesg
         DEFM Current Firmware Ink Sett
         DEFM ings Are :-
         DEFB 13,13,0
ColsMess
         DEFM INK 
COLSMESR
         DEFM 00,00,00
         DEFB 13,0
HELPA
         DEFM HELP PRESENT
         DEFB 0
commline EQU  65                        ; Maximum Length Of Input
Commbuff DEFW 0                         ; Location Of Command Buffer
commbuff DEFS commline+1,0
buffer   DEFS commline+1,0
comtable                                ; List Of Address For Command Table
         DEFW CAT,HELP,LIST
         DEFW PEN,BORDER,OUT,IN
         DEFW CLEAN,CLEAN,QUIT,QUIT
         DEFW INITIAL
adverbl  EQU  2
adverbl1 EQU  2
ADVERBS                                 ; Extension To Command Table
         DEFM COMMAND
         DEFB "S"+#80
         DEFM COLOUR
         DEFB "S"+#80
         DEFB 0
ADVERBS1
         DEFM FIRMWAR
         DEFB "E"+#80
         DEFM DIS
         DEFB "K"+#80
         DEFB 0
COMMANDS                                ; Commands Included In System
         DEFM CA
         DEFB "T"+#80
comm2
         DEFM HEL
         DEFB "P"+#80
comm3
         DEFM LIS
         DEFB "T"+#80
comm4
         DEFM IN
         DEFB "K"+#80
comm5
         DEFM BORDE
         DEFB "R"+#80
comm6
         DEFM OU
         DEFB "T"+#80
comm7
         DEFM I
         DEFB "N"+#80
comm8
         DEFM CLEA
         DEFB "N"+#80
comm9
         DEFM CL
         DEFB "S"+#80
comm10
         DEFM QUI
         DEFB "T"+#80
comm11
         DEFM EXI
         DEFB "T"+#80
comm12
         DEFM INITIALIZ
         DEFB "E"+#80
         DEFB 0
NumbComm EQU  13
CATBUFFR DEFS 2048,0
end
