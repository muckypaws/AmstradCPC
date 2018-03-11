;
         ORG  #814a                     ; Fruit Machine Simulator
start                                   ; Written By Jason Brooks
         ENT  start                     ; Started 27/06/90
         DI   
         IM   1
         LD   sp,#38
         CALL blackink
         CALL cleanscr
         CALL setinks
         CALL trans
         CALL jumble
newgame
         CALL ishscore
         CALL welcome
         CALL resetgc
         CALL resetwb
         CALL setwinb
         CALL resetspd
         LD   a,(functcnt)
         OR   a
         CALL nz,takeit1
         CALL funhfc
startr
         CALL game0
         CALL resetf
         CALL game0
         CALL getret
         CALL swichhld
         CALL resetgc
         LD   a,0
walkf    EQU  $-1
         OR   a
         JR   nz,newgame
         CALL getwin
         CALL gamble
         LD   a,(lastwin)
         OR   a
         PUSH af
         CALL nz,incmoney
         POP  af
         CALL nz,im2
         CALL getwin
         LD   a,(lastwin)
         OR   a
         JR   nz,startr3
         CALL getnum
         CALL nz,dispfunc
         LD   a,0
numbers  EQU  $-1
         OR   a
         CALL nz,modulec
         CALL gamblef
startr3
         CALL funhfc
;startr3
         CALL resetf
         CALL game0
         LD   a,r
         CP   56
         LD   a,#28
         JR   nc,setgt
         XOR  a
setgt
         LD   (gamblet),a
         LD   a,(lastwin)
         OR   a
         LD   a,0
         LD   c,a
         LD   (tsetg),a
         JR   nz,start1
;CALL getwin
         LD   a,(lastwin)
         OR   a
         LD   c,0
         JR   nz,start1
         CALL allnumb
         LD   c,0
         JR   c,start1
         LD   a,r
         CP   34
         LD   c,0
         JR   nc,start1
         LD   c,#18
start1
         LD   hl,getret+1
         LD   (hl),c
         CALL checkmon
         JP   nz,startr
         LD   a,4
         CALL losec1
         JP   newgame
welcome
         XOR  a
         LD   (walkf),a
         CALL dbest
         LD   hl,welcomem
         CALL setupms
newgame1
         LD   a,27
         CALL scrmess
         JR   c,newgame1
         CALL dspace
         CALL resetwb
         CALL setwinb
         LD   hl,hello
         CALL setupms
         LD   a,80
jason1
         CALL scrmess
         JP   dspace
allnumb
         CALL getwin
         CALL getnum
         LD   a,(number1)
         OR   a
         RET  z
         LD   a,(number2)
         OR   a
         RET  z
         LD   a,(number3)
         OR   a
         RET  z
         SCF  
         RET  
*f,hd6845ct.adm
