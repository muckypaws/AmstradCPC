;
         ORG  #3000                     ; Pinball Simulator - Written By
start                                   ; JASON BROOKS : Project Started 31/1/9
         ENT  $                         ; (C) 1991 JacesofT Software.
scankey  EQU  #bb1e
maxi     EQU  12
me       EQU  5
         DI   
         IM   1
         LD   sp,#bff8
         CALL load                      ; Load Sprites
         CALL setinks                   ; Set Mode , Border Etc.
         DI   
         CALL calcoffs
         CALL putball
         CALL putbat
         LD   a,9
         LD   (movex),a
;
loop
         CALL framefly                  ; Await
         CALL putball                   ; Erase Current Ball
         CALL putbat
;
         CALL updatey                   ; Update Ball In Y Direction - Accell.
         CALL updatex                   ; Update Ba
         CALL upbat                     ; Update Bat
         CALL putbat
;CALL end                       ; Has B
         CALL putball                   ; Draw 
         LD   a,0
         CALL #bb1e
         CALL nz,incc
         LD   a,2
         CALL #bb1e
         CALL nz,decc
         LD   a,47
         CALL scankey                   ; Scan SPACE Bar For Quitting.
         JR   z,loop                    ; If Not Pressed Loop
         JR   adam                      ; Otherwise QUIT !
incc
         LD   hl,movex
         INC  (hl)
         RET  
decc
         LD   hl,movex
         DEC  (hl)
         BIT  7,(hl)
         RET  z
         LD   (hl),0
         RET  
upbat
         LD   a,71
         CALL #bb1e
         CALL nz,batleft
         LD   a,63
         CALL #bb1e
         RET  z
         LD   a,(batx)
         CP   70
         RET  z
         INC  a
         LD   (batx),a
         RET  
batleft
         LD   a,(batx)
         OR   a
         RET  z
         DEC  a
         LD   (batx),a
         RET  
end                                     ; Check To See if ball reached edge of 
         LD   a,(ballx)
         OR   a
         JR   z,end1
         CP   79
         RET  nz
end1
         LD   a,(ballvely)
         XOR  1
         LD   (ballvely),a
         RET  
;
moveball
         RET  nz                        ; Test Loop For Moving Ball Around Scre
         LD   a,63
         CALL scankey
         CALL nz,bright
         LD   a,71
         CALL scankey
         CALL nz,bleft
         LD   a,19
         CALL scankey
         CALL nz,bup
         LD   a,22
         CALL scankey
         CALL nz,bdown
         LD   a,47
         CALL scankey
         JR   nz,adam
         CALL framefly
         CALL putball
         JP   loop                      ; This Section Remed Out.
adam                                    ; Exit Back Into ADAM - Assembler.
         CALL #bb09
         JR   c,adam
         JP   #4000
;
updateb  LD   a,(ballvely)              ; Move Ball Up/Down Accordingly
         AND  #80
         JP   z,bdown
         JP   bup
updatex
         LD   hl,countdh
         LD   a,(hl)
         DEC  (hl)
         OR   a
         RET  nz
         LD   (hl),0
updatexx                                ; Move X In Appropriate Direction
         LD   hl,ballx                  ; Point HL To BallX Variable
         LD   a,(movex)                 ; Let A=Amount To Move
         OR   a
         RET  z
         LD   b,a                       ; LET B=A
         PUSH bc
udx1
         PUSH bc
         CALL bright
         POP  bc
         DJNZ udx1
         POP  bc
         LD   a,(ballvely)              ; Get Velocity Of Ball
         RRA                            ; Shift Into Carry
         JR   nc,udatex1                ; If No Carry Ball Is RIGHT !
         LD   a,b
         ADD  a,a
         LD   b,a
         PUSH bc
udx1a
         PUSH bc
         CALL bleft
         POP  bc
         DJNZ udx1a
         POP  bc
         LD   a,(ballx)
jj
         RLA  
         JR   c,udx1b                   ; If BALL <0 then BALL=0
         OR   a
         RET  nz
