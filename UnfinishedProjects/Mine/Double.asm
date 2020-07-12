;
         ORG  #9000
start    ENT  $                         ; Double Click, By Jason Brooks
         CALL #bd19
         LD   a,6
         CALL #bb1e
         RET  nz
         CALL double
         LD   a,(click2)
         OR   a
         JR   z,start
         LD   a,"D"
         CALL #bb5a
         XOR  a
         LD   (click2),a
         JR   start
double
         XOR  a
         LD   (click2),a
         LD   a,0
part1    EQU  $-1
         OR   a
         JR   nz,doublec
         LD   a,47                      ; Check If Click Button Pressed
         CALL #bb1e
         JR   z,doublea                 ; If Not Button Released ?
;
         LD   hl,part1c                 ; Point To Counter
doubleb
         INC  (hl)
         LD   a,(hl)
         CP   20
         RET  c                         ; Check That Held For Small Period
doublef
         XOR  a
         LD   (hl),a
         LD   (part1c),a                ; Reset Counters
         LD   (part1),a
         RET  
doublea
         LD   a,(part1c)
         LD   (part1),a                 ; Set Part 1 Flag
         RET  
doublec                                 ; Next Of Click
         LD   a,47
         CALL #bb1e
         LD   hl,part2c
         JR   z,doubleb
         LD   a,(part2c)
         OR   a
         RET  z
         LD   (click2),a
         LD   (part2c),a
         JR   doublef
;
part1c   DEFB 0
part2c   DEFB 0
click2   DEFB 0
;
