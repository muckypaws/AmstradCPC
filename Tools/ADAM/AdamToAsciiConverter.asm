;
         ORG  #1000                     ; ADAM Text To Ascii File Converter
start                                   ; Written By Jason Brooks 
         ENT  $                         ; (C) 1989 JacesofT
;
         LD   a,2
         CALL #bc0e
         LD   hl,filename
         LD   b,len
         LD   de,#2000
         CALL #bc8c
         CALL displayt
         CALL #bc8f
         CALL #bb18
         RET  
filename DEFM B:SPRCOMP.ASC
len      EQU  $-filename
displayt                                ; Display ADAM As Text On Screen
         LD   hl,(ADAMTEXT)
         XOR  a
         LD   (labels),a
dpt1
         LD   a,(hl)                    ; Get Byte Of Adam Text
         INC  hl
         OR   a                         ; CP 0
         RET  z                         ; Return If 0
         CP   #ff
         JP   z,remit
dpt2
         BIT  7,a
         JR   nz,itstoken
         CP   #d                        ; Is It End Of Text ?
         JR   z,cr
         PUSH af
         LD   a,(labels)
         OR   a
         JR   nz,dpt3
         LD   a,"."
         CALL txtout
         LD   (labels),a
dpt3
         POP  af
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
         LD   a,10
         CALL txtout
         XOR  a
         LD   (textwrit),a
         LD   (textpart),a
         LD   (labels),a
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
         CALL #bb5a
         PUSH af
         PUSH bc
         PUSH de
         PUSH hl
         PUSH ix
         CALL #bc95
         POP  ix
         POP  hl
         POP  de
         POP  bc
         POP  af
         PUSH hl
         LD   hl,textwrit
         INC  (hl)
         POP  hl
         RET  
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
         LD   a,(#3000+12!45@12&2+#899) ; Jason
;
labels   DEFB 0
ADAMTEXT DEFW #68f5                     ; Location Of ADAM Text
textpart DEFB 0                         ; Part Of Text 0=Label 1=Operand 2=REMS
textwrit DEFB 0                         ; How Much Text Has Been Written/Line
spacelen DEFB 9
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