udx1b
         LD   a,(ballvely)              ; Get Ball Velocity Again
         XOR  1                         ; Reverse X Velocities
         LD   (ballvely),a              ; Store Ball Velocity
         XOR  a                         ; RESET A Since BALLX = 0
         LD   (ballx),a
         LD   (ballt),a
udatex1
         LD   hl,ballx
         LD   a,(hl)
         CP   78                        ; Has Ball Reached Edge Of Screen ?
         RET  c                         ; IF Not Quit
         JR   nz,udatex2
         LD   a,(ballt)
         CP   3
         RET  nz
udatex2
         LD   a,78                      ; Otherwise Ball=Edge
         LD   (hl),a
         LD   a,3
         LD   (ballt),a
         LD   a,(ballvely)              ; Get Ball Velocity Again
         XOR  1                         ; Reverse X Velocities
         LD   (ballvely),a              ; Store Ball Velocity
         RET                            ; Quit  
;
updatey                                 ; update ball on Y-Axis
         LD   hl,countdy
         DEC  (hl)                      ; Decrement Ball Y Counter (DIR)
         JR   nz,updateb                ; If Not End Of Update BALL Y POS
         LD   a,(ballvely)              ; Get Balls Velocity (DIR)
         BIT  7,a                       ; Is it going UP or DOWN ?
         LD   hl,speed                  ; Point HL To Velocity Of BALL
         LD   a,(hl)                    ; And GET VELOCITY in A
         JR   z,updyneg                 ; Jump If Negative Ball Velocity
         INC  (hl)                      ; Otherwise Increment Velocity
         CP   maxi                      ; Has Ball Reached Maximum ?
         JR   nz,updy1                  ; If Not Jump
updyn1                                  ; Otherwise Invert Balls Direction !
         LD   a,(ballvely)
         XOR  128
         LD   (ballvely),a              ; Invert Ball Y's Direction !
updy1
         LD   a,(hl)                    ; Get Velocity
         OR   a                         ; Is It Zero ?
         LD   a,2                       ; Load With Two
         JR   nz,updy2                  ; If A <> 0 then JUMP
         DEC  a                         ; Otherwise A = 1
updy2
         LD   (countdy),a               ; Set Count Down Y
         JR   bup                       ; Move Ball Up
updyneg
         OR   a
         JR   z,updyn1
         DEC  (hl)
         LD   a,(hl)
         OR   a
         LD   a,2
         JR   nz,updyn2
         DEC  a
updyn2
         LD   (countdy),a
         JR   bdown
bleft
         LD   hl,ballx
         LD   a,(hl)
         OR   a
         RET  z
         LD   hl,ballt
         LD   a,(hl)
         DEC  a
         AND  3
         LD   (hl),a
         CP   3
         RET  nz
         LD   hl,ballx
         DEC  (hl)
         RET  
bright
         LD   hl,ballx
         LD   a,(hl)
         CP   79
         RET  z
         LD   hl,ballt
         LD   a,(hl)
         INC  a
         AND  3
         LD   (hl),a
         RET  nz
         LD   hl,ballx
         INC  (hl)
         RET  
bup
         LD   hl,bally
         LD   a,(speed)
         LD   b,a
         LD   a,(hl)
         CP   10
         RET  c
         SUB  b
         RET  c
         LD   (hl),a
         RET  
bdown
         LD   hl,bally
         LD   a,(hl)
         LD   b,2
speed    EQU  $-1
         ADD  a,b
         CP   5
         RET  c
         CP   195
         RET  nc
         LD   (hl),a
         RET  
;
calcaddr                                ; Calculate Screen Address From X, Y
         LD   h,0                       ; Entry : L = Y
         LD   d,h                       ; E = X
         ADD  hl,hl
         LD   bc,scrtable
         ADD  hl,bc                     ; BC Corrupt
         LD   c,(hl)
         INC  hl
         LD   b,(hl)
         PUSH bc
         POP  hl
         ADD  hl,de                     ; DE corrupt
         RET                            ; Exit HL = Screen Address
putball
         LD   a,(ballt)
         ADD  a,a
         LD   hl,sprload
         LD   e,a
         LD   d,0
         ADD  hl,de
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   hl,sprload
         ADD  hl,de                     ; Get Address Of Ball Sprite
         PUSH hl
         LD   l,180
