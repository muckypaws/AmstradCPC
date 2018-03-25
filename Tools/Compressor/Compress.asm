
         ORG  #a000
         EQU  $
output   EQU  #bb5a
         LD   ix,count
         LD   bc,0
         LD   de,smallpic
         CALL start
         XOR  a
         LD   (de),a
         INC  de
         LD   hl,sizemsg
         CALL print
         EX   de,hl
         LD   de,smallpic
         SBC  hl,de
         CALL printhl
         CALL crlf
         RET  
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
         RLCA 
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
smallpic EQU  #4000

