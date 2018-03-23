
;
         ORG  #9000                     ; Compile Sound Samples
start                                   ; Written By Jason Brooks
         ENT  $
         DI   
         LD   sp,#bff8
         LD   bc,#7fc0
         OUT  (c),c
         LD   hl,#abff
         LD   de,#40
         LD   bc,7
         CALL #bcce
         LD   ix,names
compile
         LD   a,(ix+0)
         CP   #ff
         JR   z,finished
         PUSH ix
         PUSH ix
         POP  hl
         LD   de,#c000
         LD   b,12
         CALL #bc77
         LD   hl,#4100
nextadd  EQU  $-2
         LD   (len),bc
         CALL #bc83
         CALL #bc7a
         LD   hl,(nextadd)
         PUSH hl
         LD   bc,0
len      EQU  $-2
         ADD  hl,bc
         LD   (nextadd),hl
         POP  hl
         LD   a,h
         SUB  #41
         LD   h,a
         EX   de,hl
         LD   hl,table
tb       EQU  $-2
         LD   (hl),e
         INC  hl
         LD   (hl),d
         INC  hl
         LD   (hl),c
         INC  hl
         LD   (hl),b
         INC  hl
         LD   (tb),hl
         POP  ix
         LD   de,12
         ADD  ix,de
         JR   compile
finished
         LD   hl,(nextadd)
         LD   de,#4100
         AND  a
         SBC  hl,de
         PUSH hl
         LD   hl,save
         LD   b,leng
         LD   de,#c000
         CALL #bc8c
         POP  de
         LD   hl,#4000
         LD   bc,0
         LD   a,2
         CALL #bc98
         CALL #bc8f
         RET  
save     DEFM SAMPLES.SMP
leng     EQU  $-save
;
names    DEFM FANT    .SMP
         DEFM RIGHT   .SMP
         DEFM BRIL    .SMP
         DEFM GENIUS  .SMP
         DEFM VERYGOOD.SMP
         DEFM GOTIT   .SMP
         DEFM PERFECT .SMP
         DEFM CORRECT .SMP
         DEFM EXCEL   .SMP
         DEFM TRY     .SMP
         DEFM MONEY   .SMP
         DEFB #ff
table    EQU  #4000