bally    EQU  $-1
         LD   e,0
ballx    EQU  $-1
         CALL calcaddr
         POP  de
         LD   b,5
putball1
         LD   c,(hl)
         LD   a,(de)
         XOR  c
         LD   (hl),a
         INC  hl
         INC  de
         LD   c,(hl)
         LD   a,(de)
         XOR  c
         LD   (hl),a
         INC  de
         DEC  hl
         LD   a,h
         ADD  a,8
         JR   nc,putball2
         LD   a,#50
         ADD  a,l
         LD   l,a
         LD   a,h
         ADC  a,#c8
putball2
         OR   #c0
         LD   h,a
         DJNZ putball1
         RET  
putbat
         LD   a,(batt)
         ADD  a,4
         ADD  a,a
         LD   hl,sprload
         LD   e,a
         LD   d,0
         ADD  hl,de
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   hl,sprload
         ADD  hl,de                     ; Get Address Of Ball Sprite
         PUSH hl
         LD   l,30
baty     EQU  $-1
         LD   e,0
batx     EQU  $-1
         CALL calcaddr
         POP  de
         LD   b,4
putbat1
         LD   c,(hl)
         LD   a,(de)
         XOR  c
         LD   (hl),a
         INC  hl
         INC  de
         LD   c,(hl)
         LD   a,(de)
         XOR  c
         LD   (hl),a
;
         INC  hl
         INC  de
         LD   c,(hl)
         LD   a,(de)
         XOR  c
         LD   (hl),a
;
         INC  hl
         INC  de
         LD   c,(hl)
         LD   a,(de)
         XOR  c
         LD   (hl),a
         INC  hl
         INC  de
         LD   c,(hl)
         LD   a,(de)
         XOR  c
         LD   (hl),a
         INC  de
         DEC  hl
         DEC  hl
         DEC  hl
         DEC  hl
         LD   a,h
         ADD  a,8
         JR   nc,putbat2
         LD   a,#50
         ADD  a,l
         LD   l,a
         LD   a,h
         ADC  a,#c8
putbat2
         OR   #c0
         LD   h,a
         DJNZ putbat1
         RET  
calcoffs                                ; Calculate Screen Offset Addressess
         LD   ix,scrtable+398
         LD   b,200
         LD   hl,#c000
calca1
         LD   (ix+0),l
         LD   (ix+1),h
         DEC  ix
         DEC  ix
         LD   a,h
         ADD  a,8
         JR   nc,calca2
         LD   a,#50
         ADD  a,l
         LD   l,a
         LD   a,h
         ADC  a,#c8
calca2
         OR   #c0
         LD   h,a
         DEC  b
         JR   nz,calca1
         RET  
load                                    ; Load In Graphics Data
         LD   hl,lfa
         LD   a,(hl)
         OR   a
         RET  nz
         LD   (hl),1
         LD   hl,name
         LD   b,len
         LD   de,#c000
         CALL #bc77
         LD   hl,sprload
         CALL #bc83
         JP   #bc7a
framefly                                ; Wait For Frame Fly Back
         LD   b,#f5
framef1
         IN   a,(c)
         RRA  
         RET  c
         JR   framef1
setinks                                 ; Set Inks - Replace With HARDWARE !
         LD   a,1
         CALL #bc0e
         LD   bc,#101
         CALL #bc38
         LD   ix,inks
         XOR  a
setinks1
         PUSH af
         LD   b,(ix+0)
         LD   c,b
         CALL #bc32
         POP  af
         INC  ix
         INC  a
         CP   4
         JR   nz,setinks1
         RET  
;
sprload  EQU  #2000
;
inks     DEFB 0,25,6,15
;
name     DEFM PINBALL .SPR
len      EQU  $-name
;
lfa      EQU  #100
;
scrtable DEFS 400,0
ballt    DEFB 0                         ; Shift State Of Ball !
batt     DEFB 0
;
countdy  DEFB 2                         ; Count Down
countdh  DEFB 1
ballvely DEFB 0                         ; Balls Velocity X
movex    DEFB 0                         ; How Much To Move Ball X-Axis !
;
