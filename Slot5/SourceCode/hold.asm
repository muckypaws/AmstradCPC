;
swichhld
         LD   a,252
         LD   (colhl),a
         CALL holds2
         LD   a,#c0
         LD   (colhl),a
         RET  
setheldb
         CALL setrc
         CALL boing
         LD   hl,heldf
         BIT  4,(hl)
         SET  4,(hl)
         RET  z
shb1
         BIT  3,(hl)
         SET  3,(hl)
         RET  z
shb2
         BIT  2,(hl)
         SET  2,(hl)
         RET  z
shb3
         BIT  1,(hl)
         SET  1,(hl)
         RET  z
shb4
         SET  0,(hl)
         RET  
holdr
         LD   a,(count)
         CP   39
         CALL z,swichcan
holdrn
         LD   hl,count1
         INC  (hl)
         LD   a,(hl)
         SUB  15
         CALL nc,holds
         LD   a,(functcnt)
         OR   a
         JR   nz,holdrn1
         LD   a,64
         CALL scankey
         CALL z,holdr1
         LD   a,49
         CALL scankey
         CALL z,holdr5
holdrn1
         LD   a,65
         CALL scankey
         CALL z,holdr2
         LD   a,57
         CALL scankey
         CALL z,holdr3
         LD   a,56
         CALL scankey
         CALL z,holdr4
         LD   a,0
heldf    EQU  $-1
         OR   a
         RET  z
         LD   a,(functcnt)
         OR   a
         RET  nz
         LD   a,62
         CALL scankey
         RET  nz
         LD   a,252
         LD   (seth1+5),a
         CALL holdr1
         CALL holdr2
         CALL holdr3
         CALL holdr4
         CALL holdr5
         XOR  a
         LD   (heldf),a
         LD   a,#c0
         LD   (seth1+5),a
         RET  
holds                                   ; Swap Hold Colours
         LD   (hl),a
         LD   a,(colhl)
         XOR  #3c
         LD   (colhl),a
holds2
         LD   a,(heldf)
         BIT  4,a
         LD   hl,#ec12
         CALL z,flashhld
         BIT  3,a
         LD   hl,#cdaf
         CALL z,flashhld
         BIT  2,a
         LD   hl,#eefd
         CALL z,flashhld
         BIT  1,a
         LD   hl,#ef0a
         CALL z,flashhld
         BIT  0,a
         LD   hl,#ef17
         RET  nz
         JR   flashhld
holdr1
         LD   hl,heldf
         BIT  4,(hl)
         SET  4,(hl)
         CALL z,boing
         LD   hl,#ec12
         JR   seth1
holdr2
         LD   hl,heldf
         BIT  3,(hl)
         SET  3,(hl)
         CALL z,boing
         LD   hl,#cdaf
         JR   seth1
holdr3
         LD   hl,heldf
         BIT  2,(hl)
         SET  2,(hl)
         CALL z,boing
         LD   hl,#eefd
         JR   seth1
holdr4
         LD   hl,heldf
         BIT  1,(hl)
         SET  1,(hl)
         CALL z,boing
         LD   hl,#ef0a
         JR   seth1
holdr5
         LD   hl,heldf
         BIT  0,(hl)
         SET  0,(hl)
         CALL z,boing
         LD   hl,#ef17
seth1
         LD   a,(colhl)
         PUSH af
         LD   a,#c0
         LD   (colhl),a
         CALL flashhld
         POP  af
         LD   (colhl),a
         RET  
flashhld
         PUSH af
         LD   de,#fcc0
         CALL setcs
         LD   bc,#a0f
swap1
         LD   a,#c0
colhl    EQU  $-1
         CALL swichgwa
         POP  af
         RET  
*f,reelcu.adm
