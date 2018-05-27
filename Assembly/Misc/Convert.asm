;
         ORG  #9c00                     ; Program To Convert .BIN to .COM files
start
         ENT  $
         LD   a,#c9
         LD   (start),a
         LD   hl,work
         LD   bc,table
         CALL #bcd1
         LD   hl,logged
         JP   print
memsf                                   ; |MEMSF,start_addr,End_Addr,"FILENAME.
         CP   3
         JP   nz,EC2
         CALL reset
         LD   l,(ix+0)
         LD   h,(ix+1)
         CALL getname
         LD   de,nameout
         LDIR 
         LD   l,(ix+2)
         LD   h,(ix+3)
         LD   e,(ix+4)
         LD   d,(ix+5)
         LD   (START),de
         AND  a
         SBC  hl,de
         LD   (LEN),hl
         JP   savefile
memsl                                   ; |MEMSL,start_addr,length,"FILENAME.CO
         CP   3
         JP   nz,EC3
         CALL reset
         LD   l,(ix+0)
         LD   h,(ix+1)
         CALL getname
         LD   de,nameout
         LDIR 
         LD   l,(ix+2)
         LD   h,(ix+3)
         LD   e,(ix+4)
         LD   d,(ix+5)
         LD   (START),de
         LD   (LEN),hl
         JR   savefile
convert                                 ; |CONVERT,"FILENAME.BIN","FILENAME.COM
         CP   2
         JP   nz,EC
         CALL reset
;
         LD   l,(ix+0)
         LD   h,(ix+1)
         CALL getname
         LD   de,nameout
         LDIR 
         LD   l,(ix+2)
         LD   h,(ix+3)
         CALL getname
         LD   de,namein
         LDIR 
         LD   hl,namein
         LD   de,#c000
         LD   b,12
         CALL #bc77
         JP   nc,lerror
         LD   (LEN),bc
         LD   hl,#100
         ADD  hl,bc
         LD   de,start
         AND  a
         SBC  hl,de
         JP   nc,merror
         LD   hl,#100
         LD   (START),hl
         CALL #bc83
         JP   nc,lerror
         CALL #bc7a
         JP   nc,lerror
         JR   savefile
getname
         LD   c,(hl)
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   b,0
         EX   de,hl
         LD   a,c
         CP   13
         RET  c
         POP  de
         LD   hl,ferror
         JR   print
savefile                                ; Save File Out
         DI   
         LD   hl,nameout
         LD   de,#c000
         LD   b,12
         CALL #bc8c
         JP   nc,error
         LD   hl,(START)
         LD   de,(LEN)
write
         LD   a,(hl)
         CALL #bc95
         JP   nc,error
         INC  hl
         DEC  de
         LD   a,e
         OR   d
         JR   nz,write
         LD   a,#1a
         CALL #bc95
         JP   nc,error
         CALL #bc8f
         JP   nc,error
         RET  
reset                                   ; Transfer Load Name
         LD   hl,nameout
         LD   de,nameout+1
         LD   bc,23
         LD   (hl),32
         LDIR 
         RET  
error
         CALL #bc92
         CALL #bc8f
         LD   hl,errorm
print
         LD   a,(hl)
         OR   a
         RET  z
         INC  hl
         CALL #bb5a
         JR   print
EC                                      ; Error In Convert
         CALL ET
         LD   hl,com3
         JR   print
EC2
         CALL ET
         LD   hl,com1
         JR   print
EC3
         CALL ET
         LD   hl,com2
         JR   print
ET
         LD   hl,errorm1
         CALL print
         LD   hl,comsyn
         JR   print
lerror
         CALL #bc92
         CALL #bc8f
         LD   hl,LER
         JR   print
merror
         CALL #bc92
         CALL #bc8f
         LD   hl,MER
         JR   print
START    DEFW 0
LEN      DEFW 0
logged
         DEFB 7,13,10,10
         DEFM *** New RSX's Initialize
         DEFM d ***
         DEFB 13,10
         DEFM (C) Jason Brooks - All Ri
         DEFM ghts Reserved.
         DEFB 13,10,0
ferror
         DEFB 7,13,10,10
         DEFM *** Filename Error ***
         DEFB 13,10,0
MER
         DEFB 7,13,10
         DEFM *** Memory Violation Erro
         DEFM r ***
         DEFB 13,10,0
LER
         DEFB 7,13,10
         DEFM *** Loading Error ***
         DEFB 13,10,0
errorm
         DEFB 7,13,10,10
         DEFM *** Error Writting Outpu
         DEFM t File ***
         DEFB 13,10,10,0
errorm1
         DEFB 7,13,10,10
         DEFM *** Wrong Number Of Param
         DEFM eters ***
         DEFB 13,10,0
comsyn
         DEFB 13,10
         DEFM Command Syntax :-
         DEFB 13,10
         DEFM -----------------
         DEFB 13,10,0
com1
         DEFB 13,10
         DEFM |MEMSF,<start_addr>,<end_
         DEFM addr>,<"FILENAME.COM">
         DEFB 13,10,0
com2
         DEFB 13,10
         DEFM |MEMSL,<start_addr>,<leng
         DEFM th>,<"FILENAME.COM">
         DEFB 13,10,0
com3
         DEFB 13,10
         DEFM |CONVERT,<"FILENAME.BIN"
         DEFM >,<"FILENAME.COM">
         DEFB 13,10,10,0
work     DEFS 4,0
table
         DEFW comms
         JP   memsf
         JP   memsl
         JP   convert
comms
         DEFM MEMS
         DEFB "F"+#80
         DEFM MEMS
         DEFB "L"+#80
         DEFM CONVER
         DEFB "T"+#80
         DEFB 0
;
nameout  DEFM OUTFILE .COM
namein   DEFM INFILE  .BIN
