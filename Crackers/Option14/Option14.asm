;
         ORG  #1000
start    ENT  $
         DI   
         LD   sp,#bff8
         LD   bc,#7fc0
         OUT  (c),c
         LD   hl,#afff
         LD   de,#40
         LD   c,7
         CALL #bcce
         DI   
;
         LD   bc,#7fc7                  ; Preserve Firmware In Last Bank
         OUT  (c),c
         LD   hl,#b000
         LD   de,#4000
         LD   bc,#1000
         LDIR 
         LD   bc,#7fc0
         OUT  (c),c
;
         CALL #bd37
         LD   hl,name
         LD   de,#2000
         LD   b,0
         CALL #bc77
         EX   de,hl
         LD   (exec),hl
         LD   (run1),hl
         LD   (run2),bc
         CALL #bc83
         LD   (run),hl
         LD   (run3),hl
         CALL #bc7a
         LD   hl,(exec)
         LD   b,0
findcall                                ; Find First LD IX,#C000 instruction.
         LD   a,(hl)
         INC  hl                        ; Normally of the form*-
         CP   #dd
         JR   z,fc1
         DJNZ findcall                  ; LD IX,#C000
fc1
         LD   a,(hl)                    ; LD DE,xxxx
         INC  hl                        ; CALL yyyy
         CP   #21
         JR   z,fc2
         DJNZ findcall
fc2
         INC  hl
         LD   a,(hl)
         CP   #c0
         JR   z,fc3
         DJNZ findcall
fc3
         INC  hl
         INC  hl
         INC  hl                        ; Should Point To Call Routine
fcall1
         LD   a,(hl)
         INC  hl
         CP   #cd
         JR   nz,fcall1
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (calladdr),de             ; Store Tape Load Address
         XOR  a
         LD   (hl),a
         DEC  hl
         LD   (hl),a
         DEC  hl
         LD   (hl),#c7                  ; Put An RST 0 In Place Of Call
         LD   bc,#400
change1                                 ; Change All occurences Of Tape Load CA
         LD   a,(hl)
         CP   #cd
         JR   nz,changeo
         INC  hl
         LD   a,e
         CP   (hl)
         JR   nz,changeo
         INC  hl
         LD   a,d
         SUB  (hl)
         JR   nz,changeo
         LD   (hl),a                    ; Convert All Calls To RST 0
         DEC  hl
         LD   (hl),a
         DEC  hl
         LD   (hl),#c7
changeo                                 ; Loop Until Finished
         INC  hl
         DEC  bc
         LD   a,b
         OR   c
         JR   nz,change1
         LD   hl,(run1)
         LD   (execute),hl
         LD   bc,(run2)
         ADD  hl,bc
         LD   (run3),hl
         PUSH hl
         LD   bc,execcl
         ADD  hl,bc
         LD   (execc),hl                ; End Of Orig. Code + Addition Code
;
         LD   hl,execcode
         POP  de
         LD   bc,execcl
         LDIR 
         LD   hl,endit
         LD   bc,#200
         LDIR 
;
         LD   hl,#abff
         LD   de,#40
         LD   c,7
         CALL #bcce
         LD   hl,name1
         LD   b,8
         CALL #bc8c
         LD   hl,0
run1     EQU  $-2
         LD   de,0
run2     EQU  $-2
         INC  d
         INC  d
         LD   bc,0
run3     EQU  $-2
         LD   a,2
         CALL #bc98
         CALL #bc8f
;
         CALL #bd37
         LD   hl,next
         LD   c,#ff
         CALL #bd16
