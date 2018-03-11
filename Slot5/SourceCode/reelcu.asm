;
reel1cd                                 ; Reel 1 Control
         LD   a,(reel1spd)
         OR   a
         JP   z,scrolr1
         LD   hl,reeloffs
         CALL shiftdwr
         LD   a,(moved1)
         ADD  a,e
         LD   (moved1),a
         CALL scrolr1                   ; Move Reel 1
         LD   hl,(reel1adp)
         CALL replaced
         LD   (reel1adp),hl
         LD   hl,moved1
         LD   a,(hl)
         SUB  36
         RET  nz
         LD   (hl),a
         CALL r1down
         LD   hl,ree1adpf
         LD   (reel1adp),hl
         LD   a,(reelt1+mid)
         LD   hl,reel1bfd
         JP   ingamefd
reel2cd                                 ; Reel 2 Control
         LD   a,(reel2spd)
         OR   a
         JP   z,scrolr2
         LD   hl,reelofs1
         CALL shiftdwr
         LD   a,(moved2)
         ADD  a,e
         LD   (moved2),a
         CALL scrolr2
         LD   hl,(reel2adp)
         CALL replaced
         LD   (reel2adp),hl
         LD   hl,moved2
         LD   a,(hl)
         SUB  36
         RET  nz
         LD   (hl),a
         CALL r2down
         LD   hl,ree2adpf
         LD   (reel2adp),hl
         LD   a,(reelt2+mid)
         LD   hl,reel2bfd
         JP   ingamefd
reel3cd
         LD   a,(reel3spd)
         OR   a
         JP   z,scrolr3
         LD   hl,reelofs2
         CALL shiftdwr
         LD   a,(moved3)
         ADD  a,e
         LD   (moved3),a
         CALL scrolr3
         LD   hl,(reel3adp)
         CALL replaced
         LD   (reel3adp),hl
         LD   hl,moved3
         LD   a,(hl)
         SUB  36
         RET  nz
         LD   (hl),a
         CALL r3down
         LD   hl,ree3adpf
         LD   (reel3adp),hl
         LD   a,(reelt3+mid)
         LD   hl,reel3bfd
         JP   ingamefd
reel4cd
         LD   a,(reel4spd)
         OR   a
         JP   z,scrolr4
         LD   hl,reelofs1
         CALL shiftdwr
         LD   a,(moved4)
         ADD  a,e
         LD   (moved4),a
         CALL scrolr4
         LD   hl,(reel4adp)
         CALL replaced
         LD   (reel4adp),hl
         LD   hl,moved4
         LD   a,(hl)
         SUB  36
         RET  nz
         LD   (hl),a
         CALL r4down
         LD   hl,ree4adpf
         LD   (reel4adp),hl
         LD   a,(reelt4+mid+1)
         LD   hl,reel4bfd
         JP   ingamefd
reel5cd
         LD   a,(reel5spd)
         OR   a
         JP   z,scrolr5
         LD   hl,reeloffs
         CALL shiftdwr
         LD   a,(moved5)
         ADD  a,e
         LD   (moved5),a
         CALL scrolr5
         LD   hl,(reel5adp)
         CALL replaced
         LD   (reel5adp),hl
         LD   hl,moved5
         LD   a,(hl)
         SUB  36
         RET  nz
         LD   (hl),a
         CALL r5down
         LD   hl,ree5adpf
         LD   (reel5adp),hl
         LD   a,(reelt5+mid+2)
         LD   hl,reel5bfd
         JP   ingamefd
shiftdwr                                ; Shift Reel Down
         DEC  a
         LD   e,a
         LD   d,0
         ADD  hl,de
         LD   a,(hl)
         LD   (copyr1),a
         LD   (copyr3),a
         LD   e,6
         ADD  hl,de
         LD   a,(hl)
         LD   (scrolrm1),a
         LD   (scrolrm5),a
         LD   (scrolrm2),a
         LD   (scrolrm4),a
         LD   (scrolrm3),a
         LD   e,0
copyr1   EQU  $-1
         RET  
replaced                                ; Replace Sprite Down : HL=ReelADDP
         LD   b,0
copyr3   EQU  $-1
repr1
         PUSH bc
         PUSH de
         PUSH hl
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
         POP  hl
         LD   de,11
         AND  a
         SBC  hl,de
         POP  de
         LD   a,d
         SUB  8
         LD   d,a
         CP   #c0
         JR   nc,repr1a
         EX   de,hl
         LD   bc,#3fb0
         ADD  hl,bc
         EX   de,hl
