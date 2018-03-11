;
decomp                                  ; HL=Addr - DECMP DATA : DE = CMP DATA
         PUSH af
         LD   a,c
         OR   a
         LD   a,#38
         JR   nz,dec
         XOR  a
dec
         LD   (decompv2+4),a
         POP  af
         CALL setdcmpv
         LD   a,b
         LD   (decmwid1),a
         LD   (decomps4),a
         LD   (decwid),a
decompv1
         LD   a,(de)
         OR   a
         RET  z
         PUSH af
         AND  #80
         JR   nz,decr
         POP  af
         AND  #7f
         LD   b,a
         INC  de
decompv3
         LD   a,(de)
         INC  de
         CALL decompv2
         RET  nc
         DJNZ decompv3
         JR   decompv1
decr
         POP  af
         AND  #7f
         LD   b,a
         INC  de
decrv1
         LD   a,(de)
         CALL decompv2
         RET  nc
         DJNZ decrv1
         INC  de
         JR   decompv1
decompv2                                ; Update HL
         LD   hl,#c000
         JR   decmem
decompvs
         LD   (hl),a
         LD   a,8
         ADD  a,h
         JR   nc,decomps1
         LD   a,#50
         ADD  a,l
         LD   l,a
         LD   a,h
         ADC  a,#c8
decomps1
         OR   #c0
         LD   h,a
         LD   (decompv2+1),hl
         INC  c
         LD   a,c
         CP   200
decomps2 EQU  $-1
         SCF  
         RET  nz
         LD   c,0
         LD   hl,(decmpvo)
         INC  hl
         LD   a,h
         OR   #c0
         LD   h,a
         LD   (decmpvo),hl
         LD   (decompv2+1),hl
         LD   a,0
decomps3 EQU  $-1
         INC  a
         LD   (decomps3),a
         CP   2
decomps4 EQU  $-1
         SCF  
         RET  nz
         XOR  a
         LD   (decomps3),a
         RET  
decmem
         LD   (hl),a
         LD   a,0
decwid   EQU  $-1
         ADD  a,l
         LD   l,a
         ADC  a,h
         SUB  l
         LD   h,a
         LD   (decompv2+1),hl
         INC  c
         LD   a,c
         CP   0
decompof EQU  $-1
         SCF  
         RET  nz
         LD   c,0
         LD   hl,#c000
decmpvo  EQU  $-2
         INC  hl
         LD   a,0
decmwid  EQU  $-1
         INC  a
         LD   (decmwid),a
         CP   0
decmwid1 EQU  $-1
         JR   nz,setd
         OR   a
         RET  
setd     LD   a,(decompof)
setdcmpv
         LD   (decmpvo),hl
         LD   (decompv2+1),hl
         LD   (decompof),a
         LD   (decomps2),a
         XOR  a
         LD   (decmwid),a
         LD   (decomps3),a
         LD   c,0
         SCF  
         RET  
*f,gamble.adm
