;
         ORG  #1000                     ; ADAM Text To Ascii File Converter
start                                   ; Written By Jason Brooks 
         ENT  $                         ; (C) 1989 JacesofT
         LD   a,2
         CALL #bc0e
         LD   bc,0
         CALL #bc38
         XOR  a
         LD   bc,0
         CALL #bc32
         LD   a,1
         LD   bc,#1919
         CALL #bc32
         LD   hl,startupt               ; Print My Copyrite Messages
         CALL print
         CALL menu
;
         CALL #bb18
         RET  
locate   EQU  #bb75
scrd     EQU  #1605
menu
         LD   hl,scrd+#1000
         CALL locate
         LD   hl,opta
         CALL print
         LD   hl,scrd+#802
         CALL locate
         LD   hl,optb
         CALL print
         LD   hl,scrd+#504
         CALL locate
         LD   hl,optbx
         CALL print
         LD   hl,scrd+#306
         CALL locate
         LD   hl,optc
         CALL print
         LD   hl,scrd+#08
         CALL locate
         LD   hl,optcx
         CALL print
         LD   hl,scrd+#a
         CALL locate
         LD   hl,optd
         CALL print
         LD   hl,scrd+#e0c
         CALL locate
         LD   hl,opte
         CALL print
         LD   hl,scrd+#b0e
         CALL locate
         LD   hl,optf
         CALL print
         LD   hl,scrd+#d10
         CALL locate
         LD   hl,optg
         CALL print
;
         RET  
;
startupt
         DEFM * 
         DEFM ADAM Text - ASCII File Co
         DEFM nverter  Written By Jason
         DEFB 32
         DEFM Brooks  (C) 1989 JacesofT
         DEFB 32,"*",0
opta
         DEFM USER : 0
         DEFB 0
optb
         DEFM SOURCE DRIVE : A
         DEFB 0
optbx
         DEFM SOURCE FILENAME : DISKNAM
         DEFM E.BIN
         DEFB 0
optc
         DEFM DESTINATION DRIVE : A
         DEFB 0
optcx
         DEFM DESTINATION FILENAME : SA
         DEFM VENAME.BIN
         DEFB 0
optd
         DEFM OUTPUT :-
         DEFB 0
opte
         DEFM SCREEN : YES
         DEFB 0
optf
         DEFM DISQUETTE : YES
         DEFB 0
optg
         DEFM PRINTER : NO 
         DEFB 0
optj
         DEFM DEFM/BYTE/TEXT/DEFB/DB  
         DEFB 0
optk
         DEFM DEFW/WORD/DW  
         DEFB 0
optl
         DEFM DEFS/RMEM/DS  
         DEFB 0
print
         LD   a,(hl)
         OR   a
         RET  z
         INC  hl
         CALL #bb5a
         JR   print
convertt                                ; Display ADAM As Text On Screen
         LD   hl,(ADAMTEXT)
dpt1
         LD   a,(hl)                    ; Get Byte Of Adam Text
         INC  hl
         OR   a                         ; CP 0
         RET  z                         ; Return If 0
         CP   #ff
         JR   z,remit
dpt2
         BIT  7,a
         JR   nz,itstoken
         CP   #d                        ; Is It End Of Text ?
         JR   z,cr
         CALL txtout                    ; Print Ascii Character
         JR   dpt1
itstoken
         PUSH af                        ; Preserve Token Value
         LD   a,(textwrit)
         LD   b,a
         LD   a,(spacelen)
         SUB  b
         LD   b,a
         INC  b
         CALL spaces
         POP  af
         CALL tokend
itst1
         LD   a,(hl)
         INC  hl
         CP   #d
         JR   z,cr
         CP   #ff
         JR   z,notherem
         CP   "!"
         JR   z,xors
         CP   "&"
         JR   z,ands
         CP   "@"
         JR   z,ors
itst2
         CALL txtout
         JR   itst1
cr
         CALL txtout
         XOR  a
         LD   (textwrit),a
         LD   a,10
         CALL txtout
         JR   dpt1
xors
         PUSH hl
         LD   hl,XOR
         CALL txtstr
         POP  hl
         LD   a,32
         JR   itst2
ands
         PUSH hl
         LD   hl,AND
         CALL txtstr
         POP  hl
         LD   a,32
         JR   itst2
ors
         PUSH hl
         LD   hl,OR
         CALL txtstr
         POP  hl
         LD   a,32
         JR   itst2