next                                    ; Trap All Restore Jump Blocks
         LD   a,#c9
         LD   (#bd37),a
         LD   a,#e9
         LD   (#bd16),a
         LD   (#bd13),a
         LD   hl,(#bd38)
         RES  7,h
         RES  6,h
         LD   (restore),hl
         LD   a,#c3
         LD   hl,decide
         LD   (0),a
         LD   (1),hl
;
;JP   adam
;
         LD   sp,#bff8
         LD   hl,0
run      EQU  $-2
         JP   (hl)
execcode                                ;Execution Code For Loader
         LD   hl,0
execute  EQU  $-2
         PUSH hl
         LD   hl,0
execc    EQU  $-2
         LD   de,#a900
         PUSH de
         LD   bc,#400
         LDIR 
         RET  
execcl   EQU  $-execcode
adam
         LD   bc,#7fc4
         OUT  (c),c
         JP   #4000
;
restore  EQU  3
exec     DEFW 0
name     DEFM holly.BIN
len      EQU  $-name
name1    DEFM GAMECODE.1
len1     EQU  $-name1
         DEFS 10,32
decide                                  ; What Is Trying To Be Loaded & Saved.
         DI   
         LD   (codest),ix
         LD   (codelen),de
         CALL 0                         ; Load In Title Page.
calladdr EQU  $-2
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
         XOR  a
         LD   bc,#f600
         OUT  (c),c
         LD   bc,#7f8e
         OUT  (c),c
         EXX  
         EX   af,af
         LD   (oldstk),sp
         LD   sp,#b0fe
         LD   hl,#b000
         LD   de,#40
         LD   c,7
         CALL #bcce
         LD   hl,name1
         LD   b,len1
         LD   de,#c000
         CALL #bc8c
         LD   hl,#c000
codest   EQU  $-2
         LD   de,#4000
codelen  EQU  $-2
         LD   bc,0
         LD   a,2
         CALL #bc98
         CALL #bc8f
         LD   bc,#fa7e
         XOR  a
         LD   (#be5f),a
         OUT  (c),a
         DI   
;
         LD   hl,main
         LD   de,#c000
         LD   bc,#300
         LDIR 
;
         LD   hl,(calladdr)
         LD   (codeload),hl
;
         LD   hl,startc
         LD   (1),hl
         LD   a,#c3
         LD   (0),a
;
         LD   hl,(restore)
         LD   (bd38),hl
         LD   bc,#f610
         OUT  (c),c
;
         LD   sp,0
oldstk   EQU  $-2
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
         POP  af
         RET                            ; Carry On With Execution
;
main                                    ; Main Code To Save Source Code
         ORG  #c000
startc
         DI   
         LD   (cdst),ix                 ; Save Code Start Address
         LD   (cdle),de                 ; Save Code Length
         PUSH hl
         PUSH de
         PUSH bc
         PUSH af                        ; Preserve Registers
;
         PUSH ix
         POP  hl
;
         LD   a,h
         CP   #c0
         JR   nc,newscr                 ; A New Screen Is Loading !
         ADD  hl,de
         LD   a,h
         CP   #a9
         JR   nc,split                  ; Split Main Source Code
         POP  af
         POP  bc
         POP  de
         POP  hl
         CALL codeld
         JP   saveout
codeld
         DI   
         JP   0
codeload EQU  $-2                       ; Load In From Tape
newscr
         LD   hl,scrcode
         LD   de,scrit
         LD   bc,#100
         LDIR 
         LD   (scrst),ix
         LD   hl,(cdle)
         LD   (scrle),hl
         LD   hl,(codeload)
         LD   (tload),hl
         POP  af
         POP  bc
         POP  de
         POP  hl
         JP   scrit
split
         DI   
         LD   hl,(cdle)
         PUSH hl
         LD   hl,#a900
         LD   de,(cdst)
         AND  a
         SBC  hl,de
         LD   (cdle),hl                 ; Store New Partial Length
         EX   de,hl
         POP  hl
         AND  a
         SBC  hl,de
         LD   (partial),hl              ; Store Remaining Partial Length
         POP  af
         POP  bc
         POP  de
         POP  hl
         CALL codeld
         DI   
;
         PUSH hl
         PUSH de
         PUSH bc
         PUSH af
         LD   hl,#a900
         LD   de,#d000
         LD   bc,0
partial  EQU  $-2
         LDIR 
         LD   bc,#7fc7
         OUT  (c),c
         LD   hl,#4100
         LD   de,#b100
         LD   bc,#c000-#b100
         LDIR 
         LD   bc,#7fc0
         OUT  (c),c
         LD   bc,#7f8d
         OUT  (c),c
         XOR  a
         EXX  
         EX   af,af
         LD   hl,nameit+9
         INC  (hl)
         CALL saveout
         LD   hl,nameit+9
         DEC  (hl)
         DEC  (hl)
         LD   hl,#d000
         LD   (cdst),hl
         LD   hl,(partial)
         LD   (cdle),hl
         LD   a,3
         LD   (ftype),a
         CALL saveout
         LD   a,2
         LD   (ftype),a
         LD   hl,nameit+9
         INC  (hl)
         POP  af
         POP  bc
         POP  de
         POP  hl
         RET  
;
nextcdst DEFW #a900
saveout
         DI   
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
         LD   (retstk),sp
         LD   sp,#b0fe
         XOR  a
         LD   bc,#f600
         OUT  (c),c
         LD   bc,#7f8b
         OUT  (c),c
         EXX  
         EX   af,af
         CALL #44
         CALL 0
bd38     EQU  $-2
         LD   bc,#7f8d
         OUT  (c),c
         EXX  
         LD   hl,#b000
         LD   de,#40
         LD   c,7
         CALL #bcce
         LD   hl,nameit+9
         INC  (hl)
         LD   hl,nameit
         LD   de,#d000
         LD   b,length
         CALL #bc8c
         LD   hl,0
cdst     EQU  $-2
         LD   de,0
cdle     EQU  $-2
         LD   bc,0
         LD   a,2
ftype    EQU  $-1
         CALL #bc98
         CALL #bc8f
@
         LD   bc,#fa7e
         XOR  a
         LD   (#be5f),a
         OUT  (c),a
@
;
normal
         DI                             ; Restore All Parameters
         LD   bc,#f610
         OUT  (c),c
         LD   bc,#7f8d
         OUT  (c),c
         LD   a,#c3
         LD   hl,#c000
         LD   (0),a
         LD   (1),hl
         LD   sp,0
retstk   EQU  $-2
         POP  hl
         POP  de
         POP  bc
         POP  af
         EXX  
         EX   af,af
         POP  iy
         POP  ix
         POP  hl
         POP  de
         POP  bc
         POP  af
         RET                            ; Return Back To Program
;
nameit   DEFM GAMECODE.1  
length   EQU  $-nameit
scrcode
         ORG  #a700
scrit
         DI   
         PUSH hl
         PUSH de
         PUSH bc
         LD   hl,#c000
         LD   de,endd
         LD   bc,#200
         LDIR 
         LD   hl,nameit
         LD   de,nameita
         LD   bc,13
         LDIR 
         POP  bc
         POP  de
         POP  hl
         CALL 0
tload    EQU  $-2
         DI   
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
         LD   (retstka),sp
         LD   sp,#b0fe
         XOR  a
         LD   bc,#7f8d
         OUT  (c),c
         EXX  
         EX   af,af
         LD   hl,#afff
         LD   de,#40
         LD   c,7
         CALL #bcce
         LD   hl,nameita+9
         INC  (hl)
         LD   hl,nameita
         LD   de,#d000
         LD   b,length
         CALL #bc8c
         LD   hl,0
scrst    EQU  $-2
         LD   de,0
scrle    EQU  $-2
         LD   bc,0
         LD   a,2
         CALL #bc98
         CALL #bc8f
         LD   bc,#fa7e
         XOR  a
         LD   (#be5f),a
         OUT  (c),a
         DI   
         LD   hl,endd
         LD   de,#c000
         LD   bc,#200
         LDIR 
         LD   hl,nameita
         LD   de,nameit
         LD   bc,13
         LDIR 
         LD   sp,0
retstka
         JP   normal
nameita  DEFS 14,32
;
endd
endit    EQU  #1500
