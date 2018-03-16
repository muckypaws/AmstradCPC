;
         ORG  #3000                     ; Sine Wave Balls - Written By
start                                   ; JASON BROOKS : Project Started 31/1/91
         ENT  $                         ; (C) 1991 JacesofT Software.
scankey  EQU  #bb1e
index1   EQU  12
balls    EQU  7
         DI   
         IM   1
         LD   sp,#bff8
         CALL load                      ; Load Sprites
         CALL setinks                   ; Set Mode , Border Etc.
         LD   hl,mess
         CALL print
         DI   
         CALL calcoffs
         LD   l,90
         LD   e,0
         CALL calcaddr
         LD   b,#50
line
         LD   (hl),#ff
         INC  hl
         DJNZ line
         CALL putball
         CALL putbat
         LD   a,1
         LD   (ix+5),a
;
loop
         CALL framefly                  ; Await
         CALL putball                   ; Erase Current Ball
         CALL putbat
;
         CALL updatey                   ; Update Ball In Y Direction - Accell.
         CALL updatex                   ; Updat
         CALL upbat                     ; Updat
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
         INC  (ix+5)
         RET  
decc
         DEC  (ix+5)
         BIT  7,(ix+5)
         RET  z
         LD   (ix+5),0
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
         LD   a,(ix+7)
         OR   a
         JR   z,end1
         CP   79
         RET  nz
end1
         LD   a,(ix+0)
         XOR  1
         LD   (ix+0),a
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
updateb  LD   a,(ix+0)                  ; Move Ball Up/Down Accordingly
         AND  #80
         JP   z,bdown
         JP   bup
updatex
         LD   ix,btable
         LD   b,balls
updxloop
         PUSH bc
         CALL mainux
         POP  bc
         LD   de,index1
         ADD  ix,de
         DJNZ updxloop
         RET  
mainux
         LD   a,(ix+3)
         DEC  (ix+3)
         OR   a
         RET  nz
         LD   a,(ix+11)
         LD   (ix+3),a
updatexx                                ; Move X In Appropriate Direction
         LD   a,(ix+5)                  ; Let A=Amount To Move
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
         LD   a,(ix+0)                  ; Get Velocity Of Ball
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
         LD   a,(ix+7)
jj
         RLA  
         JR   c,udx1b                   ; If BALL <0 then BALL=0
         OR   a
         RET  nz
udx1b
         LD   a,(ix+0)                  ; Get Ball Velocity Again
         XOR  1                         ; Reverse X Velocities
         LD   (ix+0),a                  ; Store Ball Velocity
         XOR  a                         ; RESET A Since BALLX = 0
         LD   (ix+7),a
         LD   (ix+6),a
udatex1
         LD   a,(ix+7)
         CP   78                        ; Has Ball Reached Edge Of Screen ?
         RET  c                         ; IF Not Quit
         JR   nz,udatex2
         LD   a,(ix+6)
         CP   3
         RET  nz
udatex2
         LD   a,78                      ; Otherwise Ball=Edge
         LD   (ix+7),a
         LD   a,3
         LD   (ix+6),a
         LD   a,(ix+0)                  ; Get Ball Velocity Again
         XOR  1                         ; Reverse X Velocities
         LD   (ix+0),a                  ; Store Ball Velocity
         RET                            ; Quit  
;
updatey                                 ; update ball on Y-Axis
         LD   ix,btable                 ; Point To Main Table
         LD   b,balls
updyloop
         PUSH bc
         CALL mainy
         POP  bc
         LD   de,index1
         ADD  ix,de
         DJNZ updyloop
         RET  
mainy
         DEC  (ix+2)
         JP   nz,updateb                ; If Not End Of Update BALL Y POS
         BIT  7,(ix+0)                  ; Is it going UP or DOWN ?
         LD   a,(ix+1)                  ; And GET VELOCITY in A
         JR   z,updyneg                 ; Jump If Negative Ball Velocity
         INC  (ix+1)                    ; Otherwise Increment Velocity
         CP   (ix+9)                    ; Has Ball Reached Maximum ?
         JR   nz,updy1                  ; If Not Jump
