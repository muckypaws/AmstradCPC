;
;         - BREAKOUT - Amstrad Computer User August 1987
;
char     EQU  #bb09
joystick EQU  #bb24
output   EQU  #bb5a
enable   EQU  #bb66
cursor   EQU  #bb75
pen      EQU  #bb90
paper    EQU  #bb96
reset    EQU  #bc02
mode     EQU  #bc0e
ink      EQU  #bc32
border   EQU  #bc38
position EQU  #bc1a
flyback  EQU  #bd19
;
batsize  EQU  #0406                     ; 4 Rows high, 6 Bytes wide
ballsize EQU  #0402                     ; 4 Rows high, 2 Bytes wide
bricks   EQU  #0804                     ; 8 Rows high, 4 Bytes wide
;
         ORG  #9000
         ENT  $
;
init
         CALL reset                     ; Set default colours
         LD   bc,#1414
         CALL border                    ; Set border to cyan
         LD   hl,start
         LD   de,yball
         LD   bc,start-yball            ; Initialize all variables
         LDIR                           ; Copy starting values into variables
;
levell
         LD   hl,start
         LD   de,yball
         LD   bc,score-yball            ; Initialize "NEW LEVEL" variables
         LDIR 
;
         LD   a,1
         CALL mode                      ; Set screen to MODE 1
         LD   hl,#0107
         CALL cursor                    ; Move text cursor to Column 1 Row 7
         LD   de,#0301                  ; Ink 3/Ink 1
         LD   bc,#0a05                  ; Width counter 10/Row counter 5
;
brickl
         PUSH bc                        ; Save Counters
;
bl1
         LD   a,d
         CALL paper                     ; Set paper to ink D
         LD   a,32
         CALL output
         CALL output                    ; Print 2 spaces to represent a brick
         LD   a,e
         CALL paper                     ; Set paper to ink in E
         LD   a,32
         CALL output
         CALL output                    ; Print next brick in next colour
         DJNZ bl1                       ; Loop 10 times, printing 20 bricks
;
         LD   a,e
         LD   e,d
         LD   d,a                       ; Now swap over inks D and E
         POP  bc                        ; Get counters
         DEC  c                         ; Decrement row counter
         JR   nz,brickl                 ; Loop5time
;
         LD   hl,#0000
         LD   de,#2702
         CALL enable                    ; Set up score window
         LD   a,3
         CALL pen                       ; Set red letters
         LD   a,1
         CALL paper                     ; on a yellow background
         LD   hl,screen
         CALL print                     ; Print Score headings
         CALL prints                    ; Print the current score
         LD   hl,#1c02
         CALL cursor                    ; Move cursor to "LIVES" position
         LD   a,(lives)                 ; This is a number 0-9
         ADD  a,#30                     ; Convert it to ASCII
         CALL output                    ; Print it
;
gamel
         LD   hl,start
         LD   de,yball
         LD   bc,bitmap-yball
         LDIR                           ; Initialize "NEW GAME" variables
         LD   bc,batsize
         LD   de,(bataddr)
         LD   hl,batpic
         CALL drawb
         LD   bc,ballsize
         LD   de,(balladdr)
         LD   hl,ballpic1
         LD   (ballpic),hl
         CALL drawb
framel
         CALL flyback
         LD   bc,batsize
         LD   de,(bataddr)
         LD   hl,batpic
         CALL drawb
         LD   bc,ballsize
         LD   de,(balladdr)
         LD   hl,(ballpic)
         CALL drawb
         CALL joystick
         LD   de,(bataddr)
         AND  #0c
         JP   pe,nom
         AND  8
         JR   nz,mover
         LD   hl,#e730
         SBC  hl,de
         JR   z,nom
         DEC  de
         JR   nom
mover
         LD   hl,#e77a
         SBC  hl,de
         JR   z,nom
         INC  de
nom
         LD   (bataddr),de
         LD   de,(xball)
         LD   a,(xvel)
         LD   l,a
         RLA  
         SBC  a,a
         LD   h,a
         ADD  hl,de
         EX   de,hl
         LD   hl,317
         OR   a
         SBC  hl,de
         JR   c,bouncex
         LD   a,(yball)
         CALL hitbit
         JR   z,nobx
         XOR  (hl)
         LD   (hl),a
         SRL  d
         RR   e
         SRL  e
         SRL  e
         RES  0,e
         LD   h,e
         LD   a,(yball)
         SRL  a
         SRL  a
         SRL  a
         ADD  a,3
         LD   l,a
         CALL position
         LD   bc,bricks
         CALL clearb
         LD   a,#20
         LD   (points),a
bouncex
         LD   a,(xvel)
         NEG  
         LD   (xvel),a
         LD   de,(xball)
nobx
         LD   (xball),de
         LD   a,(yvel)
         LD   hl,yball
         ADD  a,(hl)
         CP   172
         JP   z,death
         JR   nc,bouncey
         PUSH af
         CALL hitbit
         JR   z,hitbat
         XOR  (hl)
         LD   (hl),a
         SRL  d
         RR   e
         SRL  e
         SRL  e
         RES  0,e
         LD   h,e
         RES  0,e
         LD   h,e
         RES  0,e
         LD   h,e
         POP  af
         SRL  a
         SRL  a
         SRL  a
         ADD  a,3
         LD   l,a
         CALL position
         LD   bc,bricks
         CALL clearb
         LD   a,(points)
         ADD  a,#20
         LD   (points),a
         JR   bouncey
hitbat
         POP  af
         PUSH af
         CALL scradd
         LD   d,h
         LD   e,l
         LD   bc,(bataddr)
         OR   a
         SBC  hl,bc
         JR   c,noby
         LD   hl,5
         ADD  hl,bc
         SBC  hl,de
         JR   c,noby
         POP  af
