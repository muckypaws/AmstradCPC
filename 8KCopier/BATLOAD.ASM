;
         ORG  #8000
batman
         ENT  $
         DI   
         LD   sp,#bff8
         LD   hl,codeing
         LD   de,#be80
         LD   bc,#150
         PUSH de
         LDIR 
         LD   a,47
         CALL #bb1e
         RET  nz
         LD   a,1
         CALL #bc0e
         LD   hl,cheatm
         CALL print
yn
         LD   a,43
         CALL #bb1e
         LD   a,"Y"
         JR   nz,yn1
         LD   a,46
         CALL #bb1e
         JR   z,yn
         LD   a,"N"
yn1
         CALL #bb5a
         SUB  "N"
         LD   (cheat),a
         RET  
;
cheatm
         DEFB 12,13,10
         DEFM Do you wish to cheat ? 
         DEFB 0
print
         LD   a,(hl)
         OR   a
         RET  z
         INC  hl
         CALL #bb5a
         JR   print
codeing
         ORG  #be80                     ; Loader For Batman The Caped Crusader
         DI   
         LD   sp,#b100
         LD   bc,#7fc0
         OUT  (c),c
         CALL #bc02
         LD   hl,bsel
         CALL load
         LD   bc,0
         CALL #bc38
         XOR  a
         LD   c,a
         LD   b,c
         CALL #bc32
         CALL #8000
         PUSH af
         LD   a,1
         CALL #bc0e
         LD   ix,inks
         XOR  a
inks1
         PUSH af
         LD   b,(ix+0)
         LD   c,b
         CALL #bc32
         POP  af
         INC  ix
         INC  a
         CP   4
         JR   nz,inks1
         LD   bc,#bc01
         LD   a,#20
         OUT  (c),c
         INC  b
         OUT  (c),a
         DEC  b
         INC  c
         LD   a,#2a
         OUT  (c),c
         INC  b
         OUT  (c),a
         DEC  b
         LD   c,6
         LD   a,#18
         OUT  (c),c
         INC  b
         OUT  (c),a
         DEC  b
         INC  c
         OUT  (c),c
         LD   a,#1e
         INC  b
         OUT  (c),a
         LD   hl,bpage
         CALL load
         POP  af
         PUSH af
         LD   hl,batbird
         DEC  a
         JR   z,select1
         LD   hl,batfete
select1
         LD   de,mname
         PUSH de
         LD   bc,8
         LDIR 
         POP  hl
         PUSH hl
         CALL load
         LD   hl,mname+7
         INC  (hl)
         POP  hl
         CALL load
         DI   
         POP  af
         LD   sp,#bff8
         LD   de,load
         LD   bc,#40
         PUSH de
         LD   hl,code1
         DEC  a
         JR   z,yes
         LD   hl,code2
yes
         LDIR 
         LD   hl,#c000
         LD   bc,#2000
         RET  
;
code1    LD   de,#9230
         LDIR 
         LD   hl,#6a30
         PUSH hl
         LD   a,(cheat)
         OR   a
         RET  z
         LD   hl,0
         LD   (#7b37),hl
         LD   a,#c9
         LD   (#7080),a
         RET  
code2
         LD   de,#91fd
         LDIR 
         LD   hl,#69fd
         PUSH hl
         LD   a,(cheat)
         OR   a
         RET  z
         LD   hl,0
         LD   (#7d12),hl
         LD   a,#c9
         LD   (#72a7),a
         RET  
load
         PUSH hl
         LD   hl,#b000
         LD   de,#40
         LD   c,7
         CALL #bcce
         POP  hl
         LD   de,#c000
         LD   b,8
         CALL #bc77
         EX   de,hl
         CALL #bc83
         PUSH hl
         CALL #bc7a
         POP  hl
         LD   a,l
         OR   h
         RET  z
         PUSH hl
         LD   de,#be80
         SBC  hl,de
         POP  hl
         RET  z
         LD   a,(#62)
         CP   #ca
         JR   nz,load1
         POP  de
         LD   (#63),de
load1
         JP   (hl)
mname    DEFM USERNAME
bsel     DEFM BATGAME 
bpage    DEFM BATPAGE 
batbird  DEFM BATBIRD1
batfete  DEFM BATFETE1
inks     DEFB #1a,2,0,16
cheat    DEFB 0