remit
         LD   a,(textwrit)
         OR   a
         JR   nz,notherem
         LD   a,";"
         CALL txtout
         JR   itst1
notherem
         LD   a,(textwrit)
         LD   b,a
         LD   a,40
         SUB  b
         LD   b,a
         JR   nc,nother1
         ADD  a,41
         LD   b,a
nother1
         CALL spaces
         LD   a,";"
         CALL txtout
         JR   itst1
;
txtout                                  ; Output Routine For Screen/Printer/Dis
         PUSH af
         LD   a,(screen)
         OR   a
         CALL nz,scrwrite
         LD   a,(putchar)
         OR   a
         CALL nz,disk
         POP  af
         PUSH hl
         LD   hl,textwrit
         INC  (hl)
         POP  hl
         RET  
scrwrite
         DI   
         EXX  
         POP  hl
         POP  af
         PUSH af
         PUSH hl
         EXX  
         JP   #bb5a
disk
         POP  af
         PUSH af
         CALL #bc95
spaces
         PUSH af
         LD   a,b
         OR   a
         JR   z,spacesq
         LD   a,32
spaces1
         CALL txtout
         DJNZ spaces1
spacesq
         POP  af
         RET  
txtstr
         LD   a,(hl)
         OR   a
         RET  z
         CALL txtout
         INC  hl
         JR   txtstr
rem
         LD   a,";"
         RET  
tokend
         CP   #ff
         JR   z,rem
         SUB  128
         PUSH hl
         LD   l,a
         LD   h,0
         ADD  hl,hl
         ADD  hl,hl
         LD   de,tokens
         ADD  hl,de
         LD   b,4
tokend1
         LD   a,(hl)
         CALL txtout
         CP   32
         JR   z,tokend2
         INC  hl
         DJNZ tokend1
tokend2
         POP  hl
         LD   a,b
         OR   a
         RET  nz
         LD   a,32
         CALL txtout
         XOR  a
         RET  
ADAMTEXT DEFW #68f5                     ; Location Of ADAM Text
textwrit DEFB 0                         ; How Much Text Has Been Written/Line
spacelen DEFB 9
screen   DEFB 255
putchar  DEFB 255
XOR
         DEFB 32
         DEFM XOR
         DEFB 0
AND
         DEFB 32
         DEFM AND
         DEFB 0
OR
         DEFB 32
         DEFM OR
         DEFB 0
tokens                                  ; Adam Tokens Starting From 128
         DEFM LD  
         DEFM INC 
         DEFM DEC 
         DEFM ADD 
         DEFM ADC 
         DEFM SUB 
         DEFM SBC 
         DEFM AND 
         DEFM XOR 
         DEFM OR  
         DEFM CP  
         DEFM PUSH
         DEFM POP 
         DEFM BIT 
         DEFM RES 
         DEFM SET 
         DEFM RLC 
         DEFM RRC 
         DEFM RL  
         DEFM RR  
         DEFM SLA 
         DEFM SRA 
         DEFM SRL 
         DEFM IN  
         DEFM OUT 
         DEFM RST 
         DEFM DJNZ
         DEFM EX  
         DEFM IM  
         DEFM JR  
         DEFM CALL
         DEFM RET 
         DEFM JP  
         DEFM NOP 
         DEFM RLCA
         DEFM RRCA
         DEFM RLA 
         DEFM RRA 
         DEFM DAA 
         DEFM CPL 
         DEFM SCF 
         DEFM CCF 
         DEFM HALT
         DEFM EXX 
         DEFM DI  
         DEFM EI  
         DEFM NEG 
         DEFM RETN
         DEFM RETI
         DEFM RRD 
         DEFM RLD 
         DEFM LDI 
         DEFM CPI 
         DEFM INI 
         DEFM OUTI
         DEFM LDD 
         DEFM CPD 
         DEFM IND 
         DEFM OUTD
         DEFM LDIR
         DEFM CPIR
         DEFM INIR
         DEFM OTIR
         DEFM LDDR
         DEFM CPDR
         DEFM INDR
         DEFM OTDR
         DEFM DEFB
         DEFM DEFW
         DEFM DEFM
         DEFM DEFS
         DEFM EQU 
         DEFM ORG 
         DEFM ENT 
         DEFM IF  
         DEFM ELSE
         DEFM END 
