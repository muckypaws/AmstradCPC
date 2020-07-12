;
         ORG  #9000
start
         ENT  $
         CALL loadspr
         LD   hl,sprites+30
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   hl,sprites+#100
         ADD  hl,de
         LD   (ALFA),hl                 ; Store Location Of Alfa Letters !
         LD   a,1
         CALL #bc0e
         LD   hl,message
         LD   (messageo),hl
         LD   (messageb),hl
         CALL print
loop
         CALL #bd19
         LD   a,47
         CALL #bb1e
         RET  nz
         CALL scroll
         JR   loop
         RET  
print
         LD   a,(hl)
         OR   a
         RET  z
         INC  hl
         CALL #bb5a
         JR   print
message  DEFM This Is A Test Routine Pr
         DEFM int O.K. 
         DEFB 13,10
         DEFM Hello There again Look A
         DEFM t Me
         DEFB 0
scroll
         LD   hl,#c020
messaddr EQU  $-2
         LD   c,16
scroll1
         LD   b,#21
         PUSH bc
         PUSH hl
         LD   c,0
scroll2
         LD   a,(hl)
         AND  %10001000
         LD   e,a
         LD   a,(hl)
         RLCA 
         AND  %11101110
         OR   c
         LD   (hl),a
         LD   a,e
         RRCA 
         RRCA 
         RRCA 
         LD   c,a
         DEC  hl
         DJNZ scroll2
         POP  hl
         LD   a,h
         ADD  a,8
         JR   nc,scroll3
         LD   a,#50
         ADD  a,l
         LD   l,a
         LD   a,h
         ADC  a,#c8
scroll3
         OR   #c0
         LD   h,a
         POP  bc
         DEC  c
         JR   nz,scroll1
         RET  
calcscr
         PUSH af
         PUSH bc
         PUSH de
         LD   a,h
         AND  7
         RLCA 
         RLCA 
         RLCA 
         OR   #c0
         LD   b,a
         LD   c,l
         LD   a,h
         AND  %11111000
         LD   e,a
         LD   d,0
         LD   h,d
         LD   l,a
         ADD  hl,hl
         ADD  hl,hl
         ADD  hl,de
         ADD  hl,hl
         ADD  hl,bc
         LD   a,h
         OR   #c0
         LD   h,a
         POP  de
         POP  bc
         POP  af
         RET  
plocalfa
         PUSH de
         CALL calcscr
         LD   (alfaaddr),hl
         POP  hl
palfa
         LD   a,(hl)
         OR   a
         RET  z
         INC  hl
         PUSH hl
         CALL putalfa
         POP  hl
         JR   palfa
putalfa                                 ; Put Alfa Numeric On The Screen
@
         SUB  "@"
         LD   h,0
         LD   d,h
         LD   l,a
         ADD  a,a
         ADD  a,l
         ADD  a,a
         LD   l,a
         LD   e,l
         ADD  hl,hl
         ADD  hl,de
         LD   de,0
ALFA     EQU  $-2
         ADD  hl,de
@
;
         EX   de,hl
         LD   hl,#c000
alfaaddr EQU  $-2
         LD   bc,#209
;CALL drawspr1
         LD   hl,(alfaaddr)
         INC  hl
         INC  hl
         LD   (alfaaddr),hl
         RET  
restart
         LD   hl,(messageo)
         LD   (messageb),hl
         RET  
smessage                                ; Scrolled Message Print
         LD   a,(messpart)
         OR   a
         JR   nz,sm1
         LD   hl,(messageb)
         INC  hl
         LD   a,(hl)
         OR   a
         CALL z,restart
         LD   hl,(messageo)
         LD   a,(hl)
         PUSH hl
;
         SUB  "@"
         LD   h,0
         LD   d,h
         LD   l,a
         ADD  a,a
         ADD  a,l
         ADD  a,a
         LD   l,a
         LD   e,l
         ADD  hl,hl
         ADD  hl,de
         LD   de,(ALFA)
         ADD  hl,de
         LD   de,messbuff
         LD   bc,18
         LDIR 
         POP  hl
sm1
         LD   (messageb),hl
         LD   hl,(messaddr)
         LD   de,messbuff
smx      EQU  $-2
         LD   b,9
sm2
         LD   a,(de)
         RRCA 
         LD   (de),a
         RRCA 
         RRCA 
         AND  %10001
         OR   (hl)
         LD   (hl),a
         INC  de
         INC  de
         LD   a,h
         ADD  a,8
         JR   nc,sm3
         LD   a,l
         ADD  a,#50
         LD   l,a
         LD   a,h
         ADC  a,#c8
sm3
         OR   #c0
         LD   h,a
         DJNZ sm2
         LD   hl,messpart
         INC  (hl)
         LD   a,(hl)
         AND  7
         LD   (hl),a
         CP   4
         LD   hl,messbuff
         JR   nz,sm4
         INC  hl
sm4
         LD   (smx),hl
         RET  
loadspr
         LD   hl,memflag
         LD   a,(hl)
         OR   a
         RET  nz
         LD   (hl),#ff
         DI   
         LD   bc,#7fc7
         OUT  (c),c
         LD   hl,name1
         LD   b,len1
         CALL #bc77
         LD   hl,#4000
         CALL #bc83
         CALL #bc7a
         DI   
         LD   bc,#7fc0
         OUT  (c),c
         LD   hl,name
         LD   b,len
         LD   de,#c000
         CALL #bc77
         LD   hl,sprites
         CALL #bc83
         JP   #bc7a
;
name
         DEFM MINE.SPR
len      EQU  $-name
name1    DEFM MINE.SCR
len1     EQU  $-name1
memflag  EQU  #100                      ; Flag Address For Loaded Data
sprites  EQU  #1000
messpart DEFB 0
messbuff DEFS 18,0
messageb DEFW 0
messageo DEFW 0
