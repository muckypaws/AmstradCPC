         ORG  #a000                     ; Character Expansion Routine.
expand   ENT  $
         LD   de,256
         CALL #bbab
         LD   hl,#8000
         LD   de,32
         CALL #bbab                     ; Set Up Chars
         LD   a,"A"                     ; Load With Char To Expand !
         SUB  32
         LD   l,a
         LD   h,0
         LD   de,#8000
         ADD  hl,hl
         ADD  hl,hl
         ADD  hl,hl
         ADD  hl,de                     ; Point HL to Char Data
         EX   de,hl
         LD   hl,#c000
         LD   (screen),hl
         LD   (oscreen),hl
         LD   b,7                       ; Loop Counter
loop
         LD   a,(de)
         LD   c,8
loop1
         RRCA 
         CALL block
         DEC  c
         JR   nz,loop1
         INC  de
         DJNZ loop
         RET  
block
         PUSH af
         PUSH bc
         PUSH de
         PUSH hl
         LD   a,0
         JR   nc,block5
         LD   a,255
block5
         LD   (pen),a
         LD   hl,(screen)
         LD   b,8
block2
         LD   a,(pen)
         LD   (hl),a
         INC  hl
         LD   (hl),a
         DEC  hl
         LD   a,h
         ADD  a,8
         LD   h,a
         JR   nc,block1
         LD   de,#c050
         ADD  hl,de
block1
         DJNZ block2
         LD   hl,(screen)
         INC  hl
         INC  hl
         LD   (screen),hl
         LD   hl,xlen
         DEC  (hl)
         JR   nz,block3
         LD   (hl),8
         LD   hl,(oscreen)
         LD   de,#50
         ADD  hl,de
         LD   (screen),hl
         LD   (oscreen),hl
block3
         POP  hl
         POP  de
         POP  bc
         POP  af
         RET  
pen      DEFB 0
screen   DEFW #c000
oscreen  DEFW #c000
xlen     DEFB 8
