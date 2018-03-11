;
nudge                                   ; **** NUDGES.ADM ****
         XOR  a
         LD   (functcnt),a
         CALL resetag
         CALL game0
         CALL resetcom
;LD   a,(nudges)
;CP   5
;JR   c,nudgeok
         LD   hl,think
         CALL setupms
         LD   a,80
         CALL scrmess
nudgeok
         LD   de,reel1bfd
         LD   hl,reelt1
         LD   bc,nfrtpr*5+20
         PUSH hl
         PUSH de
         PUSH bc
         LDIR                           ; Copy Reels Into Buffer
         CALL forn1                     ; Get Nudges
         POP  bc
         POP  hl
         POP  de
         LDIR 
         LD   hl,nowin
         CALL setupms
         LD   a,(currcomb)
         OR   a
         CALL z,scrmess
         CALL dspace
         LD   hl,currcomb
         LD   a,(hl)
         OR   a
         RET  z                         ; Quit If No Win Available
         INC  hl                        ; Point To Nudge Sequence
         LD   a,(hl)
         LD   (state),a
         AND  a
         CALL setptbf
         LD   hl,currcomb+3
         LD   b,5                       ; 5 Reels
         LD   c,%11111110
nudgem
         PUSH hl
         PUSH bc
         LD   a,(hl)
         AND  31
         JR   z,nudgem2
         LD   b,a
         LD   a,c
         LD   (heldf),a
nudgem1
         PUSH bc
         LD   a,(state)
         AND  a
         CALL setptbf
         CALL nreel
         LD   hl,nudges
         DEC  (hl)
         POP  bc
         DJNZ nudgem1
nudgem2
         POP  bc
         LD   a,c
         RLCA 
         LD   c,a
         POP  hl
         INC  hl
         DJNZ nudgem
         XOR  a
         LD   (heldf),a
         CALL getwin
         CALL gamble
         JP   incmoney
;
forn1                                   ; Routine To Generate Combinations For
         LD   a,(nudges)
         OR   a
         RET  z
         LD   a,%1111                   ; Nudges !
         CALL maskdbit                  ; This Was A BASTARD To Write
         CALL rp1
forn1l
         CALL forn2
         LD   a,(n1)
         CP   4
nudges   EQU  $-1
         JR   z,ud1b
         CALL r1ud
         JR   forn1l
ud1b
         LD   c,16
         CALL xordbit
         RET  z
         CALL rp1
         CALL r1ud
         JR   forn1l
forn2
         LD   c,%10111
         CALL maskdbit
         CALL rp2
forn2b
         XOR  a
         LD   hl,n2
         CALL addsub3
         LD   (to2),a
forn2l
         CALL forn3
         LD   a,(to2)
         OR   a
         RET  z
         LD   a,(n2)
         CP   10
to2      EQU  $-1
         JR   z,ud2b
         CALL r2ud
         JR   forn2l
ud2b
         LD   c,8
         CALL xordbit
         RET  z
         CALL rp2
         CALL r2ud
         JR   forn2l
forn3
         LD   c,%11011
         CALL maskdbit
         CALL rp3
forn3b
         LD   hl,n2
         LD   a,(hl)
         CALL addsub3
         LD   (to3),a
forn3l
         CALL forn4
         LD   a,(to3)
         OR   a
         RET  z
         LD   a,(n3)
         CP   10
to3      EQU  $-1
         JR   z,ud3b
         CALL r3ud
         JR   forn3l
ud3b
         LD   c,4
         CALL xordbit
         RET  z
         CALL rp3
         CALL r3ud
         JR   forn3l
forn4                                   ; Next
         LD   c,%11101
         CALL maskdbit
         CALL rp4
forn4b
         LD   hl,n3
         LD   a,(hl)
         CALL addsub2
         LD   (to4),a
forn4l
         CALL forn5
         LD   a,(to4)
         OR   a
         RET  z
         LD   a,(n4)
         CP   0
to4      EQU  $-1
         JR   z,ud4b
         CALL r4ud
         JR   forn4l
ud4b
         LD   c,2
         CALL xordbit
         RET  z
         CALL rp4
         CALL r4ud
         JR   forn4l
forn5                                   ; Call For Loop
         LD   c,%11110
         CALL maskdbit
         CALL rp5
forn5b
         CALL addsub
         LD   (to5),a
forn5l
         CALL checkwin
         LD   a,(to5)
         OR   a
         RET  z
         LD   a,(n5)
         CP   0
to5      EQU  $-1
         JR   z,ud5b
         CALL r5ud
         JR   forn5l
ud5b
         LD   c,1
         CALL xordbit
         RET  z
         CALL rp5
         CALL r5ud
         JR   forn5l
rp1                                     ; Replace Reel One
         XOR  a
         LD   (n1),a
         LD   hl,reel1bfd
         LD   de,reelt1
rcop
         LD   bc,nfrtpr
         LDIR 
         RET  