updyn1                                  ; Otherwise Invert Balls Direction !
         CALL bup
         CALL bup
         LD   a,(ix+4)
         XOR  128
         LD   (ix+4),a
updyn1a
         LD   a,(ix+0)
         XOR  128
         LD   (ix+0),a                  ; Invert Ball Y's Direction !
updy1
         LD   a,(ix+1)                  ; Get Velocity
         OR   a                         ; Is It Zero ?
         LD   a,2                       ; Load With Two
         JR   nz,updy2                  ; If A <> 0 then JUMP
         DEC  a                         ; Otherwise A = 1
updy2
         LD   (ix+2),a                  ; Set Count Down Y
         JR   bup                       ; Move Ball Up
updyneg
         OR   a
         JR   z,updyn1a
         DEC  (ix+1)
         DEC  a
;OR   a
         LD   a,2
         JR   nz,updyn2
         DEC  a
updyn2
         LD   (ix+2),a
         JR   bdown
bleft
         LD   a,(ix+7)
         OR   (ix+6)
         RET  z
         LD   a,(ix+6)
         DEC  a
         AND  3
         LD   (ix+6),a
         CP   3
         RET  nz
         DEC  (ix+7)
         RET  
bright
         LD   a,(ix+7)
         CP   79
         RET  z
         LD   a,(ix+6)
         INC  a
         AND  3
         LD   (ix+6),a
         RET  nz
         INC  (ix+7)
         RET  
bup
         LD   a,(ix+4)
         AND  128
         JR   nz,bdown1
bup1
         LD   b,(ix+1)
         LD   a,(ix+8)
         CP   10
         RET  c
         SUB  b
         RET  c
         LD   (ix+8),a
         RET  
bdown
         LD   a,(ix+4)
         AND  128
         JR   nz,bup1
bdown1
         LD   a,(ix+8)
         LD   b,(ix+1)
         ADD  a,b
         CP   5
         RET  c
         CP   195
         RET  nc
         LD   (ix+8),a
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
         LD   ix,btable
         LD   b,balls                   ; How Many Balls
pbloop
         PUSH bc
         CALL pbmain
         LD   de,index1
         ADD  ix,de
         POP  bc
         DJNZ pbloop
         RET  
pbmain
         LD   a,(ix+6)
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
         LD   l,(ix+8)
         LD   e,(ix+7)
         CALL calcaddr
         POP  de
         LD   b,5
putball1
         LD   a,(de)
         AND  (ix+10)
         XOR  (hl)
         LD   (hl),a
         INC  hl
         INC  de
         LD   a,(de)
         AND  (ix+10)
         XOR  (hl)
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
print
         LD   a,(hl)
         OR   a
         RET  z
         INC  hl
         CALL #bb5a
         JR   print
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
batt     DEFB 0
mess
         DEFS 5,32
         DEFM Sine Balls Demo - The Arg
         DEFM onaut
         DEFB 13,10
         DEFS 5,32
         DEFM -------------------------
         DEFM -----
         DEFB 13,10,0
;
; Ball   Index   Table
btable
;
         DEFB 0                         ; Ball Velocity Y - ballvely
         DEFB 5                         ; Speed Y - speed
         DEFB 2                         ; Count Down Y - countdy
         DEFB 0                         ; Count Down H - countdh
         DEFB 0                         ; SineWave Flag - sine
         DEFB 3                         ; Adjustment For X - movex
         DEFB 0                         ; Ball Shift State - ballt
         DEFB 0                         ; Ball X Pos. - ballx
         DEFB 100                       ; Ball Y Pos. - bally
         DEFB 5                         ; Height Of Ball - maxi
         DEFB #f                        ; Colour Mask
         DEFB 0
