;
         ORG  #a000
         EQU  $
output   EQU  #bb5a
comp
         LD   a,#c9
         LD   (comp),a
         LD   hl,work
         LD   bc,rsx
         JP   #bcd1
work     DEFS 4,0
rsx      DEFW name
         JP   compress
         JP   help
name     DEFM COMPRES
         DEFB "S"+#80
         DEFM CMPHEL
         DEFB "P"+#80,0
ER       DEFM ! Wrong Number Of 
         DEFM Parameters Supplied !
         DEFB 7,7,7,7,7,0
hello
         DEFM >>> Screen Compressor <<<
         DEFB 13,10,10
         DEFM Taken From ACU Februa
         DEFM ry 1987
         DEFB 13,10,10
         DEFM From The ASSEMBLY POINT A
         DEFM RTICLE
         DEFB 13,10,10
         DEFM Type :-
         DEFB 13,10,10
         DEFM |COMPRESS,
         DEFB #22
         DEFM Filename","Savename"
         DEFB 13,10,10,0
help
         LD   a,1
         CALL #bc0e
         LD   hl,hello
         JP   print
wait
         DEFB 13,10,10
waita    DEFM Insert Destination Dis
         DEFM k & Press A Key.
         DEFB 0
load
         LD   hl,filename
lfl      LD   b,12
         LD   de,#c000
         CALL #bc77
         JR   nc,loaderr
         LD   hl,#c000
         CALL #bc83
         JP   #bc7a
save
         LD   hl,savename
sfl      LD   b,12
         LD   de,#8000
         CALL #bc8c
         JR   nc,saveerr
         LD   hl,#4000
scrlen   LD   de,#4000
scrlena  LD   bc,0
         LD   a,2
         CALL #bc98
         JP   #bc8f
filename DEFM LOADNAME.BIN
savename DEFM COMPRESS.SCN
loaderr
         POP  hl                        ; Get Rid Of Return Address
         LD   hl,Loading
         JP   print
saveerr
         POP  hl
         LD   hl,Saving
         JP   print
Loading  DEFM Loading Error
         DEFB 0
Saving   DEFM Writing Error
         DEFB 0
;
errorsx
         LD   hl,ER
         CALL print
         RET  
blanknam                                ; Blank File Name
         LD   hl,filename
         LD   de,filename+1
         LD   bc,11
         LD   (hl),32
         LDIR 
         LD   hl,savename
         LD   de,savename+1
         LD   bc,11
         LD   (hl),32
         LDIR 
         LD   hl,filename+8
         LD   de,savename+8
         LD   a,"."
         LD   (hl),a
         LD   (de),a
         RET  
insertn                                 ; Get Filenames
         LD   de,savename
         CALL putfile
         LD   (sfl+1),a
         LD   de,filename
         CALL putfile
         LD   (lfl+1),a
         DEC  ix
         DEC  ix
         DEC  ix
         DEC  ix
         RET  
putfile
         PUSH de
         LD   l,(ix+0)
         LD   h,(ix+1)
         LD   a,(hl)
         PUSH af
;
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         EX   de,hl                     ; HL=Address
         POP  af
         POP  de
         PUSH af
         LD   c,a
         LD   b,0
         LDIR 
         POP  af
         INC  ix
         INC  ix
         RET  
compress
         CP   2
         JR   nz,errorsx
         CALL blanknam
         CALL insertn                   ; Get Filenames
         LD   a,1
         CALL #bc0e
         CALL load
         LD   hl,expand
         LD   de,#4000
         LD   bc,lenf
         LDIR 
         LD   ix,count
         LD   bc,0
         LD   de,smallpic
         CALL start
         XOR  a
         LD   (de),a
         INC  de
         PUSH de
         LD   a,1
         CALL #bc0e
         POP  de
         LD   hl,sizemsg
         CALL print
         EX   de,hl
         LD   de,smallpic
         SBC  hl,de
         PUSH hl
         CALL printhl
         POP  hl
         LD   de,#4d
         ADD  hl,de
         LD   (scrlen+1),hl
         LD   hl,wait
         CALL print
         CALL #bb18
         CALL save
         CALL crlf
         JP   #4000
error
         POP  bc
         LD   a,7
         CALL output
         LD   hl,errmsg
print
         LD   a,(hl)
         INC  hl
         OR   a
         RET  z
         CALL output
         JR   print
crlf
         LD   a,13
         CALL output
         LD   a,10
         CALL output
         RET  
sizemsg
         DEFB 12
         DEFM Size of compressed 
         DEFM screen = &
         DEFB 0
errmsg
         DEFB 12
         DEFM Screen to complex
         DEFB 13,10,0
