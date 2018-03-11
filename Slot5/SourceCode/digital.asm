;
Digital                                 ; Digital Display Routine
         LD   hl,DigitalN
DigitalJ
         LD   b,4
dig
         LD   a,(hl)
Digit1
         PUSH hl
         PUSH bc
         ADD  a,a
         LD   e,a
         LD   h,0
         LD   l,h
         LD   d,h
         LD   ix,sprload
         ADD  ix,de
         LD   l,(ix+0)
         LD   h,(ix+1)
         LD   de,sprload
         ADD  hl,de                     ; HL=Address Of Digital No. Data.
         PUSH hl
         LD   a,b
         DEC  a
         ADD  a,a
         LD   l,a
         LD   h,0
         LD   de,dig1
         ADD  hl,de
         LD   e,(hl)
         INC  hl
         LD   d,(hl)                    ; DE=Screen Address
         POP  hl
         LD   a,28
         EX   de,hl
         LD   c,0
         LD   b,6
         CALL decomp
         POP  bc
         POP  hl
         INC  hl
         DJNZ dig
         RET  
*f,rbuffers.adm
