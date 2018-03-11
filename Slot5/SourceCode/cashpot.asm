;
cashpot                                 ; Mystery Gaming Function
         LD   a,24
cashpotm EQU  $-1
         LD   (lastwin),a
         OR   a
         JP   z,cashfal8
         XOR  a
         LD   (functcnt),a
         CALL dcasha
         CALL resetag
         CALL cashfals
         LD   hl,potcash
         LD   de,potcash+1
         LD   bc,23
         LD   (hl),b
         LDIR 
         LD   a,(cashpotm)
cashpot1
         LD   (hl),#ff
         DEC  hl
         DEC  a
         JR   nz,cashpot1
cashpot2
         LD   (cashpotm),a
         CALL tenps64
         LD   hl,potcash
         LD   b,24
cashpota
         LD   a,(hl)
         OR   a
         JR   nz,cashpot3
         INC  hl
         DEC  b
         JR   cashpota
cashpot3
         PUSH bc
         PUSH hl
         CALL flashpot
         LD   (hl),0
         CALL tenps64
         POP  hl
         INC  hl
         POP  bc
         DJNZ cashpot3
         CALL game0
         JP   incmoney
flashpot
         XOR  a
         LD   (functcnt),a
         CALL flshpt1
         LD   a,1
flshpt1
         PUSH hl
         LD   (hl),a
         CALL ping
         CALL tenps64
         POP  hl
         RET  
dcash
         LD   a,(cashpotm)
dcasha
         LD   hl,wunm
         PUSH hl
         LD   (hl),12
         INC  hl
         LD   d,10
         CALL subtract
         OR   #30
         PUSH hl
         INC  hl
         LD   (hl),"."
         INC  hl
         LD   (hl),a
         INC  hl
         LD   (hl),#30
         INC  hl
         LD   (hl),#ff
         POP  hl
         LD   a,c
         OR   #30
         LD   (hl),a
         POP  hl
         CALL setupms
         LD   hl,#cf92
         LD   b,8
         CALL dcash1
dnudge
         LD   a,(nudges)
         LD   hl,wunm
         PUSH hl
         DEC  (hl)
         INC  hl
         OR   #30
         LD   (hl),a
         INC  hl
         LD   (hl),#ff
         POP  hl
         CALL setupms
         LD   hl,#ff51
         LD   b,2
dcash1
         PUSH bc
         PUSH hl
         LD   (dmessad),hl
         CALL dmess
         POP  hl
         PUSH hl
         LD   b,5
dcash2
         LD   a,(hl)
         AND  #55
         ADD  a,a
         LD   (hl),a
         LD   a,8
         ADD  a,h
         JR   nc,dcash3
         LD   a,#50
         ADD  a,l
         LD   l,a
         LD   a,#c8
         ADC  a,h
dcash3
         OR   #c0
         LD   h,a
         DJNZ dcash2
         CALL dmess
         POP  hl
         POP  bc
         INC  hl
         DJNZ dcash1
         LD   hl,#f9b6
         LD   (dmessad),hl
         RET  
;
*f,nudges.adm
