;
         ORG  #be80                     ; Transfer Fruit Machine II
         ENT  $
trans
         DI   
         LD   sp,#bff8
         LD   bc,#7fc0
         OUT  (c),c
         CALL disk
         CALL load
         LD   a,#c3
         LD   de,next
         LD   (#bc77),a
         LD   (#bc78),de
         CALL jphl
next
         DI   
         LD   sp,#bff8
         CALL #bd37
         CALL disk
         CALL load
         CALL nz,jphl
         CALL load
         PUSH hl
         LD   de,#abe7
         LD   hl,#c334
         LD   bc,#2d1d
scrop
         PUSH bc
         PUSH hl
scrop1
         LD   a,(hl)
         LD   (de),a
         INC  hl
         INC  de
         DJNZ scrop1
         POP  hl
         LD   a,8
         ADD  a,h
         JR   nc,scrop2
         LD   a,#50
         ADD  a,l
         LD   l,a
         LD   a,#c8
         ADC  a,h
scrop2
         LD   h,a
         POP  bc
         DEC  c
         JR   nz,scrop
         POP  hl
jphl     JP   (hl)
disk
         LD   hl,#b0ff
         LD   de,#40
         LD   c,7
         JP   #bcce
load
         LD   hl,name+9
         INC  (hl)
         LD   hl,name
         LD   b,len
         CALL #bc77
         EX   de,hl
         CALL #bc83
         PUSH hl
         CALL #bc7a
         POP  hl
         LD   a,l
         OR   h
         RET  
name     DEFM FRUITII .0
len      EQU  $-name
