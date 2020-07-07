;
         ORG  #8000                     ; Fruit Machine Simulator II
start    ENT  $                         ; Transfer Routine
         DI   
         LD   sp,#bff8
         LD   bc,#7fc0
         OUT  (c),c
         CALL #bd37
         LD   a,#ff
         CALL #bc6b
         LD   de,#100
         LD   b,0
         CALL #bc77
         EX   de,hl
         PUSH hl
         PUSH bc
         CALL #bc83
         PUSH hl
         CALL #bc7a
         LD   hl,next1
         LD   de,#be80
         LD   bc,#ff
         LDIR 
         LD   hl,#b0ff
         LD   de,#40
         LD   bc,7
         CALL #bcce
         POP  bc
         POP  de
         POP  hl
         PUSH bc
         CALL save
         LD   bc,3
pause
         CALL #bd19
         DJNZ pause
         DEC  c
         JR   nz,pause
         CALL #bd37
         LD   hl,#bd37
         PUSH hl
         LD   de,#bd3a
         LD   bc,3
         LDIR 
         LD   hl,next
         POP  de
         LD   c,3
         LDIR 
         LD   hl,#abff
         LD   de,#40
         RET  
next
         JP   trans
next1
         ORG  #be80                     ; Transfer Fruit Machine II
trans
         DI   
         POP  hl
         LD   sp,#bff8
         PUSH hl
tt
         LD   de,#abe7
         LD   hl,#c334
         LD   bc,#2d1d
scrop
         PUSH bc
         PUSH hl
scrop1
         LD   a,(de)
         LD   (hl),a
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
         OR   #C0
         LD   h,a
         POP  bc
         DEC  c
         JR   nz,scrop
         CALL #bd3a
         LD   hl,#b0ff
         LD   de,#40
         LD   c,7
         CALL #bcce
         LD   hl,#c000
         LD   de,#4000
         LD   bc,0
         CALL save
         LD   hl,#40
         LD   de,#abe7-#3f
         POP  bc
         CALL save
         RST  0
save
         PUSH bc
         PUSH de
         PUSH hl
         LD   hl,name+9
         INC  (hl)
         LD   hl,name
         LD   b,len
         CALL #bc8c
         POP  hl
         POP  de
         POP  bc
         LD   a,2
         CALL #bc98
         JP   #bc8f
name     DEFM FRUITII .0
len      EQU  $-name
