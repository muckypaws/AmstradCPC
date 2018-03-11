;
numberun                                ; Mystery Gaming Function
         LD   hl,numbr1
         CALL setupms
         CALL game0
         LD   a,47
         CALL scrmess
         CALL dspace
         CALL setpoint
         CALL random
         AND  7
         ADD  a,8                       ; At least 4 Reel Drops
         LD   b,a
num1
         PUSH bc
         CALL numsr
         CALL getwinl
         LD   hl,winlbuff+3
         LD   c,7
         LD   a,(hl)
         AND  c
         LD   (keyna1),a
         INC  hl
         LD   a,(hl)
         AND  c
         LD   (keyna2),a
         INC  hl
         LD   a,(hl)
         AND  c
         LD   (keyna3),a
         LD   b,90
numd
         PUSH bc
         CALL numbk
         POP  bc
         DJNZ numd
         POP  bc
         DJNZ num1
         XOR  a
         LD   (heldf),a
         CALL swichhld
         JP   takeit1
numsr                                   ; Spin Reels For Numbers
         LD   a,7
         LD   (numbk1),a
         SUB  a
         BIT  0,b
         JR   nz,numsr1
         LD   a,(heldf)
numsr1
         OR   #11
         LD   (heldf),a
         LD   a,(state)
         CALL setptbf
nreel                                   ; Nudge Reel
         SUB  a
         LD   (lastwin),a
         LD   hl,nudgesac
         LD   b,18
         CALL accelrl1
         JP   boing
numbk
         CALL holdrn
         LD   a,7
numbk1   EQU  $-1
         BIT  2,a
         CALL nz,keyn2
         BIT  1,a
         CALL nz,keyn3
         BIT  0,a
         CALL nz,keyn4
         LD   (numbk1),a
         RET  
keyn2                                   ; Is Key 2 Pressed ?
         EX   af,af
         LD   a,(heldf)
         BIT  3,a
         LD   b,3
         LD   a,0
keyna1   EQU  $-1
         JR   nz,keyadd
         EX   af,af
         RET  
keyadd                                  ; Add Dosh !
         PUSH bc
         OR   a
         JR   z,kkkk
         LD   b,a
         CALL im1
;JR   kkkk
;LD   hl,numbwun
;ADD  a,(hl)
;LD   (hl),a
kkkk
         POP  bc
         EX   af,af
         AND  b
         RET  
keyn3                                   ; Is Key 2 Pressed ?
         EX   af,af
         LD   a,(heldf)
         BIT  2,a
         LD   b,%101
         LD   a,0
keyna2   EQU  $-1
         JR   nz,keyadd
         EX   af,af
         RET  
keyn4                                   ; Is Key 2 Pressed ?
         EX   af,af
         LD   a,(heldf)
         BIT  1,a
         LD   b,%110
         LD   a,0
keyna3   EQU  $-1
         JR   nz,keyadd
         EX   af,af
         RET  
;
*f,hilocash.adm