bouncey
         LD   a,(yvel)
         NEG  
         LD   (yvel),a
         LD   a,(yball)
         PUSH af
noby
         POP  af
         LD   (yball),a
         CALL scradd
         LD   (balladdr),hl
         EX   de,hl
         LD   bc,ballsize
         LD   hl,ballpic1
         LD   a,(xball)
         AND  2
         JR   z,ds1
         LD   hl,ballpic2
ds1
         LD   (ballpic),hl
         CALL drawb
         LD   hl,batpic
         LD   de,(bataddr)
         LD   bc,batsize
         CALL drawb
         CALL char
         JR   nc,noquit
         CP   #fc
         JR   nz,noquit
         XOR  a
         CALL paper
         LD   a,1
         CALL pen
         LD   a,2
         JP   mode
noquit
         LD   a,(points)
         OR   a
         JP   z,framel
         LD   hl,score+2
         ADD  a,(hl)
         DAA  
         LD   (hl),a
         LD   a,0
         DEC  hl
         ADC  a,(hl)
         DAA  
         LD   (hl),a
         LD   a,0
         DEC  hl
         ADC  a,(hl)
         DAA  
         LD   (hl),a
         CALL prints
         XOR  a
         LD   (points),a
         LD   a,(brickc)
         DEC  a
         LD   (brickc),a
         JP   nz,framel
         JP   levell
death
         LD   b,10
d1
         PUSH bc
         CALL flyback
         LD   bc,#0606
         CALL border
         CALL flyback
         LD   bc,#1414
         CALL border
         POP  bc
         DJNZ d1
         LD   hl,#1c02
         CALL cursor
         LD   a,(lives)
         DEC  a
         LD   (lives),a
         JP   z,init
         ADD  a,#30
         CALL output
         JP   gamel
prints
         LD   hl,#0902
         CALL cursor
         LD   hl,score
         LD   b,3
         ADD  a,#30
ps1
         RLD  
         CALL output
         RLD  
         CALL output
         RLD  
         INC  hl
         DJNZ ps1
         RET  
hitbit
         LD   hl,bitmap-3
         LD   bc,3
         SRL  a
         SRL  a
         SRL  a
         INC  a
hb1
         ADD  hl,bc
         DEC  a
         JR   nz,hb1
         LD   b,d
         LD   c,e
         LD   a,e
         SLA  c
         RL   b
         LD   c,b
         LD   b,0
         LD   bc,p2
         SRL  a
         SRL  a
         SRL  a
         SRL  a
         AND  7
         ADD  a,c
         LD   c,a
         JR   nc,hb2
         INC  b
hb2
         LD   a,(bc)
         AND  (hl)
         RET  
p2
         DEFB #80,#40,#20,#10,8,4,2,1
scradd
         LD   e,a
         AND  7
         INC  a
         LD   hl,#c0f0
         LD   bc,2048
scradd1
         DEC  a
         JR   z,scradd2
         ADD  hl,bc
         JR   scradd1
scradd2
         LD   a,e
         SRL  a
         SRL  a
         SRL  a
         LD   bc,80
         INC  a
scradd3
         DEC  a
         JR   z,scradd4
         ADD  hl,bc
         JR   scradd3
scradd4
         LD   bc,(xball)
         SRL  b
         RR   c
         SRL  c
         ADD  hl,bc
         RET  
clearb
         PUSH bc
         PUSH hl
cb1
         LD   (hl),0
         INC  hl
         DEC  c
         JR   nz,cb1
         POP  hl
         LD   bc,2048
         ADD  hl,bc
         JR   nc,cb2
         LD   bc,#c050
         ADD  hl,bc
cb2
         POP  bc
         DJNZ clearb
         RET  
drawb
         PUSH bc
         PUSH de
db0
         LD   a,(de)
         XOR  (hl)
         LD   (de),a
         INC  hl
         INC  de
         DEC  c
         JR   nz,db0
         POP  de
         EX   de,hl
         LD   bc,2048
         ADD  hl,bc
         JR   nc,db1
         LD   bc,#c050
         ADD  hl,bc
db1
         EX   de,hl
         POP  bc
         DJNZ drawb
         RET  
print
         LD   a,(hl)
         INC  hl
         OR   a
         RET  z
         CALL output
         JR   print
;
;
;
yball    DEFB 0
xball    DEFW 0
yvel     DEFB 0
xvel     DEFB 0
ballpic  DEFW 0
balladdr DEFW 0
bataddr  DEFW 0
points   DEFB 0
bitmap   DEFS 66
brickc   DEFB 0
score    DEFS 3
lives    DEFW 0
;
;
;
start
         DEFB 160
         DEFW 160
         DEFB -2
         DEFB 2
         DEFW ballpic1
         DEFW #c758
         DEFW #e755
         DEFB 0
         DEFS 9
         DEFB #ff,#ff,#ff
         DEFB #ff,#ff,#ff
         DEFB #ff,#ff,#ff
         DEFB #ff,#ff,#ff
         DEFB #ff,#ff,#ff
         DEFS 42
         DEFB 100
         DEFS 3,0
         DEFB 9
batpic
         DEFB #ff,#ff,#ff,#ff
         DEFB #ff,#ff,#ff,#ff
         DEFB #ff,#ff,#ff,#ff
         DEFB #ff,#ff,#ff,#ff
         DEFB #ff,#ff,#ff,#ff
         DEFB #ff,#ff,#ff,#ff
ballpic1
         DEFB #60,00,#f0,0,#f0,0,#60,0
ballpic2
         DEFB #10,#80,3,#c0,3,#c0,#10
         DEFB #80
screen
         DEFB 12,31,2,2
         DEFM Score:            Li
         DEFM ves: 
         DEFB 0
