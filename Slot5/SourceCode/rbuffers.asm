;
ingamefd
         LD   ix,sprload
         LD   (placefbd),hl
         LD   de,#e3
         ADD  hl,de
         LD   (placefd1),hl
placefb                                 ; Place Fruit Sprite Into Buffer
         CALL calcrspa
         PUSH hl
         EX   de,hl
         LD   de,reel1bfd
placefbd EQU  $-2
         LD   b,36
placefb1
         PUSH bc
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         LDI  
         POP  bc
         DJNZ placefb1
         POP  de
         LD   a,d
         OR   e
         RET  z
         LD   hl,reel1bfd+#e3
placefd1 EQU  $-2
         LD   c,12
         LD   b,3
placefb0
         PUSH bc
placefb2
         LD   a,(de)
         AND  #aa
         CP   #8a
         JR   z,placefb3
         LD   c,a
         LD   a,(hl)
         AND  #55
         OR   c
         LD   (hl),a
placefb3
         LD   a,(de)
         AND  #55
         CP   #45
         JR   z,placefb4
         LD   c,a
         LD   a,(hl)
         AND  #aa
         OR   c
         LD   (hl),a
placefb4
         INC  hl
         INC  de
         DJNZ placefb2
         INC  hl
         INC  hl
         INC  hl
         INC  hl
         INC  hl
         INC  hl
         INC  hl
         INC  hl
         POP  bc
         DEC  c
         JR   nz,placefb0
         RET  
calcrspa                                ; Calculate Reel Sprite Address
         LD   c,a
         SRL  a
         SRL  a
         SRL  a                         ; Shift Fruit Number
         LD   e,a
         LD   h,0
         ADD  a,a
         ADD  a,e
         ADD  a,a
         ADD  a,a
         LD   l,a
         LD   d,h
         ADD  hl,hl
         ADD  hl,hl
         ADD  hl,de
         ADD  hl,hl
         ADD  hl,de
         ADD  hl,hl
         ADD  hl,hl
         LD   e,(ix+26)
         LD   d,(ix+27)
         ADD  hl,de
         PUSH de
         LD   de,sprload
         ADD  hl,de
         POP  de
         LD   a,c
         PUSH hl
         AND  7
         LD   hl,0
         JR   z,calcra1
         DEC  a
         LD   e,a
         ADD  a,a
         ADD  a,a
         ADD  a,a
         ADD  a,e
         ADD  a,a
         ADD  a,a
         LD   l,a
         LD   e,(ix+28)
         LD   d,(ix+29)
         ADD  hl,de
         LD   de,sprload
         ADD  hl,de
calcra1
         POP  de
         RET  
setpoint                                ; Set Reel Pointers
         LD   ix,sprload
         CALL checkm0
         RET  nz
         LD   a,r
         AND  7
         LD   e,a
         LD   d,0
         LD   hl,reeldtb
         ADD  hl,de
         LD   a,(hl)
         LD   (state),a
         AND  a
setptbf                                 ; Set Buffer Pointers
         RRA  
         LD   de,rel5addd
         LD   hl,ree5adpf
         JR   nc,setbfr5
         LD   de,rel5addu
         LD   hl,ree5aupf
setbfr5
         LD   (reel5adp),hl
         PUSH af
         LD   a,(de)
         LD   hl,reel5bfd
         CALL ingamefd
         POP  af
         RRA  
         LD   de,rel4addd
         LD   hl,ree4adpf
         JR   nc,setbfr4
         LD   de,rel4addu
         LD   hl,ree4aupf
setbfr4
         LD   (reel4adp),hl
         PUSH af
         LD   a,(de)
         LD   hl,reel4bfd
         CALL ingamefd
         POP  af
         RRA  
         LD   de,rel3addd
         LD   hl,ree3adpf
         JR   nc,setbfr3
         LD   de,rel3addu
         LD   hl,ree3aupf
setbfr3
         LD   (reel3adp),hl
         PUSH af
         LD   a,(de)
         LD   hl,reel3bfd
         CALL ingamefd
         POP  af
         RRA  
         LD   de,rel2addd
         LD   hl,ree2adpf
         JR   nc,setbfr2
         LD   de,rel2addu
         LD   hl,ree2aupf
setbfr2
         LD   (reel2adp),hl
         PUSH af
         LD   a,(de)
         LD   hl,reel2bfd
         CALL ingamefd
         POP  af
         RRA  
         LD   de,rel1addd
         LD   hl,ree1adpf
         JR   nc,setbfr1
         LD   de,rel1addu
         LD   hl,ree1aupf
setbfr1
         LD   (reel1adp),hl
         PUSH af
         LD   a,(de)
         LD   hl,reel1bfd
         CALL ingamefd
         POP  af
setrc                                   ; Set Reel Counter
         LD   a,r
         XOR  #4a
xr       EQU  $-1
         LD   (xr),a
         AND  3
         ADD  a,5
         LD   (rscount),a
         RET  
*f,hold.adm
