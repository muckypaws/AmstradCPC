;
         ORG  #af00
isit
         LD   a,(#9845)
         OR   a
         JR   nz,no
         LD   a,(#8039)
         CP   #40
         JR   c,no
         JR   z,no
         CP   #4a
         JR   c,hello
no
         LD   a,0
hello
         LD   (flag),a
         LD   a,#45
         JP   #bb6f
dos48                                   ; Do I Do An S48 ?
         LD   a,(flag)
         OR   a
         CALL nz,s48
nos48
         XOR  a
         LD   (flag),a
         LD   (#9840),a
         RET  
deldata                                 ; Is Track 0 Got Deleted Data On It ?
         LD   a,(#9845)
         OR   a
         JR   nz,ndeldata
         LD   a,(flag)
         OR   a
         JR   z,ndeldata
         POP  hl
         POP  af
         XOR  a
         PUSH af
         PUSH hl
ndeldata
         LD   a,#34
         JP   #bb6f
s48                                     ; Sector 48
         LD   hl,#c666
         LD   (rw),hl
         LD   a,(#9844)
         LD   e,a
         LD   a,#41
         RST  #18
         DEFW select
         CALL readwrit
         LD   hl,(#be42)
         LD   d,0
         LD   a,(#9844)
         OR   a
         LD   e,0
         JR   z,patch1
         LD   e,64
patch1
         ADD  hl,de
         LD   (hl),40
         LD   e,15
         ADD  hl,de
         LD   (hl),#41
         INC  hl
         LD   (hl),10
         INC  hl
         LD   (hl),20
         INC  hl
         LD   (hl),32
         LD   e,6
         ADD  hl,de
         LD   (hl),#ff
         LD   hl,headbuff
         LD   d,0
         LD   a,(#9844)
         LD   e,a
         RST  #18
         DEFW format
         LD   hl,#c64e
         LD   (rw),hl
readwrit
         LD   hl,#3800
         LD   bc,#941
rw1
         PUSH bc
         PUSH hl
         LD   d,0
         LD   a,(#9844)
         LD   e,a
         RST  #18
         DEFW rw
         POP  hl
         INC  h
         INC  h
         POP  bc
         INC  c
         DJNZ rw1
         RET  
select
         DEFW #c581
         DEFB 7
format   DEFW #c652
         DEFB 7
rw       DEFW #c666
         DEFB 7
flag
         DEFB 0
headbuff
         DEFB 0,0,#41,2
         DEFB 0,0,#46,2
         DEFB 0,0,#42,2
         DEFB 0,0,#47,2
         DEFB 0,0,#43,2
         DEFB 0,0,#48,2
         DEFB 0,0,#44,2
         DEFB 0,0,#49,2
         DEFB 0,0,#45,2
         DEFB 0,0,#48,2
