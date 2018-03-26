         ORG  #a000                     ; Vertical message Scroll routine !
vertscrl ENT  $
here
         LD   hl,message
         LD   (msg),hl
         LD   hl,#c004
         LD   b,#c8
         CALL verts
         RET  
verts    CALL #bd19
verts1
         PUSH hl
         POP  de
         LD   a,h
         ADD  a,8
         LD   h,a
         JR   nc,verts2
         PUSH de
         LD   de,#c050
         ADD  hl,de
         POP  de
verts2
         LD   a,(hl)
         LD   (de),a
         INC  hl
         INC  de
         LD   a,(hl)
         LD   (de),a
         DEC  hl
         DJNZ verts1
         LD   (store+1),hl
         LD   hl,(msg)
         LD   a,(hl)
         SUB  #20
         RET  c
         LD   l,a
         LD   h,0
         LD   de,chars
         ADD  hl,hl
         ADD  hl,hl
         ADD  hl,hl
         ADD  hl,de
         LD   a,(point)
         LD   e,a
         LD   d,0
         ADD  hl,de
store    LD   de,0
         LD   a,(hl)
         AND  %11110000
         LD   (de),a
         LD   a,(hl)
         AND  15
         LD   (de),a
         LD   a,(point)
         INC  a
         CP   9
         JR   nz,here
         XOR  a
         LD   (point),a
         JR   here
message  DEFM This is a test.
         DEFB 0
msg      DEFW 0
point    DEFB 0
chars    EQU  $
