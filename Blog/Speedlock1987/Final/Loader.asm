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