;
boing1
         LD   hl,boingt1
         JR   msound
boing
         LD   hl,boingt
         JR   msound
sosc
         LD   c,a
         JR   gtable
rnoise                                  ; For Repeaters
         PUSH af
         LD   a,40
         JR   z,rnoise1
         RRCA 
rnoise1
         LD   (ntone1),a
         LD   hl,noiset
         CALL msound
         POP  af
         RET  
bf
         LD   c,0
bft      EQU  $-1
         CALL bf1
         INC  c
bf1
gtable                                  ; Cash Table (GAMBLE MONEY GRID) Sound
         PUSH af
         PUSH bc
         PUSH hl
         LD   a,c
         INC  a
         INC  a
         ADD  a,a
         ADD  a,a                       ; Entry A = Grid Part
         ADD  a,a
         ADD  a,a
         LD   (gstable1),a
         LD   hl,gstable
         CALL msound
         POP  hl
         POP  bc
         POP  af
         RET  
sdisable                                ; Sound Disable
         LD   hl,disablet
         JR   msound
ping
         LD   hl,pingt
msound
         LD   a,(hl)
         CP   #ff
         JR   z,msounde
         INC  hl
         LD   c,(hl)
         INC  hl
         CALL sound
         JR   msound
msounde                                 ; If Not Exited Writing To reg. 14 The 
         LD   a,14                      ; Keyboard Hangs
         LD   c,0
sound                                   ; Control AY-3-8192 CHIP
         DI   
         LD   b,#f4
         OUT  (c),a
         INC  b
         INC  b
         IN   a,(c)
         OR   #c0
         OUT  (c),a
         AND  #3f
         OUT  (c),a
         DEC  b
         DEC  b
         OUT  (c),c
         INC  b
         INC  b
         LD   c,a
         OR   #80
         OUT  (c),a
         OUT  (c),c
         RET  
;
pingt                                   ; Ping Table
         DEFB 8,16                      ; Envelope Enable Voluem
         DEFB 1,0
         DEFB 0,37                      ; Set Up CHANNEL A
         DEFB 11,255
         DEFB 12,18                     ; Set Envelope Duration
         DEFB 13,1                      ; Select Envelope 1
         DEFB 7,62                      ; Enable Tone
         DEFB #ff
disablet                                ; Disable Sound Table
         DEFB 8,0                       ; Volume 0
         DEFB 0,0
         DEFB 1,0                       ; CHANNEL A SOUND 0
         DEFB 2,0
         DEFB 3,0                       ; CHANNEL B SOUND 0
         DEFB 4,0
         DEFB 5,0                       ; CHANNEL C SOUND 0
         DEFB 7,63                      ; Disable All Channels
         DEFB #ff                       ; End
gstable                                 ; Gamble Sound Table
         DEFB 8,16
         DEFB 1,0
         DEFB 0,20
gstable1 EQU  $-1
         DEFB 11,50
         DEFB 12,6
         DEFB 13,2
         DEFB 7,60
         DEFB #ff
noiset                                  ; NOISE TABLE
         DEFB 8,16
         DEFB 1,0
         DEFB 0,100
ntone    EQU  $-1
         DEFB 6,12
ntone1   EQU  $-1
         DEFB 11,180
         DEFB 12,0
         DEFB 13,9
         DEFB 7,%110110
         DEFB #ff
boingt                                  ; Boing Table
         DEFB 8,16
         DEFB 9,16
         DEFB 10,16
         DEFB 11,200
         DEFB 12,2
         DEFB 13,9
         DEFB 1,3
         DEFB 3,3
         DEFB 5,3
         DEFB 7,%111000
         DEFB #ff
boingt1                                 ; Boing Table
         DEFB 8,16
         DEFB 9,16
         DEFB 10,16
         DEFB 11,200
         DEFB 12,1
         DEFB 13,9
         DEFB 0,50
         DEFB 1,2
         DEFB 2,50
         DEFB 3,2
         DEFB 4,50
         DEFB 5,2
         DEFB 7,%111010
         DEFB #ff
;end
*f,varibles.adm
