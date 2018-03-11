;
setupms                                 ; Set Up Message Scroll
         XOR  a
         LD   (messagep),a
         LD   (messagec),hl
         LD   (messageo),hl
         RET  
scrmess
         LD   (exitkey),a
scrmess1
         CALL framefly
         CALL scrolmb
         LD   a,0
exitmes  EQU  $-1
         BIT  7,a
         JR   nz,exitkey1
         LD   a,27
exitkey  EQU  $-1
         CALL scankey
         JR   nz,scrmess1
         LD   a,(messagep)
         OR   a
         JR   nz,scrmess1
         RET  
exitkey1
         SCF  
         RET  
dspace
         LD   hl,spaces
         CALL setupms
         LD   a,37*2+4
dspace1
         PUSH af
         CALL framefly
         CALL scrolmb
         POP  af
         DEC  a
         JR   nz,dspace1
         RET  
scrolmb
         LD   hl,#f992
         LD   d,5
scrolmb1
         PUSH hl
         LD   b,37
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
dmess
         LD   hl,welcome
messagec EQU  $-2
         LD   a,(hl)
         LD   (exitmes),a
         BIT  7,a
         JR   z,dmess1
         LD   hl,welcome
messageo EQU  $-2
         LD   (messagec),hl
         LD   a,"?"
         CALL dmess1
         XOR  a
         LD   (messagep),a
         RET  
@
colour
         ADD  a,17
         LD   e,a
         XOR  a
         LD   (messagep),a
         LD   d,0
         LD   hl,einktble
         ADD  hl,de
         LD   a,(hl)
         LD   (lcolmask),a
         CALL dmess9
         JR   dmess
dmess1
         SUB  17
         JR   c,colour
         SUB  #16
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
         LD   ix,sprload
         LD   e,(ix+30)
         LD   d,(ix+31)
         ADD  hl,de
         LD   de,sprload
         ADD  hl,de
         EX   de,hl
         LD   hl,#f9b6
dmessad  EQU  $-2
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
         AND  #ff
lcolmask EQU  $-1
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
dmess9
         LD   hl,(messagec)
         INC  hl
         LD   (messagec),hl
         RET  
*f,mystery.adm
