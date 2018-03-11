;
dbest                                   ; Display Best Win Of Today !
         LD   hl,hscore
         CALL DigitalJ
         LD   hl,sprload+24
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         JR   setwinbw
ishscore                                ; Is There A Higher Win ?
         LD   hl,dspace
         PUSH hl
         LD   de,hscore+3
         LD   hl,DigitalN+3
         LD   b,4
ishs1
         LD   a,(de)
         CP   (hl)
         JR   c,ishs2
         RET  nz
         DEC  hl
         DEC  de
         DJNZ ishs1
         RET  
ishs2
         LD   hl,DigitalN
         LD   de,hscore
         LD   bc,4
         LDIR 
         LD   hl,hicon
         CALL setupms
         LD   a,80
         JP   scrmess
setwinb
         CALL Digital
         LD   ix,sprload
         LD   e,(ix+20)
         LD   d,(ix+21)
         LD   hl,sprload
         ADD  hl,de
         EX   de,hl
         LD   hl,#d800
         LD   c,0
         LD   b,9
         LD   a,23
         CALL decomp
         LD   ix,sprload
         LD   e,(ix+22)
         LD   d,(ix+23)
setwinbw
         LD   hl,sprload
         ADD  hl,de
         LD   bc,#1608
         LD   de,3*#50+#e808
Generals                                ; General Sprite Routine
         PUSH bc
         PUSH de                        ; HL = Scr Addr : DE = SPRITE ADDR
         LD   c,b
         LD   b,0
Genspr1
         LDIR 
         POP  de
         LD   a,d
         ADD  a,8
         JR   nc,Genspr2
         LD   a,#50
         ADD  a,e
         LD   e,a
         LD   a,d
         ADC  a,#c8
Genspr2
         LD   d,a
         POP  bc
         DEC  c
         JR   nz,Generals
         RET  
dpause
         XOR  a
         CALL pause
pause                                   ; Entry A=Pause Length In 1/50th S
         PUSH af
         CALL framefly
         POP  af
         DEC  a
         RET  z
         JR   pause
blackink
         XOR  a
blakink1
         PUSH af
         LD   b,0
         CALL setink
         POP  af
         INC  a
         BIT  4,a
         JR   z,blakink1
         RET  
setinks
         XOR  a
         CALL setmode
         LD   b,0
         LD   a,16
         CALL setink
         LD   ix,inks
         XOR  a
setinks1
         PUSH af
         LD   b,(ix+0)
         CALL setink
         INC  ix
         POP  af
         INC  a
         CP   16
         JR   nz,setinks1
         RET  
jumble
         CALL spinrls
         CALL resetwb
         JP   spinrls
*f,messcrol.adm
