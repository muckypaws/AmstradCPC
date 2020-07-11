;
         ORG  #bf00                     ; Unerase For NIRVANA !
unerase
         CP   #e5
         RET  nz
         LD   a,(ix+1)
         CP   #e5
         RET  
rtn1
         LD   a,(ix+0)
         CP   #e5
         LD   a,#20
         JR   nz,rtn2
         LD   a,"E"
rtn2
         JP   #bb5a
rtn3
         LD   a,#c3
         LD   hl,unerase
         LD   (#30),a
         LD   (#31),hl
         RET  
rtn4
         LD   a,l
         CP   229
         LD   a,4
         JP   nz,#a522
         INC  sp
         INC  sp
         JP   #a5a1
