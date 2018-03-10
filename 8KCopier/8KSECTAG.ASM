;
         ORG  #1300                     ; Speedlock Cracker V2.90 - Disk
start                                   ; Designed & Developed By Jason Brooks
         ENT  $                         ; (C) 1990 JacesofT Software Ltd.
         DI                             ; Currently For Version 90 Types
         IM   1                         ; Executed By RUN "DISC
Decode   EQU  #1000
compare  EQU  #11f9
compare1 EQU  #11fe
naddress EQU  #1281
         LD   sp,#c000
         LD   bc,#7fc0
         OUT  (c),c
         CALL #bd37
         LD   hl,#1800
         LD   de,#1800
         LD   bc,#a900-#1800
         LD   (hl),0
         LDIR 
         LD   hl,#abff
         LD   de,#40
         LD   c,7
         CALL #bcce
         LD   hl,name
         LD   b,len
         CALL #bc77
         CALL nc,DISK                   ; Possibly Spelt Differently
         EX   de,hl
         LD   (filetype),a
         CALL #bc83
         PUSH hl
         CALL #bc7a
         LD   hl,comm
         CALL #bcd4
         EX   de,hl
         LD   hl,read
         LD   (hl),e
         INC  hl
         LD   (hl),d
         INC  hl
         LD   (hl),c
         POP  hl
         LD   a,0
filetype EQU  $-1
         BIT  1,a
         JR   z,CPM
         LD   b,0
         LD   de,#790e
         CALL compare1
         INC  hl
         LD   c,(hl)
         LD   hl,#40
entry1
         LD   de,0
         RST  #18
         DEFW read
         DI   
         LD   a,0
wrong    EQU  $-1
         OR   a
         JR   nz,DISK1
         LD   hl,#100
         LD   de,#d5ed
         LD   b,0
         CALL compare1
         DEC  hl
         LD   (hl),0
         DEC  hl
         LD   d,(hl)
         DEC  hl
         LD   e,(hl)
         PUSH de
         CALL #100
         POP  hl
         DEC  hl
         LD   (hl),a
         DEC  hl
         LD   (hl),#3e
         LD   (naddress),hl
         JR   re
CPM                                     ; Those Executed With |CPM
         LD   hl,#100
         LD   c,#41
         JR   entry1
DISK
         CALL #bc7d
         LD   a,"K"
         LD   (wrong),a
         LD   (name+3),a
         LD   hl,name
         LD   b,len
         CALL #bc77
         RET  c
         RST  0
DISK1
         LD   hl,#108
DI1
         INC  hl
         LD   a,(hl)
         CP   #c3
         JR   nz,DI1
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         LD   (naddress),de
         LD   de,re
         LD   (hl),d
         DEC  hl
         LD   (hl),e
         CALL #100
re
         CALL Decode
copygame                                ; Copy Game
         LD   hl,(naddress)
end1
         INC  hl
         LD   a,(hl)
         CP   #cd
         JR   nz,end1
         INC  hl
         INC  hl
         INC  hl
         LD   a,(hl)
         DEC  hl
         DEC  hl
         CP   #d9
         JR   z,end2
         CP   #21
         JR   nz,end1
end2
         INC  hl
         INC  hl
end2a
         LD   (naddress),hl
         LD   hl,end3
         LD   c,#ff
         CALL #bd16