printhl
         LD   a,h
         CALL a_to_bc
         CALL output
         LD   a,c
         CALL output
         LD   a,l
         CALL a_to_bc
         CALL output
         LD   a,c
         CALL output
         RET  
a_to_bc
         LD   b,a
         CALL altoasc
         LD   c,a
         LD   a,b
         CALL ahtoasc
         LD   b,a
         RET  
ahtoasc
         RLCA 
         RLCA 
         RLCA 
         7,7,7,7,7,0
hello
E             
altoasc
         AND  #0f
         ADD  a,48
         CP   58
         RET  c
         ADD  a,7
         RET  
start
         LD   hl,smallpic+#4000
         OR   a
         SBC  hl,de
         JP   c,error
         LD   hl,diffs
         CALL getbyte
         RET  nc
         LD   (ix+1),a
         LD   (hl),a
         INC  hl
         LD   (ix+0),1
         CALL getbyte
         CALL nc,outsame
         RET  nc
         INC  (ix+0)
         LD   (hl),a
         INC  hl
         CP   (ix+1)
         LD   (ix+1),a
         JR   z,same
diffrent
         CALL getbyte
         CALL nc,outdiff
         RET  nc
         CP   (ix+1)
         CALL z,backdiff
         CALL z,outdiff
         JR   z,start
         CALL adddiff
         JR   nc,start
         JR   diffrent
same
         CALL getbyte
         CALL nc,outsame
         RET  nc
         CP   (ix+1)
         CALL nz,backsame
         CALL nz,outsame
         JR   nz,start
         CALL addsame
         JR   nc,start
         JR   same
getbyte
         LD   a,c
         CP   200
         RET  z
         PUSH hl
         PUSH bc
         AND  7
         ADD  a,a
         ADD  a,a
         ADD  a,a
         ADD  a,#c0
         LD   h,a
         LD   l,b
         PUSH hl
         LD   b,0
         SRL  c
         SRL  c
         SRL  c
         PUSH bc
         POP  hl
         ADD  hl,hl
         ADD  hl,hl
         ADD  hl,bc
         ADD  hl,hl
         ADD  hl,hl
         ADD  hl,hl
         ADD  hl,hl
         POP  bc
         ADD  hl,bc
         POP  bc
         INC  b
         LD   a,b
         CP   80
         JR   nz,gb2
         LD   b,0
         INC  c
gb2
         LD   a,(hl)
         POP  hl
         SCF  
         RET  
adddiff
         LD   (ix+1),a
         LD   (hl),a
         INC  hl
         INC  (ix+0)
         LD   a,(ix+0)
         CP   127
         RET  c
outdiff
         LD   a,(ix+0)
         LD   (de),a
         INC  de
         LD   hl,diffs
         PUSH bc
         LD   c,a
         LD   b,0
         LDIR 
         POP  bc
         RET  
addsame
         INC  (ix+0)
         LD   a,(ix+0)
         CP   127
         RET  c
outsame
         LD   a,(ix+0)
         SET  7,a
         LD   (de),a
         INC  de
         LD   a,(ix+1)
         LD   (de),a
         INC  de
         RET  
backdiff
         PUSH af
         DEC  (ix+0)
         POP  af
         CALL backsame
backsame
         PUSH af
         LD   a,b
         SUB  1
         JR   nc,bs1
         DEC  c
         LD   a,79
bs1
         LD   b,a
         POP  af
         RET  
count    DEFW 0
diffs    DEFS 127
;
;
expand
         ORG  #4000
le
         LD   hl,smallpic
         LD   de,0
ex2
         LD   a,(hl)
         INC  hl
         OR   a
         RET  z
         LD   c,a
         LD   b,a
         RES  7,b
ex3
         PUSH de
         PUSH hl
         LD   a,e
         AND  7
         ADD  a,a
         ADD  a,a
         ADD  a,a
         ADD  a,#c0
         LD   h,a
         LD   l,d
         PUSH hl
         LD   d,0
         SRL  e
         SRL  e
         SRL  e
         PUSH de
         POP  hl
         ADD  hl,hl
         ADD  hl,hl
         ADD  hl,de
         ADD  hl,hl
         ADD  hl,hl
         ADD  hl,hl
         ADD  hl,hl
         POP  de
         ADD  hl,de
         EX   de,hl
         POP  hl
         LD   a,(hl)
         LD   (de),a
         POP  de
         INC  d
         LD   a,d
         CP   80
         JR   nz,ex4
         CALL #bd19
         LD   d,0
         INC  e
ex4
         BIT  7,c
         JR   nz,ex5
         INC  hl
ex5
         DJNZ ex3
         BIT  7,c
         JR   z,ex2
         INC  hl
         JR   ex2
lenf     EQU  $-le
smallpic