repr1a
         POP  bc
         DJNZ repr1
         RET  
scrolr1                                 ; Move Reel 1 Down
         LD   a,(reel1spd)
         LD   de,#dbc2
         LD   hl,reel1sad
         LD   b,35
scrolrm1 EQU  $-1
         JR   scroldr
scrolr2
         LD   a,(reel2spd)
         LD   de,#fd0f
         LD   hl,reel2sad
         LD   b,70
scrolrm2 EQU  $-1
         JR   scroldr
scrolr3
         LD   a,(reel3spd)
         LD   de,#deac
         LD   hl,reel3sad
         LD   b,105
scrolrm3 EQU  $-1
         JR   scroldr
scrolr4
         LD   a,(reel4spd)
         LD   de,#deb9
         LD   hl,reel4sad
         LD   b,71
scrolrm4 EQU  $-1
         JR   scroldr
scrolr5
         LD   a,(reel5spd)
         LD   de,#dec6
         LD   hl,reel5sad
         LD   b,35
scrolrm5 EQU  $-1
scroldr                                 ; Scroll Reel X
         PUSH de
         SLA  a
         LD   e,a
         LD   d,0
         ADD  hl,de
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         EX   de,hl
         POP  de
scroldr1
         PUSH bc
         PUSH de
         PUSH hl
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
         POP  hl
         LD   a,h
         SUB  8
         LD   h,a
         CP   #c0
         JR   nc,scroldr2
         LD   de,#3fb0
         ADD  hl,de
scroldr2
         POP  de
         LD   a,d
         SUB  8
         LD   d,a
         CP   #c0
         JR   nc,scroldr3
         EX   de,hl
         LD   bc,#3fb0
         ADD  hl,bc
         EX   de,hl
scroldr3
         POP  bc
         DJNZ scroldr1
         RET  
reel1cu                                 ; Reel 1 Control
         LD   a,(reel1spd)
         OR   a
         JP   z,scrour1
         LD   hl,reeloffs
         CALL shiftupr
         LD   a,(moved1)
         ADD  a,e
         LD   (moved1),a
         CALL scrour1                   ; Move Reel 1
         LD   hl,(reel1adp)
         CALL replaceu
         LD   (reel1adp),hl
         LD   hl,moved1
         LD   a,(hl)
         SUB  36
         RET  nz
         LD   (hl),a
         CALL r1up
         LD   hl,ree1aupf
         LD   (reel1adp),hl
         LD   a,(reelt1+mid+2)
         LD   hl,reel1bfd
         JP   ingamefd
reel2cu
         LD   a,(reel2spd)
         OR   a
         JP   z,scrour2
         LD   hl,reelofs1
         CALL shiftupr
         LD   a,(moved2)
         ADD  a,e
         LD   (moved2),a
         CALL scrour2                   ; Move Reel 1
         LD   hl,(reel2adp)
         CALL replaceu
         LD   (reel2adp),hl
         LD   hl,moved2
         LD   a,(hl)
         SUB  36
         RET  nz
         LD   (hl),a
         CALL r2up
         LD   hl,ree2aupf
         LD   (reel2adp),hl
         LD   a,(reelt2+mid+3)
         LD   hl,reel2bfd
         JP   ingamefd
reel3cu
         LD   a,(reel3spd)
         OR   a
         JP   z,scrour3
         LD   hl,reelofs2
         CALL shiftupr
         LD   a,(moved3)
         ADD  a,e
         LD   (moved3),a
         CALL scrour3                   ; Move Reel 1
         LD   hl,(reel3adp)
         CALL replaceu
         LD   (reel3adp),hl
         LD   hl,moved3
         LD   a,(hl)
         SUB  36
         RET  nz
         LD   (hl),a
         CALL r3up
         LD   hl,ree3aupf
         LD   (reel3adp),hl
         LD   a,(reelt3+mid+4)
         LD   hl,reel3bfd
         JP   ingamefd