end3
         DI   
         LD   hl,save
         LD   de,#b000
         LD   bc,#200
         LDIR 
         LD   hl,load
         LD   de,#be80
         LD   bc,#100
         LDIR 
         LD   hl,(#bd38)
         LD   a,h
         AND  #3f
         LD   h,a
         LD   (bd37),hl
         LD   a,#c3
         LD   hl,end3a
         LD   (#bd16),a
         LD   (#bd17),hl
         LD   hl,(naddress)
         JP   (hl)
end3a
         LD   (naddress),hl
md1
         INC  hl
         LD   a,(hl)
         CP   #cd
         JR   nz,md1
         INC  hl
         LD   a,(hl)
         CP   #e
         JR   nz,md1
         INC  hl
         LD   a,(hl)
         CP   #bc
         JR   nz,md1
         PUSH hl
         DEC  hl
         DEC  hl
         DEC  hl
         LD   a,(hl)
         CP   #af
         JR   z,mdd
         LD   (mode),a
mdd
         POP  hl
         INC  hl
         LD   a,(hl)
         CP   #21
         JR   z,sci1
         LD   b,0
sc1
         INC  b
         LD   a,b
         OR   a
         JR   z,sc2
         INC  hl
         LD   a,(hl)
         CP   #21
         JR   nz,sc1
         INC  hl
         LD   a,(hl)
         OR   a
         JR   nz,sc1
         INC  hl
         LD   a,(hl)
         CP   #c0
         JR   nz,sc1
         INC  hl
         LD   a,(hl)
         CP   #cd
         JR   nz,sc1
sc2
         LD   a,b
         OR   a
         JR   z,sc2a                    ; Inks Not Found
         INC  hl
         INC  hl
         INC  hl
sci1
         INC  hl
         LD   e,(hl)
         INC  hl
         PUSH hl
         LD   d,(hl)
         EX   de,hl
         LD   de,inks
         LD   bc,16
         LDIR 
         POP  hl
sc2a                                    ; Get Execution Address
         INC  hl
         LD   a,(hl)
         CP   #cd
         JR   nz,sc2a
         INC  hl
         INC  hl
         INC  hl
         LD   a,(hl)
         CP   #21
         JR   nz,sc2a
         PUSH hl
         INC  hl
         INC  hl
         INC  hl
         LD   a,(hl)
         POP  hl
         CP   #d9
         JR   z,execute8
         CP   #18
         JR   nz,sc2a
execute8
         PUSH hl
         LD   (xdest),hl
         LD   de,execcode
         LD   bc,#bfc0-execcode
         LDIR 
         POP  hl
         PUSH hl
         LD   c,0
         INC  hl
         LD   a,(hl)
         OR   a
         JR   nz,sc22
         INC  hl
         LD   a,(hl)
         CP   #b3
         JR   nz,sc22
         LD   c,1
sc22
         LD   a,c
         LD   (barb),a
         LD   (barbl),a
         POP  hl
         LD   de,save1
         LD   (hl),#c3
         INC  hl
         LD   (hl),e
         INC  hl
         LD   (hl),d
         JP   #b000
name     DEFM DISC
len      EQU  $-name
comm     DEFB #84
read     DEFS 3,0
save                                    ; Save Code
         ORG  #b000
         LD   hl,(naddress)
         PUSH hl
         LD   l,0
         LD   (saves),hl
         LD   hl,#40
         LD   de,#41
         POP  bc
         PUSH bc
         LD   c,h
         LD   (hl),h
         LDIR 
         POP  hl
         JP   (hl)
save1
         DI   
         LD   sp,#bff8
         LD   a,0
barb     EQU  $-1                       ; Is It BARBARIAN II
         OR   a
         JR   z,barb1
         LD   hl,#b300
         LD   de,#40
         LD   bc,#800
         LDIR 
barb1
         LD   bc,#7f8b
         OUT  (c),c
         CALL #44
         CALL 0
bd37     EQU  $-2
         XOR  a
         LD   bc,#7f8e
         OUT  (c),c
         EX   af,af
         EXX  
         LD   hl,#af00
         LD   c,7
         CALL #bcce
         LD   bc,#7f10
         LD   a,#44
         OUT  (c),c
         OUT  (c),a
         LD   a,7
         CALL #bb5a
savek
         LD   a,51
         CALL #bb1e
         JR   z,savek
         LD   hl,#be80
         LD   de,#bfa0-#be80
         LD   b,4
         CALL saver
         LD   hl,#c000
         LD   de,#4000
         LD   b,slen
         CALL saver
         LD   hl,#3f
savex
         INC  hl
         LD   a,(hl)
         OR   a
         JR   z,savex
         LD   de,#a600
saves    EQU  $-2
save2
         DEC  de
         LD   a,(de)
         OR   a
         JR   z,save2
         EX   de,hl
         AND  a
         SBC  hl,de
         INC  hl
         INC  hl
         EX   de,hl
         LD   b,slen
         CALL saver
         RST  0
saver
         PUSH de
         PUSH hl
         LD   hl,saven+4
         INC  (hl)
         LD   hl,saven
         CALL #bc8c
         POP  hl
         POP  de
         LD   bc,#be80
         LD   a,2
         CALL #bc98
         JP   #bc8f
saven    DEFM DISC
         DEFB "0"-1
slen     EQU  $-saven
load                                    ; Loader Code
         ORG  #be80
         DI   
         LD   sp,#b100
         LD   bc,#7fc0
         OUT  (c),c
         LD   hl,#b090
         LD   c,7
         CALL #bcce
         LD   bc,0
         CALL #bc38
         LD   ix,inks
         XOR  a
seti
         PUSH af
         LD   b,(ix+0)
         LD   c,b
         CALL #bc32
         POP  af
         INC  ix
         INC  a
         CP   16
         JR   nz,seti
         LD   a,0
mode     EQU  $-1
         CALL #bc0e
         CALL loader
         CALL loader
         DI   
         LD   hl,execcode
         LD   de,0
xdest    EQU  $-2
         PUSH de
         LD   bc,#100
         LDIR 
         LD   a,0
barbl    EQU  $-1
         OR   a
         RET  z
         LD   hl,#40
         LD   de,#b300
         LD   bc,#800
         LDIR 
         RET  
loader
         LD   hl,namel+4
         INC  (hl)
         LD   hl,namel
         LD   b,lenl
         CALL #bc77
         EX   de,hl
         CALL #bc83
         JP   #bc7a
namel    DEFM DISC0
lenl     EQU  $-namel
inks     DEFS 16,0
execcode                                ; Place Execution Code Here
         DEFS 100,0
;
;