rp2
         XOR  a
         LD   (n2),a
         LD   hl,reel1bfd+nfrtpr
rs2      EQU  $-2
         LD   de,reelt2
         JR   rcop
rp3
         XOR  a
         LD   (n3),a
         LD   hl,nfrtpr*2+reel1bfd
         LD   de,reelt3
         JR   rcop
rp4
         XOR  a
         LD   (n4),a
         LD   hl,nfrtpr*3+reel1bfd
         LD   de,reelt4
         JR   rcop
rp5
         XOR  a
         LD   (n5),a
         LD   hl,nfrtpr*4+reel1bfd
         LD   de,reelt5
         JR   rcop
xordbit
         LD   a,(state)
         XOR  c
         LD   (state),a
         AND  c
         LD   a,1
         RET  
maskdbit
         LD   a,(state)
         AND  c
         LD   (state),a
         RET  
addsub
         LD   hl,n4
         LD   a,(hl)
addsub1
         INC  hl
         ADD  a,(hl)
addsub2
         INC  hl
         ADD  a,(hl)
addsub3
         INC  hl
         ADD  a,(hl)
         LD   b,a
         LD   a,(nudges)
         SUB  b
         RET  
resetcom
         LD   hl,currcomb               ; Reset Winning Combination
resetcm1
         LD   b,8
         XOR  a
resetcm2
         LD   (hl),a
         INC  hl
         DJNZ resetcm2
         LD   (to2),a
         LD   (to3),a
         LD   (to4),a
         LD   (to5),a
         RET  
r1ud                                    ; Reel 1 Up Or Down ?
         LD   hl,n1
         INC  (hl)
         LD   a,(state)
         AND  16
         JR   z,r1down
r1up
         LD   hl,reelt1+1
         JR   shiftu
r2ud                                    ; Reel 1 Up Or Down ?
         LD   hl,n2
         INC  (hl)
         LD   a,(state)
         AND  8
         JR   z,r2down
r2up
         LD   hl,reelt2+1
         JR   shiftu
r3ud                                    ; Reel 1 Up Or Down ?
         LD   hl,n3
         INC  (hl)
         LD   a,(state)
         AND  4
         JR   z,r3down
r3up
         LD   hl,reelt3+1
         JR   shiftu
r4ud                                    ; Reel 1 Up Or Down ?
         LD   hl,n4
         INC  (hl)
         LD   a,(state)
         AND  2
         JR   z,r4down
r4up
         LD   hl,reelt4+1
         JR   shiftu
r5ud                                    ; Reel 1 Up Or Down ?
         LD   hl,n5
         INC  (hl)
         LD   a,(state)
         AND  1
         JR   z,r5down
r5up
         LD   hl,reelt5+1
shiftu
         PUSH hl
         POP  de
         DEC  de
         LD   bc,nfrtpr-1
         LD   a,(de)
         LDIR 
         LD   (de),a
         RET  
r1down
         LD   hl,reelt1+nfrtpr-2
         JR   shiftd
r2down
         LD   hl,reelt2+nfrtpr-2
         JR   shiftd
r3down
         LD   hl,reelt3+nfrtpr-2
         JR   shiftd
r4down
         LD   hl,reelt4+nfrtpr-2
         JR   shiftd
r5down
         LD   hl,reelt5+nfrtpr-2
shiftd
         PUSH hl
         POP  de
         INC  de
         LD   bc,nfrtpr-1
         LD   a,(de)
         LDDR 
         LD   (de),a
         RET  
checkwin
         CALL getwin                    ; See If Win Available
         LD   a,(lastwin)
         OR   a
         RET  z                         ; If Not Exit
         LD   b,a
         LD   a,(currcomb)              ; Get Stored Win
         SUB  b
         JR   z,equalw                  ; If Equal Win The See If Less Nudges !
         RET  nc                        ; Quit If Lesser Win
         JR   nputwin                   ; Put Bigger Win In
equalw                                  ; If Equal Winnings Is It Fewer Nudges 
         LD   hl,n5
         XOR  a
         LD   b,5
equalw1
         ADD  a,(hl)
         INC  hl
         DJNZ equalw1
         LD   b,a
         LD   a,(currcomb+2)
         SUB  b
         RET  c                         ; If More Nudges Then Exit
nputwin
         LD   hl,currcomb               ; Point HL To Current Combination
         LD   a,(lastwin)               ; Get Winnings
         LD   (hl),a                    ; And Store
         INC  hl
         LD   a,(state)
         LD   (hl),a                    ; Poke Direction BIT
         INC  hl
         INC  hl
         LD   de,n5                     ; Poke Nudge Sequence
         LD   b,5
         LD   c,0
nputwin1
         LD   a,(de)
         LD   (hl),a
         ADD  a,c                       ; Add Nudges
         LD   c,a
         INC  hl
         INC  de
         DJNZ nputwin1
         LD   a,c
         LD   (currcomb+2),a            ; Store Number Of Nudges
         RET  
;
*f,repeater.adm
