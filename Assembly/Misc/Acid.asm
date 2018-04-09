;
         ORG  #9000
         ENT  $
         DI   
         LD   bc,#1a1a
         LD   a,3
         CALL #bc32
         CALL scrcalc
         CALL setflake
loop
         CALL calculat
         CALL framefly
         CALL display
         CALL animate
         LD   a,47
         CALL #bb1e
         RET  nz
         CALL framefly
         CALL display
         JR   loop
animate
         LD   hl,flakeadr+2
         LD   b,flakes
animate1
         LD   a,(hl)
         CP   200
         JR   nz,animate2
         LD   a,#ff
animate2
         INC  a
         LD   (hl),a
         INC  hl
         INC  hl
         INC  hl
         INC  hl
         DJNZ animate1
         RET  
calculat
         LD   ix,flakeadr
         LD   iy,dest
         LD   b,flakes
display1
         LD   l,(ix+0)
         LD   h,(ix+1)
         LD   e,(ix+2)
         LD   d,0
         CALL calcplot
         LD   (iy+0),l
         LD   (iy+1),h
         LD   (iy+2),a
         INC  ix
         INC  ix
         INC  ix
         INC  ix
         INC  iy
         INC  iy
         INC  iy
         DJNZ display1
         RET  
display
         LD   a,(flag)
         XOR  1
         LD   (flag),a
         LD   hl,dest
         LD   b,flakes
dispf1
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         INC  hl
         LD   c,(hl)
         INC  hl
         LD   a,(de)
         AND  c
         JR   z,dispf2
         LD   a,(flag)
         OR   a
         JR   z,dispf2
         LD   a,flakes
         SUB  b
         PUSH hl
         LD   l,a
         LD   h,0
         ADD  hl,hl
         ADD  hl,hl
         LD   de,flakeadr
         ADD  hl,de
         PUSH hl
         PUSH de
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         INC  hl
         LD   l,(hl)
         EX   de,hl
         LD   d,0
         CALL plotit
         POP  de
         POP  hl
         INC  hl
         INC  hl
         LD   (hl),1
         POP  hl
         DJNZ dispf1
         RET  
plotit
         CALL calcplot
         LD   c,a
         LD   a,(hl)
         OR   c
         LD   (hl),a
         RET  
dispf2
         LD   a,d
         OR   #c0
         LD   d,a
         LD   a,(de)
         XOR  c
         LD   (de),a
         DJNZ dispf1
         RET  
;
setflake
         LD   b,flakes
         LD   ix,flakeadr
setflak1
         CALL random
         AND  a
         LD   a,h
         AND  3
         LD   h,a
         LD   de,320
         SBC  hl,de
         JR   nc,setflak1
         ADD  hl,de
         LD   (ix+0),l
         LD   (ix+1),h
setflk2
         CALL random
         LD   a,l
         CP   200
         JR   nc,setflk2
         LD   (ix+2),a
         INC  ix
         INC  ix
         INC  ix
         INC  ix
         DJNZ setflak1
         LD   hl,#ff80
         LD   b,80
setflk3
         LD   (hl),#ff
         INC  hl
         DJNZ setflk3
         RET  
random
         PUSH af
         PUSH bc
         PUSH de
         LD   bc,(seed)
         LD   hl,(seed)
         SLA  l
         RL   h
         ADD  hl,bc
         LD   b,h
         LD   c,l
         SLA  l
         RL   h
         LD   d,1
         SLA  l
         RL   h
         SLA  l
         RL   h
         ADD  hl,bc
         LD   b,h
         LD   c,l
         LD   h,d
         LD   l,#29
         OR   a
         SBC  hl,bc
         LD   (seed),hl
         POP  de
         POP  bc
         POP  af
         RET  
framefly
         PUSH af
         PUSH bc
         LD   b,#f5
framefl1
         IN   a,(c)
         RRA  
         JR   nc,framefl1
         POP  bc
         POP  af
         RET  
scrcalc
         LD   hl,#c000
         LD   ix,calcaddr
         LD   b,200
scrcalc1
         LD   (ix+0),l
         LD   (ix+1),h
         LD   a,h
         ADD  a,8
         LD   h,a
         JR   nc,scrcalc2
         LD   de,#c050
         ADD  hl,de
scrcalc2
         INC  ix
         INC  ix
         DJNZ scrcalc1
         RET  
calcplot                                ; Calculate Relative Screen address
         PUSH hl
         EX   de,hl
         ADD  hl,hl                     ; HL*2
         LD   de,calcaddr
         ADD  hl,de
         LD   e,(hl)
         INC  hl
         LD   d,(hl)                    ; DE=Screen Line Address
         POP  hl
         LD   a,%10001000               ; Mask
         SRL  h
         RR   l                         ; HL/2
         JR   nc,calcplt2
         RRCA 
calcplt2
         SRL  h
         RR   l                         ; HL/4
         JR   nc,calcplt3
         RRCA 
         RRCA 
calcplt3
         ADD  hl,de
         RET  
calcaddr DEFS 400,0
flakes   EQU  75
seed     DEFW #7685
flag     DEFB 0
flakeadr DEFS flakes*4,0                ; X-2 Bytes Y-1 Byte XY Velocity-1 Byte
dest     DEFS flakes*3
