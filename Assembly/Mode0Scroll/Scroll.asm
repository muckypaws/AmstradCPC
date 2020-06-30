
.COPYRIGHT 1985 MICRO-APPLICATION.
.DAMS.

;
         ORG  #9000                     ; Mode 0 Scroll Routine
         ENT  $                         ; 4 Bits Per Second
;
         DI   
         LD   b,#f5
ff
         IN   a,(c)
         RRA  
         JR   nc,ff
         LD   hl,#c0a0+#50
         LD   d,5
scrolmb1
         PUSH hl
         LD   b,#19
scrolmb2
         LD   a,(hl)
         AND  #55
         RLCA 
         LD   (hl),a
         INC  hl
         LD   a,(hl)
         AND  #aa
         RRCA 
         DEC  hl
         OR   (hl)
         LD   (hl),a
         INC  hl
         DJNZ scrolmb2
         POP  hl
         LD   a,8
         ADD  a,h
         JR   nc,scrolmb3
         LD   a,#50
         ADD  a,l
         LD   l,a
         LD   a,#c8
         ADC  a,h
scrolmb3
         OR   #c0
         LD   h,a
         DEC  d
         JR   nz,scrolmb1
         LD   hl,message
messagec EQU  $-2
         LD   a,(hl)
         BIT  7,a
         JR   z,dmess1
         LD   hl,message
messageo EQU  $-2
         LD   (messagec),hl
         RET  
         LD   a,32
dmess1
         SUB  #27
         LD   d,0
         LD   h,d
         ADD  a,a
         LD   e,a
         ADD  a,a
         LD   l,a
         ADD  hl,hl
         ADD  hl,de
         LD   a,(messagep)
         BIT  1,a
         JR   z,dmess2
         LD   e,5
         ADD  hl,de
dmess2
         LD   de,#200                   ; Spr load
         ADD  hl,de
         EX   de,hl
         LD   hl,#c108
         LD   b,5
dmess3
         LD   a,0
messagep EQU  $-1
         AND  1
         LD   a,(de)
         JR   nz,dmess4
         AND  #aa
         RRCA 
dmess4
         AND  #55
         LD   c,a
         LD   a,(hl)
         AND  #aa
         OR   c
         LD   (hl),a
         LD   a,8
         ADD  a,h
         JR   nc,dmess5
         LD   a,#50
         ADD  a,l
         LD   l,a
         LD   a,#c8
         ADC  a,h
dmess5
         OR   #c0
         LD   h,a
         INC  de
         DJNZ dmess3
         LD   hl,messagep
         INC  (hl)
         LD   a,(hl)
         SUB  4
         RET  nz
         LD   (hl),a
         LD   hl,(messagec)
         INC  hl
         LD   (messagec),hl
         RET  
message
         DEFM TEST?MESSAGE?
         DEFB #ff
