;
         ORG  #9a00                     ; Keyboard Decoder
start    ENT  $
         LD   a,70
         CALL scankey
         JR   nz,start
         RET  
;
scankey
         LD   b,a
         AND  7
         LD   c,a
         LD   a,1
         SRL  c
         JR   nc,scan1
         ADD  a,a
scan1
         SRL  c
         JR   nc,scan2
         ADD  a,a
         ADD  a,a
scan2
         SRL  c
         JR   nc,scan3
         ADD  a,a
         ADD  a,a
         ADD  a,a
         ADD  a,a
scan3
         LD   (bitmask+1),a
         LD   a,b
         SRL  a
         SRL  a
         SRL  a
         OR   #40
         LD   (rowsel+1),a
         LD   bc,#f792
         OUT  (c),c
         DEC  b
rowsel   LD   c,0
         OUT  (c),c
         LD   b,#f4
         IN   a,(c)
         LD   bc,#f782
         OUT  (c),c
         LD   (ret),a
bitmask  AND  0
         RET  
;
ret      DEFB 0
