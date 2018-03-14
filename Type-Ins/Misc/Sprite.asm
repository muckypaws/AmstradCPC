         ORG  #a000                     ; Routine to display sprite
         ENT  $
         LD   hl,#c000
         LD   de,sprited
display
         EX   de,hl
         LD   b,(hl)                    ; First byte = length across
         INC  hl
         LD   c,(hl)                    ; Second byte = length down
         INC  hl                        ; Third byte etc. = Data
         EX   de,hl
display1
         PUSH bc
         PUSH hl
display2
         LD   a,(de)
         XOR  (hl)
         LD   (hl),a
         INC  hl
         INC  de
         DJNZ display2
         POP  hl
         LD   bc,#800
         ADD  hl,bc
         JR   nc,display3
         LD   bc,#c050
         ADD  hl,bc
display3
         POP  bc
         DEC  c
         JR   nz,display1
         RET  
sprited
         DEFB 2,3
         DEFB #ff,#ff
         DEFB #a0,#a0
         DEFB #40,#40
