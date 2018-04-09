;
         ORG  #a000
start
         ENT  $
scroll
         XOR  a
         LD   (horiz),a
         LD   (uper),a
         LD   (offset),a
         LD   hl,#c780
         LD   (hardscrn),hl
         LD   a,180
         LD   (vert),a
         CALL blitter
;
up                                      ; BLITTER that screen & Re-calc Co-ords
         LD   hl,(hardscrn)
         LD   de,#50
         ADD  hl,de
         LD   a,h
         AND  7
         OR   #c0
         LD   h,a
         LD   (hardscrn),hl
         LD   hl,uper
         INC  (hl)
         LD   a,(hl)
         CP   26
         JR   z,up1
         LD   a,(horiz)
         ADD  a,40
         LD   (horiz),a
         RET  nc
         LD   hl,vert
         INC  (hl)
         RET  
up1
         LD   (hl),1
         LD   a,(horiz)
         SUB  216
         LD   (horiz),a
         LD   a,(vert)
         SBC  a,3
         OR   #b0
         LD   (vert),a
         RET  
;
down
         LD   hl,(hardscrn)
         LD   de,#50
         AND  a
         SBC  hl,de
         LD   a,h
         AND  7
         OR   #c0
         LD   h,a
         LD   (hardscrn),hl
         LD   hl,uper
         DEC  (hl)
         LD   a,(hl)
         CP   #ff
         JR   z,down1
         LD   a,(horiz)
         SUB  40
         LD   (horiz),a
         RET  nc
         LD   hl,vert
         LD   a,(hl)
         DEC  a
         OR   #b0
         LD   (hl),a
         RET  
down1
         LD   (hl),25
         LD   a,(horiz)
         ADD  a,216
         LD   (horiz),a
         LD   a,(vert)
         ADC  a,3
         LD   (vert),a
         RET  
bc1d
         EX   de,hl
         ADD  hl,hl
         PUSH hl
         LD   hl,0
         ADD  hl,de
         ADD  hl,hl
         ADD  hl,hl
         ADD  hl,de
         ADD  hl,hl
         ADD  hl,hl
         ADD  hl,hl
         ADD  hl,hl
         EX   de,hl
         LD   hl,(hardscrn)
         AND  a
         SBC  hl,de
         POP  de
         ADD  hl,de
         LD   a,(offset)
         SLA  a
         LD   e,a
         LD   d,0
         ADD  hl,de
         LD   a,h
         AND  7
         OR   #c0
         LD   h,a
         RET  
blitter
         PUSH af
         PUSH bc
         CALL bd19
         LD   bc,#bc0c
         LD   a,(vert)
         AND  #b7
         OR   #b0
         OUT  (c),c
         INC  b
         OUT  (c),a
         DEC  b
         INC  c
         LD   a,(horiz)
         OUT  (c),c
         INC  b
         OUT  (c),a
         POP  bc
         POP  af
         RET  
bd19
         LD   b,#f5
bd19a
         IN   a,(c)
         RRA  
         RET  c
         JR   bd19a
hardscrn DEFW #c780
offset   DEFB 0
uper     DEFB 0
vert     DEFB 180
horiz    DEFB 0
