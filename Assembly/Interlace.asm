;
         ORG  #9000                     ; Interupts For Interlace
start
         ENT  $
         XOR  a
         LD   (count),a
         XOR  #c9
         LD   (start),a
         LD   hl,tickblok
         LD   de,event
         LD   bc,#8000
         JP   #bce0
event
         DI   
         PUSH af
         LD   a,(count)
         INC  a
         CP   6
         JR   z,switch
event2
         LD   (count),a
         POP  af
         RET  
switch
         LD   a,(screen)
         XOR  1
         LD   (screen),a
         LD   a,#40
         JR   z,top
         LD   a,#c0
top
         CALL #bc08
         XOR  a
         JR   event2
count    DEFB 0
screen   DEFB 0
tickblok DEFS 9,0