reel4cu
         LD   a,(reel4spd)
         OR   a
         JP   z,scrour4
         LD   hl,reelofs1
         CALL shiftupr
         LD   a,(moved4)
         ADD  a,e
         LD   (moved4),a
         CALL scrour4                   ; Move Reel 1
         LD   hl,(reel4adp)
         CALL replaceu
         LD   (reel4adp),hl
         LD   hl,moved4
         LD   a,(hl)
         SUB  36
         RET  nz
         LD   (hl),a
         CALL r4up
         LD   hl,ree4aupf
         LD   (reel4adp),hl
         LD   a,(reelt4+mid+4)
         LD   hl,reel4bfd
         JP   ingamefd
reel5cu
         LD   a,(reel5spd)
         OR   a
         JP   z,scrour5
         LD   hl,reeloffs
         CALL shiftupr
         LD   a,(moved5)
         ADD  a,e
         LD   (moved5),a
         CALL scrour5                   ; Move Reel 1
         LD   hl,(reel5adp)
         CALL replaceu
         LD   (reel5adp),hl
         LD   hl,moved5
         LD   a,(hl)
         SUB  36
         RET  nz
         LD   (hl),a
         CALL r5up
         LD   hl,ree5aupf
         LD   (reel5adp),hl
         LD   a,(reelt5+mid+4)
         LD   hl,reel5bfd
         JP   ingamefd
shiftupr                                ; Shift Reel Up
         DEC  a
         LD   e,a
         LD   d,0
         ADD  hl,de
         LD   a,(hl)
         LD   (copyru1),a
         LD   (copyru3),a
         LD   e,6
         ADD  hl,de
         LD   a,(hl)
         LD   (scrourm1),a
         LD   (scrourm5),a
         LD   (scrourm2),a
         LD   (scrourm4),a
         LD   (scrourm3),a
         LD   e,0
copyru1  EQU  $-1
         RET  
replaceu                                ; Replace Sprite Up : HL=ReelADDP
         LD   b,0
copyru3  EQU  $-1
repru1
         PUSH bc
         PUSH de
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
         POP  de
         EX   de,hl
         LD   a,h
         ADD  a,8
         JR   nc,repru1a
         LD   a,l
         ADD  a,#50
         LD   l,a
         LD   a,h
         ADC  a,#c8
repru1a
         LD   h,a
         EX   de,hl
         POP  bc
         DJNZ repru1
         RET  
scrour1                                 ; Move Reel 1 Up
         LD   a,(reel1spd)
         LD   de,#c282
         LD   hl,reel1sau
         LD   b,35
scrourm1 EQU  $-1
         JR   scrolur
scrour2
         LD   a,(reel2spd)
         LD   de,#c28f
         LD   hl,reel2sau
         LD   b,70
scrourm2 EQU  $-1
         JR   scrolur
scrour3
         LD   a,(reel3spd)
         LD   de,#c29c
         LD   hl,reel3sau
         LD   b,105
scrourm3 EQU  $-1
         JR   scrolur
scrour4
         LD   a,(reel4spd)
         LD   de,#e3e9
         LD   hl,reel4sau
         LD   b,71
scrourm4 EQU  $-1
         JR   scrolur
scrour5
         LD   a,(reel5spd)
         LD   de,#c586
         LD   hl,reel5sau
         LD   b,35
scrourm5 EQU  $-1
scrolur                                 ; Scroll Reel X
         OR   a
         JR   nz,scrolurx
         PUSH de
         POP  hl
         JR   scrolur1
scrolurx
         DEC  a
         PUSH de
         SLA  a
         LD   e,a
         LD   d,0
         ADD  hl,de
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         POP  hl
         EX   de,hl
         LD   a,h
         ADD  a,8
         JR   nc,scrolurj
         LD   a,l
         ADD  a,#50
         LD   l,a
         LD   a,h
         ADC  a,#c8
scrolurj
         LD   h,a
scrolur1
         PUSH bc
         PUSH de
         PUSH hl
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
         POP  hl
         LD   a,h
         ADD  a,8
         JR   nc,scrolur2
         LD   a,l
         ADD  a,#50
         LD   l,a
         LD   a,h
         ADC  a,#c8
scrolur2
         LD   h,a
         POP  de
         LD   a,d
         ADD  a,8
         JR   nc,scrolur3
         LD   a,e
         ADD  a,#50
         LD   e,a
         LD   a,d
         ADC  a,#c8
scrolur3
         LD   d,a
         POP  bc
         DJNZ scrolur1
         RET  
*f,hilocont.adm
