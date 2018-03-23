;
         ORG  #4000                     ; Speech Processor For Money Matters
speech   EQU  #4100
start    ENT  $
         DI   
         PUSH ix
         LD   a,(ix+0)
         ADD  a,a
         ADD  a,a
         LD   l,a
         LD   h,speech/256
         PUSH hl
         POP  ix
         LD   l,(ix+0)
         LD   h,(ix+1)
         LD   e,(ix+2)
         LD   d,(ix+3)
         LD   bc,speech+#100
         ADD  hl,bc
         CALL replay
         POP  ix
         RET  
replay
         PUSH hl
         PUSH de
         CALL #bca7
         DI   
         LD   a,2
         LD   c,0
         CALL bd34
         LD   a,3
         LD   c,0
         CALL bd34
         LD   c,%111101
         LD   a,7
         CALL bd34
         POP  de
         POP  hl
replay1
         LD   b,8
replay2
         PUSH bc
         RLC  (hl)
         CALL nc,sound1
         CALL c,sound0
         POP  bc
         DJNZ replay2
         INC  hl
         DEC  de
         LD   a,d
         OR   e
         JR   nz,replay1
         CALL #bca7
         DI   
         RET  
sound1
         PUSH af
         LD   c,15
         LD   a,9
         CALL bd34
         POP  af
         RET  
sound0
         PUSH af
         LD   c,0
         LD   a,9
         CALL bd34
         POP  af
         RET  
bd34
         PUSH af
         LD   A,#C0
         LD   B,#F6
         OUT  (C),A
         LD   B,#F4
         POP  AF
         OUT  (C),A
         LD   B,#F6
         LD   A,#80
         OUT  (C),A
         LD   B,#F4
         OUT  (C),C
         RET  
;
         DEFM Sound SAMPLE/DIGITIZER 
         DEFM Written By JASON BROOKS 
         DEFM (C) 1987 JacesofT Softwar
         DEFM e.  All Rights Reserved