;
         DEFB 0                         ; Ball Velocity Y - ballvely
         DEFB 6                         ; Speed Y - speed
         DEFB 2                         ; Count Down Y - countdy
         DEFB 0                         ; Count Down H - countdh
         DEFB 0                         ; SineWave Flag - sine
         DEFB 3                         ; Adjustment For X - movex
         DEFB 0                         ; Ball Shift State - ballt
         DEFB 0                         ; Ball X Pos. - ballx
         DEFB 100                       ; Ball Y Pos. - bally
         DEFB 6                         ; Height Of Ball - maxi
         DEFB #f0                       ; Colour Mask
         DEFB 0
;
         DEFB 0                         ; Ball Velocity Y - ballvely
         DEFB 7                         ; Speed Y - speed
         DEFB 2                         ; Count Down Y - countdy
         DEFB 0                         ; Count Down H - countdh
         DEFB 0                         ; SineWave Flag - sine
         DEFB 3                         ; Adjustment For X - movex
         DEFB 0                         ; Ball Shift State - ballt
         DEFB 0                         ; Ball X Pos. - ballx
         DEFB 100                       ; Ball Y Pos. - bally
         DEFB 7                         ; Height Of Ball - maxi
         DEFB #ff                       ; Colour Mask
         DEFB 0
;
         DEFB 0                         ; Ball Velocity Y - ballvely
         DEFB 4                         ; Speed Y - speed
         DEFB 2                         ; Count Down Y - countdy
         DEFB 0                         ; Count Down H - countdh
         DEFB 0                         ; SineWave Flag - sine
         DEFB 2                         ; Adjustment For X - movex
         DEFB 0                         ; Ball Shift State - ballt
         DEFB 0                         ; Ball X Pos. - ballx
         DEFB 100                       ; Ball Y Pos. - bally
         DEFB 4                         ; Height Of Ball - maxi
         DEFB %10101111                 ; Colour Mask
         DEFB 0
;
         DEFB 128                       ; Ball Velocity Y - ballvely
         DEFB 3                         ; Speed Y - speed
         DEFB 2                         ; Count Down Y - countdy
         DEFB 0                         ; Count Down H - countdh
         DEFB 0                         ; SineWave Flag - sine
         DEFB 1                         ; Adjustment For X - movex
         DEFB 0                         ; Ball Shift State - ballt
         DEFB 0                         ; Ball X Pos. - ballx
         DEFB 100                       ; Ball Y Pos. - bally
         DEFB 3                         ; Height Of Ball - maxi
         DEFB %11110101                 ; Colour Mask
         DEFB 0
;
         DEFB 0                         ; Ball Velocity Y - ballvely
         DEFB 5                         ; Speed Y - speed
         DEFB 2                         ; Count Down Y - countdy
         DEFB 3                         ; Count Down H - countdh
         DEFB 0                         ; SineWave Flag - sine
         DEFB 1                         ; Adjustment For X - movex
         DEFB 0                         ; Ball Shift State - ballt
         DEFB 0                         ; Ball X Pos. - ballx
         DEFB 100                       ; Ball Y Pos. - bally
         DEFB 5                         ; Height Of Ball - maxi
         DEFB %11110110                 ; Colour Mask
         DEFB 3                         ; Original Contents Of CountdH !
;
         DEFB 0                         ; Ball Velocity Y - ballvely
         DEFB 3                         ; Speed Y - speed
         DEFB 2                         ; Count Down Y - countdy
         DEFB 0                         ; Count Down H - countdh
         DEFB 0                         ; SineWave Flag - sine
         DEFB 1                         ; Adjustment For X - movex
         DEFB 0                         ; Ball Shift State - ballt
         DEFB 0                         ; Ball X Pos. - ballx
         DEFB 100                       ; Ball Y Pos. - bally
         DEFB 3                         ; Height Of Ball - maxi
         DEFB %10011111                 ; Colour Mask
         DEFB 2
;
finish
