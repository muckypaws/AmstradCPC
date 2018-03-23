;
         ORG  #a000                     ; Screen Compressor
compress                                ; Written By Jason Brooks 30/07/90
         ENT  $                         ; (C) 1990 JacesofT Software Ltd.
         DI   
         PUSH ix
         PUSH iy
         LD   ix,#100                   ; Location To Place Data
         LD   iy,stack
         XOR  a
         LD   (counters),a
         LD   (numbern),a
         LD   l,a
         LD   h,l
         LD   e,h
         LD   d,e
loop
         CALL samebyte
         PUSH af
         LD   a,l
         SUB  200
         JR   nc,quit1
         POP  af
         CALL c,dwdate
         CALL nonbyte
         CALL dwdate
         DEFB #dd
         LD   a,h
         CP   #3f
         JR   nz,loop
quit
         LD   (ix+0),0
         INC  ix
         POP  iy
         POP  ix
         EI   
         RET  
quit1
         POP  af
         JR   quit
;
nonbyte
         CALL getbyte
         LD   (iy+0),a
         LD   (compar),a
non1
         CALL update
         JR   nc,non2
         CALL getbyte
         CP   0
compar   EQU  $-1
         JR   z,non2
         LD   (compar),a
         LD   (iy+1),a
         INC  iy
         LD   a,0
numbern  EQU  $-1
         INC  a
         LD   (numbern),a
         CP   #7f
         JR   nz,non1
         LD   a,(numbern)
         INC  a
         RES  7,a
         LD   (ix+0),a
         CALL non4
         JR   nonbyte
non4
         PUSH hl
         LD   hl,stack
         LD   b,a
non3
         LD   a,(hl)
         LD   (ix+1),a
         INC  hl
         INC  ix
         DJNZ non3
         LD   iy,stack
         POP  hl
         XOR  a
         INC  ix
         LD   (numbern),a
         RET  
non2
         LD   a,(numbern)
         OR   a
         SCF  
         RET  z
         JR   z,dwdate
         RES  7,a
         LD   (ix+0),a
         JR   non4
samebyte
         CALL getbyte
         LD   (compare),a
same1
         CALL update
         JR   nc,same2
         CALL getbyte
         LD   (iy+0),a
         CP   0
compare  EQU  $-1
         JR   nz,same2
         LD   a,0
counters EQU  $-1
         INC  a
         LD   (counters),a
         CP   #7f
         JR   nz,same1
         CALL same3
;CALL dwdate
;CALL update
         JR   samebyte
same2
         LD   a,(counters)
         OR   a
         SCF  
         RET  z
         JR   z,dwdate
         INC  a
same3
         SET  7,a
         LD   (ix+0),a
         LD   a,(compare)
         LD   (ix+1),a
         INC  ix
         INC  ix
         XOR  a
         LD   (counters),a
         RET  
getbyte                                 ; Entry L & E = Co-Ords Exit A=Byte
         PUSH hl
         PUSH de
         PUSH bc
         CALL calcbyte
         LD   a,(hl)
         POP  bc
         POP  de
         POP  hl
         RET  
update
         INC  e
         LD   a,e
         SUB  80
         RET  nz
         LD   e,0
         INC  l
         LD   a,l
         SUB  200
         RET  
dwdate
         DEC  e
         LD   a,e
         CP   #ff
         RET  nz
         LD   e,79
         DEC  l
         RET  
calcbyte                                ; Entry L=Row (0-199) , E=Column (0-79)
         LD   h,0
         LD   a,l
         AND  7
         ADD  a,a
         ADD  a,a
         ADD  a,a
         SRL  l
         SRL  l
         SRL  l
         LD   c,a
         LD   a,l
         ADD  a,a
         ADD  a,a
         ADD  a,l
         ADD  a,a
         LD   l,a
         ADD  hl,hl
         ADD  hl,hl
         ADD  hl,hl
         LD   a,c
         ADD  a,h
         OR   #c0
         LD   h,a
         LD   a,e
         ADD  a,l
         LD   l,a
         ADC  a,h
         SUB  l
         OR   #c0
         LD   h,a
         RET  
decomp
         XOR  a
         LD   l,a
         LD   h,l
         LD   e,h
         LD   d,e
         LD   ix,#100
decomp1
         LD   a,(ix+0)
         OR   a
         RET  z
         BIT  7,a
         JR   nz,decr
         LD   b,a
         INC  ix
decomp3
         LD   a,(ix+0)
         INC  ix
         CALL decomp2
         RET  nc
         DJNZ decomp3
         JR   decomp1
decr
         RES  7,a
         LD   b,a
         INC  ix
decr1
         LD   a,(ix+0)
         CALL decomp2
         RET  nc
         DJNZ decr1
         INC  ix
         JR   decomp1
decomp2
         PUSH bc
         PUSH de
         PUSH hl
         PUSH af
         CALL calcbyte
         POP  af
         LD   (hl),a
         POP  hl
         POP  de
         POP  bc
         JP   update
stack    DEFS 128,0
