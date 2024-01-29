         ORG  #be80
start
         ENT  $
         DI   
         LD   sp,#c000
         LD   hl,#abff
         LD   de,#40
         LD   c,7
         CALL #bcce                     ; Initialise AMSDOS ROM
         LD   a,1
         CALL #bc0e                     ; MODE 1
         LD   bc,0
         CALL #bc38                     ; Border 0
;
         LD   ix,inks
         LD   b,4
         XOR  a
setinks
         PUSH af
         PUSH bc
         LD   b,(ix+0)
         LD   c,b
         CALL #bc32                     ; SET INK 
         POP  bc
         POP  af
         INC  a
         INC  ix
         DJNZ setinks
;
         CALL load
         CALL load
         CALL cheats
         JP   #73b1
;
load
         LD   hl,fname+5
         INC  (hl)
         LD   hl,fname
         LD   b,fnamel
         LD   de,#c000
         CALL #bc77
         EX   de,hl
         CALL #bc83
         JP   #bc7a
fname    DEFM DIZZY0.BIN
fnamel   EQU  $-fname
inks     DEFB 0,26,6,18
;
; Bonus  You've found the cheats!  
;        Remove the ones you don't need
;
cheats
         LD   A,#01
         LD   (#8925),A                 ; Increase Dizzy Speed
;
         LD   A,#C9
         LD   (#751B),A                 ; Remove Collision Detection
;
         LD   HL,#00
         LD   (#78D7),HL
         LD   (#78DE),HL                ; Watch Screens Being Drawn
;
         XOR  A
         LD   (#953A),A
         LD   (#9537),A                 ; Infinite Lives
;
         RET  							; Leave this
;